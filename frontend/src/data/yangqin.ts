/**
 * 扬琴调弦数据 - 网格布局 (行×列)
 *
 * 扬琴结构说明:
 * - 弦从左码(高音)到右码(低音)排列
 * - 行(row): 从上往下, 第1行最高音, 第4/5行最低音
 * - 列(col): 从左到右, 每列对应一个码子上的弦组
 *
 * 标准401型扬琴 (简化为4行×6列 = 24弦)
 */

export interface YangqinString {
  row: number       // 第几行 (1-4)
  col: number       // 第几列 (1-6)
  note: string      // 音名
  frequency: number // 频率 Hz
  label: string     // 显示标签
  bridge: string    // 码子: left(左码), mid(中码), right(右码)
}

// 401型扬琴标准调弦 (4行 × 6列)
export const YANGQIN_STRINGS: YangqinString[][] = [
  // 第1行 (最高音区)
  [
    { row: 1, col: 1, note: 'A5',  frequency: 880.00, label: 'A5', bridge: 'left' },
    { row: 1, col: 2, note: 'G5',  frequency: 783.99, label: 'G5', bridge: 'left' },
    { row: 1, col: 3, note: 'F5',  frequency: 698.46, label: 'F5', bridge: 'left' },
    { row: 1, col: 4, note: 'E5',  frequency: 659.26, label: 'E5', bridge: 'left' },
    { row: 1, col: 5, note: 'D5',  frequency: 587.33, label: 'D5', bridge: 'left' },
    { row: 1, col: 6, note: 'C5',  frequency: 523.25, label: 'C5', bridge: 'left' },
  ],
  // 第2行 (中高音区)
  [
    { row: 2, col: 1, note: 'B4',  frequency: 493.88, label: 'B4', bridge: 'mid' },
    { row: 2, col: 2, note: 'A4',  frequency: 440.00, label: 'A4', bridge: 'mid' },
    { row: 2, col: 3, note: 'G4',  frequency: 392.00, label: 'G4', bridge: 'mid' },
    { row: 2, col: 4, note: 'F4',  frequency: 349.23, label: 'F4', bridge: 'mid' },
    { row: 2, col: 5, note: 'E4',  frequency: 329.63, label: 'E4', bridge: 'mid' },
    { row: 2, col: 6, note: 'D4',  frequency: 293.66, label: 'D4', bridge: 'mid' },
  ],
  // 第3行 (中低音区)
  [
    { row: 3, col: 1, note: 'C4',  frequency: 261.63, label: 'C4', bridge: 'mid' },
    { row: 3, col: 2, note: 'B3',  frequency: 246.94, label: 'B3', bridge: 'mid' },
    { row: 3, col: 3, note: 'A3',  frequency: 220.00, label: 'A3', bridge: 'mid' },
    { row: 3, col: 4, note: 'G3',  frequency: 196.00, label: 'G3', bridge: 'right' },
    { row: 3, col: 5, note: 'F3',  frequency: 174.61, label: 'F3', bridge: 'right' },
    { row: 3, col: 6, note: 'E3',  frequency: 164.81, label: 'E3', bridge: 'right' },
  ],
  // 第4行 (最低音区)
  [
    { row: 4, col: 1, note: 'D3',  frequency: 146.83, label: 'D3', bridge: 'right' },
    { row: 4, col: 2, note: 'C3',  frequency: 130.81, label: 'C3', bridge: 'right' },
    { row: 4, col: 3, note: 'B2',  frequency: 123.47, label: 'B2', bridge: 'right' },
    { row: 4, col: 4, note: 'A2',  frequency: 110.00, label: 'A2', bridge: 'right' },
    { row: 4, col: 5, note: 'G2',  frequency: 98.00,  label: 'G2', bridge: 'right' },
    { row: 4, col: 6, note: 'E2',  frequency: 82.41,  label: 'E2', bridge: 'right' },
  ],
]

export const YANGQIN_ROWS = 4
export const YANGQIN_COLS = 6

// 获取所有弦的平坦列表
export function getAllYangqinStrings(): YangqinString[] {
  return YANGQIN_STRINGS.flat()
}

// 根据行列获取弦
export function getStringAt(row: number, col: number): YangqinString | null {
  if (row < 1 || row > YANGQIN_ROWS || col < 1 || col > YANGQIN_COLS) return null
  return YANGQIN_STRINGS[row - 1][col - 1]
}

// 根据频率找最近的弦
export function findNearestString(freq: number): { string: YangqinString; cents: number } | null {
  if (freq <= 0) return null
  const all = getAllYangqinStrings()
  let best: YangqinString | null = null
  let bestCents = Infinity

  for (const s of all) {
    const cents = Math.round(1200 * Math.log2(freq / s.frequency))
    if (Math.abs(cents) < Math.abs(bestCents)) {
      bestCents = cents
      best = s
    }
  }

  return best ? { string: best, cents: bestCents } : null
}
