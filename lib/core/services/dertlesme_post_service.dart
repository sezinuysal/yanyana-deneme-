import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yanyana_p/core/firebase/firebase_auth_errors.dart';
import 'package:yanyana_p/core/firebase/firestore_collections.dart';
import 'package:yanyana_p/core/firebase/firestore_utils.dart';
import 'package:yanyana_p/shared/models/dertlesme_post.dart';

/// Firestore CRUD ve stream işlemleri — dertlesme_posts koleksiyonu.
class DertlesmePostService {
  DertlesmePostService._();

  static final DertlesmePostService instance = DertlesmePostService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.dertlesmePosts);

  // ── Stream ──────────────────────────────────────────────
  Stream<List<DertlesmePost>> streamPosts() {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(80)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  // ── Gönderi ekle ───────────────────────────────────────
  Future<void> addPost({
    required String authorId,
    required String authorName,
    required bool isAnonymous,
    required String body,
    required String category,
  }) async {
    final ref = _col.doc();
    try {
      await ref.set({
        'id': ref.id,
        'authorId': authorId,
        'authorName': isAnonymous ? 'Anonim' : authorName.trim(),
        'isAnonymous': isAnonymous,
        'body': body.trim(),
        'category': category,
        'reactions': <String, int>{},
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  // ── Emoji tepkisi ekle/artır ───────────────────────────
  Future<void> addReaction({
    required String postId,
    required String emoji,
  }) async {
    try {
      await _col.doc(postId).update({
        'reactions.$emoji': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  // ── Mapper ────────────────────────────────────────────
  DertlesmePost _fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final rawReactions = data['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = rawReactions.map(
      (k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0),
    );
    return DertlesmePost(
      id: data['id'] as String? ?? doc.id,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Kullanıcı',
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      body: data['body'] as String? ?? '',
      category: data['category'] as String? ?? 'Genel',
      reactions: reactions,
      createdAt: parseFirestoreDate(data['createdAt']),
    );
  }
}
