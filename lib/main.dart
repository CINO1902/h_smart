import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:h_smart/features/Hospital/presentation/pages/allGovernmentHospital.dart';
import 'package:h_smart/features/Hospital/presentation/pages/allprivatehospital.dart';
import 'package:h_smart/features/Hospital/presentation/pages/hospital.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:h_smart/features/TestAndResport/presentation/pages/report.dart';
import 'package:h_smart/features/auth/presentation/pages/CompleteProfile.dart';
import 'package:h_smart/features/auth/presentation/pages/Register.dart';
import 'package:h_smart/features/auth/presentation/pages/WelcomePage.dart';
import 'package:h_smart/features/auth/presentation/pages/setUpHealthDetails.dart';
import 'package:h_smart/features/auth/presentation/pages/verifyemail.dart';
import 'package:h_smart/features/chat/presentation/pages/chat.dart';
import 'package:h_smart/features/chat/presentation/pages/chatUi.dart';
import 'package:h_smart/features/chat/presentation/provider/chatservice.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/aboutDoctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:h_smart/features/firstAid/presentation/pages/firstaid.dart';

import 'package:h_smart/features/medical_record/presentation/pages/medicalinfo.dart';
import 'package:h_smart/features/medical_record/presentation/pages/medicalrecord.dart';
import 'package:h_smart/features/medical_record/presentation/pages/medicine_and_prescription.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/legal.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/myAppointment.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/personalinfo.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/settings.dart';
import 'package:h_smart/features/myAppointment/presentation/provider/mydashprovider.dart';
import 'package:h_smart/features/support/presentation/pages/Faq.dart';
import 'package:h_smart/features/support/presentation/pages/feedback.dart';
import 'package:h_smart/features/support/presentation/pages/support.dart';
import 'package:h_smart/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service/locator.dart';
import 'features/Hospital/presentation/pages/viewhospistaldetail.dart';
import 'features/SymptomsChecker/presentation/pages/symptomschecker.dart';
import 'features/TestAndResport/presentation/pages/testandreport.dart';
import 'features/auth/presentation/pages/Login.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'firebase_options.dart';
import 'features/doctorRecord/presentation/pages/Doctor.dart';
import 'features/doctorRecord/presentation/pages/appointscheduled.dart';
import 'features/doctorRecord/presentation/pages/rateexperience.dart';
import 'features/medical_record/presentation/pages/index.dart';
import 'features/medical_record/presentation/pages/reportsanddocu.dart';
import 'features/myAppointment/presentation/pages/changepassword.dart';

