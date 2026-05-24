import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Explains why a community room exists (mock demo copy).
class RoomPurposeSection extends StatelessWidget {
  final String purposeText;

  const RoomPurposeSection({super.key, required this.purposeText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Semantics(
        label: 'Oda amacı. $purposeText',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: YanYanaColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: YanYanaColors.border),
            boxShadow: YanYanaShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: YanYanaColors.accentPurple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: YanYanaColors.accentPurple,
                      size: 20,
                      semanticLabel: 'Oda amacı',
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Oda Amacı',
                    style: TextStyle(
                      color: YanYanaColors.textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                purposeText,
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
