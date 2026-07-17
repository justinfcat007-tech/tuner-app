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

// 音名频率对照表 (A4=440Hz, 十二平均律)
const FREQ: Record<string, number> = {
  'C0': 16.35, 'C#0': 17.32, 'Db0': 17.32, 'D0': 18.35, 'D#0': 19.45, 'Eb0': 19.45, 'E0': 20.60, 'F0': 21.83, 'F#0': 23.12, 'Gb0': 23.12, 'G0': 24.50, 'G#0': 25.96, 'Ab0': 25.96, 'A0': 27.50, 'A#0': 29.14, 'Bb0': 29.14, 'B0': 30.87,
  'C1': 32.70, 'C#1': 34.65, 'Db1': 34.65, 'D1': 36.71, 'D#1': 38.89, 'Eb1': 38.89, 'E1': 41.20, 'F1': 43.65, 'F#1': 46.25, 'Gb1': 46.25, 'G1': 49.00, 'G#1': 51.91, 'Ab1': 51.91, 'A1': 55.00, 'A#1': 58.27, 'Bb1': 58.27, 'B1': 61.74,
  'C2': 65.41, 'C#2': 69.30, 'Db2': 69.30, 'D2': 73.42, 'D#2': 77.78, 'Eb2': 77.78, 'E2': 82.41, 'F2': 87.31, 'F#2': 92.50, 'Gb2': 92.50, 'G2': 98.00, 'G#2': 103.83, 'Ab2': 103.83, 'A2': 110.00, 'A#2': 116.54, 'Bb2': 116.54, 'B2': 123.47,
  'C3': 130.81, 'C#3': 138.59, 'Db3': 138.59, 'D3': 146.83, 'D#3': 155.56, 'Eb3': 155.56, 'E3': 164.81, 'F3': 174.61, 'F#3': 185.00, 'Gb3': 185.00, 'G3': 196.00, 'G#3': 207.65, 'Ab3': 207.65, 'A3': 220.00, 'A#3': 233.08, 'Bb3': 233.08, 'B3': 246.94,
  'C4': 261.63, 'C#4': 277.18, 'Db4': 277.18, 'D4': 293.66, 'D#4': 311.13, 'Eb4': 311.13, 'E4': 329.63, 'F4': 349.23, 'F#4': 369.99, 'Gb4': 369.99, 'G4': 392.00, 'G#4': 415.30, 'Ab4': 415.30, 'A4': 440.00, 'A#4': 466.16, 'Bb4': 466.16, 'B4': 493.88,
  'C5': 523.25, 'C#5': 554.37, 'Db5': 554.37, 'D5': 587.33, 'D#5': 622.25, 'Eb5': 622.25, 'E5': 659.26, 'F5': 698.46, 'F#5': 739.99, 'Gb5': 739.99, 'G5': 783.99, 'G#5': 830.61, 'Ab5': 830.61, 'A5': 880.00, 'A#5': 932.33, 'Bb5': 932.33, 'B5': 987.77,
}

