import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:provider/provider.dart';

import '../../../../constant/Inkbutton.dart';

class viewhospitaldetail extends StatefulWidget {
  const viewhospitaldetail({super.key});

  @override
  State<viewhospitaldetail> createState() => _viewhospitaldetailState();
}

class _viewhospitaldetailState extends State<viewhospitaldetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Hero(
                        tag: context.watch<GetHospitalProvider>().imagetag1,
                        child: Image.asset(
                          'images/hospital1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 170),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.white.withOpacity(.1),
                          Colors.white.withOpacity(.8)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 235,
                              child: Text(
                                context
                                    .watch<GetHospitalProvider>()
                                    .clickedHospital[2],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: Image.asset(
                                    'images/MapPin.png',
                                    color: Color(0xff3772FF),
                                  ),
                                ),
                                Gap(5),
                                Text(
                                  context
                                      .watch<GetHospitalProvider>()
                                      .clickedHospital[3],
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                                Gap(5),
                                SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: Image.asset(
                                    'images/Clock.png',
                                    color: Color(0xff3772FF),
                                  ),
                                ),
                                Gap(5),
                                Text(
                                  '10am-3pm',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ]),
                    ),
                  )
                ],
              ),
              Gap(30),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              Gap(10),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff706F6F)),
                  )),
              Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Working Time',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              Gap(10),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Monday - Friday (08:30am - 5:00pm)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff706F6F)),
                  )),
              Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Available Sessions',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.all(5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      'images/chevron-left.png',
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xffC1D3FF)),
                        color: Color(0xffF3F7FF)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '22 June 2023, 10:00am',
                        style: TextStyle(
                            color: Color(0xff3772FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      'images/iconright.png',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Appointment Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              Gap(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(7)),
                  child: TextFormField(
                    //controller: keystonecontroller,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        labelText: 'Enter a message to the Hospital',
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        fillColor: Colors.black54,
                        focusColor: Colors.black54),
                  ),
                ),
              ),
              Gap(30),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 44,
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/AppointmentScheduled');
                          },
                          child: InkButton(title: 'Book and appointment')))),
            ],
          ),
          SafeArea(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.all(5),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 237, 237, 237)),
                child: Image.asset(
                  'images/chevron-left.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
