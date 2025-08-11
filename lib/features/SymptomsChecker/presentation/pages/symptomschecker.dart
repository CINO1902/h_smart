import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/appColor.dart';
import 'symptomsdesc.dart';

class SymptomsChecker extends StatefulWidget {
  const SymptomsChecker({super.key});

  @override
  State<SymptomsChecker> createState() => _SymptomsCheckerState();
}

class _SymptomsCheckerState extends State<SymptomsChecker>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this);
  late final TextEditingController searchController;

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

  List<String> Child = [
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

  List<String> suggestAdult = [];
  List<String> suggestchild = [];

  @override
  void initState() {
    super.initState();
    suggestAdult = Adult;
    suggestchild = Child;
    searchController = TextEditingController();

    controller.addListener(() {
      if (controller.indexIsChanging ||
          controller.index != controller.previousIndex) {
        searchController.clear();
        setState(() {
          suggestAdult = Adult;
          suggestchild = Child;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0.1,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins'),
        title: const Text(
          'Symptoms Checker',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .7,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffF3F7FF),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / 2;
                return Stack(
                  children: [
                    AnimatedBuilder(
                      animation: controller.animation!,
                      builder: (context, _) {
                        final animationValue = controller.animation!.value;
                        return Transform.translate(
                          offset: Offset(animationValue * tabWidth, 0),
                          child: Container(
                            width: tabWidth,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.kprimaryColor500,
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.animateTo(0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 42,
                              child: AnimatedBuilder(
                                animation: controller.animation!,
                                builder: (context, _) {
                                  final value = controller.animation!.value;
                                  return Text(
                                    "Adult",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: value < 0.5
                                          ? Colors.white
                                          : Colors.black.withOpacity(.7),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.animateTo(1),
                            child: Container(
                              alignment: Alignment.center,
                              height: 42,
                              child: AnimatedBuilder(
                                animation: controller.animation!,
                                builder: (context, _) {
                                  final value = controller.animation!.value;
                                  return Text(
                                    "Children",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: value > 0.5
                                          ? Colors.white
                                          : Colors.black.withOpacity(.7),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(controller: controller, children: [
                buildSymptomsTab(suggestAdult, true),
                buildSymptomsTab(suggestchild, false),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSymptomsTab(List<String> list, bool isAdult) {
    return Column(
      children: [
        const Gap(20),
        SizedBox(
          height: 44,
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10),
              prefixIcon: Icon(Icons.search),
              prefixIconColor: Colors.grey,
              hintText: 'Search',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 192, 192, 192), width: 2)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 226, 226, 226))),
            ),
            onChanged: (value) {
              if (isAdult) {
                searchbook(value);
              } else {
                searchchild(value);
              }
            },
          ),
        ),
        const Gap(20),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (isAdult) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SymptomsDesc(title: list[index]),
                        ));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(.3)))),
                  height: 44,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list[index],
                        style: const TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset('images/iconright.png'))
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
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