Future<void> _firebasebackgroundhandler(RemoteMessage message) async {
  Firebase.initializeApp();
  print("handling message in ${message.messageId}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final pref = await SharedPreferences.getInstance();
  String? logtoken = pref.getString('jwt_token');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebasebackgroundhandler);
  print(logtoken);
  runApp(MyApp(
    token: logtoken,
  ));
  setup();
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.token});
  String? token;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterNativeSplash.remove();
  }

  String jwtToken = "";
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authprovider(locator()),
        ),
        ChangeNotifierProvider(
          create: (context) => doctorprpvider(locator()),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicalRecordprovider(locator()),
        ),
        ChangeNotifierProxyProvider<authprovider, ChatService>(
            create: (context) => ChatService(),
            update: (BuildContext context, authprovider authprovider,
                ChatService? chatService) {
              chatService!.update(authprovider);
              return ChatService();
            }),
        ChangeNotifierProxyProvider<authprovider, mydashprovider>(
            create: (context) => mydashprovider(locator()),
            update: (BuildContext context, authprovider authprovider,
                mydashprovider? mydashprovider) {
              mydashprovider!.update(authprovider);
              return mydashprovider;
            }),
        ChangeNotifierProvider(
          create: (context) => GetHospitalProvider(locator()),
        ),
      ],
      child: ChangeNotifierProvider(
          create: (context) => Themeprovider(),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'H Smart',
              theme: myTheme.lighttheme,
              darkTheme: myTheme.darktheme,
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(),
              initialRoute: '/',
              routes: {
                '/': (context) => widget.token == null
                    ? const WelcomePage()
                    : const indexpage(),
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),

                '/verifyemail': (context) => const verifyemail(),
                '/CompleteProfilePage': (context) =>
                    const CompleteProfilePage(),
                '/setuphealth': (context) => const setuphealth(),
                // '/HomePage': (context) => const HomePage(),
                '/indexpage': (context) => const indexpage(),
                //'/DoctorsPage': (context) => const DoctorPage(),
                '/Doctor': (context) => const Doctor(),
                '/aboutDoctor': (context) => const AboutDoctor(),
                '/AppointmentScheduled': (context) =>
                    const AppointmentScheduled(),
                '/RateExperience': (context) => const RateExperience(),
                '/Chat': (context) => const Chat(),
                '/MyAppointment': (context) => const MyAppointment(),
                '/PersonalInfo': (context) => const PersonalInfo(),
                '/MedicalRecord': (context) => const MedicalRecord(),
                '/MedicalInfo': (context) => const MedicalInfo(),
                '/MedicineAndPres': (context) => const MedicineAndPres(),
                '/SymptomsChecker': (context) => const SymptomsChecker(),
                '/Support': (context) => const Support(),
                '/feedback': (context) => const Feedbacks(),
                '/faq': (context) => const FAQ(),
                '/firstAid': (context) => const FirstAid(),
                '/TestAndReport': (context) => const TestAndReport(),
                '/Report': (context) => const Report(),
                '/Legal': (context) => const Legal(),
                '/ReportAndDoc': (context) => const ReportAndDoc(),
                '/Settings': (context) => const Settings(),
                '/ChangePassword': (context) => const ChangePassword(),
                '/Hospital': (context) => const Hospital(),
                '/viewhospitaldetail': (context) => const viewhospitaldetail(),
                '/governmenthospital': (context) => const GovermentHospital(),
                '/privatehospital': (context) => const PrivateHosptal(),
                //  '/ChatUi': (context) => const ChatUI(),
              },

              // home: isLoggedIn ? const MainPage(title: 'Home') : const WelcomePage(),
            );
          }),
    );
  }
}

// class MainPage extends StatefulWidget {
//   const MainPage({super.key, required this.title});

//   final String title;

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   static const List<Widget> pages = <Widget>[
//     HomePage(),
//     DoctorsPage(),
//     ChatsPage(),
//     ProfilePage()
//   ];

//   void bottomNavClick(int item) {
//     setState(() {
//       _selectedIndex = item;
//     });
//     // switch (item) {
//     //   case 0:
//     //     Navigator.of(context).push(
//     //       MaterialPageRoute(
//     //         builder: (context) => const HomePage(),
//     //       ),
//     //     );
//     // }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         selectedIndex: _selectedIndex,
//         destinations: const <Widget>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.home_rounded, color: Colors.blue),
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.calendar_month, color: Colors.blue),
//             icon: Icon(Icons.calendar_month_outlined),
//             label: 'Appointments',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.chat, color: Colors.blue),
//             icon: Icon(Icons.chat_bubble_outline_outlined),
//             label: 'Chat',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.person, color: Colors.blue),
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   onTap: bottomNavClick,
//       //   currentIndex: _selectedIndex,
//       //   items: [
//       //     BottomNavigationBarItem(
//       //       backgroundColor: Colors.primaries[2],
//       //         icon: const Icon(Icons.home_rounded),
//       //         label: "Home",),
//       //     const BottomNavigationBarItem(
//       //         icon: Icon(Icons.calendar_month_outlined), label: "Calender"),
//       //     const BottomNavigationBarItem(
//       //         icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
//       //     const BottomNavigationBarItem(
//       //         icon: Icon(Icons.person), label: "Account"),
//       //   ],
//       // ),
//       body: pages.elementAt(
//           _selectedIndex), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
