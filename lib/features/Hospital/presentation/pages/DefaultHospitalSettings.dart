import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant/SchimmerWidget.dart';
import '../../../../constant/snackbar.dart';
import '../../../../core/utils/appColor.dart';
import '../../domain/entities/GetHospital.dart';
import '../../domain/states/hospitalStates.dart';
import '../controller/hospitalController.dart';
import '../provider/getHospitalProvider.dart';

class DefaultHospitalSettings extends ConsumerStatefulWidget {
  const DefaultHospitalSettings({super.key});

  @override
  ConsumerState<DefaultHospitalSettings> createState() =>
      _DefaultHospitalSettingsState();
}

class _DefaultHospitalSettingsState
    extends ConsumerState<DefaultHospitalSettings> {
  @override
  void initState() {
    super.initState();
    // Load connected hospitals and default hospital
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hospitalprovider).getHospital();
      ref.read(hospitalprovider).getDefaultHospital();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = ref.watch(hospitalprovider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0.1,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        title: const Text(
          'Default Hospital',
          style: TextStyle(fontSize: 19),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your default hospital',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.kprimaryColor500,
              ),
            ),
            const Gap(8),
            Text(
              'This hospital will be displayed on your homepage and used as the default for appointments.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Gap(24),

            // Connected Hospitals List
            Expanded(
              child: hospitalProvider.hospitalResult.state.name == 'isLoading'
                  ? _buildLoadingList(theme)
                  : hospitalProvider.hospitalData.isEmpty
                      ? _buildEmptyState()
                      : _buildHospitalList(hospitalProvider, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingList(ThemeData theme) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: const Row(
          children: [
            ShimmerWidget(height: 48, width: 48),
            Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(height: 16, width: 150),
                  Gap(8),
                  ShimmerWidget(height: 12, width: 100),
                ],
              ),
            ),
            ShimmerWidget(height: 20, width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const Gap(16),
          Text(
            'No Connected Hospitals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const Gap(8),
          Text(
            'Connect to hospitals first to set a default',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () => context.push('/hospital'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kprimaryColor500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Browse Hospitals'),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalList(
      GetHospitalProvider hospitalProvider, ThemeData theme) {
    final connectedHospitals = hospitalProvider.hospitalData
        .where((hospital) => hospital.isConnected == true)
        .toList();

    if (connectedHospitals.isEmpty) {
      return _buildEmptyState();
    }

    final defaultHospital = hospitalProvider.defaultHospitalResult.state ==
            DefaultHospitalResultStates.isData
        ? hospitalProvider
            .defaultHospitalResult.response.payload?.summary.defaultHospital
        : null;

    return ListView.builder(
      itemCount: connectedHospitals.length,
      itemBuilder: (context, index) {
        final hospital = connectedHospitals[index];
        final isDefault = defaultHospital?.id == hospital.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDefault
                  ? AppColors.kprimaryColor500
                  : const Color(0xffE5E7EB),
              width: isDefault ? 2 : 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_hospital,
                color: AppColors.kprimaryColor500,
                size: 24,
              ),
            ),
            title: Text(
              hospital.hospitalName ?? 'Unknown Hospital',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(4),
                Text(
                  '${hospital.city ?? ''}, ${hospital.state ?? ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (isDefault) ...[
                  const Gap(8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.ksuccessColor300.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Default Hospital',
                      style: TextStyle(
                        color: AppColors.ksuccessColor300,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: isDefault
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.ksuccessColor300,
                    size: 24,
                  )
                : IconButton(
                    onPressed: () => _setDefaultHospital(hospital),
                    icon: const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
            onTap: isDefault ? null : () => _setDefaultHospital(hospital),
          ),
        );
      },
    );
  }

  void _setDefaultHospital(Hospital hospital) async {
    if (hospital.id == null) return;

    try {
      await ref.read(hospitalprovider).setDefaultHospital(hospital.id!);

      final result = ref.read(hospitalprovider).connectToHospitalResult;
      if (result.state.name == 'isData') {
        SnackBarService.notifyAction(
          context,
          message: '${hospital.hospitalName} set as default hospital',
          status: SnackbarStatus.success,
        );
      } else {
        SnackBarService.notifyAction(
          context,
          message: 'Failed to set default hospital',
          status: SnackbarStatus.fail,
        );
      }
    } catch (e) {
      SnackBarService.notifyAction(
        context,
        message: 'An error occurred',
        status: SnackbarStatus.fail,
      );
    }
  }
}
