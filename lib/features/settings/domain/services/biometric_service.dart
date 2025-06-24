import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available on the device
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Check if Face ID is available
  static Future<bool> isFaceIdAvailable() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Check if Touch ID/Fingerprint is available
  static Future<bool> isTouchIdAvailable() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Authenticate using biometrics
  static Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    String cancelLabel = 'Cancel',
    String disableLabel = 'Disable',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Error during authentication: $e');
      return false;
    }
  }

  /// Authenticate with Face ID
  static Future<bool> authenticateWithFaceId({
    String reason = 'Please authenticate with Face ID',
  }) async {
    if (!await isFaceIdAvailable()) {
      return false;
    }
    return authenticate(reason: reason);
  }

  /// Authenticate with Touch ID
  static Future<bool> authenticateWithTouchId({
    String reason = 'Please authenticate with Touch ID',
  }) async {
    if (!await isTouchIdAvailable()) {
      return false;
    }
    return authenticate(reason: reason);
  }

  /// Check if passkey is supported (placeholder for future implementation)
  static Future<bool> isPasskeySupported() async {
    // TODO: Implement passkey support when available
    // This would check for WebAuthn support or platform-specific passkey APIs
    return false;
  }

  /// Create a passkey (placeholder for future implementation)
  static Future<bool> createPasskey({
    required String username,
    required String displayName,
  }) async {
    // TODO: Implement passkey creation
    // This would use WebAuthn or platform-specific APIs
    return false;
  }

  /// Authenticate with passkey (placeholder for future implementation)
  static Future<bool> authenticateWithPasskey() async {
    // TODO: Implement passkey authentication
    // This would use WebAuthn or platform-specific APIs
    return false;
  }

  /// Get device information for security purposes
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final biometrics = await getAvailableBiometrics();
      final isAvailable = await isBiometricAvailable();

      return {
        'biometricAvailable': isAvailable,
        'availableBiometrics': biometrics.map((e) => e.toString()).toList(),
        'faceIdAvailable': await isFaceIdAvailable(),
        'touchIdAvailable': await isTouchIdAvailable(),
        'passkeySupported': await isPasskeySupported(),
      };
    } catch (e) {
      print('Error getting device info: $e');
      return {
        'biometricAvailable': false,
        'availableBiometrics': [],
        'faceIdAvailable': false,
        'touchIdAvailable': false,
        'passkeySupported': false,
      };
    }
  }
}
