export interface StringNote {
  name: string       // 显示名称
  note: string       // 音名 (用于匹配)
  frequency: number  // 标准频率 Hz
  octave: number
}

export interface Instrument {
  id: string
  name: string
  nameEn: string
  emoji: string
  strings: StringNote[]
}

// 扬琴 - 常见调式 (以24弦扬琴为例，取常用弦)
// 扬琴是击弦乐器，调弦较为复杂，这里列出常用弦的标准音
export const yangqin: Instrument = {
  id: 'yangqin',
  name: '扬琴',
  nameEn: 'Yangqin',
  emoji: '🎵',
  strings: [
    // 高音区 (右马条)
    { name: '1弦 (高音)', note: 'A5', frequency: 880.00, octave: 5 },
    { name: '2弦',       note: 'G5', frequency: 783.99, octave: 5 },
    { name: '3弦',       note: 'F5', frequency: 698.46, octave: 5 },
    { name: '4弦',       note: 'E5', frequency: 659.26, octave: 5 },
    { name: '5弦',       note: 'D5', frequency: 587.33, octave: 5 },
    { name: '6弦',       note: 'C5', frequency: 523.25, octave: 5 },
    { name: '7弦',       note: 'B4', frequency: 493.88, octave: 4 },
    { name: '8弦',       note: 'A4', frequency: 440.00, octave: 4 },
    // 中音区
    { name: '9弦',       note: 'G4', frequency: 392.00, octave: 4 },
    { name: '10弦',      note: 'F4', frequency: 349.23, octave: 4 },
    { name: '11弦',      note: 'E4', frequency: 329.63, octave: 4 },
    { name: '12弦',      note: 'D4', frequency: 293.66, octave: 4 },
    { name: '13弦',      note: 'C4', frequency: 261.63, octave: 4 },
    // 低音区
    { name: '14弦',      note: 'B3', frequency: 246.94, octave: 3 },
    { name: '15弦',      note: 'A3', frequency: 220.00, octave: 3 },
    { name: '16弦',      note: 'G3', frequency: 196.00, octave: 3 },
    { name: '17弦',      note: 'F3', frequency: 174.61, octave: 3 },
    { name: '18弦',      note: 'E3', frequency: 164.81, octave: 3 },
    { name: '19弦',      note: 'D3', frequency: 146.83, octave: 3 },
    { name: '20弦',      note: 'C3', frequency: 130.81, octave: 3 },
    { name: '21弦 (低音)', note: 'A2', frequency: 110.00, octave: 2 },
    { name: '22弦',      note: 'G2', frequency: 98.00, octave: 2 },
    { name: '23弦',      note: 'F2', frequency: 87.31, octave: 2 },
    { name: '24弦 (最低)', note: 'E2', frequency: 82.41, octave: 2 },
  ]
}

// 吉他 - 标准调弦 EADGBE
export const guitar: Instrument = {
  id: 'guitar',
  name: '吉他',
  nameEn: 'Guitar',
  emoji: '🎸',
  strings: [
    { name: '1弦 (最细)', note: 'E4', frequency: 329.63, octave: 4 },
    { name: '2弦',        note: 'B3', frequency: 246.94, octave: 3 },
    { name: '3弦',        note: 'G3', frequency: 196.00, octave: 3 },
    { name: '4弦',        note: 'D3', frequency: 146.83, octave: 3 },
    { name: '5弦',        note: 'A2', frequency: 110.00, octave: 2 },
    { name: '6弦 (最粗)', note: 'E2', frequency: 82.41, octave: 2 },
  ]
}

// 尤克里里 - 标准调弦 GCEA (高音G)
export const ukulele: Instrument = {
  id: 'ukulele',
  name: '尤克里里',
  nameEn: 'Ukulele',
  emoji: '🪕',
  strings: [
    { name: '1弦 (A)',  note: 'A4', frequency: 440.00, octave: 4 },
    { name: '2弦 (E)',  note: 'E4', frequency: 329.63, octave: 4 },
    { name: '3弦 (C)',  note: 'C4', frequency: 261.63, octave: 4 },
    { name: '4弦 (G)',  note: 'G4', frequency: 392.00, octave: 4 },
  ]
}

export const instruments: Instrument[] = [yangqin, guitar, ukulele]
