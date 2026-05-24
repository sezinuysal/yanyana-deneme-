import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community/utils/room_activity_stats.dart';

/// Dynamic online / activity indicators derived from [memberCount].
class RoomActivityBar extends StatelessWidget {
  final int memberCount;
  final bool chatActive;

  const RoomActivityBar({
    super.key,
    required this.memberCount,
    this.chatActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final onlineCount = estimateRoomOnlineCount(memberCount);
    final showOnline = memberCount > 0 && onlineCount > 0;
    final showChatLabel = chatActive || memberCount > 0;

    return Semantics(
      label: showOnline
          ? '$onlineCount üye çevrimiçi.'
          : 'Üye çevrimiçi bilgisi yok.',
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
            _IndicatorDot(
              color: showOnline ? YanYanaColors.success : YanYanaColors.textLight,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                showOnline
                    ? '$onlineCount üye çevrimiçi'
                    : 'Henüz çevrimiçi üye yok',
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            if (showChatLabel) ...[
              const Icon(
                Icons.forum_outlined,
                size: 16,
                color: YanYanaColors.textMuted,
              ),
              const SizedBox(width: 4),
              const Text(
                'Sohbet aktif',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (memberCount > 0)
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
