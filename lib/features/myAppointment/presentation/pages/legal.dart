import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Legal extends StatefulWidget {
  const Legal({super.key});

  @override
  State<Legal> createState() => _LegalState();
}

class _LegalState extends State<Legal> {
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
            'Legal',
            style: TextStyle(fontSize: 19),
          )),
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(10),
        height: 180,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xffC1D3FF)),
            borderRadius: BorderRadius.circular(16),
            color: Color(0xffF3F7FF)),
        child: Column(
          children: [
            InkWell(
                // onTap: () {
                //   Navigator.pushNamed(context, '/MedicalInfo');
                // },
                child: recordtype('Terms & Condition')),
            Gap(10),
            InkWell(child: recordtype('Privacy Policy')),
            Gap(10),
            InkWell(
                // onTap: () {
                //   Navigator.pushNamed(context, '/TestAndReport');
                // },
                child: recordtype('Copyrights')),
          ],
        ),
      ),
    );
  }

  Container recordtype(title) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffC1D3FF)),
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
