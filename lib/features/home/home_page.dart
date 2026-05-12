import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/matching/matching_module.dart';
import 'package:yanyana_p/features/messages/messages_module.dart';
import 'package:yanyana_p/features/notifications/notifications_module.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 22),
              _buildWelcomeCard(),
              const SizedBox(height: 18),
              _buildSOSCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Hızlı Erişim', 'Bugün ne yapmak istersin?'),
              const SizedBox(height: 14),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildSectionHeader('Topluluk Akışı'),
              const SizedBox(height: 12),
              _buildCommunityPosts(),
              const SizedBox(height: 24),
              _buildSectionHeader('Başarı Hikayeleri'),
              const SizedBox(height: 12),
              _buildStoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merhaba 👋',
              style: TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'YanYana’ya hoş geldin',
              style: TextStyle(
                color: YanYanaColors.textDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsModulePage(),
              ),
            );
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              shape: BoxShape.circle,
              boxShadow: YanYanaShadows.soft,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_rounded,
                  color: YanYanaColors.primary,
                  size: 24,
                ),
                Positioned(
                  top: 11,
                  right: 12,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: YanYanaColors.sos,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: calmGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: YanYanaShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.diversity_3_rounded,
              color: YanYanaColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugün yalnız değilsin',
                  style: TextStyle(
                    color: YanYanaColors.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Topluluk, destek ve erişilebilir mekanlar tek yerde.',
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOSCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: YanYanaColors.sosLight),
        boxShadow: YanYanaShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: YanYanaColors.sosLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.emergency_share_rounded,
              color: YanYanaColors.sos,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acil Yardım',
                  style: TextStyle(
                    color: YanYanaColors.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Konumunu güvenilir kişilere hızlıca gönder.',
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('SOS Gönderildi'),
                  content: const Text(
                    'Konumunuz acil kişilerinize iletildi.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tamam'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: sosGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: YanYanaColors.sos.withOpacity(0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: YanYanaColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            color: YanYanaColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: YanYanaColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'Tümünü Gör',
          style: TextStyle(
            color: YanYanaColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.volunteer_activism_rounded,
        'label': 'Destek İste',
        'color': YanYanaColors.primary,
      },
      {
        'icon': Icons.groups_rounded,
        'label': 'Topluluk',
        'color': YanYanaColors.secondary,
      },
      {
        'icon': Icons.map_rounded,
        'label': 'Harita',
        'color': YanYanaColors.accentBlue,
      },
      {
        'icon': Icons.chat_bubble_rounded,
        'label': 'Mesajlar',
        'color': YanYanaColors.accentPink,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final label = actions[index]['label'] as String;
        VoidCallback? onTap;
        if (label == 'Destek İste') {
          onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const MatchingModulePage(),
              ),
            );
          };
        } else if (label == 'Mesajlar') {
          onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const MessagesModulePage(),
              ),
            );
          };
        }
        return _QuickActionItem(
          icon: actions[index]['icon'] as IconData,
          label: label,
          color: actions[index]['color'] as Color,
          onTap: onTap,
        );
      },
    );
  }

  Widget _buildCommunityPosts() {
    final posts = [
      {
        'title': 'Erişilebilir etkinlik önerisi',
        'desc': 'Bu hafta sonu herkes için uygun bir buluşma alanı arıyoruz.',
        'tag': 'Etkinlik',
        'icon': Icons.event_available_rounded,
        'color': YanYanaColors.primary,
      },
      {
        'title': 'Gönüllü eğitim duyurusu',
        'desc': 'Yeni gönüllüler için güvenli iletişim eğitimi açıldı.',
        'tag': 'Duyuru',
        'icon': Icons.campaign_rounded,
        'color': YanYanaColors.secondary,
      },
    ];

    return Column(
      children: posts
          .map(
            (p) => _CommunityCard(
          title: p['title'] as String,
          desc: p['desc'] as String,
          tag: p['tag'] as String,
          icon: p['icon'] as IconData,
          color: p['color'] as Color,
        ),
      )
          .toList(),
    );
  }

  Widget _buildStoryList() {
    final stories = [
      {
        'name': 'Ayşe K.',
        'story': 'YanYana sayesinde güvenilir bir gönüllüyle tanıştım.',
      },
      {
        'name': 'Mehmet A.',
        'story': 'Topluluk odaları sayesinde artık kendimi daha yalnız hissetmiyorum.',
      },
    ];

    return Column(
      children: stories
          .map(
            (s) => _StoryCard(
          name: s['name']!,
          story: s['story']!,
        ),
      )
          .toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: color.withOpacity(0.13),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.18)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: YanYanaColors.textDark,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
    if (onTap == null) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final String title;
  final String desc;
  final String tag;
  final IconData icon;
  final Color color;

  const _CommunityCard({
    required this.title,
    required this.desc,
    required this.tag,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: YanYanaShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String name;
  final String story;

  const _StoryCard({
    required this.name,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: YanYanaColors.primaryLight),
        boxShadow: YanYanaShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: YanYanaColors.primaryLight,
            child: Text(
              name[0],
              style: const TextStyle(
                color: YanYanaColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  story,
                  style: const TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            color: YanYanaColors.accentPink,
            size: 20,
          ),
        ],
      ),
    );
  }
}