import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:provider/provider.dart';

class AboutDoctor extends StatefulWidget {
  const AboutDoctor({super.key});

  @override
  State<AboutDoctor> createState() => _AboutDoctorState();
}

class _AboutDoctorState extends State<AboutDoctor> {
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<doctorprpvider>().ondispose();
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
                      tag: context.watch<doctorprpvider>().doctorclicked
                          ? context
                              .watch<doctorprpvider>()
                              .clickeddoctorcategory
                              .firstName
                          : context.watch<doctorprpvider>().mydoctorclicked
                              ? context
                                  .watch<doctorprpvider>()
                                  .mydoctorlist[0]
                                  .doctor
                                  .firstName
                              : context
                                  .watch<MedicalRecordprovider>()
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
                        imageUrl: context.watch<doctorprpvider>().doctorclicked
                            ? context
                                .watch<doctorprpvider>()
                                .clickeddoctorcategory
                                .docProfilePicture
                            : context.watch<doctorprpvider>().mydoctorclicked
                                ? context
                                    .watch<doctorprpvider>()
                                    .mydoctorlist[0]
                                    .doctor
                                    .docProfilePicture
                                : context
                                    .watch<MedicalRecordprovider>()
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
                        context.watch<doctorprpvider>().doctorclicked
                            ? '${context.watch<doctorprpvider>().clickeddoctorcategory.firstName} ${context.watch<doctorprpvider>().clickeddoctorcategory.lastName}'
                            : '${context.watch<MedicalRecordprovider>().clickeddoctorcategory.firstName} ${context.watch<MedicalRecordprovider>().clickeddoctorcategory.lastName}',
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
                        Gap(5),
                        Text(
                          context.watch<doctorprpvider>().doctorclicked
                              ? context
                                  .watch<doctorprpvider>()
                                  .clickdoctordescription
                              : context.watch<doctorprpvider>().mydoctorclicked
                                  ? context
                                      .watch<doctorprpvider>()
                                      .mydoctorlist[0]
                                      .doctor
                                      .specialization
                                      .name
                                  : 'Psychiatry',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        Gap(5),
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
                          context.watch<doctorprpvider>().doctorclicked
                              ? 'Lenox Hill Hospital'
                              : context.watch<doctorprpvider>().mydoctorclicked
                                  ? context
                                      .watch<doctorprpvider>()
                                      .mydoctorlist[0]
                                      .doctor
                                      .hospital
                                      .city
                                  : context
                                      .watch<MedicalRecordprovider>()
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
                  context.watch<doctorprpvider>().doctorclicked
                      ? context
                          .watch<doctorprpvider>()
                          .clickeddoctorcategory
                          .bio
                      : context.watch<doctorprpvider>().mydoctorclicked
                          ? context
                              .watch<doctorprpvider>()
                              .mydoctorlist[0]
                              .doctor
                              .bio
                          : context
                              .watch<MedicalRecordprovider>()
                              .clickeddoctorcategory
                              .bio,
                  style: const TextStyle(
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
                context.watch<doctorprpvider>().doctorclicked
                    ? InkWell(
                        onTap: () async {
                          await context.read<doctorprpvider>().addtoFavourite(
                              Provider.of<doctorprpvider>(context,
                                      listen: false)
                                  .clickeddoctorcategory
                                  .user
                                  .id);
                          SmartDialog.showToast(Provider.of<doctorprpvider>(
                                  context,
                                  listen: false)
                              .msg);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.all(5),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: context.watch<doctorprpvider>().loadfav
                              ? SvgPicture.asset(
                                  'images/star-favourite.svg',
                                  color: Colors.black.withOpacity(.6),
                                )
                              : context.watch<doctorprpvider>().favdoctorid ==
                                      context
                                          .watch<doctorprpvider>()
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
                    : context.watch<doctorprpvider>().mydoctorclicked
                        ? InkWell(
                            onTap: () async {
                              await context
                                  .read<doctorprpvider>()
                                  .removefromFavourite(
                                      Provider.of<doctorprpvider>(context,
                                              listen: false)
                                          .clickeddoctorcategory
                                          .user
                                          .id);
                              SmartDialog.showToast(Provider.of<doctorprpvider>(
                                      context,
                                      listen: false)
                                  .msg);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: context.watch<doctorprpvider>().loadfav
                                  ? SvgPicture.asset(
                                      'images/star-favourite.svg',
                                      color: Colors.black.withOpacity(.6),
                                    )
                                  : context
                                              .watch<doctorprpvider>()
                                              .favdoctorid ==
                                          context
                                              .watch<doctorprpvider>()
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
