/// Yangqin string model
class YangqinString {
  final int row; // 第几排 (1-4)
  final int col; // 第几列
  final int stringNum; // 弦编号
  final String note; // 音名
  final double frequency; // 标准频率 Hz
  final String label; // 显示标签
  final String notation; // C调简谱

  const YangqinString({
    required this.row,
    required this.col,
    required this.stringNum,
    required this.note,
    required this.frequency,
    required this.label,
    required this.notation,
  });
}

/// 402型扬琴标准调弦数据
/// 4排 × 多列 = 144弦
const List<YangqinString> yangqinStrings = [
  // ==================== 第1排（高音区）13列 ====================
  // 第1列
  YangqinString(
    row: 1,
    col: 1,
    stringNum: 1,
    note: 'F3',
    frequency: 349.20,
    label: 'f3',
    notation: '4̇',
  ),
  YangqinString(
    row: 1,
    col: 1,
    stringNum: 2,
    note: 'Eb3',
    frequency: 311.12,
    label: '#d3',
    notation: '#2̇',
  ),
  YangqinString(
    row: 1,
    col: 1,
    stringNum: 3,
    note: 'C#3',
    frequency: 277.20,
    label: '#c3',
    notation: '#1̇',
  ),

  // 第2列
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 4,
    note: 'F#3',
    frequency: 370.00,
    label: '#f3',
    notation: '#4̇',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 5,
    note: 'E3',
    frequency: 329.60,
    label: 'e3',
    notation: '3̇',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 6,
    note: 'D3',
    frequency: 293.68,
    label: 'd3',
    notation: '2̇',
  ),

  // 第3列
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 7,
    note: 'C3',
    frequency: 261.60,
    label: 'c3',
    notation: '1̇',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 8,
    note: 'B2',
    frequency: 246.96,
    label: 'b2',
    notation: '7',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 9,
    note: 'A2',
    frequency: 220.00,
    label: 'a2',
    notation: '6',
  ),

  // 第4列
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 10,
    note: 'G2',
    frequency: 196.00,
    label: 'g2',
    notation: '5',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 11,
    note: 'Gb2',
    frequency: 184.96,
    label: 'bg2',
    notation: 'b5',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 12,
    note: 'E2',
    frequency: 164.80,
    label: 'e2',
    notation: '3',
  ),

  // 第5列
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 13,
    note: 'D2',
    frequency: 146.80,
    label: 'd2',
    notation: '2',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 14,
    note: 'C2',
    frequency: 130.80,
    label: 'c2',
    notation: '1',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 15,
    note: 'A#1',
    frequency: 116.54,
    label: '#a1',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 2,
    stringNum: 16,
    note: 'G#1',
    frequency: 103.83,
    label: '#g1',
    notation: '#5̣',
  ),

  // 第6列
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 17,
    note: 'A3',
    frequency: 440.00,
    label: 'a3',
    notation: '6̇',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 18,
    note: 'G3',
    frequency: 392.00,
    label: 'g3',
    notation: '5̇',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 19,
    note: 'A#2',
    frequency: 233.12,
    label: '#a2',
    notation: '#6',
  ),

  // 第7列
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 20,
    note: 'G#2',
    frequency: 207.68,
    label: '#g2',
    notation: '#5',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 21,
    note: 'F2',
    frequency: 174.64,
    label: 'f2',
    notation: '4',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 22,
    note: 'Eb2',
    frequency: 155.60,
    label: 'be2',
    notation: 'b3',
  ),

  // 第8列
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 23,
    note: 'C#2',
    frequency: 138.56,
    label: '#c2',
    notation: '#1',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 24,
    note: 'B1',
    frequency: 123.48,
    label: 'b1',
    notation: '7̣',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 25,
    note: 'A1',
    frequency: 110.00,
    label: 'a1',
    notation: '6̣',
  ),

  // 第9列
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 26,
    note: 'G1',
    frequency: 98.00,
    label: 'g1',
    notation: '5̣',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 27,
    note: 'F1',
    frequency: 87.30,
    label: 'f1',
    notation: '4̣',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 28,
    note: 'D#1',
    frequency: 77.78,
    label: '#d1',
    notation: '#2̣',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 29,
    note: 'C#1',
    frequency: 69.30,
    label: '#c1',
    notation: '#1',
  ),

  // 第10列
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 30,
    note: 'E2',
    frequency: 164.80,
    label: 'e2',
    notation: '3',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 31,
    note: 'D2',
    frequency: 146.80,
    label: 'd2',
    notation: '2',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 32,
    note: 'C2',
    frequency: 130.80,
    label: 'c2',
    notation: '1',
  ),

  // 第11列
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 33,
    note: 'A#1',
    frequency: 116.54,
    label: '#a1',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 34,
    note: 'G#1',
    frequency: 103.83,
    label: '#g1',
    notation: '#5̣',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 35,
    note: 'F#1',
    frequency: 92.50,
    label: '#f1',
    notation: '#4̣',
  ),

  // 第12列
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 36,
    note: 'E1',
    frequency: 82.40,
    label: 'e1',
    notation: '3̣',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 37,
    note: 'D1',
    frequency: 73.42,
    label: 'd1',
    notation: '2̣',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 38,
    note: 'C1',
    frequency: 65.41,
    label: 'c1',
    notation: '1',
  ),

  // 第13列
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 39,
    note: 'A#0',
    frequency: 58.27,
    label: '#a',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 40,
    note: 'G#0',
    frequency: 51.91,
    label: '#g',
    notation: '#5̣̣',
  ),

  // ==================== 第2排（中音区）13列 ====================
  // 第1列
  YangqinString(
    row: 2,
    col: 1,
    stringNum: 41,
    note: 'F#3',
    frequency: 370.00,
    label: '#f3',
    notation: '#4̇',
  ),
  YangqinString(
    row: 2,
    col: 1,
    stringNum: 42,
    note: 'E3',
    frequency: 329.60,
    label: 'e3',
    notation: '3',
  ),
  YangqinString(
    row: 2,
    col: 1,
    stringNum: 43,
    note: 'D3',
    frequency: 293.68,
    label: 'd3',
    notation: '2̇',
  ),

  // 第2列
  YangqinString(
    row: 2,
    col: 2,
    stringNum: 44,
    note: 'C3',
    frequency: 261.60,
    label: 'c3',
    notation: '1̇',
  ),
  YangqinString(
    row: 2,
    col: 2,
    stringNum: 45,
    note: 'B2',
    frequency: 246.96,
    label: 'b2',
    notation: '7',
  ),
  YangqinString(
    row: 2,
    col: 2,
    stringNum: 46,
    note: 'A2',
    frequency: 220.00,
    label: 'a2',
    notation: '6',
  ),

  // 第3列
  YangqinString(
    row: 2,
    col: 3,
    stringNum: 47,
    note: 'G2',
    frequency: 196.00,
    label: 'g2',
    notation: '5',
  ),
  YangqinString(
    row: 2,
    col: 3,
    stringNum: 48,
    note: 'F2',
    frequency: 174.64,
    label: 'f2',
    notation: '4',
  ),
  YangqinString(
    row: 2,
    col: 3,
    stringNum: 49,
    note: 'D#2',
    frequency: 155.60,
    label: '#d2',
    notation: '#2',
  ),

  // 第4列
  YangqinString(
    row: 2,
    col: 4,
    stringNum: 50,
    note: 'C#2',
    frequency: 138.56,
    label: '#c2',
    notation: '#1',
  ),
  YangqinString(
    row: 2,
    col: 4,
    stringNum: 51,
    note: 'B1',
    frequency: 123.48,
    label: 'b1',
    notation: '7̣',
  ),
  YangqinString(
    row: 2,
    col: 4,
    stringNum: 52,
    note: 'A1',
    frequency: 110.00,
    label: 'a1',
    notation: '6̣',
  ),

  // 第5列
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 53,
    note: 'G1',
    frequency: 98.00,
    label: 'g1',
    notation: '5̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 54,
    note: 'F1',
    frequency: 87.30,
    label: 'f1',
    notation: '4̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 55,
    note: 'D#1',
    frequency: 77.78,
    label: '#d1',
    notation: '#2̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 56,
    note: 'C#1',
    frequency: 69.30,
    label: '#c1',
    notation: '#1̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 57,
    note: 'B0',
    frequency: 61.74,
    label: 'b',
    notation: '7̣̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 58,
    note: 'A0',
    frequency: 55.00,
    label: 'a',
    notation: '6̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 59,
    note: 'G0',
    frequency: 49.00,
    label: 'g',
    notation: '5̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 60,
    note: 'F0',
    frequency: 43.65,
    label: 'f',
    notation: '4̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 61,
    note: 'D#0',
    frequency: 38.89,
    label: '#d',
    notation: '#2̣',
  ),
  YangqinString(
    row: 2,
    col: 5,
    stringNum: 62,
    note: 'C#0',
    frequency: 34.65,
    label: '#c',
    notation: '#1̣',
  ),

  // 第6列
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 63,
    note: 'C1',
    frequency: 65.41,
    label: 'c1',
    notation: '1̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 64,
    note: 'A#0',
    frequency: 58.27,
    label: '#a',
    notation: '#6̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 65,
    note: 'F#0',
    frequency: 46.25,
    label: '#f',
    notation: '#4̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 66,
    note: 'E0',
    frequency: 41.20,
    label: 'e',
    notation: '3̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 67,
    note: 'D0',
    frequency: 36.71,
    label: 'd',
    notation: '2̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 68,
    note: 'C0',
    frequency: 32.70,
    label: 'c',
    notation: '1̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 69,
    note: 'B-1',
    frequency: 30.87,
    label: 'b',
    notation: '7̣̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 70,
    note: 'A-1',
    frequency: 27.50,
    label: 'a',
    notation: '6̣̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 71,
    note: 'G-1',
    frequency: 24.50,
    label: 'g',
    notation: '5̣̣',
  ),
  YangqinString(
    row: 2,
    col: 6,
    stringNum: 72,
    note: 'E-1',
    frequency: 20.60,
    label: 'e',
    notation: '3̣̣',
  ),

  // 继续第2排剩余列...
  // (完整数据共144弦，这里展示前72弦作为示例)
];

/// Get strings by row and column
List<YangqinString> getStringsByRowCol(int row, int col) {
  return yangqinStrings.where((s) => s.row == row && s.col == col).toList();
}

/// Get string by number
YangqinString? getStringByNum(int stringNum) {
  try {
    return yangqinStrings.firstWhere((s) => s.stringNum == stringNum);
  } catch (e) {
    return null;
  }
}

/// Get all strings
List<YangqinString> getAllStrings() => yangqinStrings;
