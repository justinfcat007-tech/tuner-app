import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/audio/audio_engine.dart';
import '../../tuner/presentation/widgets/tuning_meter.dart';
import '../domain/yangqin_data.dart';

/// Yangqin tuner screen
class YangqinTunerScreen extends ConsumerStatefulWidget {
  const YangqinTunerScreen({super.key});

  @override
  ConsumerState<YangqinTunerScreen> createState() => _YangqinTunerScreenState();
}

class _YangqinTunerScreenState extends ConsumerState<YangqinTunerScreen> {
  int _selectedCol = 1; // 1-14
  int _selectedStringNum = 1;
  double _a4Reference = 440.0;

  // Simulated pitch result (will be replaced with actual audio engine)
  final PitchResult _pitchResult = PitchResult.empty();

  List<YangqinString> get _stringsInCol => getStringsByColumn(_selectedCol);

  YangqinString? get _targetString {
    try {
      return yangqinStrings.firstWhere(
        (s) => s.stringNum == _selectedStringNum,
      );
    } catch (e) {
      return null;
    }
  }

  double get _targetFrequency {
    final s = _targetString;
    if (s == null) return 440.0;
    // Adjust frequency based on A4 reference
    return s.frequency * (_a4Reference / 440.0);
  }

  String get _targetNote {
    final s = _targetString;
    if (s == null) return '--';
    // Convert scientific notation to Helmholtz notation
    final match = RegExp(r'^([#b]?)([A-G])(\d)$').firstMatch(s.note);
    if (match == null) return s.note.toLowerCase();

    final accidental = match.group(1) ?? '';
    final letter = match.group(2)!;
    final octave = int.parse(match.group(3)!);

    if (octave >= 4) return '$accidental${letter.toLowerCase()}${octave - 3}';
    if (octave == 3) return '$accidental${letter.toLowerCase()}';
    return '$accidental$letter';
  }

  void _onColSelected(int col) {
    setState(() {
      _selectedCol = col;
      // Auto-select first string in column
      final strings = getStringsByColumn(col);
      if (strings.isNotEmpty) {
        _selectedStringNum = strings.first.stringNum;
      }
    });
  }

  void _onStringSelected(int stringNum) {
    setState(() {
      _selectedStringNum = stringNum;
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
              '设置',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'A4 基准音',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [440, 442, 443].map((freq) {
                final isSelected = _a4Reference == freq.toDouble();
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text('$freq Hz'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _a4Reference = freq.toDouble();
                        });
                        Navigator.pop(context);
                      }
                    },
                    selectedColor: AppTheme.accent,
                    backgroundColor: AppTheme.surfaceRaised,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.ink : AppTheme.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text('帮助', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: _showSettings,
            child: Text('设置', style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tuning meter
            TuningMeter(
              cents: _pitchResult.cents,
              state: AudioEngineState.idle,
            ),
            const SizedBox(height: 16),

            // Note display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _targetNote,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_targetFrequency.toStringAsFixed(2)} Hz',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Column selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '列',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: getAvailableColumns().map((col) {
                        final isSelected = col == _selectedCol;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$col'),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) _onColSelected(col);
                            },
                            selectedColor: AppTheme.accent,
                            backgroundColor: AppTheme.surface,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.ink
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // String list
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: ListView.builder(
                  itemCount: _stringsInCol.length,
                  itemBuilder: (context, index) {
                    final string = _stringsInCol[index];
                    final isSelected = string.stringNum == _selectedStringNum;

                    return InkWell(
                      onTap: () => _onStringSelected(string.stringNum),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.surfaceRaised
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.border,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${string.stringNum}弦',
                              style: TextStyle(
                                color: AppTheme.accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                string.label,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '[${string.notation}]',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
