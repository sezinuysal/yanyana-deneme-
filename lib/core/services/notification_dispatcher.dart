import 'package:yanyana_p/shared/models/app_notification.dart';

/// Mock notification dispatcher (in-app / push stand-in).
///
/// Later this can be mapped to FCM and Firestore notification documents.
class NotificationDispatcher {
  const NotificationDispatcher();

  Future<String> sendNotification(String title, String message) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return 'Bildirim (prototip) gönderildi: $title · $message';
  }

  Future<AppNotification> dispatchSosNotification({
    required String userId,
    String detail = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AppNotification(
      id: 'n_sos_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: 'Acil durum bildirimi',
      body: detail.isEmpty ? 'SOS tetiklendi (mock).' : detail,
      type: AppNotificationType.sos,
      createdAt: DateTime.now(),
    );
  }

  Future<AppNotification> dispatchMatchNotification({
    required String userId,
    required String volunteerName,
    String requestLabel = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final extra = requestLabel.isEmpty ? '' : ' ($requestLabel)';
    return AppNotification(
      id: 'n_match_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: 'Yeni eşleşme',
      body: '$volunteerName gönüllüsü atanmış olabilir$extra.',
      type: AppNotificationType.match,
      createdAt: DateTime.now(),
    );
  }

  Future<AppNotification> dispatchMessageNotification({
    required String userId,
    String preview = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AppNotification(
      id: 'n_msg_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: 'Yeni mesaj',
      body: preview.isEmpty ? 'Yeni bir mesajınız var (mock).' : preview,
      type: AppNotificationType.message,
      createdAt: DateTime.now(),
    );
  }

  Future<AppNotification> dispatchAnnouncementNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AppNotification(
      id: 'n_ann_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      body: body,
      type: AppNotificationType.announcement,
      createdAt: DateTime.now(),
    );
  }
}
