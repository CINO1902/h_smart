import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../medical_record/presentation/widgets/separator.dart';

class FirstAidDesc extends StatefulWidget {
  FirstAidDesc({super.key, required this.title});
  String title;

  @override
  State<FirstAidDesc> createState() => _FirstAidDescState();
}

class _FirstAidDescState extends State<FirstAidDesc> {
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
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 16),
          )),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 44,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xffF3F7FF)),
              child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset('images/firstaid_opacity.png')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Quick First Aid Tips',
                    style: TextStyle(
                        color: Color(0xffFF5C5D),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  )
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: EdgeInsets.only(top: 44),
              child: ListView(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. Clean It:',
                          style: TextStyle(fontSize: 13),
                        ),
                        Gap(10),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('images/dot.svg'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.82,
                                  child: Text(
                                    'Fever is a temporary increase in body temperature, often in response to an infection or illness. It\'s a natural defense mechanism as it helps the body fight off infections.',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('images/dot.svg'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.82,
                                  child: Text(
                                    'Use clean, running water to gently rinse the scrape. This helps remove any dirt and debris.',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ]),
                  Gap(20),
                  MySeparator(),
                  Gap(20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Common Causes::',
                          style: TextStyle(fontSize: 13),
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
                                'Fever can be caused by various factors, including viral or bacterial infections, the flu, common cold, urinary tract infections, or other health conditions.',
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          ],
                        )
                      ]),
                  Gap(20),
                  MySeparator(),
                  Gap(20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Self-Help Tips:',
                          style: TextStyle(fontSize: 13),
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
                                'If you have a mild fever, it\'s essential to rest, stay hydrated, and keep cool by taking a lukewarm bath. Over-the-counter fever reducers like acetaminophen or ibuprofen can help lower the fever. However, if your fever is severe, persistent, or accompanied by other concerning symptoms, it\'s important to seek medical advice.',
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          ],
                        )
                      ]),
                  Gap(20),
                  MySeparator(),
                  Gap(20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'When to Seek Medical Attention:',
                          style: TextStyle(fontSize: 13),
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
                                'Contact a healthcare provider if your fever persists for more than a few days, is very high (above 39°C), is accompanied by severe headache, difficulty breathing, chest pain, rash, or confusion, or if you have underlying health conditions.',
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          ],
                        )
                      ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
