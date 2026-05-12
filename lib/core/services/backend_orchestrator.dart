import 'package:yanyana_p/shared/models/accessible_place.dart';
import 'package:yanyana_p/shared/models/app_user.dart';
import 'package:yanyana_p/shared/models/community_room.dart';
import 'package:yanyana_p/shared/models/support_request.dart';
import 'package:yanyana_p/shared/models/volunteer_application.dart';

import 'database_bridge.dart';
import 'matching_engine.dart';
import 'notification_dispatcher.dart';
import 'request_manager.dart';
import 'sos_service.dart';
import 'volunteer_verification_service.dart';

/// Central service layer representing the YanYana Backend Orchestrator.
/// In this prototype it only uses local mock data/services.
class BackendOrchestrator {
  BackendOrchestrator._()
      : databaseBridge = const DatabaseBridge(),
        matchingEngine = const MatchingEngine(),
        notificationDispatcher = const NotificationDispatcher(),
        sosService = const SOSService(),
        volunteerVerificationService = const VolunteerVerificationService(),
        requestManager = RequestManager(
          matchingEngine: const MatchingEngine(),
          notificationDispatcher: const NotificationDispatcher(),
        );

  static final BackendOrchestrator instance = BackendOrchestrator._();

  final RequestManager requestManager;
  final MatchingEngine matchingEngine;
  final SOSService sosService;
  final NotificationDispatcher notificationDispatcher;
  final VolunteerVerificationService volunteerVerificationService;
  final DatabaseBridge databaseBridge;

  Future<SupportRequest> createSupportRequest(SupportRequest request) {
    return requestManager.createSupportRequest(request);
  }

  Future<String> triggerSOS() => sosService.triggerSOS();

  Future<String> startSafeCall() => sosService.startSafeCall();

  Future<VolunteerApplication> approveVolunteer(VolunteerApplication application) {
    return volunteerVerificationService.approveVolunteer(application);
  }

  Future<VolunteerApplication> rejectVolunteer(VolunteerApplication application) {
    return volunteerVerificationService.rejectVolunteer(application);
  }

  List<CommunityRoom> getRooms() => databaseBridge.getRooms();

  List<AccessiblePlace> getPlaces() => databaseBridge.getPlaces();

  List<VolunteerApplication> getVolunteerApplications() =>
      databaseBridge.getVolunteerApplications();

  AppUser getCurrentUser() => databaseBridge.getCurrentUser();
}

