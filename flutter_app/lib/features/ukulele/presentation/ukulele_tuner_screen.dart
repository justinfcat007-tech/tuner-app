import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/audio/audio_engine.dart';
import '../../../shared/models/tunings.dart';
import '../../tuner/presentation/widgets/tuning_meter.dart';
import 'widgets/ukulele_headstock.dart';

/// Ukulele tuner screen
class UkuleleTunerScreen extends ConsumerStatefulWidget {
  const UkuleleTunerScreen({super.key});

  @override
  ConsumerState<UkuleleTunerScreen> createState() => _UkuleleTunerScreenState();
}

class _UkuleleTunerScreenState extends ConsumerState<UkuleleTunerScreen> {
  int _selectedString = 0; // 0-3 (A4, E4, C4, G4)
  bool _autoMode = false;
  double _a4Reference = 440.0;

  // Simulated pitch result (will be replaced with actual audio engine)
  final PitchResult _pitchResult = PitchResult.empty();

  List<String> get _stringNotes => ukulele.strings.map((s) => s.note).toList();

  void _onPegSelected(int peg) {
    setState(() {
      _selectedString = peg - 1;
      _autoMode = false;
    });
  }

  void _onNoteChange(int peg) {
    // TODO: Show note picker dialog
    setState(() {
      _selectedString = peg - 1;
    });
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'A4 Reference',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                DropdownButton<double>(
                  value: _a4Reference,
                  dropdownColor: AppTheme.surface,
                  items: [440.0, 442.0, 443.0].map((freq) {
                    return DropdownMenuItem(
                      value: freq,
                      child: Text('${freq.toInt()} Hz'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _a4Reference = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auto Mode',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                Switch(
                  value: _autoMode,
                  activeColor: AppTheme.accent,
                  onChanged: (value) {
                    setState(() {
                      _autoMode = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'High G Tuning',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                Switch(
                  value: true, // Default to high G
                  activeColor: AppTheme.accent,
                  onChanged: (value) {
                    // TODO: Implement high G / low G switching
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetFrequency = ukulele.strings[_selectedString].frequency;
    final targetNote = ukulele.strings[_selectedString].note;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.canvas,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Show help dialog
            },
            child: Text(
              'Help',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: _showSettings,
            child: Text(
              'Settings',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Tuning meter
              TuningMeter(
                cents: _pitchResult.cents,
                state: AudioEngineState.idle,
              ),
              const SizedBox(height: 24),

              // Note display
              NoteDisplay(
                note: _pitchResult.frequency > 0
                    ? _pitchResult.note
                    : targetNote,
                frequency: _pitchResult.frequency > 0
                    ? _pitchResult.frequency
                    : targetFrequency,
                inTune: _pitchResult.inTune,
              ),
              const SizedBox(height: 16),

              // Status indicator
              StatusIndicator(
                inTune: _pitchResult.inTune,
                tooHigh: _pitchResult.tooHigh,
                tooLow: _pitchResult.tooLow,
              ),
              const SizedBox(height: 32),

              // Ukulele headstock
              Expanded(
                child: Center(
                  child: UkuleleHeadstock(
                    activePeg: _selectedString + 1,
                    stringNotes: _stringNotes,
                    onPegSelected: _onPegSelected,
                    onNoteChange: _onNoteChange,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Auto mode toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Auto',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _autoMode,
                    activeColor: AppTheme.accent,
                    onChanged: (value) {
                      setState(() {
                        _autoMode = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
