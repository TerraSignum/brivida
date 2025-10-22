import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/analytics_repo.dart';

/// Global provider for analytics repository
final analyticsProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

/// Analytics service for easy event tracking throughout the app
class AnalyticsService {
  final AnalyticsRepository _repo;

  AnalyticsService(this._repo);

  /// Initialize analytics session
  Future<void> initialize() async {
    await _repo.initSession();
  }

  // Auth Events
  Future<void> trackLogin() async {
    await _repo.trackAuth('login_success');
  }

  Future<void> trackSignup() async {
    await _repo.trackAuth('signup_success');
  }

  // Job Events
  Future<void> trackJobCreated({
    required double sizeM2,
    required int servicesCount,
  }) async {
    await _repo.trackJobCreated(sizeM2: sizeM2, servicesCount: servicesCount);
  }

  Future<void> trackJobUpdated() async {
    await _repo.track('job_updated');
  }

  Future<void> trackJobAssigned() async {
    await _repo.track('job_assigned');
  }

  // Lead Events
  Future<void> trackLeadCreated(String jobId) async {
    await _repo.trackLeadCreated(jobId);
  }

  Future<void> trackLeadAccepted(String jobId) async {
    await _repo.trackLeadAccepted(jobId);
  }

  Future<void> trackLeadDeclined(String jobId) async {
    await _repo.track(
      'lead_declined',
      props: {'jobIdHash': _repo.hashJobId(jobId)},
    );
  }

  // Chat Events
  Future<void> trackChatMessageSent(String message) async {
    await _repo.trackChatMessage(message.length);
  }

  // Calendar Events
  Future<void> trackCalendarEventSaved(String eventType) async {
    await _repo.trackCalendarEvent(eventType);
  }

  Future<void> trackCalendarConflict(int minutesGap) async {
    await _repo.track(
      'calendar_conflict_hard',
      props: {'minutes_gap': minutesGap},
    );
  }

  // Payment Events
  Future<void> trackPaymentCheckoutOpened(double amountEur) async {
    await _repo.trackPaymentCheckout(amountEur);
  }

  Future<void> trackAdminServicePurchaseSuccess() async {
    await _repo.trackAdminServicePurchaseSuccess();
  }

  // Review Events
  Future<void> trackReviewSubmitted(double rating) async {
    await _repo.trackReview(rating);
  }

  // Push Notification Events
  Future<void> trackPushDelivered({String? type}) async {
    await _repo.trackPushNotification('push_delivered', notificationType: type);
  }

  Future<void> trackPushOpened({String? type}) async {
    await _repo.trackPushNotification('push_opened', notificationType: type);
  }

  // Analytics Settings
  Future<void> setOptOut(bool optOut) async {
    await _repo.setAnalyticsOptOut(optOut);
  }

  Future<bool> getOptOut() async {
    return await _repo.getAnalyticsOptOut();
  }
}

/// Provider for analytics service
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final repo = ref.watch(analyticsProvider);
  return AnalyticsService(repo);
});
