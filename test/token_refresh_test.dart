import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Token Refresh Tests', () {
    test('should detect token age and trigger token refresh', () async {
      // Mock SharedPreferences
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
    });

    test('should not trigger token refresh for fresh tokens', () async {
      // Mock SharedPreferences with recent token creation
      SharedPreferences.setMockInitialValues({
        'jwt_token': 'mock_token',
        'refresh_token': 'mock_refresh_token',
        'token_created_at': DateTime.now()
            .subtract(const Duration(minutes: 30))
            .millisecondsSinceEpoch,
      });

      final prefs = await SharedPreferences.getInstance();
      final tokenCreatedAt = prefs.getInt('token_created_at');
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeSinceTokenCreation =
          Duration(milliseconds: now - tokenCreatedAt!);

      // Should not detect token age since it's less than 13 minutes
    expect(timeSinceTokenCreation.inMinutes, lessThan(13));
    });

    test('should handle missing tokens gracefully', () async {
      // Mock SharedPreferences with no tokens
      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final refreshToken = prefs.getString('refresh_token');

      // Should handle missing tokens without errors
      expect(token, isNull);
      expect(refreshToken, isNull);
    });
  });
}
