import 'package:flutter/material.dart';

import '../models/accessible_place.dart';
import '../models/app_user.dart';
import '../models/community_room.dart';
import '../models/support_request.dart';
import '../models/volunteer_application.dart';
import '../theme.dart';

class MockData {
  static const AppUser currentUser = AppUser(
    id: 'u_001',
    name: 'Ayşe Yılmaz',
    email: 'ayse@mail.com',
    role: 'Kullanıcı',
    disabilityType: 'Görünmez Engellilik',
    communicationPreference: 'Metin + Kısa Cümle',
    interests: ['Müzik', 'Doğa', 'Kitap', 'Teknoloji'],
    points: 120,
    badges: ['🌟 İlk Adım', '💬 İletişimci', '🗺️ Keşifçi'],
  );

  static final List<CommunityRoom> communityRooms = [
    const CommunityRoom(
      id: 'r_001',
      title: 'Güvenli Sohbet',
      category: 'Sosyal',
      description: 'Günlük sohbet, dayanışma ve pozitif paylaşım.',
      memberCount: 128,
      isVoiceEnabled: true,
      isAuthorizedRoom: false,
    ),
    const CommunityRoom(
      id: 'r_002',
      title: 'Erişilebilirlik İpuçları',
      category: 'Eğitim',
      description: 'Uygulamalar, cihazlar ve erişilebilirlik tüyoları.',
      memberCount: 74,
      isVoiceEnabled: false,
      isAuthorizedRoom: true,
    ),
    const CommunityRoom(
      id: 'r_003',
      title: 'Sağlık ve İyi Oluş',
      category: 'Sağlık',
      description: 'Deneyim paylaşımı ve destekleyici konuşmalar.',
      memberCount: 56,
      isVoiceEnabled: true,
      isAuthorizedRoom: true,
    ),
    const CommunityRoom(
      id: 'r_004',
      title: 'Mentorluk Köşesi',
      category: 'Mentorluk',
      description: 'Mentor-gönüllü eşleşmeleri için prototip alan.',
      memberCount: 41,
      isVoiceEnabled: false,
      isAuthorizedRoom: false,
    ),
    const CommunityRoom(
      id: 'r_005',
      title: 'Hızlı Destek Masası',
      category: 'Destek',
      description: 'Ulaşım, okuma ve günlük destek için hızlı sorular.',
      memberCount: 92,
      isVoiceEnabled: true,
      isAuthorizedRoom: false,
    ),
  ];

  static final List<AccessiblePlace> accessiblePlaces = [
    AccessiblePlace(
      id: 'p_001',
      externalId: 'mock_p_001',
      source: 'MOCK',
      name: 'Engelsiz Kafe',
      category: 'Kafe',
      latitude: 39.9218,
      longitude: 32.8546,
      distance: '0.3 km',
      rating: 4.8,
      tags: const ['Rampa', 'Sessiz Alan', 'Geniş Koridor'],
      wheelchairAccessible: true,
      hasRamp: true,
      hasElevator: false,
      hasAccessibleToilet: true,
      hasQuietArea: true,
      corridorWide: true,
      userCommentCount: 2,
      color: YanYanaColors.secondary,
    ),
    AccessiblePlace(
      id: 'p_002',
      externalId: 'mock_p_002',
      source: 'MOCK',
      name: 'Yeşil Park',
      category: 'Park',
      latitude: 39.9199,
      longitude: 32.8532,
      distance: '0.6 km',
      rating: 4.5,
      tags: const ['Rampa', 'Geniş Koridor'],
      wheelchairAccessible: true,
      hasRamp: true,
      hasElevator: false,
      hasAccessibleToilet: false,
      hasQuietArea: true,
      corridorWide: true,
      userCommentCount: 1,
      color: YanYanaColors.success,
    ),
    AccessiblePlace(
      id: 'p_003',
      externalId: 'mock_p_003',
      source: 'MOCK',
      name: 'Şehir Restoranı',
      category: 'Restoran',
      latitude: 39.9204,
      longitude: 32.8560,
      distance: '1.1 km',
      rating: 4.2,
      tags: const ['Asansör', 'Engelli Tuvaleti'],
      wheelchairAccessible: true,
      hasRamp: false,
      hasElevator: true,
      hasAccessibleToilet: true,
      hasQuietArea: false,
      corridorWide: true,
      userCommentCount: 0,
      color: YanYanaColors.accentPink,
    ),
    AccessiblePlace(
      id: 'p_004',
      externalId: 'mock_p_004',
      source: 'MOCK',
      name: 'Merkez Hastanesi',
      category: 'Hastane',
      latitude: 39.9189,
      longitude: 32.8582,
      distance: '1.8 km',
      rating: 4.6,
      tags: const ['Asansör', 'Rampa', 'Engelli Tuvaleti'],
      wheelchairAccessible: true,
      hasRamp: true,
      hasElevator: true,
      hasAccessibleToilet: true,
      hasQuietArea: true,
      corridorWide: true,
      userCommentCount: 4,
      color: YanYanaColors.primary,
    ),
  ];

  static final List<SupportRequest> supportRequests = [
    const SupportRequest(
      id: 'sr_001',
      requesterName: 'Ayşe Yılmaz',
      requestType: 'Ulaşım Desteği',
      description: 'Bugün hastaneye giderken eşlik edecek gönüllü arıyorum.',
      status: 'Açık',
      assignedVolunteerName: null,
    ),
    const SupportRequest(
      id: 'sr_002',
      requesterName: 'Mehmet A.',
      requestType: 'Okuma Desteği',
      description: 'Resmi evrak için kısa bir okuma desteği gerekiyor.',
      status: 'Eşleştirildi',
      assignedVolunteerName: 'Zeynep K.',
    ),
  ];

  static final List<VolunteerApplication> volunteerApplications = [
    const VolunteerApplication(
      id: 'va_001',
      name: 'Zeynep Kaya',
      email: 'zeynep@mail.com',
      supportArea: 'Okuma Desteği',
      status: 'Beklemede',
    ),
    const VolunteerApplication(
      id: 'va_002',
      name: 'Ali Demir',
      email: 'ali@mail.com',
      supportArea: 'Ulaşım Desteği',
      status: 'Onaylandı',
    ),
    const VolunteerApplication(
      id: 'va_003',
      name: 'Elif Çetin',
      email: 'elif@mail.com',
      supportArea: 'Mentorluk',
      status: 'Beklemede',
    ),
  ];

  static final List<Map<String, String>> guideCards = [
    {
      'title': 'İletişim Kartı',
      'desc':
          'Kısa cümleler, net istekler ve tercih ettiğin iletişim şeklini belirt.',
      'badge': 'MVP',
    },
    {
      'title': 'Acil Durum Kartı',
      'desc':
          'Acil durumda aranacak kişiler, temel bilgiler ve güvenli alan notları.',
      'badge': 'Prototype',
    },
    {
      'title': 'Günlük Destek Kartı',
      'desc':
          'Rutin destek ihtiyaçların için (okuma, ulaşım, sosyal destek) hızlı form.',
      'badge': 'Prototype',
    },
  ];

  static const List<String> donationSupportTypes = [
    'Maddi Bağış',
    'Eşya Bağışı',
    'Zaman Bağışı',
    'Gönüllü Destek',
  ];
}

