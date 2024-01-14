import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/features/myAppointment/presentation/provider/mydashprovider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../constant/customesnackbar.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool updatechange = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'NG',
      newMask: '+000 000 000 0000',
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _firstname =
        TextEditingController(text: context.watch<authprovider>().firstname);
    TextEditingController lastname =
        TextEditingController(text: context.watch<authprovider>().lastname);
    TextEditingController phone =
        TextEditingController(text: context.watch<authprovider>().phone);
    TextEditingController email =
        TextEditingController(text: context.watch<authprovider>().email);
    TextEditingController address =
        TextEditingController(text: context.watch<authprovider>().address);
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
          actions: [
            updatechange
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            updatechange = true;
                          });
                        },
                        child: Icon(Icons.edit_outlined)),
                  )
          ],
          title: const Text(
            'Personal Info',
            style: TextStyle(fontSize: 19),
          )),
      body: ListView(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: context.watch<mydashprovider>().image != null
                          ? Image.file(
                              context.watch<mydashprovider>().image!,
                              height: 140,
                              width: 140,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  context.watch<authprovider>().profilepic,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                    )),
                updatechange
                    ? InkWell(
                        onTap: () {
                          context.read<mydashprovider>().pickimageupdate();
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 70),
                          margin: EdgeInsets.only(top: 90),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              'images/camera.png',
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          Gap(20),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffF3F7FF)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('First name'),
              Gap(5),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: _firstname,
                  cursorHeight: 20,
                  readOnly: !updatechange,
                  decoration: InputDecoration(
                    fillColor: updatechange ? Colors.white : Color(0xffEAECF0),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 126, 67, 40))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                  ),
                ),
              ),
              Gap(10),
              Text('Last name'),
              Gap(5),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: lastname,
                  cursorHeight: 20,
                  readOnly: !updatechange,
                  decoration: InputDecoration(
                    fillColor: updatechange ? Colors.white : Color(0xffEAECF0),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 126, 67, 40))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                  ),
                ),
              ),
              Gap(10),
              Text('Phone number'),
              Gap(5),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: phone,
                  inputFormatters: [PhoneInputFormatter()],
                  cursorHeight: 20,
                  readOnly: !updatechange,
                  decoration: InputDecoration(
                    fillColor: updatechange ? Colors.white : Color(0xffEAECF0),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 126, 67, 40))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                  ),
                ),
              ),
              Text('Address'),
              Gap(5),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: address,
                  cursorHeight: 20,
                  readOnly: !updatechange,
                  decoration: InputDecoration(
                    fillColor: updatechange ? Colors.white : Color(0xffEAECF0),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 126, 67, 40))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                  ),
                ),
              ),
              Gap(10),
              Text('Email'),
              Gap(5),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: email,
                  cursorHeight: 20,
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Color(0xffEAECF0),
                    filled: true,
                    contentPadding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 126, 67, 40))),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(width: 0, color: Color(0xffEAECF0)),
                    ),
                  ),
                ),
              )
            ]),
          ),
          Gap(50),
          updatechange
              ? Consumer<mydashprovider>(builder: (context, value, child) {
                  return SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                            onTap: () async {
                              if (value.loading == true) {
                                return;
                              }
                              SmartDialog.showLoading();
                              await value.editprofile(
                                  _firstname.text,
                                  lastname.text,
                                  phone.text,
                                  email.text,
                                  address.text);
                              if (value.error == true) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                await context.read<authprovider>().getinfo();
                                SmartDialog.dismiss();
                                Navigator.pop(context);
                              }
                            },
                            child: InkButton(title: 'Update Changes')),
                      ));
                })
              : SizedBox()
        ],
      ),
    );
  }
}
