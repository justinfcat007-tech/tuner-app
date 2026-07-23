import { ref } from 'vue'

export interface PitchData {
  frequency: number
  note: string
  cents: number
  inTune: boolean
}

export type InstrumentType = 'guitar' | 'yangqin' | 'ukulele'
export type DetectionState = 'idle' | 'listening' | 'waiting' | 'unstable' | 'detected'
export type TuneStatus = 'low' | 'high' | 'inTune' | null

const INSTRUMENT_RANGES: Record<InstrumentType, [number, number]> = {
  guitar: [80, 1200],
  yangqin: [200, 4000],
  ukulele: [200, 1500],
}

const NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
const STABLE_SAMPLE_COUNT = 6
const SAMPLE_INTERVAL_MS = 85
const MIN_SIGNAL_RMS = 0.008
const MAX_STABLE_SPREAD_CENTS = 14
const IN_TUNE_CENTS = 5

function frequencyToNote(freq: number): { note: string; cents: number } {
  const semitones = 12 * Math.log2(freq / 440)
  const roundedSemitones = Math.round(semitones)
  const cents = Math.round((semitones - roundedSemitones) * 100)
  const noteIndex = ((roundedSemitones % 12) + 12) % 12
  const octave = Math.floor((roundedSemitones + 9) / 12) + 4
  return { note: NOTE_NAMES[noteIndex] + octave, cents }
}

/** YIN 基频检测。返回的置信度用于拒绝非周期性噪声。 */
function yinPitchDetect(
  buffer: Float32Array<ArrayBuffer>,
  sampleRate: number,
  minFreq: number,
  maxFreq: number,
): { frequency: number; confidence: number } | null {
  const tauMin = Math.max(2, Math.floor(sampleRate / maxFreq))
  const tauMax = Math.min(Math.floor(buffer.length / 2), Math.ceil(sampleRate / minFreq))
  const difference = new Float32Array(tauMax + 1)

  for (let tau = tauMin; tau <= tauMax; tau++) {
    let sum = 0
    for (let i = 0; i < buffer.length - tau; i++) {
      const delta = buffer[i] - buffer[i + tau]
      sum += delta * delta
    }
    difference[tau] = sum
  }

  const cmndf = new Float32Array(tauMax + 1)
  cmndf[0] = 1
  let runningSum = 0
  for (let tau = 1; tau <= tauMax; tau++) {
    runningSum += difference[tau]
    cmndf[tau] = runningSum === 0 ? 1 : (difference[tau] * tau) / runningSum
  }

  let tau = tauMin
  while (tau <= tauMax && cmndf[tau] >= 0.18) tau++
  if (tau > tauMax) return null
  while (tau + 1 <= tauMax && cmndf[tau + 1] < cmndf[tau]) tau++

  let refinedTau = tau
  if (tau > tauMin && tau < tauMax) {
    const previous = cmndf[tau - 1]
    const current = cmndf[tau]
    const next = cmndf[tau + 1]
    const denominator = previous - 2 * current + next
    if (Math.abs(denominator) > Number.EPSILON) {
      refinedTau += (next - previous) / (2 * denominator)
    }
  }

  const frequency = sampleRate / refinedTau
  if (frequency < minFreq || frequency > maxFreq) return null
  return { frequency, confidence: 1 - cmndf[tau] }
}

function median(values: number[]): number {
  const sorted = [...values].sort((a, b) => a - b)
  const middle = Math.floor(sorted.length / 2)
  return sorted.length % 2 ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2
}

function centsBetween(frequency: number, reference: number): number {
  return 1200 * Math.log2(frequency / reference)
}

