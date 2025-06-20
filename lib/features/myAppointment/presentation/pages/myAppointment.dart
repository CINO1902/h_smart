import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColor.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this)
    ..addListener(() {
      setState(() {});
    });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: null,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'My Appointments',
              style: TextStyle(fontSize: 20),
            ),
          )),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF3F7FF),
              ),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.animateTo(0);
                      },
                      child: Container(
                        height: 38,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.index == 0
                              ? AppColors.kprimaryColor500
                              : const Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Upcoming",
                            style: controller.index == 0
                                ? TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.9))
                                : TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.7)),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.animateTo(1);
                      },
                      child: Container(
                        height: 38,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: controller.index == 1
                              ? BorderRadius.circular(10)
                              : BorderRadius.zero,
                          color: controller.index == 1
                              ? AppColors.kprimaryColor500
                              : const Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Past",
                            style: controller.index == 1
                                ? const TextStyle(color: AppColors.kprimaryColor500)
                                : TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.7)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(controller: controller, children: [
                ListView(
                  children: [
                    const Gap(20),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffEBF1FF)),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                  'images/doctorimage.png',
                                )),
                              ),
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Dr. Alis William',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/Clock.png',
                                        height: 10,
                                        width: 10,
                                      ),
                                      const Gap(5),
                                      const Text(
                                        '12th, July 2023',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Text(
                            'Upcoming',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xffFFAC32)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    const Gap(20),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffEBF1FF)),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                  'images/doctorimage.png',
                                )),
                              ),
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Dr. Alis William',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/Clock.png',
                                        height: 10,
                                        width: 10,
                                      ),
                                      const Gap(5),
                                      const Text(
                                        '12th, July 2023',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Text(
                            'Completed',
                            style: TextStyle(fontSize: 11, color: Colors.green),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffEBF1FF)),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                  'images/doctorimage.png',
                                )),
                              ),
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Dr. Alis William',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/Clock.png',
                                        height: 10,
                                        width: 10,
                                      ),
                                      const Gap(5),
                                      const Text(
                                        '12th, July 2023',
                                        style: TextStyle(fontSize: 9),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Text(
                            'Cancelled',
                            style: TextStyle(fontSize: 11, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
