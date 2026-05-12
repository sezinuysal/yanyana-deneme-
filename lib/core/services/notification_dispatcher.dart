/// Mock notification dispatcher.
/// Represents future push notification integration.
class NotificationDispatcher {
  const NotificationDispatcher();

  Future<String> sendNotification(String title, String message) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return 'Bildirim (prototip) gönderildi: $title · $message';
  }
}

