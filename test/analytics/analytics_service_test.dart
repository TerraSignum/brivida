import 'package:brivida_app/core/models/analytics.dart';
import 'package:brivida_app/features/analytics/data/analytics_repo.dart';
import 'package:brivida_app/features/analytics/data/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, Object?>{});
  });

  group('AnalyticsService', () {
    test('client events include admin service purchase success', () {
      expect(
        AnalyticsEventNames.clientEvents,
        contains(AnalyticsEventNames.adminServicePurchaseSuccess),
      );
    });

    test('trackAdminServicePurchaseSuccess delegates to repository', () async {
      final repo = _MockAnalyticsRepository();
      final service = AnalyticsService(repo);

      when(repo.trackAdminServicePurchaseSuccess).thenAnswer((_) async {});

      await service.trackAdminServicePurchaseSuccess();

      verify(repo.trackAdminServicePurchaseSuccess).called(1);
    });
  });
}
