import 'dart:async';
import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/domain/usecases/authStates.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle app lifecycle changes and manage token refresh
class AppLifecycleService {
  static AppLifecycleService? _instance;
  static AppLifecycleService get instance =>
      _instance ??= AppLifecycleService._();

  AppLifecycleService._();

  Timer? _backgroundTimer;
  DateTime? _appPausedTime;
  static const Duration _maxBackgroundTime = Duration(minutes: 30);
  bool _isTokenRefreshNeeded = false;
  bool _isTokenRefreshInProgress = false;

  /// Initialize the lifecycle service
  void initialize(AuthProvider authProvider) {
    // Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(
      _AppLifecycleObserver(authProvider, this),
    );
  }

  /// Check if token refresh is needed
  bool get isTokenRefreshNeeded => _isTokenRefreshNeeded;

  /// Check if token refresh is in progress
  bool get isTokenRefreshInProgress => _isTokenRefreshInProgress;

  /// Reset token refresh flags
  void resetTokenRefreshFlags() {
    _isTokenRefreshNeeded = false;
    _isTokenRefreshInProgress = false;
  }

  /// Mark token refresh as needed (for when refresh fails)
  void markTokenRefreshAsNeeded() {
    _isTokenRefreshNeeded = true;
    _isTokenRefreshInProgress = false;
  }

  /// Handle app pause (going to background)
  void onAppPaused() {
    _appPausedTime = DateTime.now();
    print('App paused at $_appPausedTime');
  }

  /// Handle app resume (coming to foreground)
  void onAppResumed(AuthProvider authProvider) {
    if (_appPausedTime != null) {
      final backgroundDuration = DateTime.now().difference(_appPausedTime!);
      print(
          'App resumed after ${backgroundDuration.inMinutes} minutes in background');

      // If app was in background for more than max time, mark token refresh as needed
      if (backgroundDuration > _maxBackgroundTime) {
        print(
            'App was in background for too long, token refresh will be needed');
        _isTokenRefreshNeeded = true;
      }

      _appPausedTime = null;
    }
  }

  /// Perform token refresh and return success status
  Future<bool> performTokenRefresh(AuthProvider authProvider) async {
    if (!_isTokenRefreshNeeded || _isTokenRefreshInProgress) {
      return true; // No refresh needed or already in progress
    }

    _isTokenRefreshInProgress = true;
    print('Performing token refresh before HomePage initialization...');

    try {
      // Use the new reactivateAccessToken method which handles logout internally
      await authProvider.reactivateAccessToken();

      // Check if the refresh was successful
      if (authProvider.loginResult.state == LoginResultStates.isData) {
        print('Token refresh successful before HomePage initialization');
        _isTokenRefreshNeeded = false;
        _isTokenRefreshInProgress = false;
        return true;
      } else {
        print('Token refresh failed before HomePage initialization: ${authProvider.loginResult.response.message}');
        
        // Check if user was logged out due to authentication failure
        final prefs = await SharedPreferences.getInstance();
        final hasToken = prefs.getString('jwt_token') != null;
        
        if (!hasToken) {
          // User was logged out due to invalid tokens
          print('User was logged out due to invalid tokens during app resume');
          _isTokenRefreshNeeded = false; // Reset since user is logged out
        } else {
          // Network error - keep refresh needed flag
          print('Token refresh failed due to network error - will retry');
        }
        
        _isTokenRefreshInProgress = false;
        return hasToken; // Return false if user was logged out, true if still logged in
      }
    } catch (e) {
      print('Exception during token refresh before HomePage initialization: $e');
      
      // Check if user was logged out due to the exception
      try {
        final prefs = await SharedPreferences.getInstance();
        final hasToken = prefs.getString('jwt_token') != null;
        
        if (!hasToken) {
          // User was logged out due to the exception
          print('User was logged out due to token refresh exception during app resume');
          _isTokenRefreshNeeded = false; // Reset since user is logged out
        }
        
        _isTokenRefreshInProgress = false;
        return hasToken; // Return false if user was logged out, true if still logged in
      } catch (prefsError) {
        print('Error checking token status after refresh failure: $prefsError');
        _isTokenRefreshInProgress = false;
        return false; // Assume failure if we can't check
      }
    }
  }

  /// Dispose the service
  void dispose() {
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
    _appPausedTime = null;
  }
}

/// Observer for app lifecycle changes
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final AuthProvider _authProvider;
  final AppLifecycleService _lifecycleService;

  _AppLifecycleObserver(this._authProvider, this._lifecycleService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _lifecycleService.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _lifecycleService.onAppResumed(_authProvider);
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        break;
      case AppLifecycleState.hidden:
        // App is hidden but not paused (e.g., on Android when using recent apps)
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., receiving a phone call)
        break;
    }
  }
}
