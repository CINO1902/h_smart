// lib/app_router.dart
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/pageTransition.dart';
import 'package:h_smart/features/SymptomsChecker/presentation/pages/symptomschecker.dart';
import 'package:h_smart/features/TestAndResport/presentation/pages/testandreport.dart';

import 'package:h_smart/features/auth/presentation/pages/setUpHealthDetails.dart';
import 'package:h_smart/features/chat/presentation/pages/chat.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/Doctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/aboutDoctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/appointscheduled.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/rateexperience.dart';
import 'package:h_smart/features/init/initpage.dart';
import 'package:h_smart/features/medical_record/presentation/pages/index.dart';
import 'package:h_smart/features/medical_record/presentation/pages/medicalrecord.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/changepassword.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/myAppointment.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/settings.dart';

import '../features/Hospital/presentation/pages/allGovernmentHospital.dart';
import '../features/Hospital/presentation/pages/allprivatehospital.dart';
import '../features/Hospital/presentation/pages/hospital.dart';
import '../features/Hospital/presentation/pages/viewhospistaldetail.dart';
import '../features/TestAndResport/presentation/pages/report.dart';
import '../features/auth/presentation/pages/CompleteProfile.dart'
    show CompleteProfilePage;
import '../features/auth/presentation/pages/Login.dart' show LoginPage;
import '../features/auth/presentation/pages/Register.dart' show RegisterPage;
import '../features/auth/presentation/pages/profileComplete.dart' show ProfileCompleteScreen;
import '../features/auth/presentation/pages/verifyemail.dart' show verifyemail;
import '../features/firstAid/presentation/pages/firstaid.dart';
import '../features/medical_record/presentation/pages/medicalinfo.dart';
import '../features/medical_record/presentation/pages/medicine_and_prescription.dart';
import '../features/myAppointment/presentation/pages/legal.dart';
import '../features/myAppointment/presentation/pages/personalinfo.dart';
import '../features/support/presentation/pages/Faq.dart';
import '../features/support/presentation/pages/feedback.dart';
import '../features/support/presentation/pages/support.dart';

// Pages

final appRouter = GoRouter(
  initialLocation: '/',
  observers: [FlutterSmartDialog.observer],
  routes: [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: DeciderScreen(),
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
        child: const verifyemail(),
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
      path: '/profile-complete',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const ProfileCompleteScreen(),
      ),
    ),
    GoRoute(
      path: '/setup-health',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const setuphealth(),
      ),
    ),
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
        path: '/appointments/personal-info',
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
              child: const viewhospitaldetail(),
            )),
    GoRoute(
        path: '/hospital/government',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const GovermentHospital(),
            )),
    GoRoute(
        path: '/hospital/private',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const PrivateHosptal(),
            )),
  ],
);
