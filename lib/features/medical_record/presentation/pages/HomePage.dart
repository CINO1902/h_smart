import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.scrollcontroller1});
  ScrollController scrollcontroller1;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    verifyuser();

    // context.read<GetHospitalProvider>().getHospital();
    // requestpermission();
//  gettoken();
    // makerequest();
    // context.read<doctorprpvider>().calldoctorlist();
  }

  // void gettoken() async {
  //   await FirebaseMessaging.instance.getToken().then((value) {
  //     setState(() {
  //       mtoken = value ?? '';
  //       print(value);
  //     });
  //   });
  // }
  ScrollController scrollcontroller = ScrollController();
  animateToMaxmin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController
          .animateTo(direction,
              duration: Duration(seconds: seconds), curve: Curves.linear)
          .then((value) {
        direction = direction == max ? min : max;
        animateToMaxmin(max, min, direction, seconds, scrollController);
      });
    }
  }

  void verifyuser() async {
    if (Provider.of<authprovider>(context, listen: false).getinfo1 == false) {
      await context.read<authprovider>().getinfo();
    }
    if (mounted) {
      if (Provider.of<authprovider>(context, listen: false).logoutuser) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
        SmartDialog.showToast('Session Closed, Log in Again');
        context.read<authprovider>().logout();
      } else {
        await context.read<MedicalRecordprovider>().getprescription();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (widget.scrollcontroller1.hasClients) {
            double minscrollextent =
                widget.scrollcontroller1.position.minScrollExtent;
            double maxscrollextent =
                widget.scrollcontroller1.position.maxScrollExtent;
            animateToMaxmin(maxscrollextent, minscrollextent, maxscrollextent,
                3, widget.scrollcontroller1);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.465,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 188,
                      height: 64,
                      child: Text(
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w600),
                        'Welcome back,\n${context.watch<authprovider>().firstname}',
                      ),
                    ),
                    Image.asset("images/notification.png",
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                  ],
                ),
              ),
              context.watch<MedicalRecordprovider>().loading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 0, 20),
                      child: Container(
                          height: 25,
                          child: ListView(
                            controller: widget.scrollcontroller1,
                            children: [
                              ShimmerWidget.rectangle(width: 100, height: 25)
                            ],
                          )),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                          height: 25,
                          child: ListView(
                              controller: widget.scrollcontroller1,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Text(
                                            "Arthocare Forte: One caplet 2 times /day ",
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))),
                                Gap(10),
                                Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      child: Text(
                                        "Paracetamol: Two tablet 2 times /day ",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ]))),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                child: Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: MediaQuery.of(context).size.height * 0.027),
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color:
                            Color.fromARGB(255, 197, 214, 249).withOpacity(.5)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: MediaQuery.of(context).size.height * 0.018),
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color:
                            Color.fromARGB(255, 197, 214, 249).withOpacity(.5)),
                  ),
                  Stack(
                    children: [
                      Image.asset('images/background.png'),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              width: 107,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                'Upcoming Schedule',
                                style: TextStyle(
                                    fontFamily: 'Noto_Sans',
                                    fontSize: 10,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                            const Gap(20),
                            const Text(
                              'Dr. Barbara Emma',
                              style: TextStyle(
                                  fontFamily: 'Noto_Sans',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            const Text(
                              'General practitioner',
                              style: TextStyle(
                                  fontFamily: 'Noto_Sans',
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            Gap(15),
                            Container(
                              height: 24,
                              width: 107,
                              decoration: BoxDecoration(
                                  color: Color(0xff17306B),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      height: 15,
                                      width: 15,
                                      child:
                                          Image.asset('images/calendar.png')),
                                  Text(
                                    'July 22, 9:00am',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ]),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Quick Action',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuickAction(
                        'images/emergency.png', Color(0xffFFEFEF), 'Emergency'),
                    QuickAction('images/bookappoint.png', Color(0xffE6EEFF),
                        'Book and appointment'),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/Doctor');
                      },
                      child: QuickAction(
                          'images/Doctors.png', Color(0xffF2FBFB), 'Doctors'),
                    )
                  ],
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/MedicineAndPres');
                      },
                      child: QuickAction('images/medandpres.png',
                          Color(0xffFDFCED), 'Medicine & Prescription'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/SymptomsChecker');
                      },
                      child: QuickAction('images/symptoms.png',
                          Color(0xffFFF7EB), 'Symptoms Checker'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/firstAid');
                      },
                      child: QuickAction('images/firstaid.png',
                          Color(0xffFFEFEF), 'First Aid'),
                    )
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/Hospital');
                      },
                      child: QuickAction(
                          'images/hospital.png', Color(0xffFDFCED), 'Hospital'),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    ));
  }

  Column QuickAction(image, color, title) {
    return Column(
      children: [
        Container(
          height: 87,
          width: 108,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Image.asset(
            image,
            scale: 4,
          ),
        ),
        Gap(5),
        SizedBox(
          height: 40,
          width: 90,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }
}