// 402型扬琴标准调弦数据
export const YANGQIN_STRINGS: YangqinString[] = [
  // ==================== 第1排（高音区）13列 ====================
  // 第1列
  { row: 1, col: 1, stringNum: 1, note: 'F3', frequency: FREQ['F3'], label: 'f3', notation: '4̇' },
  { row: 1, col: 1, stringNum: 2, note: 'Eb3', frequency: FREQ['Eb3'], label: '#d3', notation: '#2̇' },
  { row: 1, col: 1, stringNum: 3, note: 'C#3', frequency: FREQ['C#3'], label: '#c3', notation: '#1̇' },

  // 第2列
  { row: 1, col: 2, stringNum: 1, note: 'F#3', frequency: FREQ['F#3'], label: '#f3', notation: '#4̇' },
  { row: 1, col: 2, stringNum: 2, note: 'E3', frequency: FREQ['E3'], label: 'e3', notation: '3̇' },
  { row: 1, col: 2, stringNum: 3, note: 'D3', frequency: FREQ['D3'], label: 'd3', notation: '2̇' },

  // 第3列
  { row: 1, col: 2, stringNum: 4, note: 'C3', frequency: FREQ['C3'], label: 'c3', notation: '1̇' },
  { row: 1, col: 2, stringNum: 5, note: 'B2', frequency: FREQ['B2'], label: 'b2', notation: '7' },
  { row: 1, col: 2, stringNum: 6, note: 'A2', frequency: FREQ['A2'], label: 'a2', notation: '6' },

  // 第4列
  { row: 1, col: 2, stringNum: 7, note: 'G2', frequency: FREQ['G2'], label: 'g2', notation: '5' },
  { row: 1, col: 2, stringNum: 8, note: 'Gb2', frequency: FREQ['Gb2'], label: 'bg2', notation: 'b5' },
  { row: 1, col: 2, stringNum: 9, note: 'E2', frequency: FREQ['E2'], label: 'e2', notation: '3' },

  // 第5列
  { row: 1, col: 2, stringNum: 10, note: 'D2', frequency: FREQ['D2'], label: 'd2', notation: '2' },
  { row: 1, col: 2, stringNum: 11, note: 'C2', frequency: FREQ['C2'], label: 'c2', notation: '1' },
  { row: 1, col: 2, stringNum: 12, note: 'A#1', frequency: FREQ['A#1'], label: '#a1', notation: '#6̣' },
  { row: 1, col: 2, stringNum: 13, note: 'G#1', frequency: FREQ['G#1'], label: '#g1', notation: '#5̣' },

  // 第6列
  { row: 1, col: 3, stringNum: 1, note: 'A3', frequency: FREQ['A3'], label: 'a3', notation: '6̇' },
  { row: 1, col: 3, stringNum: 2, note: 'G3', frequency: FREQ['G3'], label: 'g3', notation: '5̇' },
  { row: 1, col: 3, stringNum: 3, note: 'A#2', frequency: FREQ['A#2'], label: '#a2', notation: '#6' },

  // 第7列
  { row: 1, col: 3, stringNum: 4, note: 'G#2', frequency: FREQ['G#2'], label: '#g2', notation: '#5' },
  { row: 1, col: 3, stringNum: 5, note: 'F2', frequency: FREQ['F2'], label: 'f2', notation: '4' },
  { row: 1, col: 3, stringNum: 6, note: 'Eb2', frequency: FREQ['Eb2'], label: 'be2', notation: 'b3' },

  // 第8列
  { row: 1, col: 3, stringNum: 7, note: 'C#2', frequency: FREQ['C#2'], label: '#c2', notation: '#1' },
  { row: 1, col: 3, stringNum: 8, note: 'B1', frequency: FREQ['B1'], label: 'b1', notation: '7̣' },
  { row: 1, col: 3, stringNum: 9, note: 'A1', frequency: FREQ['A1'], label: 'a1', notation: '6̣' },

  // 第9列
  { row: 1, col: 3, stringNum: 10, note: 'G1', frequency: FREQ['G1'], label: 'g1', notation: '5̣' },
  { row: 1, col: 3, stringNum: 11, note: 'F1', frequency: FREQ['F1'], label: 'f1', notation: '4̣' },
  { row: 1, col: 3, stringNum: 12, note: 'D#1', frequency: FREQ['D#1'], label: '#d1', notation: '#2̣' },
  { row: 1, col: 3, stringNum: 13, note: 'C#1', frequency: FREQ['C#1'], label: '#c1', notation: '#1̣' },

  // 第10列
  { row: 1, col: 4, stringNum: 1, note: 'E2', frequency: FREQ['E2'], label: 'e2', notation: '3' },
  { row: 1, col: 4, stringNum: 2, note: 'D2', frequency: FREQ['D2'], label: 'd2', notation: '2' },
  { row: 1, col: 4, stringNum: 3, note: 'C2', frequency: FREQ['C2'], label: 'c2', notation: '1' },

  // 第11列
  { row: 1, col: 4, stringNum: 4, note: 'A#1', frequency: FREQ['A#1'], label: '#a1', notation: '#6̣' },
  { row: 1, col: 4, stringNum: 5, note: 'G#1', frequency: FREQ['G#1'], label: '#g1', notation: '#5̣' },
  { row: 1, col: 4, stringNum: 6, note: 'F#1', frequency: FREQ['F#1'], label: '#f1', notation: '#4̣' },

  // 第12列
  { row: 1, col: 4, stringNum: 7, note: 'E1', frequency: FREQ['E1'], label: 'e1', notation: '3̣' },
  { row: 1, col: 4, stringNum: 8, note: 'D1', frequency: FREQ['D1'], label: 'd1', notation: '2̣' },
  { row: 1, col: 4, stringNum: 9, note: 'C1', frequency: FREQ['C1'], label: 'c1', notation: '1' },

  // 第13列
  { row: 1, col: 4, stringNum: 10, note: 'A#0', frequency: FREQ['A#0'], label: '#a', notation: '#6̣' },
  { row: 1, col: 4, stringNum: 11, note: 'G#0', frequency: FREQ['G#0'], label: '#g', notation: '#5̣̣' },


  // ==================== 第2排（中音区）13列 ====================
  { row: 2, col: 5, stringNum: 1, note: 'G1', frequency: FREQ['G1'], label: 'g1', notation: '5̣' },
  { row: 2, col: 5, stringNum: 2, note: 'F1', frequency: FREQ['F1'], label: 'f1', notation: '4̣' },
  { row: 2, col: 5, stringNum: 3, note: 'D#1', frequency: FREQ['D#1'], label: '#d1', notation: '#2̣' },

  { row: 2, col: 5, stringNum: 4, note: 'C#1', frequency: FREQ['C#1'], label: '#c1', notation: '#1̣' },
  { row: 2, col: 5, stringNum: 5, note: 'B0', frequency: FREQ['B0'], label: 'b', notation: '7̣̣' },
  { row: 2, col: 5, stringNum: 6, note: 'A0', frequency: FREQ['A0'], label: 'a', notation: '6̣' },

  { row: 2, col: 5, stringNum: 7, note: 'G0', frequency: FREQ['G0'], label: 'g', notation: '5̣' },
  { row: 2, col: 5, stringNum: 8, note: 'F0', frequency: FREQ['F0'], label: 'f', notation: '4̣̣' },
  { row: 2, col: 5, stringNum: 9, note: 'D#0', frequency: FREQ['D#0'], label: '#d', notation: '#2̣̣' },

  { row: 2, col: 5, stringNum: 10, note: 'C#0', frequency: FREQ['C#0'], label: '#c', notation: '#1̣̣' },

  { row: 2, col: 6, stringNum: 1, note: 'C1', frequency: FREQ['C1'], label: 'c1', notation: '1̣' },
  { row: 2, col: 6, stringNum: 2, note: 'A#0', frequency: FREQ['A#0'], label: '#a', notation: '#6̣̣' },

  { row: 2, col: 6, stringNum: 3, note: 'F#0', frequency: FREQ['F#0'], label: '#f', notation: '#4̣' },
  { row: 2, col: 6, stringNum: 4, note: 'E0', frequency: FREQ['E0'], label: 'e/bd2', notation: '3̣̣' },
  { row: 2, col: 6, stringNum: 5, note: 'D0', frequency: FREQ['D0'], label: 'd', notation: '2̣̣' },

  // 第6列
  { row: 2, col: 6, stringNum: 6, note: 'C0', frequency: FREQ['C0'], label: 'c', notation: '1̣̣' },
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
