import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/room_participant.dart';

/// Online / typing / activity indicators for a mock room.
class RoomActivityBar extends StatelessWidget {
  final RoomActivitySnapshot activity;

  const RoomActivityBar({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${activity.onlineCount} üye çevrimiçi. '
          '${activity.typingCount} kişi yazıyor.'
          '${activity.isActiveToday ? " Bugün aktif." : ""}',
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: YanYanaColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: YanYanaColors.border),
          boxShadow: YanYanaShadows.soft,
        ),
        child: Row(
          children: [
            _IndicatorDot(color: YanYanaColors.success),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${activity.onlineCount} üye çevrimiçi',
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            if (activity.typingCount > 0) ...[
              const Icon(
                Icons.edit_rounded,
                size: 16,
                color: YanYanaColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                '${activity.typingCount} kişi yazıyor',
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (activity.isActiveToday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: YanYanaColors.secondaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Bugün aktif',
                  style: TextStyle(
                    color: YanYanaColors.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  final Color color;

  const _IndicatorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}
