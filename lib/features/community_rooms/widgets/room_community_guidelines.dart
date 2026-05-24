import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Numbered community rules for mock room detail.
class RoomCommunityGuidelines extends StatelessWidget {
  final List<String> rules;

  const RoomCommunityGuidelines({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Semantics(
        label: 'Topluluk kuralları',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: YanYanaColors.primaryLight.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: YanYanaColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: YanYanaColors.primaryDark,
                    size: 22,
                    semanticLabel: 'Kurallar',
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Topluluk Kuralları',
                    style: TextStyle(
                      color: YanYanaColors.textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...rules.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: YanYanaColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                            color: YanYanaColors.primaryDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e.value,
                          style: const TextStyle(
                            color: YanYanaColors.textDark,
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
