import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/presentation/pages/index.dart';
import 'package:provider/provider.dart';

import '../../../../constant/Inkbutton.dart';
import '../../../../constant/customesnackbar.dart';
import '../provider/auth_provider.dart';

class setuphealth extends StatefulWidget {
  const setuphealth({super.key});

  @override
  State<setuphealth> createState() => _setuphealthState();
}

class _setuphealthState extends State<setuphealth> {
  final formKey = GlobalKey<FormState>();
  String? selectedsexOption;

  List<String> sexoptions = [
    'male',
    'female',
    'prefer not to say',
  ];
  String? selectedbloodOption;
  List<String> bloodoptions = [
    'AA',
    'AS',
    'SS',
  ];
  TextEditingController genderControler = TextEditingController();
  TextEditingController bloodtypecon = TextEditingController();
  TextEditingController allergycontoller = TextEditingController();
  TextEditingController chronicContoller = TextEditingController();
  void SetupHealth(authprovider value) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (value.loading == true) {
      return;
    }
    SmartDialog.showLoading();
    await context.read<authprovider>().setupHealthIssue(genderControler.text,
        bloodtypecon.text, allergycontoller.text, chronicContoller.text);
    if (value.error == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: value.message,
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Great!',
          msg: value.message,
          color1: Color.fromARGB(255, 25, 107, 52),
          color2: Color.fromARGB(255, 19, 95, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => const indexpage()),
        (Route<dynamic> route) => false,
      );
    }
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              Gap(20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('images/chevron-left.png')),
                ),
              ),
              const Gap(10),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Text("Setup Health Issue",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 23))),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Text(
                      "Make sure your name and date of birth matches your medical information",
                      textAlign: TextAlign.start)),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sex'),
                            const Gap(5),
                            PopupMenuButton<String>(
                              color: Colors.white,
                              onSelected: (value) {
                                setState(() {
                                  selectedsexOption = value;
                                  genderControler.text = value;
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return sexoptions.map((String option) {
                                  return PopupMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList();
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: genderControler,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    suffixIcon: Image.asset(
                                      'images/chevron-down.png',
                                      scale: 4,
                                    ),
                                    hintText: " Select your gender",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Select your gender";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Blood Type'),
                            const Gap(5),
                            PopupMenuButton<String>(
                                color: Colors.white,
                                onSelected: (value) {
                                  setState(() {
                                    bloodtypecon.text = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return bloodoptions.map((String option) {
                                    return PopupMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList();
                                },
                                child: IgnorePointer(
                                  child: TextFormField(
                                    controller: bloodtypecon,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      suffixIcon: Image.asset(
                                        'images/chevron-down.png',
                                        scale: 4,
                                      ),
                                      hintText: "Select Blood Type",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xffEAECF0))),
                                    ),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return "Blood Type can't be empty";
                                      }
                                    },
                                  ),
                                ))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Allergies'),
                            const Gap(5),
                            TextFormField(
                              controller: allergycontoller,
                              onChanged: (value) {
                                allergycontoller.text = value;
                              },
                              decoration: InputDecoration(
                                hintText: "E.g Food Allergy.",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEAECF0))),
                              ),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Allergies can't be empty";
                                }
                              },
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chronic Condition'),
                            Gap(5),
                            TextFormField(
                              controller: chronicContoller,
                              onChanged: (value) {
                                chronicContoller.text = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Optional",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: Color(0xffEAECF0))),
                              ),
                            ),
                          ],
                        )),
                    Gap(70),
                    Consumer<authprovider>(builder: (context, value, child) {
                      return InkWell(
                          onTap: () {
                            SetupHealth(value);
                            // Navigator.pushNamed(context, '/indexpage');
                          },
                          child: InkButton(title: 'Continue'));
                    })
                  ],
                ),
              )
            ],
          )),
    );
  }
}
