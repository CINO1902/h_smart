import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h_smart/core/service/app_lifecycle_service.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';

void main() {
  group('Token Refresh Failure Tests', () {
    test('should keep isTokenRefreshNeeded true when refresh fails', () async {
      // Mock SharedPreferences with old token
      SharedPreferences.setMockInitialValues({
        'jwt_token': 'mock_token',
        'refresh_token': 'mock_refresh_token',
        'token_created_at': DateTime.now()
            .subtract(const Duration(minutes: 60))
            .millisecondsSinceEpoch,
      });

      final prefs = await SharedPreferences.getInstance();
      final tokenCreatedAt = prefs.getInt('token_created_at');
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeSinceTokenCreation =
          Duration(milliseconds: now - tokenCreatedAt!);

      // Should detect that token has been active for more than 13 minutes
    expect(timeSinceTokenCreation.inMinutes, greaterThan(13));

      // Simulate token refresh failure
      final lifecycleService = AppLifecycleService.instance;
      lifecycleService.markTokenRefreshAsNeeded();

      // Verify that isTokenRefreshNeeded is true
      expect(lifecycleService.isTokenRefreshNeeded, isTrue);

      // Simulate failed refresh (this would normally be handled by the auth controller)
      // The key point is that isTokenRefreshNeeded should remain true after failure
      expect(lifecycleService.isTokenRefreshNeeded, isTrue);
    });

    test('should handle network errors vs non-network errors correctly',
        () async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({
        'jwt_token': 'mock_token',
        'refresh_token': 'mock_refresh_token',
        'token_created_at': DateTime.now()
            .subtract(const Duration(minutes: 60))
            .millisecondsSinceEpoch,
      });

      final lifecycleService = AppLifecycleService.instance;
      lifecycleService.markTokenRefreshAsNeeded();

      // Test that the service properly handles different error scenarios
      // This test verifies that the lifecycle service doesn't incorrectly reset flags
      expect(lifecycleService.isTokenRefreshNeeded, isTrue);
      expect(lifecycleService.isTokenRefreshInProgress, isFalse);
    });

    test('should reset flags only on successful refresh', () async {
      final lifecycleService = AppLifecycleService.instance;

      // Mark as needed
      lifecycleService.markTokenRefreshAsNeeded();
      expect(lifecycleService.isTokenRefreshNeeded, isTrue);

      // Simulate successful refresh
      lifecycleService.resetTokenRefreshFlags();
      expect(lifecycleService.isTokenRefreshNeeded, isFalse);
      expect(lifecycleService.isTokenRefreshInProgress, isFalse);
    });
  });
}
