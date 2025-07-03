// lib/app_router.dart
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/pageTransition.dart';
import 'package:h_smart/features/Hospital/presentation/pages/hospitalDetailView.dart';
import 'package:h_smart/features/SymptomsChecker/presentation/pages/symptomschecker.dart';
import 'package:h_smart/features/TestAndResport/presentation/pages/testandreport.dart';
import 'package:h_smart/features/auth/presentation/pages/ForgotPassword/EnterEmail.dart';
import 'package:h_smart/features/auth/presentation/pages/WelcomePage.dart';

import 'package:h_smart/features/chat/presentation/pages/chat.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/Doctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/aboutDoctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/appointscheduled.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/doctorDetailView.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/rateexperience.dart';
import 'package:h_smart/features/init/initpage.dart';
import 'package:h_smart/features/init/onboarding.dart';
import 'package:h_smart/features/medical_record/presentation/pages/index.dart';
import 'package:h_smart/features/medical_record/presentation/pages/medicalrecord.dart';
import 'package:h_smart/features/settings/presentation/pages/changepassword.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/myAppointment.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/Hospital/presentation/pages/specificHospital.dart';
import '../features/Hospital/presentation/pages/hospital.dart';
import '../features/Hospital/presentation/pages/viewhospistaldetail.dart';
import '../features/TestAndResport/presentation/pages/report.dart';
import '../features/auth/presentation/pages/CompleteProfile.dart'
    show CompleteProfilePage;
import '../features/auth/presentation/pages/ForgotPassword/succesPasswordchange.dart';
import '../features/auth/presentation/pages/ForgotPassword/verifyOtp.dart';
import '../features/auth/presentation/pages/Login.dart' show LoginPage;
import '../features/auth/presentation/pages/Register.dart' show RegisterPage;
import '../features/auth/presentation/pages/profileComplete.dart'
    show ProfileCompleteScreen;
import '../features/auth/presentation/pages/verifyemail.dart'
    show VerifyEmailPage;
import '../features/firstAid/presentation/pages/firstaid.dart';
import '../features/medical_record/presentation/pages/medicalinfo.dart';
import '../features/medical_record/presentation/pages/medicine_and_prescription.dart';
import '../features/myAppointment/presentation/pages/legal.dart';
import '../features/myAppointment/presentation/pages/personalinfo.dart';
import '../features/support/presentation/pages/Faq.dart';
import '../features/support/presentation/pages/feedback.dart';
import '../features/support/presentation/pages/support.dart';
import '../features/posts/presentation/pages/post_detail_page.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/settings/presentation/pages/settings_screen.dart';
import 'package:h_smart/features/settings/presentation/pages/security_settings_screen.dart';
import 'package:h_smart/features/settings/presentation/pages/google_authenticator_page.dart';
import 'package:h_smart/features/settings/presentation/pages/backup_codes_page.dart';
import 'package:h_smart/features/settings/presentation/pages/active_sessions_page.dart';
import 'package:h_smart/features/settings/presentation/pages/health_profile_screen.dart';
import 'package:h_smart/features/auth/presentation/pages/ChangePasswordPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pages

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    observers: [FlutterSmartDialog.observer],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      final token = prefs.getString('jwt_token');
      final loc = state.matchedLocation;
      final profileCompleted = prefs.getBool('profile_completed') ?? false;

      // 1. If onboarding not seen, always go to onboarding (unless already there)
      if (!hasSeenOnboarding && loc != '/onboarding') {
        return '/onboarding';
      }

      // 2. If onboarding seen but not authenticated, only allow login/register/verify
      final unauthenticatedRoutes = [
        '/login',
        '/register',
        '/verify-email',
        '/forgot-password',
        '/forgot-password/otp',
        '/forgot-password/changePassword',
        '/forgot-password/passwordchangecomplete',
        '/complete-profile',
        '/profile-complete'
      ];
      if (hasSeenOnboarding &&
          token == null &&
          !unauthenticatedRoutes.contains(loc)) {
        return '/login';
      }

      // 3. If authenticated, and trying to access login/onboarding, go to home
