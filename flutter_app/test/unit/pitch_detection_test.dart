import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tuner_app/core/audio/pitch_detection.dart';
import 'package:tuner_app/core/audio/test_signals.dart';

void main() {
  group('YIN Pitch Detector', () {
    const sampleRate = 44100;

    group('Pure sine waves', () {
      for (final entry in guitarTestFrequencies.entries) {
        test('Detects ${entry.key} (${entry.value} Hz)', () {
          final detector = YinPitchDetector(
            sampleRate: sampleRate,
            minFrequency: 60,
            maxFrequency: 2000,
          );

          final signal = generateSineWave(
            frequency: entry.value,
            sampleRate: sampleRate,
            durationSeconds: 0.1,
            amplitude: 0.5,
          );

          final result = detector.detect(signal);

          expect(result, isNotNull, reason: 'Should detect ${entry.key}');
          expect(result!.frequency, isNot(0));

          // Check accuracy within 1 cent
          final cents = centsDeviation(result.frequency, entry.value);
          expect(
            cents.abs(),
            lessThan(1.0),
            reason:
                '${entry.key} error: ${cents.abs().toStringAsFixed(2)} cents',
          );
        });
      }
    });

    group('Harmonic signals', () {
      test('Detects fundamental with strong 2nd harmonic', () {
        final detector = YinPitchDetector(
          sampleRate: sampleRate,
          minFrequency: 60,
          maxFrequency: 2000,
        );

        // A2 with strong 2nd harmonic (octave error test)
        final signal = generateHarmonicSignal(
          fundamental: 110.0, // A2
          sampleRate: sampleRate,
          durationSeconds: 0.1,
          fundamentalAmplitude: 0.2,
          secondHarmonicAmplitude: 0.4, // Stronger 2nd harmonic
          thirdHarmonicAmplitude: 0.1,
        );

        final result = detector.detect(signal);

        expect(result, isNotNull);
        // Should detect A2 (110 Hz), not A3 (220 Hz)
        final cents = centsDeviation(result!.frequency, 110.0);
        expect(
          cents.abs(),
          lessThan(5.0),
          reason: 'Should detect fundamental, not octave',
        );
      });
    });

    group('Edge cases', () {
      test('Returns null for silent buffer', () {
        final detector = YinPitchDetector(
          sampleRate: sampleRate,
          minFrequency: 60,
          maxFrequency: 2000,
        );

        final signal = List<double>.filled(4410, 0.0); // 0.1 seconds of silence
        final result = detector.detect(signal);

        expect(result, isNull);
      });

      test('Returns null for very short buffer', () {
        final detector = YinPitchDetector(
          sampleRate: sampleRate,
          minFrequency: 60,
          maxFrequency: 2000,
        );

        final signal = [0.1, 0.2, 0.1]; // Too short
        final result = detector.detect(signal);

        expect(result, isNull);
      });

      test('Returns null for white noise', () {
        final detector = YinPitchDetector(
          sampleRate: sampleRate,
          minFrequency: 60,
          maxFrequency: 2000,
        );

        final signal = generateWhiteNoise(
          sampleRate: sampleRate,
          durationSeconds: 0.1,
          amplitude: 0.3,
        );

        final result = detector.detect(signal);

        // White noise should not produce a stable pitch
        // (may occasionally detect something, but confidence should be low)
        if (result != null) {
          expect(result.confidence, lessThan(0.5));
        }
      });
    });

    group('Different amplitudes', () {
      test('Detects A2 at various amplitudes', () {
        final detector = YinPitchDetector(
          sampleRate: sampleRate,
          minFrequency: 60,
          maxFrequency: 2000,
        );

        for (final amplitude in [0.1, 0.3, 0.5, 0.8]) {
          final signal = generateSineWave(
            frequency: 110.0, // A2
            sampleRate: sampleRate,
            durationSeconds: 0.1,
            amplitude: amplitude,
          );

          final result = detector.detect(signal);

          expect(
            result,
            isNotNull,
            reason: 'Should detect at amplitude $amplitude',
          );
          final cents = centsDeviation(result!.frequency, 110.0);
          expect(
            cents.abs(),
            lessThan(2.0),
            reason:
                'Amplitude $amplitude error: ${cents.abs().toStringAsFixed(2)} cents',
          );
        }
      });
    });
  });

  group('Note name conversion', () {
    test('Converts A4 to correct name', () {
      expect(frequencyToNoteName(440.0), 'A4');
    });

    test('Converts E2 to correct name', () {
      expect(frequencyToNoteName(82.41), 'E2');
    });

    test('Converts frequencies near note boundaries', () {
      // 1 cent above A4
      final freq = 440.0 * pow(2.0, 1.0 / 1200.0);
      final name = frequencyToNoteName(freq);
      expect(name, 'A4');
    });
  });

  group('Cents deviation', () {
    test('Returns 0 for same frequency', () {
      expect(centsDeviation(440.0, 440.0), 0.0);
    });

    test('Returns positive for higher frequency', () {
      expect(centsDeviation(445.0, 440.0), greaterThan(0));
    });

    test('Returns negative for lower frequency', () {
      expect(centsDeviation(435.0, 440.0), lessThan(0));
    });

    test('100 cents = 1 semitone', () {
      // A4 to A#4 is 100 cents
      final a4 = 440.0;
      final aSharp4 = a4 * pow(2.0, 1.0 / 12.0);
      final cents = centsDeviation(aSharp4, a4);
      expect((cents - 100.0).abs(), lessThan(0.1));
    });
  });
}
