/// Handles emergency support and safe call flow (mock).
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
}

