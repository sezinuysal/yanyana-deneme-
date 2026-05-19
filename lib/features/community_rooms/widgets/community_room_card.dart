import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

/// Polished, accessible card for mock community rooms.
class CommunityRoomCard extends StatelessWidget {
  final CommunityRoom room;
  final bool joined;
  final VoidCallback onOpen;
  final VoidCallback onJoin;

  const CommunityRoomCard({
    super.key,
    required this.room,
    required this.joined,
    required this.onOpen,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final tagsLabel = room.accessibilityTags.isEmpty
        ? ''
        : '. Erişilebilirlik: ${room.accessibilityTags.join(", ")}';

    return Semantics(
      label:
          '${room.title}. ${room.description}. Kategori: ${room.category}. '
          '${room.memberCount} üye.$tagsLabel${joined ? " Katıldınız." : ""}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onOpen,
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: YanYanaShadows.card,
              border: joined
                  ? Border.all(color: YanYanaColors.primary, width: 1.5)
                  : Border.all(color: YanYanaColors.border.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: YanYanaColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _iconForCategory(room.category),
                        color: YanYanaColors.primary,
                        size: 26,
                        semanticLabel: 'Oda simgesi',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            style: const TextStyle(
                              color: YanYanaColors.textDark,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            room.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: YanYanaColors.textMuted,
                              fontSize: 14,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _RoomPill(label: room.category, color: YanYanaColors.secondary),
                    _RoomPill(
                      label: '${room.memberCount} üye',
                      color: YanYanaColors.accentBlue,
                    ),
                    if (joined)
                      const _RoomPill(
                        label: 'Katıldın',
                        color: YanYanaColors.success,
                      ),
                  ],
                ),
                if (room.accessibilityTags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: room.accessibilityTags
                        .map(
                          (tag) => _AccessibilityTag(label: tag),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                Semantics(
                  label: joined ? 'Odaya katıldınız' : 'Odaya katıl',
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: joined ? null : onJoin,
                      icon: Icon(
                        joined ? Icons.check_rounded : Icons.login_rounded,
                        size: 22,
                      ),
                      label: Text(
                        joined ? 'Katıldın' : 'Katıl',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: YanYanaColors.primary,
                        disabledBackgroundColor:
                            YanYanaColors.primary.withValues(alpha: 0.12),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: YanYanaColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData _iconForCategory(String category) {
    switch (category) {
      case 'Destek':
        return Icons.favorite_rounded;
      case 'Eğitim':
        return Icons.school_rounded;
      case 'Sağlık':
        return Icons.accessible_rounded;
      case 'Sosyal':
        return Icons.groups_rounded;
      case 'Mentorluk':
        return Icons.psychology_alt_rounded;
      default:
        return Icons.forum_rounded;
    }
  }
}

class _RoomPill extends StatelessWidget {
  final String label;
  final Color color;

  const _RoomPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: YanYanaColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _AccessibilityTag extends StatelessWidget {
  final String label;

  const _AccessibilityTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: YanYanaColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: YanYanaColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconForTag(label),
            size: 14,
            color: YanYanaColors.primaryDark,
            semanticLabel: '',
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: YanYanaColors.primaryDark,
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconForTag(String label) {
    if (label.contains('Ses')) return Icons.mic_rounded;
    if (label.contains('Altyazı')) return Icons.closed_caption_rounded;
    if (label.contains('Güvenli')) return Icons.shield_rounded;
    return Icons.chat_rounded;
  }
}
