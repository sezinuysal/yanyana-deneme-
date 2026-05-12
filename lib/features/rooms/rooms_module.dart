import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Prototype: community rooms list (mock). Distinct from [CommunityPage] navigation-wise.
class RoomsModulePage extends StatelessWidget {
  const RoomsModulePage({super.key});

  static final List<_MockRoom> _rooms = [
    _MockRoom(
      title: 'Sessiz Sohbet',
      category: 'Sosyal',
      members: 64,
      hasText: true,
      hasVoice: false,
    ),
    _MockRoom(
      title: 'Okuma Desteği Hattı',
      category: 'Destek',
      members: 38,
      hasText: true,
      hasVoice: true,
    ),
    _MockRoom(
      title: 'Mentor Buluşması',
      category: 'Mentorluk',
      members: 22,
      hasText: true,
      hasVoice: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        elevation: 0,
        title: const Text(
          'Topluluk Odaları',
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: _rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final r = _rooms[i];
            return Container(
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: YanYanaColors.border),
                boxShadow: YanYanaShadows.card,
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: const TextStyle(
                      color: YanYanaColors.textDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.category,
                    style: const TextStyle(
                      color: YanYanaColors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 20,
                        color: YanYanaColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${r.members} üye',
                        style: const TextStyle(
                          color: YanYanaColors.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (r.hasText)
                        _chip('Metin sohbet', YanYanaColors.primary),
                      if (r.hasVoice)
                        _chip('Sesli oda (prototip)', YanYanaColors.accentPurple),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Oda katılımı prototipte simüle edildi. Gerçek zamanlı oda future integration.',
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: YanYanaColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Katıl',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: YanYanaColors.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MockRoom {
  final String title;
  final String category;
  final int members;
  final bool hasText;
  final bool hasVoice;

  const _MockRoom({
    required this.title,
    required this.category,
    required this.members,
    required this.hasText,
    required this.hasVoice,
  });
}
