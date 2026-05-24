import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Room action buttons: join, leave, report, mute.
class RoomActionsBar extends StatelessWidget {
  final bool joined;
  final bool muted;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final VoidCallback onReport;
  final VoidCallback onToggleMute;

  const RoomActionsBar({
    super.key,
    required this.joined,
    required this.muted,
    required this.onJoin,
    required this.onLeave,
    required this.onReport,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _ActionChip(
            label: joined ? 'Katıldın · Ayrıl' : 'Katıl',
            icon: joined ? Icons.check_rounded : Icons.login_rounded,
            filled: !joined,
            onPressed: joined ? onLeave : onJoin,
            semanticLabel: joined ? 'Odadan ayrıl' : 'Odaya katıl',
          ),
          _ActionChip(
            label: muted ? 'Bildirim Açık' : 'Bildirimleri Sessize Al',
            icon: muted ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
            onPressed: onToggleMute,
            semanticLabel: muted
                ? 'Bildirimleri aç'
                : 'Bildirimleri sessize al',
          ),
          _ActionChip(
            label: 'Odayı Bildir',
            icon: Icons.flag_outlined,
            onPressed: onReport,
            semanticLabel: 'Odayı bildir',
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;
  final String semanticLabel;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: filled ? YanYanaColors.primary : YanYanaColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: filled
                  ? null
                  : Border.all(color: YanYanaColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: filled ? Colors.white : YanYanaColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: filled ? Colors.white : YanYanaColors.textDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
