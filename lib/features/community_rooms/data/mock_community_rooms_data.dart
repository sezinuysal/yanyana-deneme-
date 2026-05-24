import 'package:flutter/material.dart';
import 'package:yanyana_p/shared/models/community_room.dart';
import 'package:yanyana_p/shared/models/room_message.dart';
import 'package:yanyana_p/shared/models/room_participant.dart';

/// Static mock rooms and seed messages for offline Community Rooms UI.
class MockCommunityRoomsData {
  MockCommunityRoomsData._();

  static const String currentUserName = 'Sen';

  /// Category chips shared with [CommunityPage] mock room filters.
  static const List<String> categories = [
    'Tümü',
    'Destek',
    'Eğitim',
    'Sağlık',
    'Sosyal',
    'Mentorluk',
  ];

  static const _textChat = 'Metin Sohbet';
  static const _voiceSupport = 'Ses Desteği';
  static const _captions = 'Altyazı';
  static const _safeSpace = 'Güvenli Alan';

  static final List<CommunityRoom> rooms = [
    const CommunityRoom(
      id: 'mock-daily-chat',
      title: 'Günlük Sohbet Odası',
      category: 'Sosyal',
      description:
          'Gününüzü paylaşın, hafif sohbet edin ve topluluğa dahil olun.',
      memberCount: 356,
      accessibilityTags: [_textChat, _safeSpace],
    ),
    const CommunityRoom(
      id: 'mock-support',
      title: 'Destek Odası',
      category: 'Destek',
      description:
          'Zor günlerde birbirinize destek olabileceğiniz güvenli bir alan.',
      memberCount: 210,
      accessibilityTags: [_textChat, _safeSpace],
    ),
    const CommunityRoom(
      id: 'mock-mentorship',
      title: 'Mentorluk Odası',
      category: 'Mentorluk',
      description:
          'Deneyim paylaşımı, kariyer ve kişisel gelişim için rehberlik alanı.',
      memberCount: 94,
      accessibilityTags: [_textChat, _voiceSupport],
    ),
    const CommunityRoom(
      id: 'mock-accessibility',
      title: 'Erişilebilirlik Deneyimleri Odası',
      category: 'Sağlık',
      description:
          'Erişilebilirlik deneyimlerinizi paylaşın; ipuçları ve kaynaklar keşfedin.',
      memberCount: 142,
      accessibilityTags: [_textChat, _captions],
    ),
    const CommunityRoom(
      id: 'mock-events',
      title: 'Etkinlik ve Duyurular Odası',
      category: 'Eğitim',
      description:
          'Yaklaşan etkinlikler, duyurular ve topluluk haberleri burada.',
      memberCount: 187,
      accessibilityTags: [_textChat, _captions],
    ),
    const CommunityRoom(
      id: 'mock-hobbies',
      title: 'Hobi ve Sosyal Oda',
      category: 'Sosyal',
      description:
          'El sanatları, müzik, oyun ve sosyal aktiviteler hakkında paylaşım yapın.',
      memberCount: 128,
      accessibilityTags: [_textChat, _safeSpace],
    ),
  ];

  static List<CommunityRoom> filterByCategory(String category) {
    if (category == 'Tümü') return List<CommunityRoom>.from(rooms);
    return rooms.where((r) => r.category == category).toList();
  }

  /// Whether the current local owner can edit/delete this mock room.
  static bool canManage(CommunityRoom room, String ownerId) {
    if (room.createdByUserId.isEmpty) return false;
    return room.createdByUserId == ownerId;
  }

  static CommunityRoom addLocalRoom({
    required String title,
    required String description,
    required String category,
    required List<String> accessibilityTags,
    required String ownerId,
  }) {
    final id = 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    final room = CommunityRoom(
      id: id,
      title: title.trim(),
      category: category,
      description: description.trim(),
      memberCount: 1,
      accessibilityTags: accessibilityTags,
      createdByUserId: ownerId,
    );
    rooms.insert(0, room);
    return room;
  }

