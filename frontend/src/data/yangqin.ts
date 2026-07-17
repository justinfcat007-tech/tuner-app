/**
 * 402型扬琴标准调弦 (C调)
 *
 * 402型扬琴共144根弦，65个音位
 * 分为4排（梁），每排有多列（码位）
 *
 * 排1（高音区）：13列
 * 排2（中音区）：13列
 * 排3（低音区）：12列
 * 排4（倍低音区）：10列
 */

export interface YangqinString {
  row: number       // 第几排 (1-4)
  col: number       // 第几列
  stringNum: number // 弦编号 (1-144)
  note: string      // 音名 (如 A4, #C5, bB2)
  frequency: number // 标准频率 Hz
  label: string     // 显示标签
  notation: string  // C调简谱
}

// 扬琴专用频率表 (A4=440Hz 基准，但整体音高偏移)
const FREQYANGQIN: Record<string, number> = {
  'C0': 130.80, 'C#0': 138.56, 'Db0': 138.56, 'D0': 146.80, 'D#0': 155.60, 'Eb0': 155.60, 'E0': 164.80, 'F0': 174.64, 'F#0': 184.96, 'Gb0': 184.96, 'G0': 196.00, 'G#0': 207.68, 'Ab0': 207.68, 'A0': 220.00, 'A#0': 233.12, 'Bb0': 233.12, 'B0': 246.96,
  'C1': 261.60, 'C#1': 277.20, 'Db1': 277.20, 'D1': 293.68, 'D#1': 311.12, 'Eb1': 311.12, 'E1': 329.60, 'F1': 349.20, 'F#1': 370.00, 'Gb1': 370.00, 'G1': 392.00, 'G#1': 415.28, 'Ab1': 415.28, 'A1': 440.00, 'A#1': 466.16, 'Bb1': 466.16, 'B1': 493.92,
  'C2': 523.28, 'C#2': 554.40, 'Db2': 554.40, 'D2': 587.36, 'D#2': 622.24, 'Eb2': 622.24, 'E2': 659.28, 'F2': 698.48, 'F#2': 740.00, 'Gb2': 740.00, 'G2': 784.00, 'G#2': 830.64, 'Ab2': 830.64, 'A2': 880.00, 'A#2': 932.32, 'Bb2': 932.32, 'B2': 987.76,
  'C3': 1046.48, 'C#3': 1108.72, 'Db3': 1108.72, 'D3': 1174.64, 'D#3': 1244.48, 'Eb3': 1244.48, 'E3': 1318.48, 'F3': 1396.88, 'F#3': 1480.00, 'Gb3': 1480.00, 'G3': 1568.00, 'G#3': 1661.20, 'Ab3': 1661.20, 'A3': 1760.00, 'A#3': 1864.64, 'Bb3': 1864.64, 'B3': 1975.52,
  'C4': 2093.04, 'C#4': 2217.44, 'Db4': 2217.44, 'D4': 2349.28, 'D#4': 2489.04, 'Eb4': 2489.04, 'E4': 2637.04, 'F4': 2793.84, 'F#4': 2959.92, 'Gb4': 2959.92, 'G4': 3136.00, 'G#4': 3322.40, 'Ab4': 3322.40, 'A4': 3520.00, 'A#4': 3729.28, 'Bb4': 3729.28, 'B4': 3951.04,
  'C5': 4186.00, 'C#5': 4434.96, 'Db5': 4434.96, 'D5': 4698.64, 'D#5': 4978.00, 'Eb5': 4978.00, 'E5': 5274.08, 'F5': 5587.68, 'F#5': 5919.92, 'Gb5': 5919.92, 'G5': 6271.92, 'G#5': 6644.88, 'Ab5': 6644.88, 'A5': 7040.00, 'A#5': 7458.64, 'Bb5': 7458.64, 'B5': 7902.16,
};