// Prevent showing welcome if onboarding is done and token is present
      if (token != null && hasSeenOnboarding && loc == '/welcome') {
        if (profileCompleted) {
          return '/home';
        } else {
          return '/complete-profile';
        }
      }

      // Otherwise, allow navigation
      return null;
    },
    routes: [
      GoRoute(
          path: '/initial',
          name: 'initial',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const DeciderScreen(),
              )),
      GoRoute(
          path: '/welcome',
          name: 'welcome',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const WelcomePage(),
              )),
      GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const OnboardingScreen(),
              )),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verifyEmail',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: VerifyEmailPage(
            email: (state.extra as Map)['email'],
          ),
        ),
      ),
      GoRoute(
        path: '/complete-profile',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const CompleteProfilePage(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ForgotPassword(),
        ),
      ),
      GoRoute(
        path: '/forgot-password/otp',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: VerifyPasswordOtp(
            email: (state.extra as Map)['email'],
          ),
        ),
      ),
      GoRoute(
        path: '/forgot-password/changePassword',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: ChangePasswordPage(
            email: (state.extra as Map)['email'],
          ),
        ),
      ),
      GoRoute(
        path: '/forgot-password/passwordchangecomplete',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ChangeCompleteScreen(),
        ),
      ),
      GoRoute(
        path: '/profile-complete',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ProfileCompleteScreen(),
        ),
      ),
      // GoRoute(
      //   path: '/setup-health',
      //   pageBuilder: (context, state) => buildPageWithDefaultTransition(
      //     context: context,
      //     state: state,
      //     child: const setuphealth(),
      //   ),
      // ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const indexpage(),
        ),
      ),
      GoRoute(
          path: '/doctor',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Doctor(),
              )),
      GoRoute(
          path: '/doctor/about',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AboutDoctor(),
              )),
      GoRoute(
          path: '/doctor/scheduled',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const AppointmentScheduled(),
              )),
      GoRoute(
          path: '/doctor/rate',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const RateExperience(),
              )),
      GoRoute(
          path: '/chat',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Chat(),
              )),
      GoRoute(
          path: '/appointments',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const MyAppointment(),
              )),
      GoRoute(
          path: '/PersonalInfo',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const PersonalInfo(),
              )),
      GoRoute(
          path: '/appointments/settings', builder: (_, __) => const Settings()),
      GoRoute(
          path: '/appointments/legal',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Legal(),
              )),
      GoRoute(
          path: '/appointments/change-password',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ChangePassword(),
              )),
      GoRoute(
          path: '/medical-record',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const MedicalRecord(),
              )),
      GoRoute(
          path: '/medical-record/info',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const MedicalInfo(),
              )),
      GoRoute(
          path: '/medical-record/prescriptions',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const MedicineAndPres(),
              )),
      GoRoute(
          path: '/medical-record/docs',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const MyAppointment(),
              )),
      GoRoute(
          path: '/test-report',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Report(),
              )),
      GoRoute(
          path: '/test-report/view',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const TestAndReport(),
              )),
      GoRoute(
          path: '/symptoms-checker',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SymptomsChecker(),
              )),
      GoRoute(
          path: '/first-aid',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const FirstAid(),
              )),
      GoRoute(
          path: '/support',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Support(),
              )),
      GoRoute(
          path: '/support/feedback',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Feedbacks(),
              )),
      GoRoute(
          path: '/support/faq',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const FAQ(),
              )),
      GoRoute(
          path: '/hospital',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const Hospital(),
              )),
      GoRoute(
          path: '/hospital/detail',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: viewhospitaldetail(
                  hospital: (state.extra as Map)['hospital'],
                ),
              )),

      GoRoute(
          path: '/hospital/more-detail',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: HospitalDetailView(
                  hospital: (state.extra as Map)['hospital'],
                ),
              )),
      GoRoute(
          path: '/doctor/detail',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: DoctorDetailView(
                  doctor: (state.extra as Map)['doctor'],
                ),
              )),
      GoRoute(
          path: '/hospital/specific',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: SpecificHospital(
                  title: (state.extra as Map)['title'],
                ),
              )),
      GoRoute(
        path: '/post/:id',
        name: 'postDetail',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: Consumer(
            builder: (context, ref, child) {
              return PostDetailPage(
                post: state.extra as Post,
                parentRef: ref,
              );
            },
          ),
        ),
      ),
      GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SettingsScreen(),
              )),
      GoRoute(
          path: '/security-settings',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const SecuritySettingsScreen(),
              )),
      // GoRoute(
      //     path: '/change-password',
      //     pageBuilder: (context, state) => buildPageWithDefaultTransition(
      //           context: context,
      //           state: state,
      //           child: const ChangePasswordPage(),
      //         )),
      GoRoute(
          path: '/google-authenticator',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const GoogleAuthenticatorPage(),
              )),
      GoRoute(
          path: '/backup-codes',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const BackupCodesPage(),
              )),
      GoRoute(
          path: '/active-sessions',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const ActiveSessionsPage(),
              )),
      GoRoute(
          path: '/health-profile',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const HealthProfileScreen(),
              )),
    ],
  );
}
