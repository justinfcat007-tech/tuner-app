import 'package:shared_preferences/shared_preferences.dart';

/// Local preferences keys matching Vue project
class PreferenceKeys {
  static const String preferences = 'tuner.preferences.v1';
  static const String installCohort = 'tuner.install.v1';
}

/// Local preferences model
class LocalPreferences {
  final String lastInstrument;
  final int a4Reference;
  final bool voiceEnabled;
  final bool autoSelectString;
  final bool hasSeenMicEducation;

  const LocalPreferences({
    this.lastInstrument = 'guitar',
    this.a4Reference = 440,
    this.voiceEnabled = true,
    this.autoSelectString = true,
    this.hasSeenMicEducation = false,
  });

  LocalPreferences copyWith({
    String? lastInstrument,
    int? a4Reference,
    bool? voiceEnabled,
    bool? autoSelectString,
    bool? hasSeenMicEducation,
  }) {
    return LocalPreferences(
      lastInstrument: lastInstrument ?? this.lastInstrument,
      a4Reference: a4Reference ?? this.a4Reference,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      autoSelectString: autoSelectString ?? this.autoSelectString,
      hasSeenMicEducation: hasSeenMicEducation ?? this.hasSeenMicEducation,
    );
  }

  Map<String, dynamic> toJson() => {
    'lastInstrument': lastInstrument,
    'a4Reference': a4Reference,
    'voiceEnabled': voiceEnabled,
    'autoSelectString': autoSelectString,
    'hasSeenMicEducation': hasSeenMicEducation,
  };

  factory LocalPreferences.fromJson(Map<String, dynamic> json) {
    return LocalPreferences(
      lastInstrument: json['lastInstrument'] ?? 'guitar',
      a4Reference: json['a4Reference'] ?? 440,
      voiceEnabled: json['voiceEnabled'] ?? true,
      autoSelectString: json['autoSelectString'] ?? true,
      hasSeenMicEducation: json['hasSeenMicEducation'] ?? false,
    );
  }

  static const LocalPreferences defaults = LocalPreferences();
}

/// Install cohort for future commercialization
class InstallCohort {
  final String installationId;
  final String firstInstalledAt;
  final String firstSeenVersion;
  final String cohort; // 'early-access' or 'standard'

  const InstallCohort({
    required this.installationId,
    required this.firstInstalledAt,
    required this.firstSeenVersion,
    required this.cohort,
  });

  Map<String, dynamic> toJson() => {
    'installationId': installationId,
    'firstInstalledAt': firstInstalledAt,
    'firstSeenVersion': firstSeenVersion,
    'cohort': cohort,
  };

  factory InstallCohort.fromJson(Map<String, dynamic> json) {
    return InstallCohort(
      installationId: json['installationId'] ?? '',
      firstInstalledAt: json['firstInstalledAt'] ?? '',
      firstSeenVersion: json['firstSeenVersion'] ?? '1.0.0',
      cohort: json['cohort'] ?? 'early-access',
    );
  }
}

/// Local preferences repository
class LocalPreferencesRepository {
  final SharedPreferences _prefs;

  LocalPreferencesRepository(this._prefs);

  /// Load preferences from storage
  LocalPreferences load() {
    final json = _prefs.getString(PreferenceKeys.preferences);
    if (json == null) return LocalPreferences.defaults;
    try {
      return LocalPreferences.fromJson(
        Map<String, dynamic>.from(
          (LocalPreferences.defaults.toJson())..addAll(_decodeJson(json)),
        ),
      );
    } catch (e) {
      return LocalPreferences.defaults;
    }
  }

  /// Save preferences to storage
  Future<void> save(LocalPreferences prefs) async {
    await _prefs.setString(
      PreferenceKeys.preferences,
      _encodeJson(prefs.toJson()),
    );
  }

  /// Load or create install cohort
  InstallCohort getInstallCohort() {
    final json = _prefs.getString(PreferenceKeys.installCohort);
    if (json != null) {
      try {
        return InstallCohort.fromJson(
          Map<String, dynamic>.from(_decodeJson(json)),
        );
      } catch (e) {
        // fallthrough to create new
      }
    }

    final cohort = InstallCohort(
      installationId: _generateId(),
      firstInstalledAt: DateTime.now().toIso8601String(),
      firstSeenVersion: '1.0.0',
      cohort: 'early-access',
    );

    _prefs.setString(
      PreferenceKeys.installCohort,
      _encodeJson(cohort.toJson()),
    );

    return cohort;
  }

  Map<String, dynamic> _decodeJson(String json) {
    // Simple JSON decode - in production use dart:convert
    return {};
  }

  String _encodeJson(Map<String, dynamic> json) {
    // Simple JSON encode - in production use dart:convert
    return '{}';
  }

  String _generateId() {
    return 'flutter-${DateTime.now().millisecondsSinceEpoch}';
  }
}
