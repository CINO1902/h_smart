import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../constant/SchimmerWidget.dart';
import '../../domain/states/hospitalStates.dart';
import '../../widgets/hospitalBox.dart';
import '../provider/getHospitalProvider.dart';

class PrivateHosptal extends ConsumerStatefulWidget {
  const PrivateHosptal({super.key});

  @override
  ConsumerState<PrivateHosptal> createState() => _PrivateHosptalState();
}

class _PrivateHosptalState extends ConsumerState<PrivateHosptal> {
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
            'Hospitals',
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
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6 / 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: ref.watch(hospitalprovider).privatehospitalall.length,
            itemBuilder: (context, index) {
              var span1 = TextSpan(
                  text:
                      ref.watch(hospitalprovider).privatehospital[index].name);
              var tp1 = TextPainter(
                maxLines: 1,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                text: span1,
              );

              tp1.layout(
                maxWidth: MediaQuery.of(context).size.width * .4,
              );

              var exceeded1 = tp1.didExceedMaxLines;

              return InkWell(
                onTap: () {
                  ref.read(hospitalprovider).getClickedHospital(
                        index,
                        0,
                        ref
                            .watch(hospitalprovider)
                            .privatehospitalall[index]
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
                      .privatehospitalall[index]
                      .city!,
                  hospitalName: ref
                      .watch(hospitalprovider)
                      .privatehospitalall[index]
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
