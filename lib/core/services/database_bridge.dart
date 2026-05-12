import 'package:yanyana_p/core/constants/app_constants.dart';
import 'package:yanyana_p/shared/data/mock_data.dart';
import 'package:yanyana_p/shared/models/accessibility_review.dart';
import 'package:yanyana_p/shared/models/accessible_place.dart';
import 'package:yanyana_p/shared/models/app_notification.dart';
import 'package:yanyana_p/shared/models/app_user.dart';
import 'package:yanyana_p/shared/models/community_post.dart';
import 'package:yanyana_p/shared/models/community_room.dart';
import 'package:yanyana_p/shared/models/emergency_contact.dart';
import 'package:yanyana_p/shared/models/sos_request.dart';
import 'package:yanyana_p/shared/models/user_profile.dart';
import 'package:yanyana_p/shared/models/volunteer_application.dart';

import 'auth_service.dart';
import 'place_data_service.dart';

/// Local mock database bridge (Firestore-shaped API without a real backend).
///
/// This is a prototype facade. Later, methods can map to Firestore collections,
/// Firebase Authentication profile reads, callable Cloud Functions, and FCM topics.
class DatabaseBridge {
  const DatabaseBridge();

  static final List<AccessibilityReview> _reviews = [
    AccessibilityReview(
      id: 'rev_001',
      placeId: 'p_001',
      userId: MockData.currentUser.id,
      wheelchairAccessible: true,
      hasRamp: true,
      hasElevator: false,
      hasAccessibleToilet: true,
      hasQuietArea: true,
      corridorWide: true,
      rating: 4.5,
      comment: 'Girişte rampa var, içerisi ferah. Personel çok yardımcı.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    AccessibilityReview(
      id: 'rev_002',
      placeId: 'p_004',
      userId: MockData.currentUser.id,
      wheelchairAccessible: true,
      hasRamp: true,
      hasElevator: true,
      hasAccessibleToilet: true,
      hasQuietArea: false,
      corridorWide: true,
      rating: 4.0,
      comment: 'Asansör mevcut ama yoğun saatlerde kalabalık olabiliyor.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<VolunteerApplication> _volunteerApplications =
      List<VolunteerApplication>.from(MockData.volunteerApplications);

  static final List<SosRequest> _sosRequests = [];

  static final List<CommunityPost> _communityPosts = [
    CommunityPost(
      id: 'cp_001',
      authorId: MockData.currentUser.id,
      title: 'İlk günümde YanYana',
      body: 'Uygulamayı deniyorum, herkese merhaba!',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    CommunityPost(
      id: 'cp_002',
      authorId: 'u_demo_2',
      title: 'Erişilebilir kafe önerisi',
      body: 'Çankaya tarafında rampası geniş bir kafe gördüm, paylaşmak istedim.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n_seed_1',
      userId: MockData.currentUser.id,
      title: 'YanYana\'ya hoş geldin',
      body: 'Topluluk kurallarını okumayı unutma (mock bildirim).',
      type: AppNotificationType.announcement,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AppNotification(
      id: 'n_seed_2',
      userId: MockData.currentUser.id,
      title: 'Yeni mesaj',
      body: 'Merhaba, bugün nasılsın? (mock)',
      type: AppNotificationType.message,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static const List<EmergencyContact> _demoEmergencyContacts = [
    EmergencyContact(id: 'ec_001', name: 'Yakın Aile', phoneNumber: '+90 5xx xxx xx xx'),
    EmergencyContact(id: 'ec_002', name: 'Destek Hattı', phoneNumber: '+90 3xx xxx xx xx'),
  ];

  List<CommunityRoom> getRooms() => List.unmodifiable(MockData.communityRooms);

  List<AccessiblePlace> getPlaces() =>
      List.unmodifiable(MockData.accessiblePlaces);

  List<VolunteerApplication> getVolunteerApplications() =>
      List.unmodifiable(_volunteerApplications);

  AppUser getCurrentUser() => AuthService.resolvedUser;

  UserProfile getCurrentUserProfile() {
    final u = getCurrentUser();
    return UserProfile(
      userId: u.id,
      fullName: u.name,
      email: u.email,
      technicalRole: AppRole.normalizeToTechnical(u.role),
      disabilityType: u.disabilityType,
      communicationPreference: u.communicationPreference,
      interests: List.unmodifiable(u.interests),
      points: u.points,
      badges: List.unmodifiable(u.badges),
      emergencyContacts: List.unmodifiable(_demoEmergencyContacts),
    );
  }

  List<CommunityPost> getCommunityPosts() =>
      List.unmodifiable(_communityPosts);

  List<CommunityRoom> getCommunityRooms() => getRooms();

  List<AccessiblePlace> getAccessiblePlaces() => getPlaces();

  List<AccessibilityReview> getPlaceReviews(String placeId) =>
      getReviewsForPlace(placeId);

  Future<void> savePlaceReview(AccessibilityReview review) =>
      saveAccessibilityReview(review);

  Future<void> saveSosRequest(SosRequest sosRequest) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _sosRequests.add(sosRequest);
  }

  List<AppNotification> getNotifications(String userId) {
    return List.unmodifiable(
      _notifications.where(
        (n) => n.userId == userId || n.userId == '*',
      ),
    );
  }

  Future<void> updateVolunteerApplicationStatus(
    String applicationId,
    String status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _volunteerApplications.indexWhere((a) => a.id == applicationId);
    if (i >= 0) {
      _volunteerApplications[i] =
          _volunteerApplications[i].copyWith(status: status);
    }
  }

  /// Real-data-ready place access: future Overpass API + local YanYana reviews merge.
  Future<List<AccessiblePlace>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusMeters = 1500,
  }) {
    return PlaceDataService(databaseBridge: this).fetchNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );
  }

  Future<void> saveAccessibilityReview(AccessibilityReview review) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _reviews.add(review);
  }

  List<AccessibilityReview> getReviewsForPlace(String placeId) {
    return List.unmodifiable(_reviews.where((r) => r.placeId == placeId));
  }
}
