import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/separator.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Container(
            height: 57,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Blood Tes',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lenox Hill lab',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                Text(
                  'July 30th, 2023',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 54, bottom: 50),
            child: ListView(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Result:',
                    style: TextStyle(fontSize: 13),
                  ),
                  Gap(10),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Hemoglobin (Hb): 14.5 g/dL (Normal range: 12.0 - 16.0 g/dL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'White Blood Cell (WBC) Count: 7.2 x 10^3/μL (Normal range: 4.5 - 11.0 x 10^3/μL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Red Blood Cell (RBC) Count: 4.8 x 10^6/μL (Normal range: 4.5 - 5.5 x 10^6/μL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '4.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Hematocrit (Hct): 42.0% (Normal range: 38.0% - 52.0%)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Mean Corpuscular Volume (MCV): 87.5 fL (Normal range: 80.0 - 100.0 fL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '6.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Mean Corpuscular Hemoglobin (MCH): 29.0 pg (Normal range: 27.0 - 33.0 pg)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Mean Corpuscular Hemoglobin Concentration (MCHC): 33.1 g/dL (Normal range: 32.0 - 36.0 g/dL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '8.',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: Text(
                                'Platelet Count: 220 x 10^3/μL (Normal range: 150 - 400 x 10^3/μL)',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(20),
                      MySeparator(),
                      Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('images/dot.svg'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: Text(
                              'Mary\'s hemoglobin level (Hb) is within the normal range, indicating that his blood has an appropriate amount of oxygen-carrying red blood cells.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('images/dot.svg'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: Text(
                              'The white blood cell count (WBC) is slightly elevated but still within the normal range, suggesting a normal immune response to infection or inflammation.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('images/dot.svg'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: Text(
                              'Other parameters, including red blood cell count (RBC), hematocrit (Hct), and platelet count, are also within the normal ranges.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue, width: 2)),
                child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Share',
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset('images/ShareFat.png')),
                      ],
                    )),
              ))
        ]),
      ),
    );
  }
}
