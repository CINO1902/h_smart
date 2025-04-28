import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/domain/states/hospitalStates.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../constant/SchimmerWidget.dart';
import '../../../medical_record/presentation/widgets/AutoScrollText.dart';
import '../../widgets/hospitalBox.dart';

class GovermentHospital extends ConsumerStatefulWidget {
  const GovermentHospital({super.key});

  @override
  ConsumerState<GovermentHospital> createState() => _GovermentHospitalState();
}

class _GovermentHospitalState extends ConsumerState<GovermentHospital> {
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
            'Government Hospitals',
            style: TextStyle(fontSize: 17),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Builder(builder: (context) {
          if (ref.watch(hospitalprovider).hospitalResult.state ==
              HospitalResultStates.isLoading) {
            return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 6 / 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ShimmerWidget.rectangle(width: 130, height: 158);
                });
          }
          if (ref.watch(hospitalprovider).hospitalResult.state ==
              HospitalResultStates.isError) {
            return Center(
              child: Text(
                  ref.watch(hospitalprovider).hospitalResult.response.msg ??
                      'Something Went Wrong'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6 / 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: ref.watch(hospitalprovider).governmenthospitalall.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  ref.read(hospitalprovider).getClickedHospital(
                        index,
                        0,
                        ref
                            .watch(hospitalprovider)
                            .governmenthospitalall[index]
                            .name,
                        ref
                            .watch(hospitalprovider)
                            .governmenthospital[index]
                            .city,
                      );
                  ref.read(hospitalprovider).createimagetag();
                  Navigator.pushNamed(context, '/viewhospitaldetail');
                },
                child: HospitalWidget(
                  ref: ref,
                  index: index,
                  hospitalCity: ref
                      .watch(hospitalprovider)
                      .governmenthospitalall[index]
                      .city!,
                  hospitalName: ref
                      .watch(hospitalprovider)
                      .governmenthospitalall[index]
                      .name!,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
