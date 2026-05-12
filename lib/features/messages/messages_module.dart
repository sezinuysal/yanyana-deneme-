import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Prototype: direct messages list (mock). No real chat backend.
class MessagesModulePage extends StatelessWidget {
  const MessagesModulePage({super.key});

  static final List<_MockThread> _threads = [
    _MockThread(
      peerName: 'Zeynep K.',
      contextLabel: 'Okuma desteği',
      lastMessage: 'Yarın saat 14:00 uygun musun?',
      timeLabel: '10:42',
      statusLabel: 'Okundu',
      isRead: true,
    ),
    _MockThread(
      peerName: 'Gönüllü Destek',
      contextLabel: 'Ulaşım',
      lastMessage: 'Kapıda bekliyorum, mavi yelekli olacağım.',
      timeLabel: 'Dün',
      statusLabel: 'İletildi',
      isRead: false,
    ),
    _MockThread(
      peerName: 'Mentor Ayşe',
      contextLabel: 'Mentorluk',
      lastMessage: 'Bu hafta hedeflerini birlikte netleştirelim.',
      timeLabel: 'Pzt',
      statusLabel: 'Okundu',
      isRead: true,
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
          'Mesajlar',
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: _threads.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final t = _threads[i];
            return Material(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(22),
              elevation: 0,
              shadowColor: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${t.peerName} ile sohbet prototipte simüle edildi.',
                      ),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: YanYanaColors.border),
                    boxShadow: YanYanaShadows.card,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: YanYanaColors.primaryLight,
                            child: Text(
                              t.peerName.isNotEmpty ? t.peerName[0] : '?',
                              style: const TextStyle(
                                color: YanYanaColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.peerName,
                                  style: TextStyle(
                                    color: YanYanaColors.textDark,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    decoration: t.isRead
                                        ? TextDecoration.none
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.contextLabel,
                                  style: TextStyle(
                                    color: YanYanaColors.secondary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                t.timeLabel,
                                style: const TextStyle(
                                  color: YanYanaColors.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: t.isRead
                                      ? YanYanaColors.surfaceSoft
                                      : YanYanaColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  t.statusLabel,
                                  style: TextStyle(
                                    color: t.isRead
                                        ? YanYanaColors.textMuted
                                        : YanYanaColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t.lastMessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: YanYanaColors.textMuted.withOpacity(
                            t.isRead ? 0.9 : 1,
                          ),
                          fontSize: 14,
                          height: 1.35,
                          fontWeight: t.isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MockThread {
  final String peerName;
  final String contextLabel;
  final String lastMessage;
  final String timeLabel;
  final String statusLabel;
  final bool isRead;

  const _MockThread({
    required this.peerName,
    required this.contextLabel,
    required this.lastMessage,
    required this.timeLabel,
    required this.statusLabel,
    required this.isRead,
  });
}
