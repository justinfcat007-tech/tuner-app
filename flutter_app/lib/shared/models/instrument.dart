/// Instrument types for tuner
enum InstrumentType { guitar, ukulele, yangqin }

/// String note model
class StringNote {
  final String name;
  final String note;
  final double frequency;
  final int octave;

  const StringNote({
    required this.name,
    required this.note,
    required this.frequency,
    required this.octave,
  });
}

/// Instrument model
class Instrument {
  final String id;
  final String name;
  final String nameEn;
  final String emoji;
  final List<StringNote> strings;

  const Instrument({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.emoji,
    required this.strings,
  });
}
