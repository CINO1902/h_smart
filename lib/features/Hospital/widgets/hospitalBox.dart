import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/AutoScrollText.dart';

import '../presentation/provider/getHospitalProvider.dart';

class HospitalWidget extends StatelessWidget {
  const HospitalWidget(
      {super.key,
      required this.ref,
      required this.index,
      required this.hospitalCity,
      required this.hospitalName});

  final WidgetRef ref;
  final int index;
  final String hospitalCity;
  final String hospitalName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 158,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(16)),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                  height: 20,
                  width: MediaQuery.of(context).size.width * .5,
                  child: AutoScrollText(
                    text: hospitalName,
                    maxWidth: MediaQuery.of(context).size.width * .45,
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
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
                      width: MediaQuery.of(context).size.width * .2,
                      child: AutoScrollText(
                        text: hospitalCity,
                        maxWidth: MediaQuery.of(context).size.width * .2,
                        align: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400),
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
                      width: MediaQuery.of(context).size.width * .2,
                      child: const Text(
                        '10am-3pm',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400),
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
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: SizedBox(
                height: 75,
                child: Hero(
                  tag: '${ref.watch(hospitalprovider).imagetag}'
                      '${index}'
                      '1',
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
    );
  }
}
