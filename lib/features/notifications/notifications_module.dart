import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Prototype: in-app notification list (mock). No FCM.
class NotificationsModulePage extends StatefulWidget {
  const NotificationsModulePage({super.key});

  @override
  State<NotificationsModulePage> createState() =>
      _NotificationsModulePageState();
}

class _NotificationsModulePageState extends State<NotificationsModulePage> {
  late final List<_MockNotification> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _MockNotification(
        id: 'n1',
        title: 'SOS bildirimi',
        body: 'Acil durum akışı tetiklendi (prototip simülasyonu).',
        type: _NotifType.sos,
        timeLabel: '12:04',
        isRead: false,
      ),
      _MockNotification(
        id: 'n2',
        title: 'Gönüllü eşleşmesi',
        body: 'Yeni bir destek talebin için gönüllü atandı.',
        type: _NotifType.match,
        timeLabel: '09:30',
        isRead: false,
      ),
      _MockNotification(
        id: 'n3',
        title: 'Yeni mesaj',
        body: 'Zeynep K.: Yarın görüşelim mi?',
        type: _NotifType.message,
        timeLabel: 'Dün',
        isRead: true,
      ),
      _MockNotification(
        id: 'n4',
        title: 'Duyuru',
        body: 'Erişilebilirlik semineri: Cumartesi 15:00.',
        type: _NotifType.announcement,
        timeLabel: 'Pzt',
        isRead: true,
      ),
    ];
  }

  void _toggleRead(int index) {
    setState(() {
      final n = _items[index];
      _items[index] = n.copyWith(isRead: !n.isRead);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        elevation: 0,
        title: const Text(
          'Bildirimler',
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var i = 0; i < _items.length; i++) {
                  _items[i] = _items[i].copyWith(isRead: true);
                }
              });
            },
            child: const Text(
              'Tümünü okundu',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final n = _items[i];
            final color = _typeColor(n.type);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _toggleRead(i),
                child: Ink(
                  decoration: BoxDecoration(
                    color: n.isRead
                        ? YanYanaColors.surface
                        : YanYanaColors.primaryLight.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: n.isRead ? YanYanaColors.border : YanYanaColors.primary,
                      width: n.isRead ? 1 : 1.2,
                    ),
                    boxShadow: YanYanaShadows.soft,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(_typeIcon(n.type), color: color, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: TextStyle(
                                      color: YanYanaColors.textDark,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (!n.isRead)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: YanYanaColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              n.body,
                              style: const TextStyle(
                                color: YanYanaColors.textMuted,
                                fontSize: 14,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_typeLabel(n.type)} · ${n.timeLabel}',
                              style: const TextStyle(
                                color: YanYanaColors.textLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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

  static Color _typeColor(_NotifType t) {
    switch (t) {
      case _NotifType.sos:
        return YanYanaColors.sos;
      case _NotifType.match:
        return YanYanaColors.secondary;
      case _NotifType.message:
        return YanYanaColors.primary;
      case _NotifType.announcement:
        return YanYanaColors.accentPurple;
    }
  }

  static IconData _typeIcon(_NotifType t) {
    switch (t) {
      case _NotifType.sos:
        return Icons.emergency_share_rounded;
      case _NotifType.match:
        return Icons.volunteer_activism_rounded;
      case _NotifType.message:
        return Icons.chat_bubble_rounded;
      case _NotifType.announcement:
        return Icons.campaign_rounded;
    }
  }

  static String _typeLabel(_NotifType t) {
    switch (t) {
      case _NotifType.sos:
        return 'SOS';
      case _NotifType.match:
        return 'Eşleşme';
      case _NotifType.message:
        return 'Mesaj';
      case _NotifType.announcement:
        return 'Duyuru';
    }
  }
}

enum _NotifType { sos, match, message, announcement }

class _MockNotification {
  final String id;
  final String title;
  final String body;
  final _NotifType type;
  final String timeLabel;
  final bool isRead;

  const _MockNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timeLabel,
    required this.isRead,
  });

  _MockNotification copyWith({bool? isRead}) {
    return _MockNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      timeLabel: timeLabel,
      isRead: isRead ?? this.isRead,
    );
  }
}
