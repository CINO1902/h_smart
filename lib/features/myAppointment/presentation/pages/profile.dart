import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 195,
                decoration: const BoxDecoration(
                  color: Color(0xffF3F7FF),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) {
                        return Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      imageUrl: ref.watch(authProvider).profilepic,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: SafeArea(
                    child: Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.white,
                      ),
                    ),
                    // Solid text as fill.
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )),
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 150),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        imageUrl: ref.watch(authProvider).profilepic,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    )),
              ),
            ],
          ),
          Center(
            child: Text(
              '${ref.watch(authProvider).firstname} ${ref.watch(authProvider).lastname}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Gap(10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.53,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  height: 365,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC1D3FF)),
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffF3F7FF)),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            if (ref.watch(authProvider).infoloading == true) {
                              SmartDialog.showToast('System is busy');
                              return;
                            }
                            Navigator.pushNamed(context, '/PersonalInfo');
                          },
                          child: profilelink('Personal Info', 'UserCircle')),
                      Gap(15),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/MedicalRecord');
                          },
                          child: profilelink('Medical Records', 'Vector-3')),
                      Gap(15),
                      profilelink('Payments', 'CreditCard'),
                      Gap(15),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/Settings');
                          },
                          child: profilelink('Settings', 'Sliders')),
                      Gap(15),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/Support');
                          },
                          child: profilelink('Supports', 'UsersThree')),
                      Gap(15),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/Legal');
                          },
                          child: profilelink('Legal', 'Info'))
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: false,
                      animType: AnimType.topSlide,
                      title: 'Warning',
                      desc: 'This action would Log you out of your account',
                      btnCancelOnPress: () {},
                      onDismissCallback: (type) {},
                      btnOkOnPress: () async {
                        SmartDialog.showLoading();

                        ref.watch(authProvider).logout();

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                        SmartDialog.dismiss();
                      },
                    ).show();
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffFFEFEF),
                        border: Border.all(color: Color(0xffFFBCBD))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Log out',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Colors.red),
                            ),
                            Image.asset('images/SignOut.png'),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container profilelink(title, image) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Color(0xffC1D3FF))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(children: [
          Image.asset('images/$image.png'),
          Gap(10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
          )
        ]),
      ),
    );
  }
}
