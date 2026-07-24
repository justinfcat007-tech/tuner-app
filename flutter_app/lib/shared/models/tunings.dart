import 'instrument.dart';

/// Guitar standard tuning (EADGBE)
const Instrument guitar = Instrument(
  id: 'guitar',
  name: '吉他',
  nameEn: 'Guitar',
  emoji: '🎸',
  strings: [
    StringNote(name: '1弦 (最细)', note: 'E4', frequency: 329.63, octave: 4),
    StringNote(name: '2弦', note: 'B3', frequency: 246.94, octave: 3),
    StringNote(name: '3弦', note: 'G3', frequency: 196.00, octave: 3),
    StringNote(name: '4弦', note: 'D3', frequency: 146.83, octave: 3),
    StringNote(name: '5弦', note: 'A2', frequency: 110.00, octave: 2),
    StringNote(name: '6弦 (最粗)', note: 'E2', frequency: 82.41, octave: 2),
  ],
);

/// Ukulele standard tuning (GCEA)
const Instrument ukulele = Instrument(
  id: 'ukulele',
  name: '尤克里里',
  nameEn: 'Ukulele',
  emoji: '🪕',
  strings: [
    StringNote(name: '1弦 (A)', note: 'A4', frequency: 440.00, octave: 4),
    StringNote(name: '2弦 (E)', note: 'E4', frequency: 329.63, octave: 4),
    StringNote(name: '3弦 (C)', note: 'C4', frequency: 261.63, octave: 4),
    StringNote(name: '4弦 (G)', note: 'G4', frequency: 392.00, octave: 4),
  ],
);

/// Yangqin (simplified for now - full data in yangqin_data.dart)
const Instrument yangqin = Instrument(
  id: 'yangqin',
  name: '扬琴',
  nameEn: 'Yangqin',
  emoji: '🎵',
  strings: [
    StringNote(name: 'A5', note: 'A5', frequency: 880.00, octave: 5),
    StringNote(name: 'G5', note: 'G5', frequency: 783.99, octave: 5),
    StringNote(name: 'F5', note: 'F5', frequency: 698.46, octave: 5),
    StringNote(name: 'E5', note: 'E5', frequency: 659.26, octave: 5),
    StringNote(name: 'D5', note: 'D5', frequency: 587.33, octave: 5),
    StringNote(name: 'C5', note: 'C5', frequency: 523.25, octave: 5),
  ],
);

/// All available instruments
const List<Instrument> instruments = [guitar, ukulele, yangqin];
