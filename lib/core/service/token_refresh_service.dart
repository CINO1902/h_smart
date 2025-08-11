import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for managing automatic token refresh with smart timing
/// This service continuously monitors token age and refreshes before expiry
class TokenRefreshService {
  static TokenRefreshService? _instance;
  static TokenRefreshService get instance =>
      _instance ??= TokenRefreshService._();

  TokenRefreshService._();

  Timer? _tokenRefreshTimer;
  Timer? _tokenObserverTimer;
  static const Duration _tokenLifetime = Duration(minutes: 13);
  static const Duration _refreshBeforeExpiry = Duration(minutes: 1); // Refresh 1 minute before expiry
  static const Duration _observerCheckInterval = Duration(minutes: 1); // Check every minute
  bool _isRunning = false;

  /// Starts the smart token refresh observer
  void startTokenRefresh(ProviderContainer container) {
    if (_isRunning) {
      log('Token refresh observer is already running');
      return;
    }

    _stopAllTimers();
    _startTokenObserver(container);
    _isRunning = true;
    log('Smart token refresh observer started');
  }

  /// Stops all token refresh timers
  void stopTokenRefresh() {
    _stopAllTimers();
    _isRunning = false;
    log('Token refresh observer stopped');
  }

  /// Starts the token observer that continuously monitors token age
  void _startTokenObserver(ProviderContainer container) {
    // Start the observer timer that checks token age every minute
    _tokenObserverTimer = Timer.periodic(_observerCheckInterval, (timer) {
      _checkTokenAgeAndScheduleRefresh(container);
    });
    
    // Also check immediately when starting
    _checkTokenAgeAndScheduleRefresh(container);
  }

  /// Checks token age and schedules refresh if needed
  Future<void> _checkTokenAgeAndScheduleRefresh(ProviderContainer container) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenCreatedAt = prefs.getInt('token_created_at');
      
      if (tokenCreatedAt == null) {
        log('No token creation time found');
        return;
      }

      final tokenCreationTime = DateTime.fromMillisecondsSinceEpoch(tokenCreatedAt);
      final now = DateTime.now();
      final tokenAge = now.difference(tokenCreationTime);
      final timeUntilExpiry = _tokenLifetime - tokenAge;
      final timeUntilRefresh = timeUntilExpiry - _refreshBeforeExpiry;

      log('Token age: ${tokenAge.inMinutes} minutes, Time until refresh: ${timeUntilRefresh.inMinutes} minutes');

      // If token should be refreshed now (12+ minutes old)
      if (timeUntilRefresh.inSeconds <= 0) {
        log('Token needs immediate refresh (${tokenAge.inMinutes} minutes old)');
        await _refreshTokenAutomatically(container);
        return;
      }

      // If we don't have a scheduled refresh timer, or the current one is for a different time
      if (_tokenRefreshTimer == null) {
        _scheduleTokenRefresh(container, timeUntilRefresh);
      }
    } catch (e) {
      log('Error checking token age: $e');
    }
  }

  /// Schedules a token refresh for a specific time
  void _scheduleTokenRefresh(ProviderContainer container, Duration delay) {
    _tokenRefreshTimer?.cancel();
    
    log('Scheduling token refresh in ${delay.inMinutes} minutes and ${delay.inSeconds % 60} seconds');
    
    _tokenRefreshTimer = Timer(delay, () {
      _refreshTokenAutomatically(container);
    });
  }

  /// Automatically refreshes the access token
  Future<void> _refreshTokenAutomatically(ProviderContainer container) async {
    try {
      log('Automatically refreshing access token...');
      final authController = container.read(authProvider.notifier);
      
      // The auth controller now handles retry logic and logout internally
      await authController.reactivateAccessToken();
      
      final loginResult = authController.loginResult;
      if (loginResult.state == LoginResultStates.isData) {
        log('Token refresh successful - rescheduling next refresh');
        
        // Clear the refresh timer since we just refreshed
        _tokenRefreshTimer?.cancel();
        _tokenRefreshTimer = null;
        
        // Schedule the next refresh
        _scheduleTokenRefresh(container, _tokenLifetime - _refreshBeforeExpiry);
      } else if (loginResult.state == LoginResultStates.isError) {
        log('Token refresh failed: ${loginResult.response.message}');
        
        // Check if user was logged out due to authentication failure
        final prefs = await SharedPreferences.getInstance();
        final hasToken = prefs.getString('jwt_token') != null;
        
        if (!hasToken) {
          // User was logged out - stop the observer
          log('User was logged out due to token refresh failure - stopping observer');
          stopTokenRefresh();
        } else {
          // Network error - keep observer running but log the issue
          log('Token refresh failed but user still logged in - likely network issue');
        }
      }
    } catch (e) {
      log('Error during automatic token refresh: $e');
      
      // Check if user was logged out due to the exception
      try {
        final prefs = await SharedPreferences.getInstance();
        final hasToken = prefs.getString('jwt_token') != null;
        
        if (!hasToken) {
          // User was logged out - stop the observer
          log('User was logged out due to token refresh exception - stopping observer');
          stopTokenRefresh();
        }
      } catch (prefsError) {
        log('Error checking token status after refresh failure: $prefsError');
        // If we can't check preferences, assume the worst and stop observer
        stopTokenRefresh();
      }
    }
  }

  /// Stops all timers
  void _stopAllTimers() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
    _tokenObserverTimer?.cancel();
    _tokenObserverTimer = null;
  }

  /// Check if the observer is currently running
  bool get isRunning => _isRunning;

  /// Get the next refresh time (estimated)
  DateTime? get nextRefreshTime {
    if (_tokenRefreshTimer == null) return null;
    // This is a rough estimate since Timer doesn't expose the exact execution time
    return DateTime.now().add(_tokenLifetime - _refreshBeforeExpiry);
  }

  /// Get current token age
  Future<Duration?> get currentTokenAge async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenCreatedAt = prefs.getInt('token_created_at');
      
      if (tokenCreatedAt == null) return null;
      
      final tokenCreationTime = DateTime.fromMillisecondsSinceEpoch(tokenCreatedAt);
      return DateTime.now().difference(tokenCreationTime);
    } catch (e) {
      log('Error getting token age: $e');
      return null;
    }
  }

  /// Force an immediate token refresh check
  Future<void> forceTokenCheck(ProviderContainer container) async {
    log('Forcing immediate token check...');
    await _checkTokenAgeAndScheduleRefresh(container);
  }

  /// Disposes the service
  void dispose() {
    stopTokenRefresh();
  }
}
