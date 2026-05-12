import '../models/support_request.dart';

/// Selects the most suitable volunteer for a request (mock logic).
class MatchingEngine {
  const MatchingEngine();

  String findBestVolunteer(SupportRequest request) {
    final type = request.requestType.toLowerCase();
    if (type.contains('ulaşım')) return 'Ali Demir';
    if (type.contains('okuma')) return 'Zeynep Kaya';
    if (type.contains('acil')) return 'Ece Yıldız';
    if (type.contains('mentorluk')) return 'Elif Çetin';
    return 'Gönüllü Ekibi';
  }
}

