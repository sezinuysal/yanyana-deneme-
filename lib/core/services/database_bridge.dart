import 'package:yanyana_p/shared/data/mock_data.dart';
import 'package:yanyana_p/shared/models/accessibility_review.dart';
import 'package:yanyana_p/shared/models/accessible_place.dart';
import 'package:yanyana_p/shared/models/app_user.dart';
import 'package:yanyana_p/shared/models/community_room.dart';
import 'package:yanyana_p/shared/models/volunteer_application.dart';

import 'place_data_service.dart';

/// Local mock database bridge.
/// Represents future Firestore integration in the report architecture.
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

  List<CommunityRoom> getRooms() => List.unmodifiable(MockData.communityRooms);

  List<AccessiblePlace> getPlaces() =>
      List.unmodifiable(MockData.accessiblePlaces);

  List<VolunteerApplication> getVolunteerApplications() =>
      List.unmodifiable(MockData.volunteerApplications);

  AppUser getCurrentUser() => MockData.currentUser;

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

