import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/core/utils/relative_time.dart';
import 'package:yanyana_p/features/community/widgets/community_post_preview_card.dart';
import 'package:yanyana_p/features/community/widgets/community_story_preview_card.dart';
import 'package:yanyana_p/features/home/success_stories_page.dart';
import 'package:yanyana_p/shared/models/community_post.dart';
import 'package:yanyana_p/shared/models/success_story.dart';

enum _FeedKind { post, story }

class _FeedEntry {
  final _FeedKind kind;
  final DateTime sortDate;
  final CommunityPost? post;
  final SuccessStory? story;

  _FeedEntry.post(CommunityPost p)
      : kind = _FeedKind.post,
        sortDate = p.createdAt,
        post = p,
        story = null;

  _FeedEntry.story(SuccessStory s)
      : kind = _FeedKind.story,
        sortDate = s.createdAt,
        post = null,
        story = s;
}

/// Live community feed from Firestore (same source as Home → Topluluk).
class CommunityFeedSection extends StatefulWidget {
  const CommunityFeedSection({super.key});

  @override
  State<CommunityFeedSection> createState() => _CommunityFeedSectionState();
}

class _CommunityFeedSectionState extends State<CommunityFeedSection> {
  final _orchestrator = BackendOrchestrator.instance;

  List<CommunityPost> _posts = const [];
  List<SuccessStory> _stories = const [];
  bool _loading = true;

  StreamSubscription<List<CommunityPost>>? _postsSub;
  StreamSubscription<List<SuccessStory>>? _storiesSub;

  @override
  void initState() {
    super.initState();
    _postsSub = _orchestrator.streamCommunityPosts().listen(
      (posts) {
        if (!mounted) return;
        setState(() {
          _posts = posts;
          _loading = false;
        });
      },
      onError: (_) => _reloadFallback(),
    );
    _storiesSub = _orchestrator.streamSuccessStories().listen(
      (stories) {
        if (!mounted) return;
        setState(() {
          _stories = stories;
          _loading = false;
        });
      },
      onError: (_) => _reloadFallback(),
    );
  }

  @override
  void dispose() {
    _postsSub?.cancel();
    _storiesSub?.cancel();
    super.dispose();
  }

  Future<void> _reloadFallback() async {
    try {
      final posts = await _orchestrator.getCommunityPosts();
      final stories = await _orchestrator.getSuccessStories();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _stories = stories;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<_FeedEntry> get _entries {
    final list = <_FeedEntry>[
      ..._posts.map(_FeedEntry.post),
      ..._stories.map(_FeedEntry.story),
    ];
    list.sort((a, b) => b.sortDate.compareTo(a.sortDate));
    return list;
  }

  String _categoryForPost(CommunityPost post) {
    final t = post.title.toLowerCase();
    if (t.contains('günün') || t.contains('söz')) return 'Günün Sözü';
    if (t.contains('başarı')) return 'Başarı';
    if (t.contains('farkındalık')) return 'Farkındalık';
    if (t.contains('destek')) return 'Destek';
    return 'Topluluk Gönderisi';
  }

  void _openPostDetail(CommunityPost post) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: Container(
          decoration: BoxDecoration(
            color: YanYanaColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: YanYanaShadows.card,
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: YanYanaColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                post.body,
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${post.authorName} · ${formatRelativeTime(post.createdAt)}',
                style: const TextStyle(
                  color: YanYanaColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStories() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SuccessStoriesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topluluk Akışı',
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontSize: 23,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Gönderiler, günün sözü, başarı hikayeleri ve paylaşımlar.',
          style: TextStyle(
            color: YanYanaColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: YanYanaColors.secondaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Canlı',
                style: TextStyle(
                  color: YanYanaColors.secondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Firestore — Ana sayfa ile aynı kaynak',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (entries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: YanYanaColors.border),
            ),
            child: const Column(
              children: [
                Text(
                  'Henüz topluluk gönderisi yok.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: YanYanaColors.textDark,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '“Gönderi” ile paylaşım yapabilir veya başarı hikayesi ekleyebilirsin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        else
          ...entries.map((e) {
            if (e.kind == _FeedKind.post) {
              final post = e.post!;
              return CommunityPostPreviewCard(
                post: post,
                timeLabel: formatRelativeTime(post.createdAt),
                categoryLabel: _categoryForPost(post),
                onTap: () => _openPostDetail(post),
              );
            }
            final story = e.story!;
            return CommunityStoryPreviewCard(
              story: story,
              timeLabel: formatRelativeTime(story.createdAt),
              onTap: _openStories,
            );
          }),
      ],
    );
  }
}
