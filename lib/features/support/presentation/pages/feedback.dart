import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/Inkbutton.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({super.key});

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
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
            'Feedback',
            style: TextStyle(fontSize: 16),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            ListView(
              children: [
                const Text('Lodge a feedback'),
                const Gap(10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffC1D3FF)),
                      borderRadius: BorderRadius.circular(7)),
                  child: TextFormField(
                    //controller: keystonecontroller,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        labelText: 'Write your feedback(Optional)',
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        fillColor: Colors.black54,
                        focusColor: Colors.black54),
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(child: InkButton(title: 'Submit')))
          ],
        ),
      ),
    );
  }
}
