import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/success_story.dart';

/// Rounded preview card for a [SuccessStory] (Home + Topluluk tab).
class CommunityStoryPreviewCard extends StatelessWidget {
  final SuccessStory story;
  final String timeLabel;
  final VoidCallback? onTap;

  const CommunityStoryPreviewCard({
    super.key,
    required this.story,
    required this.timeLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label:
            'Başarı hikayesi. ${story.title}. ${story.content}. '
            '${story.authorName}. $timeLabel',
        button: onTap != null,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: YanYanaColors.accentYellow.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: YanYanaColors.warning.withValues(alpha: 0.2),
                ),
                boxShadow: YanYanaShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: YanYanaColors.warning,
                        size: 20,
                        semanticLabel: 'Başarı hikayesi',
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Başarı Hikayesi',
                        style: TextStyle(
                          color: YanYanaColors.warning,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    story.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: YanYanaColors.textDark,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    story.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: YanYanaColors.textMuted,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${story.authorName} · $timeLabel',
                    style: const TextStyle(
                      color: YanYanaColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
