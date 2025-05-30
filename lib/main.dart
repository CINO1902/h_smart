// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:h_smart/core/approuter.dart';

import 'firebase_options.dart';
import 'core/service/locator.dart';
import 'core/api/firebaseinit.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  print('Handling message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      name: 'hsmart-bb867',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await FirebaseApi().requestpermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(ProviderScope(child: MyApp()));
  setup();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'H Smart',
      routerConfig: appRouter,
      builder: FlutterSmartDialog.init(),
    );
  }
}
