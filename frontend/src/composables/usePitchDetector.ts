import { ref } from 'vue'

export interface PitchData {
  frequency: number
  note: string
  cents: number
  inTune: boolean
}

export type InstrumentType = 'guitar' | 'yangqin' | 'ukulele'

// 各乐器的频率范围
const INSTRUMENT_RANGES: Record<InstrumentType, [number, number]> = {
  guitar: [80, 1200],    // E2 ~ B5
  yangqin: [200, 4000],  // 扬琴音域较宽
  ukulele: [200, 1500],  // G4 ~ A5
}

// 语音提示状态
type TuneStatus = 'low' | 'high' | 'inTune' | null

const NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

function frequencyToNote(freq: number): { note: string; cents: number } {
  const A4 = 440
  const semitones = 12 * Math.log2(freq / A4)
  const roundedSemitones = Math.round(semitones)
  const cents = Math.round((semitones - roundedSemitones) * 100)

  const noteIndex = ((roundedSemitones % 12) + 12) % 12
  const octave = Math.floor((roundedSemitones + 9) / 12) + 4

  return { note: NOTE_NAMES[noteIndex] + octave, cents }
}

export function usePitchDetector() {
  const isListening = ref(false)
  const pitchData = ref<PitchData>({
    frequency: 0,
    note: '--',
    cents: 0,
    inTune: false
  })
  const volume = ref(0)
  const instrument = ref<InstrumentType>('guitar')
  const voiceEnabled = ref(true)

  let audioContext: AudioContext | null = null
  let analyser: AnalyserNode | null = null
  let bandpassFilter: BiquadFilterNode | null = null
  let stream: MediaStream | null = null
  let animationId: number | null = null
  let buffer: Float32Array | null = null

  // 检测窗口 - 滑动平均稳定结果
  const DETECT_WINDOW_SIZE = 5
  const detectBuffer: number[] = []
  let lastStableFreq = 0
  let lastStatus: TuneStatus = null

  // 语音合成
  const synth = typeof window !== 'undefined' ? window.speechSynthesis : null

  function speak(text: string, isChime = false) {
    if (!voiceEnabled.value || !synth) return
    if (isChime) {
      // 调准时的叮声 - 使用 AudioContext 生成
      if (audioContext) {
        const osc = audioContext.createOscillator()
        const gain = audioContext.createGain()
        osc.connect(gain)
        gain.connect(audioContext.destination)
        osc.frequency.value = 880
        osc.type = 'sine'
        gain.gain.setValueAtTime(0.3, audioContext.currentTime)
        gain.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5)
        osc.start()
        osc.stop(audioContext.currentTime + 0.5)
      }
      return
    }

    const utterance = new SpeechSynthesisUtterance(text)
    utterance.lang = 'zh-CN'
    utterance.rate = 1.2
    utterance.pitch = 1
    synth.speak(utterance)
  }

  // Autocorrelation pitch detection
  function detectPitch(buf: Float32Array, sampleRate: number): number {
    let rms = 0
    for (let i = 0; i < buf.length; i++) {
      rms += buf[i] * buf[i]
    }
    rms = Math.sqrt(rms / buf.length)
    volume.value = Math.min(1, rms * 5)

    if (rms < 0.01) return -1 // Too quiet

    // Trim silence from start and end
    let r1 = 0, r2 = buf.length - 1
    const threshold = 0.2
    for (let i = 0; i < buf.length / 2; i++) {
      if (Math.abs(buf[i]) < threshold) { r1 = i } else { break }
    }
    for (let i = 1; i < buf.length / 2; i++) {
      if (Math.abs(buf[buf.length - i]) < threshold) { r2 = buf.length - i } else { break }
    }

    const trimmed = buf.slice(r1, r2)
    if (trimmed.length < 2) return -1

    // Autocorrelation
    const c = new Float32Array(trimmed.length)
    for (let i = 0; i < trimmed.length; i++) {
      for (let j = 0; j < trimmed.length - i; j++) {
        c[i] += trimmed[j] * trimmed[j + i]
      }
    }

    // Find first dip
    let d = 0
    while (c[d] > c[d + 1] && d < c.length - 1) d++

    // Find peak after dip
    let maxVal = -1, maxPos = -1
    for (let i = d; i < c.length; i++) {
      if (c[i] > maxVal) {
        maxVal = c[i]
        maxPos = i
      }
    }

    let T0 = maxPos
    if (T0 < 2) return -1 // Frequency too high

    // Parabolic interpolation
    const x1 = c[T0 - 1] || 0
    const x2 = c[T0]
    const x3 = c[T0 + 1] || 0
    const a = (x1 + x3 - 2 * x2) / 2
    const b = (x3 - x1) / 2
    if (a) T0 = T0 - b / (2 * a)

    return sampleRate / T0
  }

  // 滑动窗口平均，稳定频率检测
  function getStableFrequency(rawFreq: number): number {
    if (rawFreq <= 0) {
      detectBuffer.length = 0
      return 0
    }

    detectBuffer.push(rawFreq)
    if (detectBuffer.length > DETECT_WINDOW_SIZE) {
      detectBuffer.shift()
    }

    // 计算平均值
    const sum = detectBuffer.reduce((a, b) => a + b, 0)
    const avg = sum / detectBuffer.length

    // 检查一致性 - 如果窗口内数值差异太大，返回0
    const maxDiff = Math.max(...detectBuffer.map(v => Math.abs(v - avg)))
    if (maxDiff > avg * 0.05) {
      return 0 // 不稳定
    }

    return avg
  }

  // 语音提示逻辑
  function updateVoicePrompt(cents: number) {
    let newStatus: TuneStatus = null
    if (Math.abs(cents) <= 5) {
      newStatus = 'inTune'
    } else if (cents < -5) {
      newStatus = 'low'
    } else {
      newStatus = 'high'
    }

    // 只在状态变化时提示
    if (newStatus !== lastStatus) {
      if (newStatus === 'low') {
        speak('低了')
      } else if (newStatus === 'high') {
        speak('高了')
      } else if (newStatus === 'inTune') {
        speak('调准了', true)  // 带叮声
      }
      lastStatus = newStatus
    }
  }

  function analyze() {
    if (!analyser || !audioContext || !buffer) return

    analyser.getFloatTimeDomainData(buffer)
    const rawFreq = detectPitch(buffer, audioContext.sampleRate)

    // 获取稳定的频率
    const stableFreq = getStableFrequency(rawFreq)

    if (stableFreq > 0) {
      const { note, cents } = frequencyToNote(stableFreq)
      const newPitchData: PitchData = {
        frequency: Math.round(stableFreq * 100) / 100,
        note,
        cents,
        inTune: Math.abs(cents) <= 5
      }

      // 只在数据变化时更新
      if (newPitchData.frequency !== pitchData.value.frequency ||
          newPitchData.cents !== pitchData.value.cents) {
        pitchData.value = newPitchData

        // 语音提示
        if (voiceEnabled.value) {
          updateVoicePrompt(cents)
        }
      }
    } else {
      pitchData.value = { frequency: 0, note: '--', cents: 0, inTune: false }
    }

    animationId = requestAnimationFrame(analyze)
  }

  async function start() {
    if (isListening.value) return
    try {
      stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      audioContext = new AudioContext()

      // 创建带通滤波器
      const [lowFreq, highFreq] = INSTRUMENT_RANGES[instrument.value]
      bandpassFilter = audioContext.createBiquadFilter()
      bandpassFilter.type = 'bandpass'
      bandpassFilter.frequency.value = Math.sqrt(lowFreq * highFreq) // 几何平均
      bandpassFilter.Q.value = 1

      analyser = audioContext.createAnalyser()
      analyser.fftSize = 4096
      analyser.smoothingTimeConstant = 0.8

      const source = audioContext.createMediaStreamSource(stream)
      source.connect(bandpassFilter)
      bandpassFilter.connect(analyser)

      buffer = new Float32Array(analyser.fftSize)
      detectBuffer.length = 0
      lastStableFreq = 0
      lastStatus = null

      isListening.value = true
      analyze()
    } catch (err) {
      console.error('Microphone access denied:', err)
    }
  }

  function stop() {
    isListening.value = false
    if (animationId) cancelAnimationFrame(animationId)
    if (stream) stream.getTracks().forEach(t => t.stop())
    if (bandpassFilter) {
      bandpassFilter.disconnect()
      bandpassFilter = null
    }
    if (audioContext) {
      audioContext.close()
      audioContext = null
    }
    analyser = null
    stream = null
    buffer = null
    detectBuffer.length = 0
    lastStableFreq = 0
    lastStatus = null
    pitchData.value = { frequency: 0, note: '--', cents: 0, inTune: false }
    volume.value = 0
  }

  function setInstrument(type: InstrumentType) {
    instrument.value = type
    // 如果正在监听，重新创建滤波器
    if (isListening.value && bandpassFilter && audioContext) {
      const [lowFreq, highFreq] = INSTRUMENT_RANGES[type]
      bandpassFilter.frequency.value = Math.sqrt(lowFreq * highFreq)
    }
  }

  function toggleVoice(enabled: boolean) {
    voiceEnabled.value = enabled
    if (!enabled) {
      lastStatus = null  // 重置状态
    }
  }

  return {
    isListening,
    pitchData,
    volume,
    instrument,
    voiceEnabled,
    start,
    stop,
    setInstrument,
    toggleVoice,
  }
}