// 402型扬琴标准调弦数据
export const YANGQIN_STRINGS: YangqinString[] = [
  // ==================== 第1排（高音区）13列 ====================
  // 第1列
  { row: 1, col: 1, stringNum: 1, note: 'F3', frequency: FREQYANGQIN['F3'], label: 'f3', notation: '4̇' },
  { row: 1, col: 1, stringNum: 2, note: 'Eb3', frequency: FREQYANGQIN['Eb3'], label: '#d3', notation: '#2̇' },
  { row: 1, col: 1, stringNum: 3, note: 'C#3', frequency: FREQYANGQIN['C#3'], label: '#c3', notation: '#1̇' },

  // 第2列
  { row: 1, col: 2, stringNum: 1, note: 'F#3', frequency: FREQYANGQIN['F#3'], label: '#f3', notation: '#4̇' },
  { row: 1, col: 2, stringNum: 2, note: 'E3', frequency: FREQYANGQIN['E3'], label: 'e3', notation: '3̇' },
  { row: 1, col: 2, stringNum: 3, note: 'D3', frequency: FREQYANGQIN['D3'], label: 'd3', notation: '2̇' },

  // 第3列
  { row: 1, col: 2, stringNum: 4, note: 'C3', frequency: FREQYANGQIN['C3'], label: 'c3', notation: '1̇' },
  { row: 1, col: 2, stringNum: 5, note: 'B2', frequency: FREQYANGQIN['B2'], label: 'b2', notation: '7' },
  { row: 1, col: 2, stringNum: 6, note: 'A2', frequency: FREQYANGQIN['A2'], label: 'a2', notation: '6' },

  // 第4列
  { row: 1, col: 2, stringNum: 7, note: 'G2', frequency: FREQYANGQIN['G2'], label: 'g2', notation: '5' },
  { row: 1, col: 2, stringNum: 8, note: 'Gb2', frequency: FREQYANGQIN['Gb2'], label: 'bg2', notation: 'b5' },
  { row: 1, col: 2, stringNum: 9, note: 'E2', frequency: FREQYANGQIN['E2'], label: 'e2', notation: '3' },

  // 第5列
  { row: 1, col: 2, stringNum: 10, note: 'D2', frequency: FREQYANGQIN['D2'], label: 'd2', notation: '2' },
  { row: 1, col: 2, stringNum: 11, note: 'C2', frequency: FREQYANGQIN['C2'], label: 'c2', notation: '1' },
  { row: 1, col: 2, stringNum: 12, note: 'A#1', frequency: FREQYANGQIN['A#1'], label: '#a1', notation: '#6̣' },
  { row: 1, col: 2, stringNum: 13, note: 'G#1', frequency: FREQYANGQIN['G#1'], label: '#g1', notation: '#5̣' },

  // 第6列
  { row: 1, col: 3, stringNum: 1, note: 'A3', frequency: FREQYANGQIN['A3'], label: 'a3', notation: '6̇' },
  { row: 1, col: 3, stringNum: 2, note: 'G3', frequency: FREQYANGQIN['G3'], label: 'g3', notation: '5̇' },
  { row: 1, col: 3, stringNum: 3, note: 'A#2', frequency: FREQYANGQIN['A#2'], label: '#a2', notation: '#6' },

  // 第7列
  { row: 1, col: 3, stringNum: 4, note: 'G#2', frequency: FREQYANGQIN['G#2'], label: '#g2', notation: '#5' },
  { row: 1, col: 3, stringNum: 5, note: 'F2', frequency: FREQYANGQIN['F2'], label: 'f2', notation: '4' },
  { row: 1, col: 3, stringNum: 6, note: 'Eb2', frequency: FREQYANGQIN['Eb2'], label: 'be2', notation: 'b3' },

  // 第8列
  { row: 1, col: 3, stringNum: 7, note: 'C#2', frequency: FREQYANGQIN['C#2'], label: '#c2', notation: '#1' },
  { row: 1, col: 3, stringNum: 8, note: 'B1', frequency: FREQYANGQIN['B1'], label: 'b1', notation: '7̣' },
  { row: 1, col: 3, stringNum: 9, note: 'A1', frequency: FREQYANGQIN['A1'], label: 'a1', notation: '6̣' },

  // 第9列
  { row: 1, col: 3, stringNum: 10, note: 'G1', frequency: FREQYANGQIN['G1'], label: 'g1', notation: '5̣' },
  { row: 1, col: 3, stringNum: 11, note: 'F1', frequency: FREQYANGQIN['F1'], label: 'f1', notation: '4̣' },
  { row: 1, col: 3, stringNum: 12, note: 'D#1', frequency: FREQYANGQIN['D#1'], label: '#d1', notation: '#2̣' },
  { row: 1, col: 3, stringNum: 13, note: 'C#1', frequency: FREQYANGQIN['C#1'], label: '#c1', notation: '#1̣' },

  // 第10列
  { row: 1, col: 4, stringNum: 1, note: 'E2', frequency: FREQYANGQIN['E2'], label: 'e2', notation: '3' },
  { row: 1, col: 4, stringNum: 2, note: 'D2', frequency: FREQYANGQIN['D2'], label: 'd2', notation: '2' },
  { row: 1, col: 4, stringNum: 3, note: 'C2', frequency: FREQYANGQIN['C2'], label: 'c2', notation: '1' },

  // 第11列
  { row: 1, col: 4, stringNum: 4, note: 'A#1', frequency: FREQYANGQIN['A#1'], label: '#a1', notation: '#6̣' },
  { row: 1, col: 4, stringNum: 5, note: 'G#1', frequency: FREQYANGQIN['G#1'], label: '#g1', notation: '#5̣' },
  { row: 1, col: 4, stringNum: 6, note: 'F#1', frequency: FREQYANGQIN['F#1'], label: '#f1', notation: '#4̣' },

  // 第12列
  { row: 1, col: 4, stringNum: 7, note: 'E1', frequency: FREQYANGQIN['E1'], label: 'e1', notation: '3̣' },
  { row: 1, col: 4, stringNum: 8, note: 'D1', frequency: FREQYANGQIN['D1'], label: 'd1', notation: '2̣' },
  { row: 1, col: 4, stringNum: 9, note: 'C1', frequency: FREQYANGQIN['C1'], label: 'c1', notation: '1' },

  // 第13列
  { row: 1, col: 4, stringNum: 10, note: 'A#0', frequency: FREQYANGQIN['A#0'], label: '#a', notation: '#6̣' },
  { row: 1, col: 4, stringNum: 11, note: 'G#0', frequency: FREQYANGQIN['G#0'], label: '#g', notation: '#5̣̣' },


  // ==================== 第2排（中音区）13列 ====================
  { row: 2, col: 5, stringNum: 1, note: 'G1', frequency: FREQYANGQIN['G1'], label: 'g1', notation: '5̣' },
  { row: 2, col: 5, stringNum: 2, note: 'F1', frequency: FREQYANGQIN['F1'], label: 'f1', notation: '4̣' },
  { row: 2, col: 5, stringNum: 3, note: 'D#1', frequency: FREQYANGQIN['D#1'], label: '#d1', notation: '#2̣' },

  { row: 2, col: 5, stringNum: 4, note: 'C#1', frequency: FREQYANGQIN['C#1'], label: '#c1', notation: '#1̣' },
  { row: 2, col: 5, stringNum: 5, note: 'B0', frequency: FREQYANGQIN['B0'], label: 'b', notation: '7̣̣' },
  { row: 2, col: 5, stringNum: 6, note: 'A0', frequency: FREQYANGQIN['A0'], label: 'a', notation: '6̣' },

  { row: 2, col: 5, stringNum: 7, note: 'G0', frequency: FREQYANGQIN['G0'], label: 'g', notation: '5̣' },
  { row: 2, col: 5, stringNum: 8, note: 'F0', frequency: FREQYANGQIN['F0'], label: 'f', notation: '4̣̣' },
  { row: 2, col: 5, stringNum: 9, note: 'D#0', frequency: FREQYANGQIN['D#0'], label: '#d', notation: '#2̣̣' },

  { row: 2, col: 5, stringNum: 10, note: 'C#0', frequency: FREQYANGQIN['C#0'], label: '#c', notation: '#1̣̣' },

  { row: 2, col: 6, stringNum: 1, note: 'C1', frequency: FREQYANGQIN['C1'], label: 'c1', notation: '1̣' },
  { row: 2, col: 6, stringNum: 2, note: 'A#0', frequency: FREQYANGQIN['A#0'], label: '#a', notation: '#6̣̣' },

  { row: 2, col: 6, stringNum: 3, note: 'F#0', frequency: FREQYANGQIN['F#0'], label: '#f', notation: '#4̣' },
  { row: 2, col: 6, stringNum: 4, note: 'E0', frequency: FREQYANGQIN['E0'], label: 'e/bd2', notation: '3̣̣' },
  { row: 2, col: 6, stringNum: 5, note: 'D0', frequency: FREQYANGQIN['D0'], label: 'd', notation: '2̣̣' },

  // 第6列
  { row: 2, col: 6, stringNum: 6, note: 'C0', frequency: FREQYANGQIN['C0'], label: 'c', notation: '1̣̣' },
  { row: 2, col: 6, stringNum: 7, note: 'B-1', frequency: 14.57, label: 'b', notation: '7̣̣̣' },
  { row: 2, col: 6, stringNum: 8, note: 'A-1', frequency: 13.75, label: 'a', notation: '6̣̣̣' },

  // 第7列
  { row: 2, col: 6, stringNum: 9, note: 'G-1', frequency: 12.25, label: 'g', notation: '5̣̣̣' },
  { row: 2, col: 6, stringNum: 10, note: 'E-1', frequency: 10.30, label: 'e', notation: '3̣̣̣' },

]

export const YANGQIN_ROWS = 4
export const ROWS_COLS = [13, 13, 12, 10]  // 每排的列数

export function getAllYangqinStrings(): YangqinString[] {
  return YANGQIN_STRINGS
}

export function getStringsByRowCol(row: number, col: number): YangqinString[] {
  return YANGQIN_STRINGS.filter(s => s.row === row && s.col === col)
}

export function getStringByNum(stringNum: number): YangqinString | null {
  return YANGQIN_STRINGS.find(s => s.stringNum === stringNum) || null
}

export function findNearestString(freq: number): { string: YangqinString; cents: number } | null {
  if (freq <= 0) return null
  let best: YangqinString | null = null
  let bestCents = Infinity
  for (const s of YANGQIN_STRINGS) {
    const cents = 1200 * Math.log2(freq / s.frequency)
    if (Math.abs(cents) < Math.abs(bestCents)) {
      bestCents = cents
      best = s
    }
  }
  return best ? { string: best, cents: Math.round(bestCents) } : null
}

export const COMMON_KEYS = ['C调', '#C调/bD调', 'D调', 'bE调/#D调', 'E调', 'F调', '#F调/bG调', 'G调', 'bA调/#G调', 'A调', 'bB调', 'B调']
