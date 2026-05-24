/// Dertleşme Duvarı gönderisi — `dertlesme_posts` Firestore koleksiyonu.
class DertlesmePost {
  final String id;
  final String authorId;
  final String authorName; // 'Anonim' olabilir
  final bool isAnonymous;
  final String body;
  final String category; // 'Ağrı', 'Yalnızlık', 'Destek', 'Günlük', 'Teşekkür'
  final Map<String, int> reactions; // emoji → sayım
  final DateTime createdAt;

  const DertlesmePost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.isAnonymous,
    required this.body,
    required this.category,
    required this.reactions,
    required this.createdAt,
  });

  String get displayName => isAnonymous ? 'Anonim' : authorName;
}
