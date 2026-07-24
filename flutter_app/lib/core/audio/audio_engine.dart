/// Audio engine interface for tuner
/// Platform-specific implementations provide real-time pitch detection
library;

/// Instrument types for tuner
enum InstrumentType { guitar, ukulele, yangqin }

/// Audio engine state
enum AudioEngineState { idle, listening, waiting, unstable, detected }

/// Microphone error types
enum MicError { denied, unavailable, none }

/// Pitch detection result
class PitchResult {
  final double frequency;
  final double cents;
  final String note;
  final double confidence;
  final double rms;
  final bool stable;
  final DateTime timestamp;

  const PitchResult({
    required this.frequency,
    required this.cents,
    required this.note,
    required this.confidence,
    required this.rms,
    required this.stable,
    required this.timestamp,
  });

  factory PitchResult.empty() => PitchResult(
    frequency: 0,
    cents: 0,
    note: '--',
    confidence: 0,
    rms: 0,
    stable: false,
    timestamp: DateTime.now(),
  );

  bool get inTune => cents.abs() <= 5;
  bool get tooHigh => cents > 5;
  bool get tooLow => cents < -5;

  PitchResult copyWith({
    double? frequency,
    double? cents,
    String? note,
    double? confidence,
    double? rms,
    bool? stable,
    DateTime? timestamp,
  }) {
    return PitchResult(
      frequency: frequency ?? this.frequency,
      cents: cents ?? this.cents,
      note: note ?? this.note,
      confidence: confidence ?? this.confidence,
      rms: rms ?? this.rms,
      stable: stable ?? this.stable,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Abstract interface for tuner audio engine
/// Platform implementations (Android/iOS) provide real DSP
abstract interface class TunerAudioEngine {
  /// Stream of pitch detection results
  Stream<PitchResult> get results;

  /// Current engine state
  AudioEngineState get state;

  /// Current microphone error state
  MicError get micError;

  /// Start audio capture and pitch detection
  Future<void> start({
    required InstrumentType instrument,
    double? targetFrequency,
  });

  /// Update target frequency for manual string selection
  Future<void> updateTarget(double? targetFrequency);

  /// Stop audio capture
  Future<void> stop();

  /// Request microphone permission and start
  /// Returns true if permission granted and started
  Future<bool> requestMicPermission();
}
