import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
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
            'Support',
            style: TextStyle(fontSize: 19),
          )),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        height: 125,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffC1D3FF)),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffF3F7FF)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/feedback');
                },
                child: recordtype('Feedback')),
            const Gap(10),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/faq');
                },
                child: recordtype('FAQ\'s')),
          ],
        ),
      ),
    );
  }

  Container recordtype(title) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffC1D3FF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          SizedBox(
              height: 20, width: 20, child: Image.asset('images/iconright.png'))
        ],
      ),
    );
  }
}
