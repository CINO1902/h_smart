import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/Hospital/domain/entities/hospitalmodel.dart';

import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../domain/states/hospitalStates.dart';
import '../../widgets/hospitalBox.dart';

class Hospital extends ConsumerStatefulWidget {
  const Hospital({super.key});

  @override
  ConsumerState<Hospital> createState() => _HospitalState();
}

class _HospitalState extends ConsumerState<Hospital> {
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
    ref.read(hospitalprovider).getHospital();
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
                      ref.watch(hospitalprovider).disablehero();
                      Navigator.pushNamed(context, '/governmenthospital');
                    },
                    child: const Text('See All'))
              ],
            ),
            Gap(20),
            SizedBox(
              height: 330,
              child: Builder(builder: (context) {
                if (ref.watch(hospitalprovider).hospitalResult.state ==
                    HospitalResultStates.isLoading) {
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
                if (ref.watch(hospitalprovider).hospitalResult.state ==
                    HospitalResultStates.isError) {
                  return Center(
                    child: Text(ref
                            .watch(hospitalprovider)
                            .hospitalResult
                            .response
                            .msg ??
                        'Something Went Wrong'),
                  );
                }
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount:
                      ref.watch(hospitalprovider).governmenthospital.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ref.read(hospitalprovider).getClickedHospital(
                              index,
                              0,
                              ref
                                  .watch(hospitalprovider)
                                  .governmenthospital[index]
                                  .name,
                              ref
                                  .watch(hospitalprovider)
                                  .governmenthospital[index]
                                  .city,
                            );
                        ref.read(hospitalprovider).createimagetag();
                        Navigator.pushNamed(context, '/viewhospitaldetail');
                      },
                      child: HospitalWidget(
                        ref: ref,
                        index: index,
                        hospitalCity: ref
                            .watch(hospitalprovider)
                            .governmenthospital[index]
                            .city!,
                        hospitalName: ref
                            .watch(hospitalprovider)
                            .governmenthospital[index]
                            .name!,
                      ),
                    );
                  },
                );
              }),
            ),
            const Gap(30),
            ref.watch(hospitalprovider).privatehospital.isEmpty
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Private Hospitals',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                          onTap: () {
                            ref.watch(hospitalprovider).disablehero();
                            Navigator.pushNamed(context, '/privatehospital');
                          },
                          child: const Text('See All'))
                    ],
                  ),
            Gap(20),
            SizedBox(
              height: 330,
              child: Builder(builder: (context) {
                if (ref.watch(hospitalprovider).hospitalResult.state ==
                    HospitalResultStates.isLoading) {
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
                if (ref.watch(hospitalprovider).hospitalResult.state ==
                    HospitalResultStates.isError) {
                  return Center(
                    child: Text(ref
                            .watch(hospitalprovider)
                            .hospitalResult
                            .response
                            .msg ??
                        'Something Went Wrong'),
                  );
                }
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: ref.watch(hospitalprovider).privatehospital.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ref.read(hospitalprovider).getClickedHospital(
                              index,
                              1,
                              ref
                                  .watch(hospitalprovider)
                                  .privatehospital[index]
                                  .name,
                              ref
                                  .watch(hospitalprovider)
                                  .governmenthospital[index]
                                  .city,
                            );
                        ref.watch(hospitalprovider).createimagetag();
                        Navigator.pushNamed(context, '/viewhospitaldetail');
                      },
                      child: HospitalWidget(
                        ref: ref,
                        index: index,
                        hospitalCity: ref
                            .watch(hospitalprovider)
                            .privatehospital[index]
                            .city!,
                        hospitalName: ref
                            .watch(hospitalprovider)
                            .privatehospital[index]
                            .name!,
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
