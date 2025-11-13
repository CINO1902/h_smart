import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/domain/states/hospitalStates.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:h_smart/features/Hospital/presentation/controller/hospitalController.dart';

// Import separated widgets
import '../widgets/connected_hospital_header.dart';
import '../widgets/doctor_search_field.dart';
import '../widgets/doctor_card.dart';
import '../widgets/no_connected_hospital_view.dart';
import '../widgets/hospital_shimmer.dart';
import '../widgets/doctors_error_state.dart';
import '../widgets/doctors_empty_state.dart';

class ConnectedHospitalDoctorsPage extends ConsumerStatefulWidget {
  const ConnectedHospitalDoctorsPage({super.key});

  @override
  ConsumerState<ConnectedHospitalDoctorsPage> createState() =>
      _ConnectedHospitalDoctorsPageState();
}

class _ConnectedHospitalDoctorsPageState
    extends ConsumerState<ConnectedHospitalDoctorsPage>
    with WidgetsBindingObserver {
  Hospital? connectedHospital;
  List<Doctor> filteredDoctors = [];
  String searchQuery = '';
  bool _hasNavigatedAway = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultHospitalAndDoctors();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh when app comes back to foreground if user navigated away
    if (state == AppLifecycleState.resumed && _hasNavigatedAway) {
      _hasNavigatedAway = false;
      _refreshData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for changes in hospital provider and refresh if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hospitalProvider = ref.read(hospitalprovider);
      // Check if disconnection was successful and refresh data
      if (hospitalProvider.disconnectFromHospitalResult.state == 
          DisconnectFromHospitalResultStates.isData) {
        _refreshData();
      }
    });
  }

  Future<void> _loadDefaultHospitalAndDoctors() async {
    final hospitalProvider = ref.read(hospitalprovider);

    // First, get the default hospital
    await hospitalProvider.getDefaultHospital();

    // Check if we have a default hospital
    if (hospitalProvider.defaultHospitalResult.isData &&
        hospitalProvider.defaultHospitalResult.response.payload != null) {
      final hospitals =
          hospitalProvider.defaultHospitalResult.response.payload!.hospitals;

      if (hospitals.isNotEmpty) {
        // Use the first hospital's ID to get doctors
        final hospitalId = hospitals.first.id;
        await hospitalProvider.callDoctorsbyhospitalid(hospitalId);
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadDefaultHospitalAndDoctors();
  }

  void _filterDoctors(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredDoctors = ref.read(hospitalprovider).doctorsData;
      } else {
        filteredDoctors = ref
            .read(hospitalprovider)
            .doctorsData
            .where((doctor) =>
                doctor.firstName?.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                doctor.lastName?.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                doctor.specialization
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ==
                    true)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = ref.watch(hospitalprovider);
    final theme = Theme.of(context);

    // Find connected hospital
    connectedHospital = hospitalProvider.hospitalData
        .where((hospital) => hospital.isConnected == true)
        .firstOrNull;

    // Update filtered doctors when data changes
    if (searchQuery.isEmpty) {
      filteredDoctors = hospitalProvider.doctorsData;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.scaffoldBackgroundColor,
        titleSpacing: 0.1,
        foregroundColor: theme.colorScheme.onBackground,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        title: const Text(
          'Hospital Doctors',
          style: TextStyle(fontSize: 21),
        ),
      ),
      body: _buildBody(context, hospitalProvider, theme),
    );
  }

  Widget _buildBody(BuildContext context, GetHospitalProvider hospitalProvider,
      ThemeData theme) {
    // Check if we're loading the default hospital
    if (hospitalProvider.defaultHospitalResult.isLoading) {
      return const HospitalShimmer();
    }

    // Check if there's an error getting default hospital
    if (hospitalProvider.defaultHospitalResult.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const Gap(16),
            Text(
              'Error loading connected hospital',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(8),
            Text(
              hospitalProvider.defaultHospitalResult.response.message,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: _loadDefaultHospitalAndDoctors,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kprimaryColor500,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Check if we have default hospital data
    if (hospitalProvider.defaultHospitalResult.isData &&
        hospitalProvider.defaultHospitalResult.response.payload != null) {
      final hospitals =
          hospitalProvider.defaultHospitalResult.response.payload!.hospitals;

      if (hospitals.isNotEmpty) {
        connectedHospital = hospitals.first;

        return RefreshIndicator(
          onRefresh: () async {
            await _refreshData();
          },
          color: AppColors.kprimaryColor500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                ConnectedHospitalHeader(
                  connectedHospital: connectedHospital!,
                  ref: ref,
                ),
                const Gap(20),
                DoctorSearchField(
                  onChanged: _filterDoctors,
                ),
                const Gap(20),
                Expanded(
                  child: hospitalProvider.doctorResult.state == DoctorResultStates.isLoading
                      ? const DoctorsListShimmer()
                      : hospitalProvider.doctorResult.state == DoctorResultStates.isError
                          ? DoctorsErrorState(
                              onRetry: () {
                                if (connectedHospital != null) {
                                  ref
                                      .read(hospitalprovider)
                                      .callDoctorsbyhospitalid(connectedHospital!.id);
                                }
                              },
                            )
                          : filteredDoctors.isEmpty
                              ? DoctorsEmptyState(
                                  isSearching: searchQuery.isNotEmpty,
                                )
                              : ListView.builder(
                                  itemCount: filteredDoctors.length,
                                  itemBuilder: (context, index) {
                                    final doctor = filteredDoctors[index];
                                    return DoctorCard(
                                      doctor: doctor,
                                      onTap: () {
                                        _hasNavigatedAway = true;
                                        context.push('/doctorProfile', extra: doctor);
                                      },
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // No connected hospital
    return NoConnectedHospitalView(
      onHospitalBrowse: () async {
        _hasNavigatedAway = true;
        await context.push('/hospital');
        // Refresh data when returning from hospital browsing
        _refreshData();
      },
    );
  }

}

class DoctorsListShimmer extends StatelessWidget {
  const DoctorsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const ShimmerWidget(height: 60, width: 60),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget(height: 16, width: 120),
                    const Gap(8),
                    const ShimmerWidget(height: 14, width: 100),
                    const Gap(8),
                    const ShimmerWidget(height: 12, width: 80),
                  ],
                ),
              ),
              const ShimmerWidget(height: 30, width: 50),
            ],
          ),
        );
      },
    );
  }
}
