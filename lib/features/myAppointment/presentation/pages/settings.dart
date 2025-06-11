import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../../../core/utils/appColor.dart' show AppColors;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _controller = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Settings',
            style: TextStyle(fontSize: 19),
          )),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        height: 180,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffC1D3FF)),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffF3F7FF)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ChangePassword');
                },
                child: recordtype('Change Password')),
            const Gap(10),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffC1D3FF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notification'),
                  AdvancedSwitch(
                    controller: _controller,
                    activeColor: AppColors.kprimaryColor500,
                    inactiveColor: Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    width: 35.0,
                    height: 20.0,
                    enabled: true,
                    disabledOpacity: 0.5,
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffC1D3FF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reminder'),
                  AdvancedSwitch(
                    controller: _controller,
                    activeColor: AppColors.kprimaryColor500,
                    inactiveColor: Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    width: 35.0,
                    height: 20.0,
                    enabled: true,
                    disabledOpacity: 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container recordtype(title) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffC1D3FF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          SizedBox(
              height: 20, width: 20, child: Image.asset('images/iconright.png'))
        ],
      ),
    );
  }
}