  static void updateLocalRoom({
    required String roomId,
    required String title,
    required String description,
    required String category,
    required List<String> accessibilityTags,
    required String ownerId,
  }) {
    final index = rooms.indexWhere((r) => r.id == roomId);
    if (index < 0) throw StateError('Oda bulunamadı.');
    final existing = rooms[index];
    if (!canManage(existing, ownerId)) {
      throw StateError('Bu odayı düzenleme yetkiniz yok.');
    }
    rooms[index] = existing.copyWith(
      title: title.trim(),
      description: description.trim(),
      category: category,
      accessibilityTags: accessibilityTags,
    );
  }

  static void deleteLocalRoom({
    required String roomId,
    required String ownerId,
  }) {
    final index = rooms.indexWhere((r) => r.id == roomId);
    if (index < 0) throw StateError('Oda bulunamadı.');
    final existing = rooms[index];
    if (!canManage(existing, ownerId)) {
      throw StateError('Bu odayı silme yetkiniz yok.');
    }
    rooms.removeAt(index);
  }

  static CommunityRoom? roomById(String id) {
    for (final r in rooms) {
      if (r.id == id) return r;
    }
    return null;
  }

  static List<RoomMessage> seedMessagesFor(String roomId) {
    return List<RoomMessage>.from(
      _seedMessages[roomId] ?? const [],
    );
  }

  /// Shared community rules shown on every mock room detail screen.
  static const List<String> communityGuidelineRules = [
    'Saygılı olun ve farklı deneyimlere değer verin.',
    'Kişisel hassas bilgilerinizi (adres, telefon vb.) paylaşmayın.',
    'Başkalarına nazik ve destekleyici bir dille yaklaşın.',
    'Güvensiz davranışları bildirin.',
    'Odayı kapsayıcı ve erişilebilir tutun.',
  ];

  static const String _defaultPurpose =
      'Bu oda, YanYana topluluğunda sosyal katılımı güçlendirmek, '
      'yalnızlığı azaltmak ve kapsayıcı iletişimi desteklemek için açılmıştır.';

  static String purposeFor(String roomId) {
    return _roomPurposes[roomId] ?? _defaultPurpose;
  }

  static final Map<String, String> _roomPurposes = {
    'mock-daily-chat':
        'Günlük sohbet odası sosyal katılımı artırmak ve yalnızlık hissini '
        'azaltmak için tasarlandı. Hafif sohbetlerle tanışın, gününüzü paylaşın '
        've topluluğun bir parçası olun.',
    'mock-support':
        'Destek odası, zor anlarda akran desteği sunmak ve güvenli bir '
        'dinleme alanı sağlamak için vardır. Birbirinize nazikçe eşlik edin; '
        'profesyonel tedavi yerine geçmez.',
    'mock-mentorship':
        'Mentorluk odası deneyim paylaşımı, rehberlik ve kişisel gelişim '
        'için açılmıştır. Kariyer, eğitim ve yaşam becerilerinde birbirinize '
        'mentorluk yapabilirsiniz.',
    'mock-accessibility':
        'Bu oda erişilebilirlik deneyimlerini paylaşmak, farkındalık oluşturmak '
        've pratik ipuçları sunmak içindir. Mekânlar, hizmetler ve günlük '
        'yaşam deneyimlerinizi anlatın.',
    'mock-events':
        'Etkinlik ve duyuru odası topluluğu bilgilendirmek, sosyal buluşmaları '
        'duyurmak ve katılımı teşvik etmek için kullanılır. Kapsayıcı etkinlik '
        'haberlerini burada paylaşın.',
    'mock-hobbies':
        'Hobi ve sosyal oda, ortak ilgi alanları üzerinden bağ kurmayı ve '
        'sosyal katılımı artırmayı hedefler. Hobileriniz aracılığıyla '
        'yeni arkadaşlıklar keşfedin.',
  };

  static const List<RoomPinnedInfo> pinnedGuidelines = [
    RoomPinnedInfo(
      title: 'Topluluk Kuralları',
      body: 'Saygılı, kapsayıcı ve destekleyici bir dil kullanın.',
      icon: Icons.groups_rounded,
    ),
    RoomPinnedInfo(
      title: 'Saygılı İletişim',
      body: 'Farklı deneyimlere saygı gösterin; yargılamadan dinleyin.',
      icon: Icons.favorite_border_rounded,
    ),
    RoomPinnedInfo(
      title: 'Güvenli Alan Politikası',
      body: 'Taciz ve dışlayıcı davranışlara sıfır tolerans.',
      icon: Icons.shield_outlined,
    ),
  ];

