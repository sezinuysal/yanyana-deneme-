/// Community feed post (mock; future Firestore `community_posts`).
class CommunityPost {
  final String id;
  final String authorId;
  final String title;
  final String body;
  final DateTime createdAt;

  const CommunityPost({
    required this.id,
    required this.authorId,
    required this.title,
    required this.body,
    required this.createdAt,
  });
}
