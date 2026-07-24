import 'package:flutter_test/flutter_test.dart';
import 'package:tuner_app/shared/models/tunings.dart';

void main() {
  group('Instrument Data', () {
    test('Guitar has 6 strings', () {
      expect(guitar.strings.length, 6);
    });

    test('Ukulele has 4 strings', () {
      expect(ukulele.strings.length, 4);
    });

    test('Guitar strings have correct frequencies', () {
      // E2 = 82.41 Hz (lowest)
      expect(guitar.strings.last.frequency, 82.41);
      // E4 = 329.63 Hz (highest)
      expect(guitar.strings.first.frequency, 329.63);
    });

    test('Ukulele strings have correct frequencies', () {
      // G4 = 392.00 Hz
      expect(ukulele.strings[3].frequency, 392.00);
      // C4 = 261.63 Hz
      expect(ukulele.strings[2].frequency, 261.63);
      // E4 = 329.63 Hz
      expect(ukulele.strings[1].frequency, 329.63);
      // A4 = 440.00 Hz
      expect(ukulele.strings[0].frequency, 440.00);
    });

    test('All instruments have unique IDs', () {
      final ids = instruments.map((i) => i.id).toSet();
      expect(ids.length, instruments.length);
    });

    test('All string frequencies are positive', () {
      for (final instrument in instruments) {
        for (final string in instrument.strings) {
          expect(
            string.frequency,
            greaterThan(0),
            reason:
                '${instrument.name} ${string.name} frequency should be positive',
          );
        }
      }
    });
  });
}
