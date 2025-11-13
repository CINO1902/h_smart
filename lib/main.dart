// lib/main.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:h_smart/core/approuter.dart';
import 'package:h_smart/core/theme/theme_provider.dart';
import 'package:h_smart/core/theme/text_scale_provider.dart';

import 'core/service/locator.dart';
import 'core/service/app_lifecycle_service.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  print('before env load object');
  try {
    await dotenv.load(fileName: "assests/config/.env");
  } catch (e, st) {
    // log or handle missing env
    log(e.toString());
  }
  
  // Create the provider container
  final container = ProviderContainer();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(container: container),
    ),
  );

  setup();
}

class MyApp extends ConsumerStatefulWidget {
  final ProviderContainer container;
  
  const MyApp({Key? key, required this.container}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Now that we've decided which screen to show, we can remove the splash:
    FlutterNativeSplash.remove();

    // Initialize token refresh service after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTokenRefresh();
    });
  }

  void _initializeTokenRefresh() async {
    // Set the container in the AuthController
    final authController = ref.read(authProvider.notifier);
    authController.setContainer(widget.container);

    // Initialize the app lifecycle service
    AppLifecycleService.instance.initialize(authController);
    
    // Start the smart token refresh observer if user is logged in
    await _initializeTokenObserver();
  }

  /// Initialize the token observer if user is logged in
  Future<void> _initializeTokenObserver() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final refreshToken = prefs.getString('refresh_token');

      // If tokens exist, start the token observer
      if (token != null && refreshToken != null && token.isNotEmpty && refreshToken.isNotEmpty) {
        print('Tokens found, starting token refresh observer');
        final authController = ref.read(authProvider.notifier);
        authController.startTokenRefreshObserver();
      } else {
        print('No tokens found, skipping token observer initialization');
      }
    } catch (e) {
      print('Error initializing token observer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return TextScaleWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'H Smart',
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
