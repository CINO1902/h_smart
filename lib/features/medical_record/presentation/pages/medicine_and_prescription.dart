import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/domain/usecases/userStates.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';

import '../../../../core/utils/appColor.dart';
import '../widgets/MedandPescription/PescriptionCard.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';

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
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(medicalRecordProvider).getprescription();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final medicalRecord = ref.read(medicalRecordProvider);
    // If data is already loaded, trigger an update (show loader at top)
    if (medicalRecord.prescription.status ==
            GetPrescriptionResultStates.success &&
        (medicalRecord.prescription.data.payload?.isNotEmpty ?? false) &&
        !medicalRecord.isUpdating) {
      // This will only trigger if not already updating
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(medicalRecordProvider).getprescription();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Text(
            'Medicine & Prescription',
            style: TextStyle(fontSize: 16),
          )),
      body: Column(
        children: [
          // Enhanced Tab Design
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.animateTo(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: controller.index == 0
                            ? AppColors.kprimaryColor500
                            : Colors.transparent,
                        boxShadow: controller.index == 0
                            ? [
                                BoxShadow(
                                  color: AppColors.kprimaryColor500
                                      .withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Current Prescriptions",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: controller.index == 0
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.animateTo(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: controller.index == 1
                            ? AppColors.kprimaryColor500
                            : Colors.transparent,
                        boxShadow: controller.index == 1
                            ? [
                                BoxShadow(
                                  color: AppColors.kprimaryColor500
                                      .withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Past Prescriptions",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: controller.index == 1
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(
                controller: controller,
                children: [
                  // Current Prescriptions Tab
                  Builder(builder: (context) {
                    final medicalRecord = ref.watch(medicalRecordProvider);

                    if (medicalRecord.prescription.status ==
                        GetPrescriptionResultStates.loading) {
                      // Show shimmer loader while loading
                      return ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            const _PrescriptionShimmerCard(),
                      );
                    } else if (medicalRecord.isUpdating) {
                      // Show loader at the top, but keep showing cached prescriptions
                      return Column(
                        children: [
                          const LinearProgressIndicator(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: medicalRecord
                                      .prescription.data.payload?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final prescription = medicalRecord
                                    .prescription.data.payload![index];
                                return EnhancedPrescriptionCard(
                                  prescription: prescription,
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (medicalRecord.prescription.status ==
                        GetPrescriptionResultStates.fail) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const Gap(16),
                            Text(
                              'Failed to load prescriptions',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Please try again later',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (medicalRecord
                            .prescription.data.payload?.isEmpty ??
                        false) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const Gap(16),
                            Text(
                              'No Current Prescriptions',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'You don\'t have any active prescriptions',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (medicalRecord.prescription.status ==
                        GetPrescriptionResultStates.success) {
                      return ListView.builder(
                        itemCount:
                            medicalRecord.prescription.data.payload!.length,
                        itemBuilder: (context, index) {
                          final prescription =
                              medicalRecord.prescription.data.payload![index];
                          return EnhancedPrescriptionCard(
                            prescription: prescription,
                            index: index,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kprimaryColor500,
                        ),
                      );
                    }
                  }),
                  // Past Prescriptions Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const Gap(16),
                        Text(
                          'No Past Prescriptions',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Your prescription history will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PrescriptionShimmerCard extends StatelessWidget {
  const _PrescriptionShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header shimmer
          const Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const ShimmerWidget.rectangle(width: 60, height: 20),
                const Spacer(),
                const ShimmerWidget.rectangle(width: 120, height: 16),
              ],
            ),
          ),
          // Medications shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget.rectangle(width: 120, height: 18),
                const Gap(12),
                for (int i = 0; i < 2; i++) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const ShimmerWidget.rectangle(
                        width: double.infinity, height: 40),
                  ),
                ],
              ],
            ),
          ),
          const Gap(16),
          // Footer shimmer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerWidget.rectangle(width: 80, height: 14),
                      const Gap(4),
                      const ShimmerWidget.rectangle(width: 80, height: 14),
                    ],
                  ),
                ),
                const ShimmerWidget.rectangle(width: 32, height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
