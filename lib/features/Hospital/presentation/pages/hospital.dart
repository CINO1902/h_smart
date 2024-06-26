import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/Hospital/domain/entities/hospitalmodel.dart';

import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class Hospital extends StatefulWidget {
  const Hospital({super.key});

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  List HospitalName = [
    'Lagos University Teaching Hospital (LUTH)',
    'Ikorodu General Hospital',
    'General Hospital Odan',
    'Gbagada General Hospital.'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetHospitalProvider>().getHospital();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Hospitals',
            style: TextStyle(fontSize: 17),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 44,
              child: TextField(
                  decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.grey,
                hintText: 'Search',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: Colors.grey, width: 2)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: Colors.grey)),
              )),
            ),
            const Gap(30),
            // const Text(
            //   'My Hospital',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            // ),
            // const Gap(15),
            // InkWell(
            //   onTap: () {
            //     Navigator.pushNamed(context, '/viewhospitaldetail');
            //   },
            //   child: Container(
            //     height: 158,
            //     child: Stack(
            //       children: [
            //         Align(
            //           alignment: Alignment.bottomCenter,
            //           child: Container(
            //             margin: EdgeInsets.symmetric(horizontal: 1),
            //             padding:
            //                 EdgeInsets.only(left: 10, bottom: 10, right: 10),
            //             height: 100.0,
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(color: Colors.blue),
            //                 borderRadius: BorderRadius.circular(16)),
            //             child: Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   crossAxisAlignment: CrossAxisAlignment.end,
            //                   children: [
            //                     SizedBox(
            //                       width: MediaQuery.of(context).size.width * .5,
            //                       child: const Text(
            //                         'Lagos University Teaching Hospital (LUTH)',
            //                         style: TextStyle(
            //                             color: Colors.black,
            //                             fontSize: 13,
            //                             fontWeight: FontWeight.w700),
            //                       ),
            //                     ),
            //                     Column(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: [
            //                           Row(
            //                             children: [
            //                               SizedBox(
            //                                 height: 15,
            //                                 width: 15,
            //                                 child: Image.asset(
            //                                     'images/MapPin.png'),
            //                               ),
            //                               Gap(5),
            //                               SizedBox(
            //                                 width: MediaQuery.of(context)
            //                                         .size
            //                                         .width *
            //                                     .2,
            //                                 child: const Text(
            //                                   'Idi-Araba',
            //                                   style: TextStyle(
            //                                       fontSize: 13,
            //                                       fontWeight: FontWeight.w400),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               SizedBox(
            //                                 height: 15,
            //                                 width: 15,
            //                                 child:
            //                                     Image.asset('images/Clock.png'),
            //                               ),
            //                               Gap(5),
            //                               SizedBox(
            //                                 width: MediaQuery.of(context)
            //                                         .size
            //                                         .width *
            //                                     .2,
            //                                 child: const Text(
            //                                   '10am-3pm',
            //                                   style: TextStyle(
            //                                       fontSize: 13,
            //                                       fontWeight: FontWeight.w400),
            //                                 ),
            //                               )
            //                             ],
            //                           )
            //                         ])
            //                   ]),
            //             ),
            //           ),
            //         ),
            //         Align(
            //           alignment: Alignment.topCenter,
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(16),
            //                 topRight: Radius.circular(16)),
            //             child: SizedBox(
            //               height: 100,
            //               width: double.infinity,
            //               child: Hero(
            //                 tag: 'hospitalheadimage',
            //                 child: Image.asset(
            //                   'images/hospital1.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Government Hospitals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      context.read<GetHospitalProvider>().disablehero();
                      Navigator.pushNamed(context, '/governmenthospital');
                    },
                    child: const Text('See All'))
              ],
            ),
            Gap(20),
            SizedBox(
              height: 330,
              child: Consumer<GetHospitalProvider>(
                  builder: (context, value, child) {
                print(value.loading);
                if (value.loading) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 6 / 5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ShimmerWidget.rectangle(width: 130, height: 158);
                      });
                }
                if (value.error) {
                  return Center(
                    child: Text('Something Went Wrong'),
                  );
                }
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: value.governmenthospital.length,
                  itemBuilder: (context, index) {
                    var span1 =
                        TextSpan(text: value.governmenthospital[index].name);
                    var tp1 = TextPainter(
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      text: span1,
                    );

                    tp1.layout(
                      maxWidth: MediaQuery.of(context).size.width * .4,
                    );

                    var exceeded1 = tp1.didExceedMaxLines;

                    return InkWell(
                      onTap: () {
                        context.read<GetHospitalProvider>().getClickedHospital(
                              index,
                              0,
                              value.governmenthospital[index].name,
                              value.governmenthospital[index].city,
                            );
                        context.read<GetHospitalProvider>().createimagetag();
                        Navigator.pushNamed(context, '/viewhospitaldetail');
                      },
                      child: SizedBox(
                        height: 158,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                height: 100.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        exceeded1
                                            ? SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextScroll(
                                                      value
                                                          .governmenthospital[
                                                              index]
                                                          .name,
                                                      mode: TextScrollMode
                                                          .bouncing,
                                                      velocity: Velocity(
                                                          pixelsPerSecond:
                                                              Offset(10, 0)),
                                                      delayBefore: Duration(
                                                          milliseconds: 200),
                                                      numberOfReps: 30,
                                                      pauseBetween: Duration(
                                                          milliseconds: 50),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.right,
                                                      selectable: true,
                                                    )),
                                              )
                                            : SizedBox(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Text(
                                                  value
                                                      .governmenthospital[index]
                                                      .name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  'images/MapPin.png'),
                                            ),
                                            Gap(5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              child: Text(
                                                value.governmenthospital[index]
                                                    .city,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  'images/Clock.png'),
                                            ),
                                            Gap(5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              child: const Text(
                                                '10am-3pm',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                child: SizedBox(
                                  height: 75,
                                  child: HeroMode(
                                    enabled: context
                                        .watch<GetHospitalProvider>()
                                        .enablehero,
                                    child: Hero(
                                      tag: '${value.imagetag}' '${index}' '0',
                                      child: Image.asset(
                                        'images/hospital1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Private Hospitals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      context.read<GetHospitalProvider>().disablehero();
                      Navigator.pushNamed(context, '/privatehospital');
                    },
                    child: const Text('See All'))
              ],
            ),
            Gap(20),
            SizedBox(
              height: 330,
              child: Consumer<GetHospitalProvider>(
                  builder: (context, value, child) {
                if (value.loading) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 6 / 5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const ShimmerWidget.rectangle(
                            width: 130, height: 158);
                      });
                }
                if (value.error) {
                  return Center(
                    child: Text('Something Went Wrong'),
                  );
                }
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: value.privatehospital.length,
                  itemBuilder: (context, index) {
                    var span1 =
                        TextSpan(text: value.privatehospital[index].name);
                    var tp1 = TextPainter(
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      text: span1,
                    );

                    tp1.layout(
                      maxWidth: MediaQuery.of(context).size.width * .4,
                    );

                    var exceeded1 = tp1.didExceedMaxLines;

                    return InkWell(
                      onTap: () {
                        context.read<GetHospitalProvider>().getClickedHospital(
                              index,
                              1,
                              value.privatehospital[index].name,
                              value.governmenthospital[index].city,
                            );
                        context.read<GetHospitalProvider>().createimagetag();
                        Navigator.pushNamed(context, '/viewhospitaldetail');
                      },
                      child: SizedBox(
                        height: 158,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 10, right: 10),
                                height: 100.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        exceeded1
                                            ? SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextScroll(
                                                      value
                                                          .privatehospital[
                                                              index]
                                                          .name,
                                                      mode: TextScrollMode
                                                          .bouncing,
                                                      velocity: Velocity(
                                                          pixelsPerSecond:
                                                              Offset(10, 0)),
                                                      delayBefore: Duration(
                                                          milliseconds: 200),
                                                      numberOfReps: 30,
                                                      pauseBetween: Duration(
                                                          milliseconds: 50),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign:
                                                          TextAlign.right,
                                                      selectable: true,
                                                    )),
                                              )
                                            : SizedBox(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                child: Text(
                                                  HospitalName[index],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  'images/MapPin.png'),
                                            ),
                                            Gap(5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              child: Text(
                                                value.privatehospital[index]
                                                    .city,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: Image.asset(
                                                  'images/Clock.png'),
                                            ),
                                            Gap(5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              child: const Text(
                                                '10am-3pm',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                child: SizedBox(
                                  height: 75,
                                  child: HeroMode(
                                    enabled: context
                                        .watch<GetHospitalProvider>()
                                        .enablehero,
                                    child: Hero(
                                      tag: '${value.imagetag}' '${index}' '1',
                                      child: Image.asset(
                                        'images/hospital1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
