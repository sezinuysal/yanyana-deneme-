import 'package:yanyana_p/shared/models/support_request.dart';
import 'matching_engine.dart';
import 'notification_dispatcher.dart';

/// Accepts support requests, forwards to MatchingEngine,
/// returns updated SupportRequest (mock).
class RequestManager {
  final MatchingEngine matchingEngine;
  final NotificationDispatcher notificationDispatcher;

  const RequestManager({
    required this.matchingEngine,
    required this.notificationDispatcher,
  });

  Future<SupportRequest> createSupportRequest(SupportRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final volunteer = matchingEngine.findBestVolunteer(request);
    final updated = request.copyWith(
      status: 'Eşleştirildi',
      assignedVolunteerName: volunteer,
    );

    await notificationDispatcher.sendNotification(
      'Yeni Destek Talebi',
      '${updated.requestType} için $volunteer eşleştirildi.',
    );

    return updated;
  }
}

