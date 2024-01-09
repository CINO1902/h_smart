import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:text_scroll/text_scroll.dart';

class AppointmentScheduled extends StatefulWidget {
  const AppointmentScheduled({super.key});

  @override
  State<AppointmentScheduled> createState() => _AppointmentScheduledState();
}

class _AppointmentScheduledState extends State<AppointmentScheduled> {
  bool exceeded = false;
  bool exceeded1 = false;
  void checkoverflow() {
    var span = TextSpan(
      text: 'General Practioner',
    );
    var tp = TextPainter(
      maxLines: 1,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );

    // trigger it to layout
    tp.layout(maxWidth: 100);

    // whether the text overflowed or not
    setState(() {
      exceeded = tp.didExceedMaxLines;
    });
    var span1 = TextSpan(
      text: 'Lenox Hill Hospital, Hospital',
    );
    var tp1 = TextPainter(
      maxLines: 1,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span1,
    );

    // trigger it to layout
    tp1.layout(maxWidth: 100);

    // whether the text overflowed or not
    setState(() {
      exceeded1 = tp1.didExceedMaxLines;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoverflow();
  }

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
            'Appointment Schedule',
            style: TextStyle(fontSize: 17),
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                const SizedBox(
                  height: 73,
                  width: 60,
                  child: Hero(
                    tag: 'doctorimage',
                    child: CircleAvatar(
                        backgroundImage: AssetImage(
                      'images/doctorimage.png',
                    )),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  height: 67,
                  width: MediaQuery.of(context).size.width * .63,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          width: 120,
                          child: Text(
                            'Dr. Alis William',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          const Gap(10),
                          const Text('5.0'),
                          const Gap(5),
                          const Text('(23)')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          exceeded
                              ? const SizedBox(
                                  width: 90,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextScroll(
                                        'General Practioner',
                                        mode: TextScrollMode.bouncing,
                                        velocity: Velocity(
                                            pixelsPerSecond: Offset(10, 0)),
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
                              : const SizedBox(
                                  width: 100,
                                  height: 15,
                                  child: Text(
                                    'General Practioner',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
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
                          exceeded
                              ? const SizedBox(
                                  width: 90,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextScroll(
                                        'Lenox Hill Hospital, Hospital',
                                        mode: TextScrollMode.bouncing,
                                        velocity: Velocity(
                                            pixelsPerSecond: Offset(10, 0)),
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
                              : const SizedBox(
                                  width: 100,
                                  height: 15,
                                  child: Text(
                                    'Lenox Hill Hospital, Hospital',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
            Gap(20),
            const Text(
              'Date and Time',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Gap(10),
            const Text(
              'Friday, July 21th, 2023 (10:00am - 10:30am)',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff706F6F)),
            ),
            const Gap(20),
            const Text(
              'Location',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Gap(10),
            const Text(
              '12 Idowu St, Ikeja, Lagos',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff706F6F)),
            ),
            const Gap(20),
            const Text(
              'Reason for visit',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Gap(10),
            const Text(
              'General Health Checkup: Routine checkup to assess overall health status and address any concerns.',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff706F6F)),
            ),
            Expanded(
              child: SafeArea(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/RateExperience');
                      },
                      child: Container(
                        height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Color(0xff3772FF), width: 1.5)),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Rate your experience',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3772FF)),
                          ),
                        ),
                      ),
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
