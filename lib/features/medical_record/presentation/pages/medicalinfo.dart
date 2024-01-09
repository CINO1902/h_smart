import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MedicalInfo extends StatefulWidget {
  const MedicalInfo({super.key});

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
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
            'Medical Info',
            style: TextStyle(fontSize: 19),
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mary Jane',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(''),
                  ],
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Blood Group: O+',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text('Genotype: AA'),
                  ],
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gender: Female',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text('DOB: 02/04/1998'),
                  ],
                ),
                const Gap(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Medical Condition',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            color: Color(0xffF3F7FF),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        )),
                  ],
                ),
                Gap(20),
                Container(
                  //  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  height: 125,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC1D3FF)),
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffF3F7FF)),
                  child: Column(
                    children: [
                      Container(
                        height: 44,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xffC1D3FF)),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hypertension (High Blood Pressure)',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      Gap(10),
                      Container(
                        height: 44,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xffC1D3FF)),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Asthma',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Allergies',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            color: Color(0xffF3F7FF),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        )),
                  ],
                ),
                Gap(20),
                Container(
                  //  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  height: 125,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC1D3FF)),
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffF3F7FF)),
                  child: Column(
                    children: [
                      Container(
                        height: 44,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xffC1D3FF)),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Food (Peanuts)',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      Gap(10),
                      Container(
                        height: 44,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xffC1D3FF)),
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Insect Sting Alergy',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
