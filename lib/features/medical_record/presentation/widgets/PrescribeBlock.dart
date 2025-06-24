import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/mydoctor.dart';
import 'package:h_smart/features/medical_record/domain/entities/prescription.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/separator.dart';
import 'package:provider/provider.dart';

class prescription1 extends ConsumerStatefulWidget {
  prescription1({
    super.key,
    required this.drfistname,
    required this.drlastname,
    required this.bio,
    required this.number,
    required this.index,
    required this.pic,
    required this.drug,
  });

  String drfistname = '';
  String drlastname = '';
  String bio = '';
  String number = '';
  int index = 0;
  List<Specializations> drug = [];
  String pic = '';
  @override
  ConsumerState<prescription1> createState() => _prescription1State();
}

class _prescription1State extends ConsumerState<prescription1> {
  bool showdetails = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //  height: 195,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 197, 255)),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.drug.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.drug[index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 11),
                            ),
                            const Gap(5),
                            const Text(
                              'One Caplet daily',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 11),
                            )
                          ],
                        ),
                        const Text(
                          'Capsule, 20mg',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 11),
                        )
                      ],
                    ),
                  );
                }),
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
                            'Prescribed by: Dr. ${widget.drfistname} ${widget.drlastname}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 11),
                          ),
                          if (showdetails)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showdetails = !showdetails;
                                });
                              },
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      Image.asset('images/chevron-down.png')),
                            )
                          else
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showdetails = !showdetails;
                                });
                              },
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset('images/iconright.png')),
                            )
                        ],
                      ),
                    ),
                    showdetails
                        ? Column(
                            children: [
                              const Gap(15),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: SizedBox(
                                        height: 56,
                                        width: 56,
                                        child: Hero(
                                            tag: 'doctorimage',
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                progressIndicatorBuilder:
                                                    (context, url, progress) {
                                                  return Center(
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        value:
                                                            progress.progress,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageUrl: widget.pic,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    const Gap(20),
                                    SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Bio:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                              width: 230,
                                              child: Text(widget.bio)),
                                          const Gap(5),
                                          const Text(
                                            'Phone Number:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                              width: 230,
                                              child: Text(widget.number)),
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          )
                        : const SizedBox(),
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
}
