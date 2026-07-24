import 'package:flutter_test/flutter_test.dart';
import 'package:tuner_app/features/yangqin/domain/yangqin_data.dart';

void main() {
  group('Yangqin Data', () {
    test('Has strings defined', () {
      expect(yangqinStrings.isNotEmpty, true);
    });

    test('All strings have positive frequencies', () {
      for (final string in yangqinStrings) {
        expect(
          string.frequency,
          greaterThan(0),
          reason: 'String ${string.stringNum} should have positive frequency',
        );
      }
    });

    test('String numbers are unique', () {
      final nums = yangqinStrings.map((s) => s.stringNum).toSet();
      expect(nums.length, yangqinStrings.length);
    });

    test('getRowCol returns correct strings', () {
      final strings = getStringsByRowCol(1, 1);
      expect(strings.length, greaterThan(0));
      for (final s in strings) {
        expect(s.row, 1);
        expect(s.col, 1);
      }
    });

    test('getStringByNum returns null for invalid number', () {
      expect(getStringByNum(99999), isNull);
    });

    test('getAllStrings returns all strings', () {
      final all = getAllStrings();
      expect(all.length, yangqinStrings.length);
    });
  });
}
