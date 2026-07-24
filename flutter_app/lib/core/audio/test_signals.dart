/// Test signal generator for pitch detection testing
library;

import 'dart:math';

/// Generate a pure sine wave at given frequency
List<double> generateSineWave({
  required double frequency,
  required int sampleRate,
  required double durationSeconds,
  double amplitude = 0.5,
}) {
  final numSamples = (sampleRate * durationSeconds).round();
  final buffer = List<double>.filled(numSamples, 0.0);

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    buffer[i] = amplitude * sin(2 * pi * frequency * t);
  }

  return buffer;
}

/// Generate a signal with harmonics
/// fundamental + 2nd harmonic + 3rd harmonic
List<double> generateHarmonicSignal({
  required double fundamental,
  required int sampleRate,
  required double durationSeconds,
  double fundamentalAmplitude = 0.3,
  double secondHarmonicAmplitude = 0.2,
  double thirdHarmonicAmplitude = 0.1,
}) {
  final numSamples = (sampleRate * durationSeconds).round();
  final buffer = List<double>.filled(numSamples, 0.0);

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final phase = 2 * pi * t;

    buffer[i] =
        fundamentalAmplitude * sin(phase * fundamental) +
        secondHarmonicAmplitude * sin(phase * fundamental * 2) +
        thirdHarmonicAmplitude * sin(phase * fundamental * 3);
  }

  return buffer;
}

/// Generate white noise
List<double> generateWhiteNoise({
  required int sampleRate,
  required double durationSeconds,
  double amplitude = 0.1,
}) {
  final numSamples = (sampleRate * durationSeconds).round();
  final buffer = List<double>.filled(numSamples, 0.0);

  // Simple random noise (not cryptographically secure, but fine for testing)
  var seed = 12345;
  for (var i = 0; i < numSamples; i++) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    buffer[i] = amplitude * ((seed / 0x7fffffff) * 2 - 1);
  }

  return buffer;
}

/// Mix two signals together
List<double> mixSignals(
  List<double> a,
  List<double> b, {
  double aGain = 1.0,
  double bGain = 1.0,
}) {
  final length = a.length < b.length ? a.length : b.length;
  final result = List<double>.filled(length, 0.0);

  for (var i = 0; i < length; i++) {
    result[i] = a[i] * aGain + b[i] * bGain;
  }

  return result;
}

/// Guitar test frequencies (standard tuning)
const Map<String, double> guitarTestFrequencies = {
  'E2': 82.41,
  'A2': 110.00,
  'D3': 146.83,
  'G3': 196.00,
  'B3': 246.94,
  'E4': 329.63,
};
