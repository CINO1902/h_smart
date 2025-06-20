import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TestAndReport extends StatefulWidget {
  const TestAndReport({super.key});

  @override
  State<TestAndReport> createState() => _TestAndReportState();
}

class _TestAndReportState extends State<TestAndReport> {
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
            'Test & Lab Results',
            style: TextStyle(fontSize: 16),
          )),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffC1D3FF)),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffF3F7FF)),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            recordtype('General Blood Test', 'Lenox Hill lab'),
            const Gap(10),
            recordtype('Thyroid Function Test', 'Lenox Hill lab'),
            const Gap(10),
            recordtype('Kidney Function Test', 'Lenox Hill lab'),
            const Gap(10),
            recordtype('Liver Function Test', 'Lenox Hill lab'),
            const Gap(10),
            recordtype('Lipid Profile', 'Lenox Hill lab'),
          ],
        ),
      ),
    );
  }

  InkWell recordtype(title, subtitle) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/Report');
      },
      child: Container(
        height: 57,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffC1D3FF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            const Text(
              'July 30th, 2023',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
