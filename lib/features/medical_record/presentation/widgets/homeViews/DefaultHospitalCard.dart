import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:h_smart/features/Hospital/domain/states/hospitalStates.dart';

class DefaultHospitalCard extends ConsumerStatefulWidget {
  const DefaultHospitalCard({super.key});

  @override
  ConsumerState<DefaultHospitalCard> createState() =>
      _DefaultHospitalCardState();
}

class _DefaultHospitalCardState extends ConsumerState<DefaultHospitalCard> {
  @override
  void initState() {
    super.initState();
    // Only load default hospital if not already loaded or if there's an error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hospitalProvider = ref.read(hospitalprovider);
      final defaultHospitalResult = hospitalProvider.defaultHospitalResult;
      
      // Only fetch if we don't have data or if there's an error
      if (!defaultHospitalResult.isData || defaultHospitalResult.isError) {
        hospitalProvider.getDefaultHospital();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hospitalProvider = ref.watch(hospitalprovider);
    final defaultHospitalResult = hospitalProvider.defaultHospitalResult;

    // Don't show anything if loading or no data
    if (defaultHospitalResult.isLoading) {
      return _buildShimmer();
    }

    if (defaultHospitalResult.isError ||
        !defaultHospitalResult.isData ||
        defaultHospitalResult.response.payload == null ||
        !defaultHospitalResult.response.payload!.summary.hasDefault) {
      return const SizedBox.shrink();
    }

    final defaultHospital =
        defaultHospitalResult.response.payload!.summary.defaultHospital;
    if (defaultHospital == null) {
      return const SizedBox.shrink();
    }

    // Full width card design
    return GestureDetector(
      onTap: () => context.push('/hospital/default-settings'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kprimaryColor500.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.kprimaryColor500.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_hospital_rounded,
                color: AppColors.kprimaryColor500,
                size: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default Hospital',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    defaultHospital.hospitalName ?? 'Unknown Hospital',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.kprimaryColor500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.kprimaryColor500.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ShimmerWidget.rectangle(height: 36, width: 36),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangle(height: 12, width: 100),
                const Gap(2),
                ShimmerWidget.rectangle(height: 14, width: 150),
              ],
            ),
          ),
          ShimmerWidget.rectangle(height: 20, width: 20),
        ],
      ),
    );
  }
}
