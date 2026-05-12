class CommunityRoom {
  final String id;
  final String title;
  final String category;
  final String description;
  final int memberCount;
  final bool isVoiceEnabled;
  final bool isAuthorizedRoom;

  const CommunityRoom({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.memberCount,
    required this.isVoiceEnabled,
    required this.isAuthorizedRoom,
  });
}