  static List<RoomParticipant> participantsFor(String roomId) {
    return List<RoomParticipant>.from(
      _participants[roomId] ?? _defaultParticipants,
    );
  }

  static const List<RoomParticipant> _defaultParticipants = [
    RoomParticipant(
      id: 'p1',
      name: 'Ayşe',
      statusLabel: 'Müsait',
      initials: 'A',
      avatarColorValue: 0xFF6366F1,
    ),
    RoomParticipant(
      id: 'p2',
      name: 'Can',
      statusLabel: 'Dinliyor',
      initials: 'C',
      avatarColorValue: 0xFF14B8A6,
    ),
  ];

  static final Map<String, List<RoomParticipant>> _participants = {
    'mock-daily-chat': [
      const RoomParticipant(
        id: 'dc1',
        name: 'Burak',
        statusLabel: 'Müsait',
        initials: 'B',
        avatarColorValue: 0xFF60A5FA,
      ),
      const RoomParticipant(
        id: 'dc2',
        name: 'Selin',
        statusLabel: 'Aktif',
        initials: 'S',
        avatarColorValue: 0xFFF472B6,
      ),
      const RoomParticipant(
        id: 'dc3',
        name: 'Emre',
        statusLabel: 'Müsait',
        initials: 'E',
        avatarColorValue: 0xFF6366F1,
      ),
      const RoomParticipant(
        id: 'dc4',
        name: 'Deniz',
        statusLabel: 'Dinliyor',
        initials: 'D',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
    'mock-support': [
      const RoomParticipant(
        id: 'sp1',
        name: 'Zeynep',
        statusLabel: 'Destek Arıyor',
        initials: 'Z',
        avatarColorValue: 0xFFF59E0B,
      ),
      const RoomParticipant(
        id: 'sp2',
        name: 'Moderatör',
        statusLabel: 'Dinliyor',
        initials: 'M',
        avatarColorValue: 0xFF6366F1,
      ),
      const RoomParticipant(
        id: 'sp3',
        name: 'Ali',
        statusLabel: 'Müsait',
        initials: 'A',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
    'mock-mentorship': [
      const RoomParticipant(
        id: 'mn1',
        name: 'Mentor Deniz',
        statusLabel: 'Mentor',
        initials: 'D',
        avatarColorValue: 0xFF4F46E5,
      ),
      const RoomParticipant(
        id: 'mn2',
        name: 'Elif',
        statusLabel: 'Müsait',
        initials: 'E',
        avatarColorValue: 0xFF60A5FA,
      ),
      const RoomParticipant(
        id: 'mn3',
        name: 'Kerem',
        statusLabel: 'Dinliyor',
        initials: 'K',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
    'mock-accessibility': [
      const RoomParticipant(
        id: 'ac1',
        name: 'Kerem',
        statusLabel: 'Müsait',
        initials: 'K',
        avatarColorValue: 0xFF6366F1,
      ),
      const RoomParticipant(
        id: 'ac2',
        name: 'Merve',
        statusLabel: 'Dinliyor',
        initials: 'M',
        avatarColorValue: 0xFFA78BFA,
      ),
      const RoomParticipant(
        id: 'ac3',
        name: 'Seda',
        statusLabel: 'Aktif',
        initials: 'S',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
    'mock-events': [
      const RoomParticipant(
        id: 'ev1',
        name: 'YanYana Ekibi',
        statusLabel: 'Mentor',
        initials: 'Y',
        avatarColorValue: 0xFF6366F1,
      ),
      const RoomParticipant(
        id: 'ev2',
        name: 'Etkinlik',
        statusLabel: 'Aktif',
        initials: 'E',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
    'mock-hobbies': [
      const RoomParticipant(
        id: 'hb1',
        name: 'Ayşe',
        statusLabel: 'Müsait',
        initials: 'A',
        avatarColorValue: 0xFFF472B6,
      ),
      const RoomParticipant(
        id: 'hb2',
        name: 'Can',
        statusLabel: 'Aktif',
        initials: 'C',
        avatarColorValue: 0xFF60A5FA,
      ),
      const RoomParticipant(
        id: 'hb3',
        name: 'Lale',
        statusLabel: 'Dinliyor',
        initials: 'L',
        avatarColorValue: 0xFF14B8A6,
      ),
    ],
  };

  static final Map<String, List<RoomMessage>> _seedMessages = {
    'mock-daily-chat': [
      RoomMessage(
        id: 'd1',
        roomId: 'mock-daily-chat',
        authorName: 'Burak',
        text: 'Günaydın herkese! Bugün hava çok güzel ☀️',
        sentAt: DateTime(2026, 5, 18, 7, 30),
      ),
      RoomMessage(
        id: 'd2',
        roomId: 'mock-daily-chat',
        authorName: 'Selin',
        text: 'Günaydın! Parka yürüyüşe çıkmayı düşünüyorum.',
        sentAt: DateTime(2026, 5, 18, 7, 38),
      ),
    ],
    'mock-support': [
      RoomMessage(
        id: 's1',
        roomId: 'mock-support',
        authorName: 'Zeynep',
        text: 'Bugün biraz zor bir gün geçirdim, burada olmanız iyi hissettiriyor.',
        sentAt: DateTime(2026, 5, 18, 8, 5),
      ),
      RoomMessage(
        id: 's2',
        roomId: 'mock-support',
        authorName: 'Topluluk Moderatörü',
        text: 'Yanındayız. İstersen özel mesajla da yazabilirsin.',
        sentAt: DateTime(2026, 5, 18, 8, 12),
      ),
    ],
    'mock-mentorship': [
      RoomMessage(
        id: 'm1',
        roomId: 'mock-mentorship',
        authorName: 'Elif',
        text: 'İş görüşmesi için hazırlık ipuçları paylaşabilir miyiz?',
        sentAt: DateTime(2026, 5, 17, 9, 40),
      ),
      RoomMessage(
        id: 'm2',
        roomId: 'mock-mentorship',
        authorName: 'Mentor Deniz',
        text: 'CV’nizi odaklı tutun; deneyimleri 3 maddeyle özetleyin.',
        sentAt: DateTime(2026, 5, 17, 9, 48),
      ),
    ],
    'mock-accessibility': [
      RoomMessage(
        id: 'a1',
        roomId: 'mock-accessibility',
        authorName: 'Kerem',
        text: 'Merkez kütüphanede yeni rampa yapılmış, tekerlekli sandalye için uygun.',
        sentAt: DateTime(2026, 5, 17, 16, 20),
      ),
      RoomMessage(
        id: 'a2',
        roomId: 'mock-accessibility',
        authorName: 'Merve',
        text: 'Sesli yönlendirme de var mı biliyor musun?',
        sentAt: DateTime(2026, 5, 17, 16, 28),
      ),
    ],
    'mock-events': [
      RoomMessage(
        id: 'e1',
        roomId: 'mock-events',
        authorName: 'YanYana Ekibi',
        text: '25 Mayıs Cumartesi online buluşma: kayıtlar açıldı!',
        sentAt: DateTime(2026, 5, 16, 14, 0),
      ),
      RoomMessage(
        id: 'e2',
        roomId: 'mock-events',
        authorName: 'Etkinlik',
        text: 'Detaylar profil bildirimlerinde de paylaşılacak.',
        sentAt: DateTime(2026, 5, 16, 14, 5),
      ),
    ],
    'mock-hobbies': [
      RoomMessage(
        id: 'h1',
        roomId: 'mock-hobbies',
        authorName: 'Ayşe',
        text: 'Hafta sonu seramik atölyesine katılan var mı?',
        sentAt: DateTime(2026, 5, 17, 10, 15),
      ),
      RoomMessage(
        id: 'h2',
        roomId: 'mock-hobbies',
        authorName: 'Can',
        text: 'Ben geçen ay katıldım, çok keyifliydi!',
        sentAt: DateTime(2026, 5, 17, 10, 22),
      ),
    ],
  };
}
