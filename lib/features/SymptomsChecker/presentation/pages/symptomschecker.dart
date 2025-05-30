import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/SymptomsChecker/presentation/pages/symptomsdesc.dart';

import '../../../../core/utils/appColor.dart';

class SymptomsChecker extends StatefulWidget {
  const SymptomsChecker({super.key});

  @override
  State<SymptomsChecker> createState() => _SymptomsCheckerState();
}

class _SymptomsCheckerState extends State<SymptomsChecker>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this)
    ..addListener(() {
      setState(() {});
    });

  List<String> Adult = [
    'Abdominal pain',
    'Chest pain',
    'Sore throat',
    'Blood in Urine or Stool',
    'Dizziness',
    'Chest Tightness',
    'Vision Changes',
    'Mood Changes',
    'Memory Problems',
    'Difficulty Sleeping',
    'Nausea',
    'Back Pain',
    'Joint Pain'
  ];

  List Child = [
    'Fever',
    'Coughing or Sneezing',
    'Vomiting',
    'Diarrhea',
    'Dizziness',
    'Fussiness or Crying',
    'Congestion',
    'Rash',
    'Sleep Disturbances',
    'Poor Feeding',
    'Earache',
    'Behavioral Changes',
    'Eating Issues',
    'Joint Pain'
  ];

  List suggestAdult = [];
  List suggestchild = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      suggestAdult = Adult;
      suggestchild = Child;
    });
  }

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
            'Symptoms Checker',
            style: TextStyle(fontSize: 16),
          )),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 50,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffF3F7FF),
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
                              : Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Adult",
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
                              : Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Children",
                            style: controller.index == 1
                                ? TextStyle(color: AppColors.kprimaryColor500)
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(controller: controller, children: [
                Column(
                  children: [
                    const Gap(20),
                    SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.grey,
                          hintText: 'Search',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 192, 192, 192),
                                  width: 2)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 226, 226, 226))),
                        ),
                        onChanged: (value) {
                          searchbook(value);
                        },
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: suggestAdult.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SymptomsDesc(
                                        title: suggestAdult[index]),
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(.3)))),
                              height: 44,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    suggestAdult[index],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          Image.asset('images/iconright.png'))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Gap(20),
                    SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.grey,
                          hintText: 'Search',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onChanged: (value) {
                          searchchild(value);
                        },
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: suggestchild.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(.3)))),
                            height: 44,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  suggestchild[index],
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset('images/iconright.png'))
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  void searchbook(String query) {
    final suggestion = Adult.where((element) {
      final symptoms = element.toLowerCase();
      final input = query.toLowerCase();

      return symptoms.contains(input);
    }).toList();
    setState(() {
      suggestAdult = suggestion;
    });
  }

  void searchchild(String query) {
    final suggestion = Child.where((element) {
      final symptoms = element.toLowerCase();
      final input = query.toLowerCase();

      return symptoms.contains(input);
    }).toList();
    setState(() {
      suggestchild = suggestion;
    });
  }
}
