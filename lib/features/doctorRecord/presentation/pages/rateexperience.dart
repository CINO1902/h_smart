import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';

class RateExperience extends StatefulWidget {
  const RateExperience({super.key});

  @override
  State<RateExperience> createState() => _RateExperienceState();
}

class _RateExperienceState extends State<RateExperience> {
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
            'Rate your experience',
            style: TextStyle(fontSize: 17),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const Gap(10),
            const Text(
              'With our anonymous ratings and reviews feature, you can freely share your experiences with us without revealing your identity.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const Gap(20),
            const Text(
              'Tell us about your experience',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Gap(10),
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                unratedColor: Color(0xffEDEDED),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
            const Gap(20),
            const Text(
              'Leave a comment',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Gap(10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffC1D3FF)),
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                //controller: keystonecontroller,
                cursorHeight: 15,
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    labelText: 'Write a review(Optional)',
                    labelStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    fillColor: Colors.black54,
                    focusColor: Colors.black54),
              ),
            ),
            Gap(100),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/indexpage');
                  },
                  child: InkButton(title: 'Submit')),
            )
          ],
        ),
      ),
    );
  }
}
