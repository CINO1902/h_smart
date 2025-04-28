import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> requestpermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // final FCMToken = await messaging.getToken();

    // print('Firebase Token: $FCMToken');
  }
}
