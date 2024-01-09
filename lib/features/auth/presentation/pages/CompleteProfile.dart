import 'dart:io';

import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/constant/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constant/customesnackbar.dart';
import '../../../medical_record/presentation/pages/HomePage.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePage();
}

class _CompleteProfilePage extends State<CompleteProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'NG',
      newMask: '+000 000 000 0000',
    );
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool chosendate = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      Utils.showSheet(
        context,
        child: SizedBox(
          height: 210,
          child: CupertinoDatePicker(
            minimumYear: 1950,
            maximumYear: DateTime.now().year,
            initialDateTime: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.dateTime = dateTime),
          ),
        ),
        onClicked: () {
          final value = DateFormat('yyyy-MM-dd').format(dateTime);
          // Utils.showSnackBar(context, 'Selected "$value"');
          dobController.text = value;
          setState(() {
            chosendate = true;
          });
          Navigator.pop(context);
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != dateTime) {
        setState(() {
          dateTime = picked;
        });
        setState(() {
          chosendate = true;
        });
      }

      dobController.value =
          TextEditingValue(text: (dateTime!.toString().split(' ')[0]));
    }
  }

  void _continue(authprovider value) async {
    if (value.loading == true) {
      return;
    }
    if (!formKey.currentState!.validate()) {
      print(dobController.text);
      return;
    }
    if (chosendate == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Date of birth can\'t be null',
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      return;
    }
    if (context.read<authprovider>().image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Please Insert a picture',
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      return;
    }
    SmartDialog.showLoading();
    await context.read<authprovider>().continueRegistration(
        firstNameController.text,
        lastNameController.text,
        phoneNumberController.text,
        DateTime.parse(dobController.text),
        homeAddressController.text);
    if (value.error == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomeSnackbar(
            topic: 'Error',
            color1: Color.fromARGB(255, 171, 51, 42),
            color2: Color.fromARGB(255, 127, 39, 33),
            msg: value.message,
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomeSnackbar(
            topic: 'Registration Successful',
            color1: Color.fromARGB(255, 25, 107, 52),
            color2: Color.fromARGB(255, 19, 95, 40),
            msg: value.message,
          )));
      Navigator.pushNamed(context, '/setuphealth');
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePage(s),
      //     ));
    }
    SmartDialog.dismiss();
  }

  bool isPrivacyPolicyChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('images/chevron-left.png')),
                  ),
                ),
              ),
              ListView(
                children: [
                  Gap(20),
                  const Gap(10),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text("Complete Your Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                          "Make sure your name and date of birth matches your medical information",
                          textAlign: TextAlign.start)),
                  Center(
                    child: InkWell(
                      onTap: () {
                        context.read<authprovider>().pickimage();
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: context.watch<authprovider>().image != null
                                ? EdgeInsets.all(5)
                                : EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 20),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xffEDEDED),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: context.watch<authprovider>().image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      context.watch<authprovider>().image!,
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'images/User.png',
                                    color: Colors.grey,
                                  ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 70),
                            margin: EdgeInsets.only(top: 90),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'images/camera.png',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                                const Text('First name'),
                                const Gap(5),
                                TextFormField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your first name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "First name can't be empty";
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
                                Text('Last name'),
                                const Gap(5),
                                TextFormField(
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your last name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Last name can't be empty";
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
                                Text('Date of birth'),
                                const Gap(5),
                                TextFormField(
                                  readOnly: true,
                                  onTap: () => {_selectDate(context)},
                                  controller: dobController,
                                  decoration: InputDecoration(
                                    hintText: "DD-MM-YYYY",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "First name can't be empty";
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
                                Text('Phone number'),
                                Gap(5),
                                TextFormField(
                                  controller: phoneNumberController,
                                  inputFormatters: [PhoneInputFormatter()],
                                  decoration: InputDecoration(
                                    hintText: "+234",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Phone Number can't be empty";
                                    }
                                    if (value!.trim().length < 11) {
                                      return "incomplete phone number";
                                    }

                                    return null;
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
                                Text('Address'),
                                const Gap(5),
                                TextFormField(
                                  controller: homeAddressController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your home address",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                            color: Color(0xffEAECF0))),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Address can't be empty";
                                    }
                                  },
                                ),
                              ],
                            )),
                        Gap(50)
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child:
                      Consumer<authprovider>(builder: (context, value, child) {
                    return InkWell(
                        onTap: () {
                          _continue(value);
                          // Navigator.pushNamed(context, '/setuphealth');
                        },
                        child: InkButton(title: 'Continue'));
                  }),
                ),
              )
            ],
          )),
    );
  }
}
