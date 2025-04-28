import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:provider/provider.dart';

class ListDoctors extends ConsumerStatefulWidget {
  ListDoctors({super.key, required this.appbartitle, required this.index});
  String appbartitle;
  int index;

  @override
  ConsumerState<ListDoctors> createState() => _ListDoctorsState();
}

class _ListDoctorsState extends ConsumerState<ListDoctors> {
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
            title: Text(
              widget.appbartitle,
              style: const TextStyle(fontSize: 18),
            )),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.grey,
                          hintText: 'Search',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 192, 192, 192),
                                  width: 2)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 226, 226, 226))),
                        ),
                        onChanged: (value) {
                          //  context.read<doctorprpvider>().searchbook(value);
                        },
                      ),
                    ),
                  ],
                ),
                Gap(20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Doctors',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Gap(10),
                Builder(builder: (context) {
                  if (ref.watch(doctorprovider).loading == true) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ref.watch(doctorprovider).error == true) {
                    return Center(
                      child: Column(
                        children: [
                          const Text('Something Went Wrong'),
                          InkWell(
                            onTap: () {
                              ref.read(doctorprovider).calldoctorcatergory();
                              ref.read(doctorprovider).callmydoctor();
                            },
                            child: Container(
                              width: 110,
                              height: 36,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context).primaryColor),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: const Center(
                                child: Text("Try Again",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ref
                            .watch(doctorprovider)
                            .doctorcategory[widget.index]
                            .doctors
                            .length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ref
                                  .read(doctorprovider)
                                  .getclickeddoctor(widget.index, index);
                              Navigator.pushNamed(context, '/aboutDoctor');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              height: 76,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xffEBF1FF))),
                              child: Row(children: [
                                SizedBox(
                                  height: 56,
                                  width: 56,
                                  child: Hero(
                                      tag: ref
                                          .watch(doctorprovider)
                                          .doctorcategory[widget.index]
                                          .doctors[index]
                                          .firstName,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder:
                                              (context, url, progress) {
                                            return Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  value: progress.progress,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            );
                                          },
                                          imageUrl: ref
                                              .watch(doctorprovider)
                                              .doctorcategory[widget.index]
                                              .doctors[index]
                                              .docProfilePicture,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )),
                                ),
                                const Gap(20),
                                SizedBox(
                                  height: 37,
                                  width:
                                      MediaQuery.of(context).size.width * .63,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                ref
                                                        .watch(doctorprovider)
                                                        .doctorcategory[
                                                            widget.index]
                                                        .doctors[index]
                                                        .firstName +
                                                    ' ' +
                                                    ref
                                                        .watch(doctorprovider)
                                                        .doctorcategory[
                                                            widget.index]
                                                        .doctors[index]
                                                        .lastName,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                widget.appbartitle,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ))
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'images/Clock.png',
                                              height: 10,
                                              width: 10,
                                            ),
                                            const Gap(5),
                                            const Text(
                                              '10am - 3pm',
                                              style: TextStyle(fontSize: 9),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          );
                        },
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ));
  }
}
