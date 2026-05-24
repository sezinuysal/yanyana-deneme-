import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

/// Gradient banner header for mock room detail.
class RoomDetailHeader extends StatelessWidget {
  final CommunityRoom room;
  final int memberCount;
  final bool joined;
  final VoidCallback onBack;
  final VoidCallback onJoinToggle;

  const RoomDetailHeader({
    super.key,
    required this.room,
    required this.memberCount,
    required this.joined,
    required this.onBack,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${room.title}. ${room.category}. $memberCount üye. ${room.description}',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: calmGradient,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: YanYanaColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: YanYanaShadows.soft,
                      ),
                      child: Icon(
                        _iconForCategory(room.category),
                        color: YanYanaColors.primary,
                        size: 28,
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
                              fontSize: 22,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: YanYanaColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: YanYanaColors.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              room.category,
                              style: const TextStyle(
                                color: YanYanaColors.textDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      size: 18,
                      color: YanYanaColors.primaryDark,
                      semanticLabel: 'Üye sayısı',
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$memberCount üye',
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    if (joined) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: YanYanaColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Üyesin',
                          style: TextStyle(
                            color: YanYanaColors.success,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (room.accessibilityTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.accessibilityTags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: YanYanaColors.surface.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: YanYanaColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: YanYanaColors.primaryDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  room.description,
                  style: const TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: joined ? 'Katıldın, ayrılmak için dokun' : 'Odaya katıl',
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: onJoinToggle,
                      style: FilledButton.styleFrom(
                        backgroundColor: joined
                            ? YanYanaColors.success
                            : YanYanaColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: Icon(
                        joined ? Icons.check_circle_rounded : Icons.login_rounded,
                        size: 24,
                      ),
                      label: Text(
                        joined ? 'Katıldın' : 'Katıl',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 4,
            child: Semantics(
              label: 'Geri dön',
              button: true,
              child: Material(
                color: YanYanaColors.surface.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                elevation: 2,
                shadowColor: Colors.black26,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onBack,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: YanYanaColors.textDark,
                      semanticLabel: 'Geri',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
