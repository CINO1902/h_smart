import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../constant/Inkbutton.dart';
import '../provider/getHospitalProvider.dart';

class viewhospitaldetail extends ConsumerStatefulWidget {
  final Hospital hospital;
  const viewhospitaldetail({super.key, required this.hospital});

  @override
  ConsumerState<viewhospitaldetail> createState() => _viewhospitaldetailState();
}

class _viewhospitaldetailState extends ConsumerState<viewhospitaldetail> {
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
                    height: 400,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Hero(
                        tag: widget.hospital.id ?? '',
                        child: widget.hospital.hospitalsCoverImage != null &&
                                widget.hospital.hospitalsCoverImage!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.hospital.hospitalsCoverImage!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                ),
                              )
                            : Image.asset(
                                'images/hospital1.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 270),
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
                            const SizedBox(
                              width: 235,
                              child: Text(
                                '',
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
                                    color: const Color(0xff3772FF),
                                  ),
                                ),
                                const Gap(5),
                                const Text(
                                  '',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Gap(5),
                                SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: Image.asset(
                                    'images/Clock.png',
                                    color: const Color(0xff3772FF),
                                  ),
                                ),
                                const Gap(5),
                                const Text(
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
              const Gap(30),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              const Gap(10),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff706F6F)),
                  )),
              const Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Working Time',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              const Gap(10),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Monday - Friday (08:30am - 5:00pm)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff706F6F)),
                  )),
              const Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Available Sessions',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(5),
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
                        border: Border.all(color: const Color(0xffC1D3FF)),
                        color: const Color(0xffF3F7FF)),
                    child: const Align(
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
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
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
              const Gap(20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Appointment Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  )),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              const Gap(30),
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
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(5),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 237, 237, 237)),
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
