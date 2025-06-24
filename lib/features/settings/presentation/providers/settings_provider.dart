import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool locationServices;
  final bool darkMode;
  final double textScale;

  const SettingsState({
    this.pushNotifications = true,
    this.emailNotifications = false,
    this.locationServices = true,
    this.darkMode = false,
    this.textScale = 1.0,
  });

  SettingsState copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? locationServices,
    bool? darkMode,
    double? textScale,
  }) {
    return SettingsState(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      locationServices: locationServices ?? this.locationServices,
      darkMode: darkMode ?? this.darkMode,
      textScale: textScale ?? this.textScale,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _locationServicesKey = 'location_services';
  static const String _darkModeKey = 'dark_mode';
  static const String _textScaleKey = 'text_scale';

  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    state = SettingsState(
      pushNotifications: prefs.getBool(_pushNotificationsKey) ?? true,
      emailNotifications: prefs.getBool(_emailNotificationsKey) ?? false,
      locationServices: prefs.getBool(_locationServicesKey) ?? true,
      darkMode: prefs.getBool(_darkModeKey) ?? false,
      textScale: prefs.getDouble(_textScaleKey) ?? 1.0,
    );
  }

  Future<void> togglePushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushNotificationsKey, value);
    state = state.copyWith(pushNotifications: value);
  }

  Future<void> toggleEmailNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, value);
    state = state.copyWith(emailNotifications: value);
  }

  Future<void> toggleLocationServices(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationServicesKey, value);
    state = state.copyWith(locationServices: value);
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    state = state.copyWith(darkMode: value);
  }

  Future<void> updateTextScale(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, value);
    state = state.copyWith(textScale: value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
