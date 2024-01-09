import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../constant/SchimmerWidget.dart';

class GovermentHospital extends StatefulWidget {
  const GovermentHospital({super.key});

  @override
  State<GovermentHospital> createState() => _GovermentHospitalState();
}

class _GovermentHospitalState extends State<GovermentHospital> {
  @override
  Widget build(BuildContext context) {
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
          title: const Text(
            'Government Hospitals',
            style: TextStyle(fontSize: 17),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<GetHospitalProvider>(builder: (context, value, child) {
          if (value.loading) {
            return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 6 / 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: 10,
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6 / 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: value.governmenthospitalall.length,
            itemBuilder: (context, index) {
              var span1 =
                  TextSpan(text: value.governmenthospitalall[index].name);
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
                        value.governmenthospitalall[index].name,
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
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          height: 100.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                exceeded1
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextScroll(
                                              value.governmenthospitalall[index]
                                                  .name,
                                              mode: TextScrollMode.bouncing,
                                              velocity: Velocity(
                                                  pixelsPerSecond:
                                                      Offset(10, 0)),
                                              delayBefore:
                                                  Duration(milliseconds: 200),
                                              numberOfReps: 30,
                                              pauseBetween:
                                                  Duration(milliseconds: 50),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.right,
                                              selectable: true,
                                            )),
                                      )
                                    : SizedBox(
                                        height: 20,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Text(
                                          value.governmenthospitalall[index]
                                              .name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: Image.asset('images/MapPin.png'),
                                    ),
                                    Gap(5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: Text(
                                        value.governmenthospitalall[index].city,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: Image.asset('images/Clock.png'),
                                    ),
                                    Gap(5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: const Text(
                                        '10am-3pm',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )
                              ]),
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
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
