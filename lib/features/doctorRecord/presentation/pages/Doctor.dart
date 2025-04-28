import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/SpecialisedDoctor.dart';
import 'package:h_smart/features/doctorRecord/domain/usecases/doctorStates.dart';
import 'package:h_smart/features/doctorRecord/presentation/pages/listdoctors.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Doctor extends ConsumerStatefulWidget {
  const Doctor({super.key});

  @override
  ConsumerState<Doctor> createState() => _DoctorState();
}

class _DoctorState extends ConsumerState<Doctor> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(doctorprovider).calldoctorcatergory();
      ref.read(doctorprovider).callmydoctor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Doctors',
            style: TextStyle(fontSize: 21),
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
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
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 192, 192, 192),
                            width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 226, 226, 226))),
                  ),
                  onChanged: (value) {
                    ref.read(doctorprovider).searchbook(value);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 44),
                  child: ListView(
                    children: [
                      const SizedBox(height: 30),
                      _buildMyDoctorSection(context, ref),
                      const SizedBox(height: 15),
                      _buildCategoriesSection(context),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the "Categories" section using a Consumer.
  Widget _buildCategoriesSection(BuildContext context) {
    if (ref.watch(doctorprovider).loading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (ref.watch(doctorprovider).error) {
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Center(
                  child: Text(
                    "Try Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (ref.watch(doctorprovider).doctorcategory.isEmpty) {
      return Column(
        children: [
          _buildSectionHeader('Categories'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: Text('Doctor category could not be found'),
            ),
          ),
        ],
      );
    } else {
      return StickyHeader(
        header: _buildSectionHeader('Categories'),
        content: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ref.watch(doctorprovider).doctorcategory.length,
          itemBuilder: (context, index) {
            final category = ref.watch(doctorprovider).doctorcategory[index];
            return categories(category.name, category.description, index);
          },
        ),
      );
    }
  }

  InkWell categories(title, String desc, index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListDoctors(
                      appbartitle: title,
                      index: index,
                    )));
      },
      child: Container(
        height: 68,
        margin: EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffEBF1FF)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 300,
                  child: Text(
                    desc,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('images/iconright.png'))
          ],
        ),
      ),
    );
  }
}

Widget _buildMyDoctorSection(BuildContext context, WidgetRef ref) {
  final doctorProvider = ref.watch(doctorprovider);

  // If there’s no favorite doctor, return an empty widget.
  if (doctorProvider.favdoctorid.isEmpty) return const SizedBox();

  // Display loading, error, or the actual content.
  switch (doctorProvider.callMyDoctorResult.state) {
    case CallMyDoctorResultState.isLoading:
      return Column(
        children: [
          _buildSectionHeader('My Doctor'),
          ShimmerWidget.rectangle(width: double.infinity, height: 75),
        ],
      );
    case CallMyDoctorResultState.isError:
      return const Center(child: Text('Opps!!!, Something went wrong'));
    default:
      return StickyHeader(
        header: _buildSectionHeader('My Doctor'),
        content: InkWell(
          onTap: () {
            ref.watch(doctorprovider).actionmydoctorclicked();
            Navigator.pushNamed(context, '/aboutDoctor');
          },
          child: _buildDoctorCard(context, ref),
        ),
      );
  }
}

/// Creates a common section header widget.
Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    height: 30,
    color: Colors.white,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}

/// Builds the card displaying the doctor's info.
Widget _buildDoctorCard(BuildContext context, WidgetRef ref) {
  final provider = ref.watch(doctorprovider);
  // Extract doctor details for clarity.
  final doctorData = provider.callMyDoctorResult.response.payload?[0].doctor;
  final firstName = doctorData?.specialization.doctors[0].firstName;
  final lastName = doctorData?.specialization.doctors[0].lastName;
  final specialization = doctorData?.specialization.name;
  final imageUrl = provider
          .callMyDoctorResult.response.payload?[0].doctor.docProfilePicture ??
      'https://t4.ftcdn.net/jpg/02/60/04/09/360_F_260040900_oO6YW1sHTnKxby4GcjCvtypUCWjnQRg5.jpg';

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    height: 76,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xffEBF1FF)),
    ),
    child: Row(
      children: [
        SizedBox(
          height: 56,
          width: 56,
          child: Hero(
            tag: 'doctorimage',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      value: progress.progress,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Doctor name and specialization.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 170,
                    child: Text(
                      'Dr $firstName $lastName',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: Text(
                      specialization ?? '',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              // Working hours.
              Row(
                children: [
                  Image.asset(
                    'images/Clock.png',
                    height: 10,
                    width: 10,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '10am - 3pm',
                    style: TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
