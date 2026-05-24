import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yanyana_p/core/firebase/firebase_auth_errors.dart';
import 'package:yanyana_p/core/firebase/firestore_collections.dart';
import 'package:yanyana_p/core/firebase/firestore_utils.dart';
import 'package:yanyana_p/shared/models/success_story.dart';

/// Firestore success stories (client-side SDK only).
class SuccessStoryService {
  SuccessStoryService._();

  static final SuccessStoryService instance = SuccessStoryService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _stories =>
      _db.collection(FirestoreCollections.successStories);

  List<SuccessStory> _mapAndSort(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final list = docs.map(_fromDoc).toList();
    sortByNewest(list, (s) => s.createdAt);
    return list;
  }

  Stream<List<SuccessStory>> streamStories() {
    return _stories.snapshots().map((snap) => _mapAndSort(snap.docs));
  }

  Future<List<SuccessStory>> getStories() async {
    try {
      final snap = await _stories.get();
      return _mapAndSort(snap.docs);
    } catch (e) {
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  Future<void> deleteStory({
    required String storyId,
    required String userId,
  }) async {
    final ref = _stories.doc(storyId);
    try {
      final snap = await ref.get();
      if (!snap.exists) {
        throw Exception('Hikaye bulunamadı.');
      }
      final ownerId = snap.data()?['userId'] as String? ?? '';
      if (ownerId != userId) {
        throw Exception('Bu hikayeyi silme yetkiniz yok.');
      }
      await ref.delete();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  Future<void> updateStory({
    required String storyId,
    required String userId,
    required String title,
    required String content,
  }) async {
    final ref = _stories.doc(storyId);
    try {
      final snap = await ref.get();
      if (!snap.exists) throw Exception('Hikaye bulunamadı.');
      final ownerId = snap.data()?['userId'] as String? ?? '';
      if (ownerId != userId) {
        throw Exception('Bu hikayeyi düzenleme yetkiniz yok.');
      }
      await ref.update({
        'title': title.trim(),
        'content': content.trim(),
      });
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  Future<void> addStory({
    required String userId,
    required String authorName,
    required String title,
    required String content,
  }) async {
    final ref = _stories.doc();
    try {
      await ref.set({
        'id': ref.id,
        'userId': userId,
        'authorName': authorName.trim(),
        'title': title.trim(),
        'content': content.trim(),
        'likes': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  SuccessStory _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return SuccessStory(
      id: data['id'] as String? ?? doc.id,
      userId: data['userId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Kullanıcı',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? data['body'] as String? ?? '',
      createdAt: parseFirestoreDate(data['createdAt']),
      likes: (data['likes'] as num?)?.toInt() ?? 0,
    );
  }
}
