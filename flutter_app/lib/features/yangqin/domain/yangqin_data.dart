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

  YangqinString copyWith({double? frequency}) {
    return YangqinString(
      row: row,
      col: col,
      stringNum: stringNum,
      note: note,
      frequency: frequency ?? this.frequency,
      label: label,
      notation: notation,
    );
  }
}

// 音名频率对照表 (A4=440Hz, 十二平均律)
const Map<String, double> _freq = {
  'C0': 16.35,
  'C#0': 17.32,
  'Db0': 17.32,
  'D0': 18.35,
  'D#0': 19.45,
  'Eb0': 19.45,
  'E0': 20.60,
  'F0': 21.83,
  'F#0': 23.12,
  'Gb0': 23.12,
  'G0': 24.50,
  'G#0': 25.96,
  'Ab0': 25.96,
  'A0': 27.50,
  'A#0': 29.14,
  'Bb0': 29.14,
  'B0': 30.87,
  'C1': 32.70,
  'C#1': 34.65,
  'Db1': 34.65,
  'D1': 36.71,
  'D#1': 38.89,
  'Eb1': 38.89,
  'E1': 41.20,
  'F1': 43.65,
  'F#1': 46.25,
  'Gb1': 46.25,
  'G1': 49.00,
  'G#1': 51.91,
  'Ab1': 51.91,
  'A1': 55.00,
  'A#1': 58.27,
  'Bb1': 58.27,
  'B1': 61.74,
  'C2': 65.41,
  'C#2': 69.30,
  'Db2': 69.30,
  'D2': 73.42,
  'D#2': 77.78,
  'Eb2': 77.78,
  'E2': 82.41,
  'F2': 87.31,
  'F#2': 92.50,
  'Gb2': 92.50,
  'G2': 98.00,
  'G#2': 103.83,
  'Ab2': 103.83,
  'A2': 110.00,
  'A#2': 116.54,
  'Bb2': 116.54,
  'B2': 123.47,
  'C3': 130.81,
  'C#3': 138.59,
  'Db3': 138.59,
  'D3': 146.83,
  'D#3': 155.56,
  'Eb3': 155.56,
  'E3': 164.81,
  'F3': 174.61,
  'F#3': 185.00,
  'Gb3': 185.00,
  'G3': 196.00,
  'G#3': 207.65,
  'Ab3': 207.65,
  'A3': 220.00,
  'A#3': 233.08,
  'Bb3': 233.08,
  'B3': 246.94,
  'C4': 261.63,
  'C#4': 277.18,
  'Db4': 277.18,
  'D4': 293.66,
  'D#4': 311.13,
  'Eb4': 311.13,
  'E4': 329.63,
  'F4': 349.23,
  'F#4': 369.99,
  'Gb4': 369.99,
  'G4': 392.00,
  'G#4': 415.30,
  'Ab4': 415.30,
  'A4': 440.00,
  'A#4': 466.16,
  'Bb4': 466.16,
  'B4': 493.88,
  'C5': 523.25,
  'C#5': 554.37,
  'Db5': 554.37,
  'D5': 587.33,
  'D#5': 622.25,
  'Eb5': 622.25,
  'E5': 659.26,
  'F5': 698.46,
  'F#5': 739.99,
  'Gb5': 739.99,
  'G5': 783.99,
  'G#5': 830.61,
  'Ab5': 830.61,
  'A5': 880.00,
  'A#5': 932.33,
  'Bb5': 932.33,
  'B5': 987.77,
};

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
    col: 3,
    stringNum: 7,
    note: 'C3',
    frequency: 261.60,
    label: 'c3',
    notation: '1̇',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 8,
    note: 'B2',
    frequency: 246.96,
    label: 'b2',
    notation: '7',
  ),
  YangqinString(
    row: 1,
    col: 3,
    stringNum: 9,
    note: 'A2',
    frequency: 220.00,
    label: 'a2',
    notation: '6',
  ),

  // 第4列
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 10,
    note: 'G2',
    frequency: 196.00,
    label: 'g2',
    notation: '5',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 11,
    note: 'Gb2',
    frequency: 184.96,
    label: 'bg2',
    notation: 'b5',
  ),
  YangqinString(
    row: 1,
    col: 4,
    stringNum: 12,
    note: 'E2',
    frequency: 164.80,
    label: 'e2',
    notation: '3',
  ),

  // 第5列
  YangqinString(
    row: 1,
    col: 5,
    stringNum: 13,
    note: 'D2',
    frequency: 146.80,
    label: 'd2',
    notation: '2',
  ),
  YangqinString(
    row: 1,
    col: 5,
    stringNum: 14,
    note: 'C2',
    frequency: 130.80,
    label: 'c2',
    notation: '1',
  ),
  YangqinString(
    row: 1,
    col: 5,
    stringNum: 15,
    note: 'A#1',
    frequency: 116.54,
    label: '#a1',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 5,
    stringNum: 16,
    note: 'G#1',
    frequency: 103.83,
    label: '#g1',
    notation: '#5̣',
  ),

  // 第6列
  YangqinString(
    row: 1,
    col: 6,
    stringNum: 17,
    note: 'A3',
    frequency: 440.00,
    label: 'a3',
    notation: '6̇',
  ),
  YangqinString(
    row: 1,
    col: 6,
    stringNum: 18,
    note: 'G3',
    frequency: 392.00,
    label: 'g3',
    notation: '5̇',
  ),
  YangqinString(
    row: 1,
    col: 6,
    stringNum: 19,
    note: 'A#2',
    frequency: 233.12,
    label: '#a2',
    notation: '#6',
  ),

  // 第7列
  YangqinString(
    row: 1,
    col: 7,
    stringNum: 20,
    note: 'G#2',
    frequency: 207.68,
    label: '#g2',
    notation: '#5',
  ),
  YangqinString(
    row: 1,
    col: 7,
    stringNum: 21,
    note: 'F2',
    frequency: 174.64,
    label: 'f2',
    notation: '4',
  ),
  YangqinString(
    row: 1,
    col: 7,
    stringNum: 22,
    note: 'Eb2',
    frequency: 155.60,
    label: 'be2',
    notation: 'b3',
  ),

  // 第8列
  YangqinString(
    row: 1,
    col: 8,
    stringNum: 23,
    note: 'C#2',
    frequency: 138.56,
    label: '#c2',
    notation: '#1',
  ),
  YangqinString(
    row: 1,
    col: 8,
    stringNum: 24,
    note: 'B1',
    frequency: 123.48,
    label: 'b1',
    notation: '7̣',
  ),
  YangqinString(
    row: 1,
    col: 8,
    stringNum: 25,
    note: 'A1',
    frequency: 110.00,
    label: 'a1',
    notation: '6̣',
  ),

  // 第9列
  YangqinString(
    row: 1,
    col: 9,
    stringNum: 26,
    note: 'G1',
    frequency: 98.00,
    label: 'g1',
    notation: '5̣',
  ),
  YangqinString(
    row: 1,
    col: 9,
    stringNum: 27,
    note: 'F1',
    frequency: 87.30,
    label: 'f1',
    notation: '4̣',
  ),
  YangqinString(
    row: 1,
    col: 9,
    stringNum: 28,
    note: 'D#1',
    frequency: 77.78,
    label: '#d1',
    notation: '#2̣',
  ),
  YangqinString(
    row: 1,
    col: 9,
    stringNum: 29,
    note: 'C#1',
    frequency: 69.30,
    label: '#c1',
    notation: '#1',
  ),

  // 第10列
  YangqinString(
    row: 1,
    col: 10,
    stringNum: 30,
    note: 'E2',
    frequency: 164.80,
    label: 'e2',
    notation: '3',
  ),
  YangqinString(
    row: 1,
    col: 10,
    stringNum: 31,
    note: 'D2',
    frequency: 146.80,
    label: 'd2',
    notation: '2',
  ),
  YangqinString(
    row: 1,
    col: 10,
    stringNum: 32,
    note: 'C2',
    frequency: 130.80,
    label: 'c2',
    notation: '1',
  ),

  // 第11列
  YangqinString(
    row: 1,
    col: 11,
    stringNum: 33,
    note: 'A#1',
    frequency: 116.54,
    label: '#a1',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 11,
    stringNum: 34,
    note: 'G#1',
    frequency: 103.83,
    label: '#g1',
    notation: '#5̣',
  ),
  YangqinString(
    row: 1,
    col: 11,
    stringNum: 35,
    note: 'F#1',
    frequency: 92.50,
    label: '#f1',
    notation: '#4',
  ),

  // 第12列
  YangqinString(
    row: 1,
    col: 12,
    stringNum: 36,
    note: 'E1',
    frequency: 82.40,
    label: 'e1',
    notation: '3',
  ),
  YangqinString(
    row: 1,
    col: 12,
    stringNum: 37,
    note: 'D1',
    frequency: 73.42,
    label: 'd1',
    notation: '2̣',
  ),
  YangqinString(
    row: 1,
    col: 12,
    stringNum: 38,
    note: 'C1',
    frequency: 65.41,
    label: 'c1',
    notation: '1',
  ),

  // 第13列
  YangqinString(
    row: 1,
    col: 13,
    stringNum: 39,
    note: 'A#0',
    frequency: 58.27,
    label: '#a',
    notation: '#6̣',
  ),
  YangqinString(
    row: 1,
    col: 13,
    stringNum: 40,
    note: 'G#0',
    frequency: 51.91,
    label: '#g',
    notation: '#5̣',
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
    notation: '#4',
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
    notation: '7̣',
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

/// Get all strings for a specific column (across all rows)
List<YangqinString> getStringsByColumn(int col) {
  return yangqinStrings.where((s) => s.col == col).toList();
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

/// Get available columns (1-14)
List<int> getAvailableColumns() {
  final cols = yangqinStrings.map((s) => s.col).toSet().toList();
  cols.sort();
  return cols;
}

/// Get available rows (1-4)
List<int> getAvailableRows() {
  final rows = yangqinStrings.map((s) => s.row).toSet().toList();
  rows.sort();
  return rows;
}
