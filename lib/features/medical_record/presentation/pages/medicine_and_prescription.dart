import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/PrescribeBlock.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/separator.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/appColor.dart';

class MedicineAndPres extends ConsumerStatefulWidget {
  const MedicineAndPres({super.key});

  @override
  ConsumerState<MedicineAndPres> createState() => _MedicineAndPresState();
}

class _MedicineAndPresState extends ConsumerState<MedicineAndPres>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this)
    ..addListener(() {
      setState(() {});
    });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ref.read(medicalRecordProvider).getprescription();
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
            'Medicine & Prescription',
            style: TextStyle(fontSize: 16),
          )),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF3F7FF),
              ),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.animateTo(0);
                      },
                      child: Container(
                        height: 38,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.index == 0
                              ? AppColors.kprimaryColor500
                              : const Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Current",
                            style: controller.index == 0
                                ? TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.9))
                                : TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.7)),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.animateTo(1);
                      },
                      child: Container(
                        height: 38,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: controller.index == 1
                              ? BorderRadius.circular(10)
                              : BorderRadius.zero,
                          color: controller.index == 1
                              ? AppColors.kprimaryColor500
                              : const Color(0xffF3F7FF),
                        ),
                        child: Center(
                          child: Text(
                            "Past",
                            style: controller.index == 1
                                ? const TextStyle(color: AppColors.kprimaryColor500)
                                : TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.7)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBarView(
              controller: controller,
              children: [
                Builder(builder: (context) {
                  final medicalRecord = ref.watch(medicalRecordProvider);

                  if (medicalRecord.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kprimaryColor500,
                      ),
                    );
                  } else if (medicalRecord.error) {
                    return const Center(
                      child: Text('Something Went Wrong'),
                    );
                  } else if (medicalRecord.currentempty) {
                    return const Center(
                      child: Text('The List is Empty'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: medicalRecord.pres.length,
                      itemBuilder: (context, index) {
                        final prescription = medicalRecord.pres[index];
                        return prescription1(
                          drfistname: prescription.doctorName.firstName,
                          drlastname: prescription.doctorName.lastName,
                          bio: prescription.doctorName.bio,
                          pic:
                              'https://res.cloudinary.com/dlsavisdq/image/upload/v1700454717/afroread/book_image/zlpsw7apuj0wuriavtbu.jpg',
                          number: prescription.doctorName.phoneNumber,
                          index: index,
                          drug: prescription.drugs,
                        );
                      },
                    );
                  }
                }),
                ListView(
                  padding: const EdgeInsets.only(top: 20),
                  children: [
                    Prescription(),
                    const SizedBox(height: 20),
                    Prescription(),
                    const SizedBox(height: 20),
                    Prescription(),
                    const SizedBox(height: 20),
                    Prescription(),
                    const SizedBox(height: 20),
                    Prescription(),
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Container Prescription11(drfirstname, drlastname, bio, number) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //  height: 195,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 197, 255)),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Arthocare Forte',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    Gap(5),
                    Text(
                      'One Caplet daily',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
                Text(
                  'Capsule, 20mg',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                )
              ],
            ),
            const Gap(10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Paracetamol',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    Gap(5),
                    Text(
                      'One Caplet, Twice daily',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
                Text(
                  'Tablet, 500mg',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                )
              ],
            ),
            const Gap(15),
            const MySeparator(),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prescribed by: Dr. $drfirstname $drlastname',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 11),
                          ),
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset('images/iconright.png'))
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Gap(15),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 56,
                                width: 56,
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
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bio:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 230, child: Text(bio)),
                                    const Gap(5),
                                    const Text(
                                      'Phone Number:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 230, child: Text(number)),
                                  ],
                                ),
                              )
                            ]),
                      ],
                    ),
                    const Gap(5),
                    const Text(
                      '20 June, 2023',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Container Prescription() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 195,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 197, 255)),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Arthocare Forte',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    Gap(5),
                    Text(
                      'One Caplet daily',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
                Text(
                  'Capsule, 20mg',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                )
              ],
            ),
            const Gap(10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Paracetamol',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    Gap(5),
                    Text(
                      'One Caplet, Twice daily',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
                Text(
                  'Tablet, 500mg',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                )
              ],
            ),
            const Gap(15),
            const MySeparator(),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Prescribed by: Dr. Williams',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    Gap(5),
                    Text(
                      '20 June, 2023',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    )
                  ],
                ),
                SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset('images/iconright.png'))
              ],
            ),
          ],
        ));
  }
}
