import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/SpecialisedDoctor.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/listdoctors.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<doctorprpvider>().calldoctorcatergory();
    context.read<doctorprpvider>().callmydoctor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Doctors',
            style: TextStyle(fontSize: 21),
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              SizedBox(
                height: 44,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10),
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                    hintText: 'Search',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 192, 192, 192),
                            width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 226, 226, 226))),
                  ),
                  onChanged: (value) {
                    context.read<doctorprpvider>().searchbook(value);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 44),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        context.watch<doctorprpvider>().favdoctorid != ''
                            ? context.watch<doctorprpvider>().mydocloading
                                ? Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 30,
                                        color: Colors.white,
                                        child: const Text(
                                          'My Doctor',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      ShimmerWidget.rectangle(
                                          width: double.infinity, height: 75),
                                    ],
                                  )
                                : StickyHeader(
                                    header: Container(
                                      width: double.infinity,
                                      height: 30,
                                      color: Colors.white,
                                      child: const Text(
                                        'My Doctor',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    content: InkWell(
                                      onTap: () {
                                        context
                                            .read<doctorprpvider>()
                                            .actionmydoctorclicked();
                                        Navigator.pushNamed(
                                            context, '/aboutDoctor');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        height: 76,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color:
                                                    const Color(0xffEBF1FF))),
                                        child: Row(children: [
                                          SizedBox(
                                            height: 56,
                                            width: 56,
                                            child: Hero(
                                                tag: 'doctorimage',
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                            progress) {
                                                      return Center(
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            value: progress
                                                                .progress,
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    imageUrl: context
                                                        .watch<doctorprpvider>()
                                                        .mydoctorlist[0]
                                                        .doctor
                                                        .docProfilePicture,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          const Gap(20),
                                          SizedBox(
                                            height: 37,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .63,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 170,
                                                        child: Text(
                                                          'Dr ${context.watch<doctorprpvider>().mydoctorlist[0].doctor.specialization.doctors[0].firstName} ${context.watch<doctorprpvider>().mydoctorlist[0].doctor.specialization.doctors[0].lastName}',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                    SizedBox(
                                                        width: 170,
                                                        child: Text(
                                                          context
                                                              .watch<
                                                                  doctorprpvider>()
                                                              .mydoctorlist[0]
                                                              .doctor
                                                              .specialization
                                                              .name,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'images/Clock.png',
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      const Gap(5),
                                                      const Text(
                                                        '10am - 3pm',
                                                        style: TextStyle(
                                                            fontSize: 9),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  )
                            : SizedBox(),
                        const Gap(15),

                        // const Gap(30),
                        // const Text(
                        //   'Available doctors for appointment',
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        // ),
                      ],
                    ),
                    //  Gap(20),
                    // SizedBox(
                    //   height: 320,
                    //   child: GridView.builder(
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2,
                    //         childAspectRatio: 6 / 5,
                    //         crossAxisSpacing: 20,
                    //         mainAxisSpacing: 20),
                    //     itemCount: 4,
                    //     itemBuilder: (context, index) {
                    //       return Container(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 8, vertical: 10),
                    //         height: 142,
                    //         width: 164,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(16),
                    //             border: Border.all(color: const Color(0xffEBF1FF))),
                    //         child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   const SizedBox(
                    //                     width: 34,
                    //                   ),
                    //                   const Align(
                    //                     alignment: Alignment.center,
                    //                     child: SizedBox(
                    //                       height: 56,
                    //                       width: 56,
                    //                       child: CircleAvatar(
                    //                           backgroundImage: AssetImage(
                    //                         'images/doctorimage.png',
                    //                       )),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     height: 17,
                    //                     width: 34,
                    //                     decoration: BoxDecoration(
                    //                         borderRadius: BorderRadius.circular(8),
                    //                         color: const Color(0xffFFF7EB)),
                    //                     child: const Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.star,
                    //                           size: 10,
                    //                           color: Color(0xffFFAC32),
                    //                         ),
                    //                         Text(
                    //                           '5.0',
                    //                           style: TextStyle(
                    //                               fontSize: 9,
                    //                               color: Color(0xffFFAC32)),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               const SizedBox(
                    //                 width: 115,
                    //                 child: Text(
                    //                   'Dr. Arlene McCoy',
                    //                   style: TextStyle(
                    //                       fontSize: 13, fontWeight: FontWeight.w600),
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 width: 115,
                    //                 child: Text(
                    //                   'General Practitioner',
                    //                   style: TextStyle(
                    //                       fontSize: 11, fontWeight: FontWeight.w400),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Image.asset(
                    //                     'images/Clock.png',
                    //                     height: 10,
                    //                     width: 10,
                    //                   ),
                    //                   const Gap(5),
                    //                   const Text(
                    //                     '10am - 3pm',
                    //                     style: TextStyle(fontSize: 9),
                    //                   )
                    //                 ],
                    //               ),
                    //             ]),
                    //       );
                    //     },
                    //   ),
                    // ),

                    Consumer<doctorprpvider>(builder: (context, value, child) {
                      if (value.loading == true) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      } else if (value.error == true) {
                        return Center(
                          child: Column(
                            children: [
                              const Text('Something Went Wrong'),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<doctorprpvider>()
                                      .calldoctorcatergory();
                                  context.read<doctorprpvider>().callmydoctor();
                                },
                                child: Container(
                                  width: 110,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Theme.of(context).primaryColor),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: const Center(
                                    child: Text("Try Again",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (value.doctorcategory.isEmpty) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 30,
                              color: Colors.white,
                              child: const Text(
                                'Categories',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .5,
                              child: Center(
                                child:
                                    Text('Doctor category could not be found'),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return StickyHeader(
                          header: Container(
                            width: double.infinity,
                            height: 30,
                            color: Colors.white,
                            child: const Text(
                              'Categories',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          content: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.doctorcategory.length,
                            itemBuilder: (context, index) {
                              return categories(
                                  value.doctorcategory[index].name,
                                  value.doctorcategory[index].description,
                                  index);
                            },
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell categories(title, String desc, index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListDoctors(
                      appbartitle: title,
                      index: index,
                    )));
      },
      child: Container(
        height: 68,
        margin: EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffEBF1FF)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 300,
                  child: Text(
                    desc,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('images/iconright.png'))
          ],
        ),
      ),
    );
  }
}
