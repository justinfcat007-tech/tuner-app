/// YIN pitch detection algorithm
/// Reference: de Cheveigné & Kawahara, "YIN, a fundamental frequency estimator..."
library;

import 'dart:math';

/// YIN pitch detector result
class YinResult {
  final double frequency;
  final double confidence;

  const YinResult({required this.frequency, required this.confidence});
}

/// YIN pitch detector
///
/// Implements:
/// 1. Difference function
/// 2. Cumulative Mean Normalized Difference Function (CMNDF)
/// 3. Absolute threshold
/// 4. Parabolic interpolation
class YinPitchDetector {
  /// Minimum frequency to detect (Hz)
  final double minFrequency;

  /// Maximum frequency to detect (Hz)
  final double maxFrequency;

  /// Absolute threshold for CMNDF (0.1-0.2 recommended)
  final double threshold;

  /// Sample rate in Hz
  final int sampleRate;

  YinPitchDetector({
    required this.sampleRate,
    this.minFrequency = 60,
    this.maxFrequency = 2000,
    this.threshold = 0.15,
  });

  /// Detect pitch from audio buffer
  /// Returns null if no pitch detected
  YinResult? detect(List<double> buffer) {
    if (buffer.length < 2) return null;

    final tauMin = _tauForFrequency(maxFrequency);
    final tauMax = _tauForFrequency(minFrequency);

    if (tauMin >= tauMax || tauMax >= buffer.length ~/ 2) return null;

    // Step 1: Difference function
    final difference = _differenceFunction(buffer, tauMax);

    // Step 2: CMNDF
    final cmndf = _cmndf(difference, tauMax);

    // Step 3: Absolute threshold
    final tau = _absoluteThreshold(cmndf, tauMin, tauMax);
    if (tau < 0) return null;

    // Step 4: Parabolic interpolation
    final betterTau = _parabolicInterpolation(cmndf, tau);

    // Calculate frequency and confidence
    final period = betterTau / sampleRate;
    final frequency = 1.0 / period;
    final confidence = 1.0 - cmndf[tau];

    if (frequency < minFrequency || frequency > maxFrequency) return null;

    return YinResult(
      frequency: frequency,
      confidence: confidence.clamp(0.0, 1.0),
    );
  }

  /// Convert frequency to tau (samples)
  int _tauForFrequency(double frequency) {
    return (sampleRate / frequency).round();
  }

  /// Step 1: Difference function
  /// d_t(τ) = Σ(x(n) - x(n+τ))²
  List<double> _differenceFunction(List<double> buffer, int tauMax) {
    final difference = List<double>.filled(tauMax + 1, 0.0);

    for (var tau = 1; tau <= tauMax; tau++) {
      var sum = 0.0;
      for (var i = 0; i < buffer.length - tau; i++) {
        final delta = buffer[i] - buffer[i + tau];
        sum += delta * delta;
      }
      difference[tau] = sum;
    }

    return difference;
  }

  /// Step 2: Cumulative Mean Normalized Difference Function
  /// d'_t(τ) = d_t(τ) / (1/τ * Σd_t(j)) for τ > 0
  List<double> _cmndf(List<double> difference, int tauMax) {
    final cmndf = List<double>.filled(tauMax + 1, 0.0);
    cmndf[0] = 1.0;

    var runningSum = 0.0;
    for (var tau = 1; tau <= tauMax; tau++) {
      runningSum += difference[tau];
      cmndf[tau] = runningSum == 0 ? 1.0 : (difference[tau] * tau) / runningSum;
    }

    return cmndf;
  }

  /// Step 3: Absolute threshold
  /// Find first τ where CMNDF < threshold, then find local minimum
  int _absoluteThreshold(List<double> cmndf, int tauMin, int tauMax) {
    var tau = tauMin;

    // Find first value below threshold
    while (tau <= tauMax) {
      if (cmndf[tau] < threshold) {
        // Find local minimum after crossing threshold
        while (tau + 1 <= tauMax && cmndf[tau + 1] < cmndf[tau]) {
          tau++;
        }
        return tau;
      }
      tau++;
    }

    // No pitch detected
    return -1;
  }

  /// Step 4: Parabolic interpolation
  /// Refine tau estimate using quadratic interpolation
  double _parabolicInterpolation(List<double> cmndf, int tau) {
    if (tau <= 0 || tau >= cmndf.length - 1) return tau.toDouble();

    final x1 = tau.toDouble();

    final y0 = cmndf[tau - 1];
    final y1 = cmndf[tau];
    final y2 = cmndf[tau + 1];

    final denom = y0 - 2 * y1 + y2;
    if (denom.abs() < 1e-10) return x1;

    final delta = 0.5 * (y0 - y2) / denom;
    return x1 + delta;
  }
}

/// Note name from frequency
String frequencyToNoteName(double frequency) {
  const noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  // A4 = 440 Hz, which is 9 semitones above C4
  // semitones from C4 = 12 * log2(f/440) + 9
  final semitonesFromC4 = 12 * log(frequency / 440.0) / ln2 + 9;
  final roundedSemitones = semitonesFromC4.round();
  final noteIndex = ((roundedSemitones % 12) + 12) % 12;
  final octave = (roundedSemitones / 12).floor() + 4;

  return '${noteNames[noteIndex]}$octave';
}

/// Cents deviation from target frequency
double centsDeviation(double frequency, double targetFrequency) {
  return 1200 * log(frequency / targetFrequency) / ln2;
}
