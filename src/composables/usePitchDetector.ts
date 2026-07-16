import { ref } from 'vue'

export interface PitchData {
  frequency: number
  note: string
  cents: number
  inTune: boolean
}

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

  let audioContext: AudioContext | null = null
  let analyser: AnalyserNode | null = null
  let stream: MediaStream | null = null
  let animationId: number | null = null
  let buffer: any

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

  function analyze() {
    if (!analyser || !audioContext) return

    analyser.getFloatTimeDomainData(buffer)
    const freq = detectPitch(buffer, audioContext.sampleRate)

    if (freq > 0 && freq < 5000) {
      const { note, cents } = frequencyToNote(freq)
      pitchData.value = {
        frequency: Math.round(freq * 100) / 100,
        note,
        cents,
        inTune: Math.abs(cents) <= 5
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
      analyser = audioContext.createAnalyser()
      analyser.fftSize = 4096
      analyser.smoothingTimeConstant = 0.8

      const source = audioContext.createMediaStreamSource(stream)
      source.connect(analyser)

      buffer = new Float32Array(analyser.fftSize)
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
    if (audioContext) audioContext.close()
    audioContext = null
    analyser = null
    stream = null
    pitchData.value = { frequency: 0, note: '--', cents: 0, inTune: false }
    volume.value = 0
  }

  return { isListening, pitchData, volume, start, stop }
}
