// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:h_smart/features/auth/domain/repositories/authrepo.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../domain/usecases/authStates.dart';
// import '../controller/auth_controller.dart';

// class AuthService with WidgetsBindingObserver {
//   Timer? _refreshTimer;
//   final Duration _tokenLifetime = Duration(minutes: 13);
//   final SharedPreferences prefs;
//   // final AuthRepository authRepository;
//   final AuthProvider authProvider;
//   AuthService(this.prefs, this.authProvider) {
//     WidgetsBinding.instance.addObserver(this);
//     _scheduleNextRefresh();
//   }

//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _refreshTimer?.cancel();
//   }

//   /// Called on app start or resume.
//   Future<void> _scheduleNextRefresh() async {
//     _refreshTimer?.cancel();

//     // 1. load when token was issued
//     final issuedAtMillis = prefs.getInt('token_created_at');
//     if (issuedAtMillis == null) {
//       // no token at all—force a refresh now (or redirect to login)
//       await _doRefresh();
//       return;
//     }

//     final issuedAt = DateTime.fromMillisecondsSinceEpoch(issuedAtMillis);
//     final elapsed = DateTime.now().difference(issuedAt);
//     final remaining = _tokenLifetime - elapsed;

//     if (remaining <= Duration.zero) {
//       // token is already expired
//       await _doRefresh();
//     } else {
//       // schedule exactly at expiry
//       _refreshTimer = Timer(remaining, () async {
//         await _doRefresh();
//       });
//     }
//   }

//   /// Actually call your API to get a new access token + refresh token.
//   Future<void> _doRefresh() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString('refresh_token');

//     try {
//       final resp =
//           await authProvider.reactivateAccessToken(refreshToken ?? '');
//       // assume resp has { accessToken, refreshToken, issuedAtUnix }
//       if (resp.state == LoginResultStates.isData) {
//         await prefs.setString(
//             'jwt_token', resp.response.payload?.accessToken ?? '');
//         await prefs.setString(
//             'refresh_token', resp.response.payload?.refreshToken ?? '');
//         await prefs.setInt(
//             'token_created_at', DateTime.now().millisecondsSinceEpoch);
//       } else {
//         authcon.logout();
//       }
//       // schedule the next one from _new_ issuedAt
//       await _scheduleNextRefresh();
//     } catch (e) {
//       // If refresh fails (network, server), you might retry
//       // after a short delay, or force the user to log in again.
//       print('Refresh failed: $e');
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // whenever the app comes back to foreground,
//       // re-evaluate where we are in that 15-minute window
//       _scheduleNextRefresh();
//     } else if (state == AppLifecycleState.paused) {
//       // optional: pause the timer to save resources
//       _refreshTimer?.cancel();
//     }
//   }
// }
