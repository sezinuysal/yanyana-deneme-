import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community/models/community_feed_content_type.dart';
import 'package:yanyana_p/features/community/widgets/community_content_manager.dart';
import 'package:yanyana_p/features/community/widgets/community_content_menu_button.dart';
import 'package:yanyana_p/shared/models/success_story.dart';

class SuccessStoriesPage extends StatefulWidget {
  const SuccessStoriesPage({super.key, this.openShareOnStart = false});

  final bool openShareOnStart;

  @override
  State<SuccessStoriesPage> createState() => _SuccessStoriesPageState();
}

class _SuccessStoriesPageState extends State<SuccessStoriesPage> {
  final _backend = BackendOrchestrator.instance;

  @override
  void initState() {
    super.initState();
    if (widget.openShareOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showShareForm());
    }
  }

  Future<void> _deleteStory(SuccessStory story) async {
    await CommunityContentManager.deleteStory(context, story);
  }

  Future<void> _editStory(SuccessStory story) async {
    await CommunityContentManager.editStory(context, story);
  }

  Future<void> _showShareForm() async {
    await CommunityContentManager.createContent(
      context,
      initialType: CommunityFeedContentType.successStory,
      lockType: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        elevation: 0,
        title: const Text(
          'Başarı Hikayeleri',
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showShareForm,
        backgroundColor: YanYanaColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text(
          'Hikaye Paylaş',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<SuccessStory>>(
          stream: _backend.streamSuccessStories(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Hikayeler yüklenemedi: ${snap.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final stories = snap.data ?? const [];
            if (stories.isEmpty) {
              return _EmptyStories(onShare: _showShareForm);
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
              itemCount: stories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final story = stories[i];
                final canManage =
                    CommunityContentManager.canManageStory(story);
                return _StoryTile(
                  story: story,
                  canManage: canManage,
                  onEdit: () => _editStory(story),
                  onDelete: () => _deleteStory(story),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyStories extends StatelessWidget {
  final VoidCallback onShare;

  const _EmptyStories({required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 56,
              color: YanYanaColors.textLight.withValues(alpha: 0.85),
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz başarı hikayesi paylaşılmadı.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: YanYanaColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'YanYana deneyimini paylaşarak başka kullanıcılara ilham verebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Hikaye Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  final SuccessStory story;
  final bool canManage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _StoryTile({
    required this.story,
    this.canManage = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: YanYanaColors.primaryLight),
        boxShadow: YanYanaShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  story.title,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              if (canManage && onEdit != null && onDelete != null)
                CommunityContentMenuButton(
                  onEdit: onEdit!,
                  onDelete: onDelete!,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            story.authorName,
            style: const TextStyle(
              color: YanYanaColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.content,
            style: const TextStyle(
              color: YanYanaColors.textMuted,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
