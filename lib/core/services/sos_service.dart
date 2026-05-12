import 'package:yanyana_p/shared/data/mock_data.dart';
import 'package:yanyana_p/shared/models/sos_request.dart';

/// Handles emergency support and safe call flow (mock prototype).
///
/// This facade can later be wired to Firestore (persist `SosRequest`),
/// callable Cloud Functions, and FCM for responder alerts.
class SOSService {
  const SOSService();

  Future<String> triggerSOS() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'SOS akışı başlatıldı. Bildirim gönderimi prototip olarak simüle edildi.';
  }

  Future<String> startSafeCall() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Güvenli arama prototip olarak başlatıldı.';
  }

  /// Builds a [SosRequest] for the emergency flow without changing [triggerSOS] callers.
  Future<SosRequest> createEmergencySosRequest({String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final uid = userId ?? MockData.currentUser.id;
    return SosRequest(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      userId: uid,
      kind: SosKind.emergency,
      createdAt: DateTime.now(),
      status: 'mock_dispatched',
    );
  }

  /// Builds a [SosRequest] for the safe-call flow without changing [startSafeCall] callers.
  Future<SosRequest> createSafeCallSosRequest({String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final uid = userId ?? MockData.currentUser.id;
    return SosRequest(
      id: 'safe_${DateTime.now().millisecondsSinceEpoch}',
      userId: uid,
      kind: SosKind.safeCall,
      createdAt: DateTime.now(),
      status: 'mock_safe_call_started',
    );
  }
}
