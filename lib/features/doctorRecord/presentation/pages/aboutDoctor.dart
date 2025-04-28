import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:provider/provider.dart';

import '../provider/doctorprovider.dart';

class AboutDoctor extends ConsumerStatefulWidget {
  const AboutDoctor({super.key});

  @override
  ConsumerState<AboutDoctor> createState() => _AboutDoctorState();
}

class _AboutDoctorState extends ConsumerState<AboutDoctor> {
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    ref.read(doctorprovider).ondispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(padding: EdgeInsets.zero, children: [
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
                      tag: ref.watch(doctorprovider).doctorclicked
                          ? ref
                              .watch(doctorprovider)
                              .clickeddoctorcategory
                              .firstName
                          : ref.read(doctorprovider).mydoctorclicked
                              ? ref
                                  .read(doctorprovider)
                                  .mydoctorlist[0]
                                  .doctor
                                  .firstName
                              : ref
                                  .watch(medicalRecordProvider)
                                  .clickeddoctorcategory
                                  .firstName,
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) {
                          print(progress.progress);
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
                        imageUrl: ref.watch(doctorprovider).doctorclicked
                            ? ref
                                .watch(doctorprovider)
                                .clickeddoctorcategory
                                .docProfilePicture
                            : ref.watch(doctorprovider).mydoctorclicked
                                ? ref
                                        .watch(doctorprovider)
                                        .mydoctorlist[0]
                                        .doctor
                                        .docProfilePicture ??
                                    'https://t4.ftcdn.net/jpg/02/60/04/09/360_F_260040900_oO6YW1sHTnKxby4GcjCvtypUCWjnQRg5.jpg'
                                : ref
                                    .watch(medicalRecordProvider)
                                    .clickeddoctorcategory
                                    .docProfilePicture,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 250),
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
                  child: Column(children: [
                    SizedBox(
                      child: Text(
                        ref.read(doctorprovider).doctorclicked
                            ? '${ref.watch(doctorprovider).clickeddoctorcategory.firstName} ${ref.watch(doctorprovider).clickeddoctorcategory.lastName}'
                            : '${ref.watch(doctorprovider).clickeddoctorcategory.firstName} ${ref.watch(medicalRecordProvider).clickeddoctorcategory.lastName}',
                        style: const TextStyle(
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
                            'images/Doctors.png',
                            color: Color(0xff3772FF),
                          ),
                        ),
                        const Gap(5),
                        Text(
                          ref.watch(doctorprovider).doctorclicked
                              ? ref.watch(doctorprovider).clickdoctordescription
                              : ref.watch(doctorprovider).mydoctorclicked
                                  ? ref
                                      .watch(doctorprovider)
                                      .mydoctorlist[0]
                                      .doctor
                                      .specialization
                                      .name
                                  : 'Psychiatry',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        const Gap(5),
                        SizedBox(
                          height: 12,
                          width: 12,
                          child: Image.asset(
                            'images/MapPin.png',
                            color: Color(0xff3772FF),
                          ),
                        ),
                        const Gap(5),
                        Text(
                          ref.watch(doctorprovider).doctorclicked
                              ? 'Lenox Hill Hospital'
                              : ref.watch(doctorprovider).mydoctorclicked
                                  ? ref
                                      .watch(doctorprovider)
                                      .mydoctorlist[0]
                                      .doctor
                                      .hospital
                                      .city
                                  : ref
                                      .watch(medicalRecordProvider)
                                      .clickeddoctorcategory
                                      .hospital
                                      .name,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ]),
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
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  ref.watch(doctorprovider).doctorclicked
                      ? ref.watch(doctorprovider).clickeddoctorcategory.bio
                      : ref.watch(doctorprovider).mydoctorclicked
                          ? ref.watch(doctorprovider).mydoctorlist[0].doctor.bio
                          : ref
                              .watch(medicalRecordProvider)
                              .clickeddoctorcategory
                              .bio,
                  style: const TextStyle(
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
                      labelText: 'Enter a message to the doctor',
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
                          Navigator.pushNamed(context, '/AppointmentScheduled');
                        },
                        child: InkButton(title: 'Book and appointment'))))
          ]),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
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
                ref.watch(doctorprovider).doctorclicked
                    ? InkWell(
                        onTap: () async {
                          await ref.watch(doctorprovider).addtoFavourite(ref
                              .read(doctorprovider)
                              .clickeddoctorcategory
                              .user
                              .id);
                          SmartDialog.showToast(ref.watch(doctorprovider).msg);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.all(5),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ref.watch(doctorprovider).loadfav
                              ? SvgPicture.asset(
                                  'images/star-favourite.svg',
                                  color: Colors.black.withOpacity(.6),
                                )
                              : ref.watch(doctorprovider).favdoctorid ==
                                      ref
                                          .watch(doctorprovider)
                                          .clickeddoctorcategory
                                          .user
                                          .id
                                  ? SvgPicture.asset(
                                      'images/star-favourite.svg',
                                      color: Colors.amber.withOpacity(.8),
                                    )
                                  : SvgPicture.asset(
                                      'images/favourite.svg',
                                      color: Colors.black.withOpacity(.6),
                                    ),
                        ),
                      )
                    : ref.watch(doctorprovider).mydoctorclicked
                        ? InkWell(
                            onTap: () async {
                              await ref
                                  .read(doctorprovider)
                                  .removefromFavourite(ref
                                      .read(doctorprovider)
                                      .clickeddoctorcategory
                                      .user
                                      .id);
                              SmartDialog.showToast(
                                  ref.watch(doctorprovider).msg);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ref.watch(doctorprovider).loadfav
                                  ? SvgPicture.asset(
                                      'images/star-favourite.svg',
                                      color: Colors.black.withOpacity(.6),
                                    )
                                  : ref.watch(doctorprovider).favdoctorid ==
                                          ref
                                              .watch(doctorprovider)
                                              .mydoctorlist[0]
                                              .doctor
                                              .user
                                              .id
                                      ? SvgPicture.asset(
                                          'images/star-favourite.svg',
                                          color: Colors.amber.withOpacity(.8),
                                        )
                                      : SvgPicture.asset(
                                          'images/favourite.svg',
                                          color: Colors.black.withOpacity(.6),
                                        ),
                            ),
                          )
                        : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
