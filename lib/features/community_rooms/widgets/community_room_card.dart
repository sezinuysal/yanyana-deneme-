import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community/widgets/community_room_menu_button.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

/// Polished, accessible card for mock and live community rooms.
class CommunityRoomCard extends StatefulWidget {
  final CommunityRoom room;
  final bool joined;
  final VoidCallback onOpen;
  final VoidCallback onJoin;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommunityRoomCard({
    super.key,
    required this.room,
    required this.joined,
    required this.onOpen,
    required this.onJoin,
    this.canManage = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CommunityRoomCard> createState() => _CommunityRoomCardState();
}

class _CommunityRoomCardState extends State<CommunityRoomCard> {
  static const _cardRadius = 28.0;
  static const _buttonRadius = 24.0;

  bool _hovered = false;

  List<String> get _displayTags => widget.room.accessibilityTags.isEmpty
      ? const ['Güvenli Alan']
      : widget.room.accessibilityTags;

  List<BoxShadow> get _cardShadow => _hovered
      ? [
          BoxShadow(
            color: const Color(0xFF475569).withValues(alpha: 0.13),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: YanYanaColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ]
      : YanYanaShadows.card;

  @override
  Widget build(BuildContext context) {
    final showMenu =
        widget.canManage && widget.onEdit != null && widget.onDelete != null;
    final tagsLabel = '. Erişilebilirlik: ${_displayTags.join(", ")}';
    final room = widget.room;

    return Semantics(
      label:
          '${room.title}. ${room.description}. Kategori: ${room.category}. '
          '${room.memberCount} üye.$tagsLabel${widget.joined ? " Katıldınız." : ""}',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _hovered
              ? (Matrix4.identity()..translate(0.0, -3.0))
              : Matrix4.identity(),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(_cardRadius),
                  onTap: widget.onOpen,
                  hoverColor: YanYanaColors.primary.withValues(alpha: 0.04),
                  splashColor: YanYanaColors.primary.withValues(alpha: 0.08),
                  child: Ink(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      24,
                      showMenu ? 50 : 24,
                      24,
                    ),
                    decoration: BoxDecoration(
                      color: YanYanaColors.surface,
                      borderRadius: BorderRadius.circular(_cardRadius),
                      boxShadow: _cardShadow,
                      border: widget.joined
                          ? Border.all(color: YanYanaColors.primary, width: 1.5)
                          : Border.all(
                              color: YanYanaColors.border.withValues(alpha: 0.55),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color:
                                    YanYanaColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Icon(
                                _iconForCategory(room.category),
                                color: YanYanaColors.primary,
                                size: 26,
                                semanticLabel: 'Oda simgesi',
                              ),
                            ),
                            const SizedBox(width: 16),
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
                                  const SizedBox(height: 8),
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
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _RoomPill(
                              label: room.category,
                              color: YanYanaColors.secondary,
                            ),
                            _RoomPill(
                              label: '${room.memberCount} üye',
                              color: YanYanaColors.accentBlue,
                            ),
                            if (widget.joined)
                              const _RoomPill(
                                label: 'Katıldın',
                                color: YanYanaColors.success,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _displayTags
                              .map((tag) => _AccessibilityTag(label: tag))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        Semantics(
                          label: widget.joined ? 'Odaya katıldınız' : 'Odaya katıl',
                          button: true,
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: widget.joined ? widget.onOpen : widget.onJoin,
                              icon: Icon(
                                widget.joined
                                    ? Icons.check_circle_rounded
                                    : Icons.login_rounded,
                                size: 21,
                              ),
                              label: Text(
                                widget.joined ? 'Katıldın' : 'Katıl',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: widget.joined
                                    ? YanYanaColors.success
                                    : YanYanaColors.primary,
                                foregroundColor: Colors.white,
                                elevation: _hovered ? 3 : 0,
                                shadowColor: YanYanaColors.primary
                                    .withValues(alpha: 0.25),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_buttonRadius),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (showMenu)
                  Positioned(
                    top: 10,
                    right: 6,
                    child: CommunityRoomMenuButton(
                      onEdit: widget.onEdit!,
                      onDelete: widget.onDelete!,
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

/// Shared card corner radius for loading overlays on room lists.
const double communityRoomCardRadius = 28;
