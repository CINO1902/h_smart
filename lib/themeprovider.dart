import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themeprovider extends ChangeNotifier {
  String _theme = "system";
  String get theme => _theme;
  int group = 3;

  bool togg = true;

  ThemeMode getTheme() {
    switch (_theme) {
      case "light":
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  Themeprovider() {
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    final pref = await SharedPreferences.getInstance();
    togg = pref.getBool('togg') ?? true;
    group = pref.getInt('group') ?? 3;
    _theme = pref.getString('theme') ?? 'system';
    notifyListeners();
  }

  _saveToPrefs() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('togg', togg);
    pref.setInt('group', group);
    pref.setString('theme', _theme);
  }

  changetheme(value1) {
    group = value1;
    togg = false;
    if (group == 1) {
      _theme = 'light';
    } else if (group == 2) {
      _theme = 'dark';
    }
    _saveToPrefs();
    notifyListeners();
  }

  changetogg(togg1) {
    togg = togg1;
    checktogg();

    notifyListeners();
  }

  checktogg() {
    if (togg == true) {
      _theme = 'system';
      group = 3;
    }
    _saveToPrefs();
    notifyListeners();
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class myTheme {
  static final darktheme = ThemeData(
      fontFamily: 'Poppins',
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 34, 34, 34),
      primaryColor: HexColor('#3772FF'),
      primaryColorLight: Colors.black,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: HexColor('#3772FF'),
        selectionColor: HexColor('#3772FF'),
      ),
      iconTheme: IconThemeData(
        color: HexColor('#87130f'),
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.black)),
      primaryColorDark: Colors.white,
      colorScheme: const ColorScheme.dark(
        onSurface: Color.fromARGB(255, 229, 229, 229),
        onTertiary: Color.fromARGB(255, 231, 231, 231),
        inverseSurface: Color(0xffF3F7FF),
        onInverseSurface: Colors.black,
        primaryContainer: Color.fromARGB(255, 28, 28, 28),
      ));

  static final lighttheme = ThemeData(
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      primaryColor: HexColor('#3772FF'),
      iconTheme: IconThemeData(
        color: HexColor('#3772FF'),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: HexColor('#3772FF'),
        selectionColor: HexColor('#3772FF'),
      ),
      primaryColorLight: Colors.white,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          )),
      primaryColorDark: Colors.black,
      colorScheme: const ColorScheme.light(
        onSurface: Color.fromARGB(255, 114, 114, 114),
        onTertiary: Color.fromARGB(255, 255, 255, 255),
        primaryContainer: Colors.white,
        inverseSurface: Color(0xffF3F7FF),
        onInverseSurface: Colors.black,
      ));
}
