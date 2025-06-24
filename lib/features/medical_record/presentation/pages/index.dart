import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:h_smart/features/chat/presentation/pages/chat.dart';
import 'package:h_smart/features/medical_record/presentation/pages/HomePage.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/myAppointment.dart';
import 'package:h_smart/features/myAppointment/presentation/pages/profile.dart';
import 'package:h_smart/features/posts/presentation/pages/posts_screen.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../core/utils/appColor.dart';

class indexpage extends StatefulWidget {
  const indexpage({super.key});

  @override
  State<indexpage> createState() => _indexpageState();
}

class _indexpageState extends State<indexpage> {
  int _selectedIndex = 0;

  bool canpop = true;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const HomePage(),
      const MyAppointment(),
      const PostsScreen(),
      const Chat(),
      const ProfileScreen(),
    ];
    return PopScope(
      canPop: canpop,
      child: Scaffold(
        body: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Theme.of(context).colorScheme.onInverseSurface,
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: GNav(
                rippleColor: Theme.of(context).colorScheme.inverseSurface,
                hoverColor: Theme.of(context).colorScheme.inverseSurface,
                gap: 4,
                activeColor: AppColors.kprimaryColor500,
                iconSize: 20,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                // color: Colors.black,
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.alternateCalendar,
                    text: 'Appointment',
                    textStyle: TextStyle(
                        fontSize: 11,
                        color: AppColors.kprimaryColor500,
                        fontWeight: FontWeight.bold),
                  ),
                  GButton(
                    icon: LineIcons.newspaper,
                    text: 'Posts',
                  ),
                  GButton(
                    icon: LineIcons.rocketChat,
                    text: 'Chat',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    if (index != 0) {
                      canpop = false;
                    } else {
                      canpop = true;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ),
      onPopInvoked: (dipop) async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
            canpop = true;
          });
        } else {
          setState(() {
            canpop = true;
          });
        }
      },
    );
  }
}
