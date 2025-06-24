import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h_smart/features/settings/domain/services/biometric_service.dart';

class SecurityState {
  final bool faceIdEnabled;
  final bool touchIdEnabled;
  final bool passkeyEnabled;
  final bool googleAuthEnabled;
  final bool isBiometricAvailable;
  final bool isFaceIdAvailable;
  final bool isTouchIdAvailable;
  final bool isPasskeySupported;
  final String savedEmail;
  final String savedPassword;

  const SecurityState({
    this.faceIdEnabled = false,
    this.touchIdEnabled = false,
    this.passkeyEnabled = false,
    this.googleAuthEnabled = false,
    this.isBiometricAvailable = false,
    this.isFaceIdAvailable = false,
    this.isTouchIdAvailable = false,
    this.isPasskeySupported = false,
    this.savedEmail = '',
    this.savedPassword = '',
  });

  SecurityState copyWith({
    bool? faceIdEnabled,
    bool? touchIdEnabled,
    bool? passkeyEnabled,
    bool? googleAuthEnabled,
    bool? isBiometricAvailable,
    bool? isFaceIdAvailable,
    bool? isTouchIdAvailable,
    bool? isPasskeySupported,
    String? savedEmail,
    String? savedPassword,
  }) {
    return SecurityState(
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      touchIdEnabled: touchIdEnabled ?? this.touchIdEnabled,
      passkeyEnabled: passkeyEnabled ?? this.passkeyEnabled,
      googleAuthEnabled: googleAuthEnabled ?? this.googleAuthEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isFaceIdAvailable: isFaceIdAvailable ?? this.isFaceIdAvailable,
      isTouchIdAvailable: isTouchIdAvailable ?? this.isTouchIdAvailable,
      isPasskeySupported: isPasskeySupported ?? this.isPasskeySupported,
      savedEmail: savedEmail ?? this.savedEmail,
      savedPassword: savedPassword ?? this.savedPassword,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  static const String _faceIdKey = 'face_id_enabled';
  static const String _touchIdKey = 'touch_id_enabled';
  static const String _passkeyKey = 'passkey_enabled';
  static const String _googleAuthKey = 'google_auth_enabled';
  static const String _savedEmailKey = 'biometric_saved_email';
  static const String _savedPasswordKey = 'biometric_saved_password';

  SecurityNotifier() : super(const SecurityState()) {
    _loadSecuritySettings();
    _checkBiometricAvailability();
  }

  Future<void> _loadSecuritySettings() async {
    final prefs = await SharedPreferences.getInstance();

    state = SecurityState(
      faceIdEnabled: prefs.getBool(_faceIdKey) ?? false,
      touchIdEnabled: prefs.getBool(_touchIdKey) ?? false,
      passkeyEnabled: prefs.getBool(_passkeyKey) ?? false,
      googleAuthEnabled: prefs.getBool(_googleAuthKey) ?? false,
      savedEmail: prefs.getString(_savedEmailKey) ?? '',
      savedPassword: prefs.getString(_savedPasswordKey) ?? '',
      isBiometricAvailable: state.isBiometricAvailable,
      isFaceIdAvailable: state.isFaceIdAvailable,
      isTouchIdAvailable: state.isTouchIdAvailable,
      isPasskeySupported: state.isPasskeySupported,
    );
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final deviceInfo = await BiometricService.getDeviceInfo();

      state = state.copyWith(
        isBiometricAvailable: deviceInfo['biometricAvailable'] ?? false,
        isFaceIdAvailable: deviceInfo['faceIdAvailable'] ?? false,
        isTouchIdAvailable: deviceInfo['touchIdAvailable'] ?? false,
        isPasskeySupported: deviceInfo['passkeySupported'] ?? false,
      );
    } catch (e) {
      print('Error checking biometric availability: $e');
      state = state.copyWith(
        isBiometricAvailable: false,
        isFaceIdAvailable: false,
        isTouchIdAvailable: false,
        isPasskeySupported: false,
      );
    }
  }

  Future<bool> toggleFaceId(bool value) async {
    if (!state.isFaceIdAvailable) {
      return false;
    }

    if (value) {
      // Authenticate before enabling
      final authenticated = await BiometricService.authenticateWithFaceId(
        reason: 'Enable Face ID for quick sign-in',
      );

      if (!authenticated) {
        return false;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_faceIdKey, value);
    state = state.copyWith(faceIdEnabled: value);
    return true;
  }

  Future<bool> toggleTouchId(bool value) async {
    if (!state.isTouchIdAvailable) {
      return false;
    }

    if (value) {
      // Authenticate before enabling
      final authenticated = await BiometricService.authenticateWithTouchId(
        reason: 'Enable Touch ID for quick sign-in',
      );

      if (!authenticated) {
        return false;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_touchIdKey, value);
    state = state.copyWith(touchIdEnabled: value);
    return true;
  }

  Future<bool> togglePasskey(bool value) async {
    if (!state.isPasskeySupported) {
      return false;
    }

    if (value) {
      // TODO: Implement passkey creation
      // final created = await BiometricService.createPasskey(
      //   username: 'user@example.com',
      //   displayName: 'User Name',
      // );
      // if (!created) return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_passkeyKey, value);
    state = state.copyWith(passkeyEnabled: value);
    return true;
  }

  Future<void> toggleGoogleAuth(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_googleAuthKey, value);
    state = state.copyWith(googleAuthEnabled: value);
  }

  Future<void> saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedEmailKey, email);
    await prefs.setString(_savedPasswordKey, password);
    state = state.copyWith(
      savedEmail: email,
      savedPassword: password,
    );
  }

  Future<void> clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
    state = state.copyWith(
      savedEmail: '',
      savedPassword: '',
    );
  }

  Future<void> signOutAllDevices() async {
    // TODO: Implement API call to sign out from all devices
    // This would typically call your backend API to invalidate all sessions
    // except the current one
  }

  Future<bool> authenticateWithBiometrics() async {
    if (state.faceIdEnabled && state.isFaceIdAvailable) {
      return await BiometricService.authenticateWithFaceId();
    } else if (state.touchIdEnabled && state.isTouchIdAvailable) {
      return await BiometricService.authenticateWithTouchId();
    } else if (state.passkeyEnabled && state.isPasskeySupported) {
      return await BiometricService.authenticateWithPasskey();
    }
    return false;
  }

  bool get hasBiometricEnabled {
    return (state.faceIdEnabled && state.isFaceIdAvailable) ||
        (state.touchIdEnabled && state.isTouchIdAvailable) ||
        (state.passkeyEnabled && state.isPasskeySupported);
  }

  String get biometricType {
    if (state.faceIdEnabled && state.isFaceIdAvailable) {
      return 'Face ID';
    } else if (state.touchIdEnabled && state.isTouchIdAvailable) {
      return 'Touch ID';
    } else if (state.passkeyEnabled && state.isPasskeySupported) {
      return 'Passkey';
    }
    return 'Biometric';
  }
}

final securityProvider =
    StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  return SecurityNotifier();
});
