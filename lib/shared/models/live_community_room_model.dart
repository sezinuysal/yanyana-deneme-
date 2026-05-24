import 'package:yanyana_p/shared/models/community_room.dart';

/// Firestore `community_rooms` document (live rooms).
class LiveCommunityRoom {
  final String id;
  final String name;
  final String description;
  final String category;
  final int memberCount;
  final List<String> accessibilityTags;
  final String createdBy;
  final DateTime createdAt;
  final List<String> joinedUserIds;

  const LiveCommunityRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberCount,
    this.accessibilityTags = const [],
    required this.createdBy,
    required this.createdAt,
    this.joinedUserIds = const [],
  });

  bool isJoinedBy(String userId) => joinedUserIds.contains(userId);

  /// Maps to shared [CommunityRoom] for UI cards and legacy detail pages.
  CommunityRoom toCommunityRoom() {
    final tags = accessibilityTags.isEmpty
        ? const ['Güvenli Alan']
        : accessibilityTags;
    return CommunityRoom(
      id: id,
      title: name,
      category: category,
      description: description,
      memberCount: memberCount,
      accessibilityTags: tags,
      createdByUserId: createdBy,
    );
  }

  factory LiveCommunityRoom.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final tags = data['accessibilityTags'];
    final joined = data['joinedUserIds'];

    return LiveCommunityRoom(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      memberCount: (data['memberCount'] as num?)?.toInt() ?? 0,
      accessibilityTags: tags is List
          ? tags.map((e) => e.toString()).toList()
          : const [],
      createdBy: data['createdBy'] as String? ??
          data['createdByUid'] as String? ??
          '',
      createdAt: _parseDate(data['createdAt']),
      joinedUserIds: joined is List
          ? joined.map((e) => e.toString()).toList()
          : const [],
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    // Timestamp handled in service layer when using Firestore types.
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