export function usePitchDetector() {
  const isListening = ref(false)
  const pitchData = ref<PitchData>({ frequency: 0, note: '--', cents: 0, inTune: false })
  const volume = ref(0)
  const instrument = ref<InstrumentType>('guitar')
  const voiceEnabled = ref(true)
  const detectionState = ref<DetectionState>('idle')
  const tuneStatus = ref<TuneStatus>(null)

  let audioContext: AudioContext | null = null
  let analyser: AnalyserNode | null = null
  let highPassFilter: BiquadFilterNode | null = null
  let lowPassFilter: BiquadFilterNode | null = null
  let stream: MediaStream | null = null
  let animationId: number | null = null
  let buffer: Float32Array<ArrayBuffer> | null = null
  let lastSampleAt = 0
  let targetFrequency = 0
  let lastSpokenStatus: TuneStatus = null
  const frequencyWindow: number[] = []
  const synth = typeof window === 'undefined' ? null : window.speechSynthesis

  function resetDetection(state: DetectionState = 'listening') {
    frequencyWindow.length = 0
    pitchData.value = { frequency: 0, note: '--', cents: 0, inTune: false }
    tuneStatus.value = null
    lastSpokenStatus = null
    detectionState.value = state
  }

  function speakStatus(status: TuneStatus) {
    if (!voiceEnabled.value || status === lastSpokenStatus) return
    lastSpokenStatus = status
    if (status === 'inTune' && audioContext) {
      const oscillator = audioContext.createOscillator()
      const gain = audioContext.createGain()
      oscillator.frequency.value = 880
      gain.gain.setValueAtTime(0.12, audioContext.currentTime)
      gain.gain.exponentialRampToValueAtTime(0.001, audioContext.currentTime + 0.25)
      oscillator.connect(gain).connect(audioContext.destination)
      oscillator.start()
      oscillator.stop(audioContext.currentTime + 0.25)
      return
    }
    if (!synth || !status) return
    synth.cancel()
    const utterance = new SpeechSynthesisUtterance(status === 'low' ? '偏低' : '偏高')
    utterance.lang = 'zh-CN'
    utterance.rate = 1.25
    synth.speak(utterance)
  }

  function publishStableFrequency(frequency: number) {
    const { note, cents } = frequencyToNote(frequency)
    const targetCents = targetFrequency > 0 ? Math.round(centsBetween(frequency, targetFrequency)) : cents
    const status: TuneStatus = Math.abs(targetCents) <= IN_TUNE_CENTS
      ? 'inTune'
      : targetCents < 0 ? 'low' : 'high'
    const next: PitchData = {
      frequency: Math.round(frequency * 100) / 100,
      note,
      cents: targetCents,
      inTune: status === 'inTune',
    }

    pitchData.value = next
    detectionState.value = 'detected'
    tuneStatus.value = status
    speakStatus(status)
  }

  function analyze() {
    if (!analyser || !audioContext || !buffer) return
    analyser.getFloatTimeDomainData(buffer)

    let sum = 0
    for (const sample of buffer) sum += sample * sample
    const rms = Math.sqrt(sum / buffer.length)
    volume.value = Math.min(1, rms * 6)

    const now = performance.now()
    if (now - lastSampleAt < SAMPLE_INTERVAL_MS) {
      animationId = requestAnimationFrame(analyze)
      return
    }
    lastSampleAt = now

    if (rms < MIN_SIGNAL_RMS) {
      resetDetection('listening')
      animationId = requestAnimationFrame(analyze)
      return
    }

    const [minFreq, maxFreq] = INSTRUMENT_RANGES[instrument.value]
    const result = yinPitchDetect(buffer, audioContext.sampleRate, minFreq, maxFreq)
    if (!result || result.confidence < 0.82) {
      frequencyWindow.length = 0
      detectionState.value = 'unstable'
      tuneStatus.value = null
      animationId = requestAnimationFrame(analyze)
      return
    }

    frequencyWindow.push(result.frequency)
    if (frequencyWindow.length > STABLE_SAMPLE_COUNT) frequencyWindow.shift()
    if (frequencyWindow.length < STABLE_SAMPLE_COUNT) {
      detectionState.value = 'waiting'
      animationId = requestAnimationFrame(analyze)
      return
    }

    const stableFrequency = median(frequencyWindow)
    const spread = Math.max(...frequencyWindow.map(value => Math.abs(centsBetween(value, stableFrequency))))
    if (spread > MAX_STABLE_SPREAD_CENTS) {
      // 保留最新的测量值，避免一次杂音导致长时间无法恢复。
      frequencyWindow.splice(0, frequencyWindow.length - 1)
      detectionState.value = 'unstable'
      tuneStatus.value = null
      animationId = requestAnimationFrame(analyze)
      return
    }

    publishStableFrequency(stableFrequency)
    animationId = requestAnimationFrame(analyze)
  }

  function configureFilters(type: InstrumentType) {
    if (!audioContext || !highPassFilter || !lowPassFilter) return
    const [minimum, maximum] = INSTRUMENT_RANGES[type]
    highPassFilter.frequency.setTargetAtTime(Math.max(35, minimum * 0.65), audioContext.currentTime, 0.03)
    lowPassFilter.frequency.setTargetAtTime(Math.min(audioContext.sampleRate / 2 - 100, maximum * 1.2), audioContext.currentTime, 0.03)
  }

  async function start() {
    if (isListening.value) return
    try {
      stream = await navigator.mediaDevices.getUserMedia({
        audio: { echoCancellation: false, noiseSuppression: true, autoGainControl: false },
      })
      audioContext = new AudioContext()
      await audioContext.resume()

      const source = audioContext.createMediaStreamSource(stream)
      highPassFilter = audioContext.createBiquadFilter()
      highPassFilter.type = 'highpass'
      highPassFilter.Q.value = 0.7
      lowPassFilter = audioContext.createBiquadFilter()
      lowPassFilter.type = 'lowpass'
      lowPassFilter.Q.value = 0.7
      analyser = audioContext.createAnalyser()
      analyser.fftSize = 4096
      analyser.smoothingTimeConstant = 0
      configureFilters(instrument.value)
      source.connect(highPassFilter).connect(lowPassFilter).connect(analyser)

      buffer = new Float32Array(analyser.fftSize)
      lastSampleAt = 0
      isListening.value = true
      resetDetection()
      analyze()
    } catch (error) {
      console.error('Unable to access microphone:', error)
      detectionState.value = 'idle'
    }
  }

  function stop() {
    isListening.value = false
    if (animationId !== null) cancelAnimationFrame(animationId)
    animationId = null
    synth?.cancel()
    stream?.getTracks().forEach(track => track.stop())
    highPassFilter?.disconnect()
    lowPassFilter?.disconnect()
    analyser?.disconnect()
    audioContext?.close()
    audioContext = null
    analyser = null
    highPassFilter = null
    lowPassFilter = null
    stream = null
    buffer = null
    resetDetection('idle')
    volume.value = 0
  }

  function setInstrument(type: InstrumentType) {
    instrument.value = type
    configureFilters(type)
    resetDetection(isListening.value ? 'listening' : 'idle')
  }

  function setTargetFrequency(frequency: number) {
    targetFrequency = frequency > 0 && Number.isFinite(frequency) ? frequency : 0
    resetDetection(isListening.value ? 'listening' : 'idle')
  }

  function toggleVoice(enabled: boolean) {
    voiceEnabled.value = enabled
    if (!enabled) synth?.cancel()
    lastSpokenStatus = null
  }

  return {
    isListening, pitchData, volume, instrument, voiceEnabled, detectionState, tuneStatus,
    start, stop, setInstrument, setTargetFrequency, toggleVoice,
  }
}
