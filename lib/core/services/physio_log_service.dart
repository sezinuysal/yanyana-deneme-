import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yanyana_p/core/firebase/firebase_auth_errors.dart';
import 'package:yanyana_p/core/firebase/firestore_collections.dart';

/// Fiziuk Tedavi egzersiz günlüklerini Firestore'a kaydeder.
class PhysioLogService {
  PhysioLogService._();

  static final PhysioLogService instance = PhysioLogService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection(FirestoreCollections.users).doc(uid)
          .collection(FirestoreCollections.physioLogs);

  /// Bugünün egzersizini logla.
  Future<void> logToday(String uid) async {
    final today = _todayKey();
    try {
      await _col(uid).doc(today).set({
        'date': today,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(firebaseAuthErrorMessage(e));
    }
  }

  /// Bugün egzersiz yapıldı mı?
  Future<bool> isDoneToday(String uid) async {
    try {
      final doc = await _col(uid).doc(_todayKey()).get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  /// Son N günün tamamlanan log tarihlerini getir (streak hesabı için).
  Future<List<String>> getRecentLogs(String uid, {int days = 30}) async {
    try {
      final cutoff = DateTime.now().subtract(Duration(days: days));
      final cutoffKey =
          '${cutoff.year}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';
      final snap = await _col(uid)
          .where('date', isGreaterThanOrEqualTo: cutoffKey)
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map((d) => d['date'] as String).toList();
    } catch (_) {
      return [];
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
