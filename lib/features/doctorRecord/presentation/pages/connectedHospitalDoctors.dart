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
      return _buildHospitalShimmer();
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
              hospitalProvider.defaultHospitalResult.response.message ??
                  'Unknown error',
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
                _buildConnectedHospitalHeader(theme),
                const Gap(20),
                _buildSearchField(theme),
                const Gap(20),
                Expanded(child: _buildDoctorsList(hospitalProvider, theme)),
              ],
            ),
          ),
        );
      }
    }

    // No connected hospital
    return _buildNoConnectedHospitalView(context, theme);
  }

  Widget _buildNoConnectedHospitalView(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.local_hospital_outlined,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const Gap(20),
                  Text(
                    'No Connected Hospital',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  Text(
                    'You need to connect to a hospital first to view their doctors and book appointments.',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        _hasNavigatedAway = true;
                        await context.push('/hospital');
                        // Refresh data when returning from hospital browsing
                        _refreshData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kprimaryColor500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Browse Hospitals',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedHospitalHeader(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        context.push('/hospital/more-detail',
            extra: {"hospital": connectedHospital, "homeref": ref});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_hospital,
                color: AppColors.kprimaryColor500,
                size: 24,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connected to',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    connectedHospital?.hospitalName ?? 'Unknown Hospital',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (connectedHospital?.city != null) ...[
                    const Gap(2),
                    Text(
                      '${connectedHospital!.city}, ${connectedHospital!.country}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Connected',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        hintText: 'Search doctors by name or specialization',
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.kprimaryColor500,
            width: 2,
          ),
        ),
      ),
      onChanged: _filterDoctors,
    );
  }

  Widget _buildDoctorsList(hospitalProvider, ThemeData theme) {
    if (hospitalProvider.doctorResult.state == DoctorResultStates.isLoading) {
      return _buildDoctorsListShimmer();
    }

    if (hospitalProvider.doctorResult.state == DoctorResultStates.isError) {
      return _buildErrorState(theme);
    }

    if (filteredDoctors.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filteredDoctors[index];
        return _buildDoctorCard(doctor, theme);
      },
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const Gap(16),
          Text(
            'Failed to load doctors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Gap(8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () {
              if (connectedHospital != null) {
                ref
                    .read(hospitalprovider)
                    .callDoctorsbyhospitalid(connectedHospital!.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kprimaryColor500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const Gap(16),
          Text(
            searchQuery.isEmpty ? 'No Doctors Available' : 'No Doctors Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Gap(8),
          Text(
            searchQuery.isEmpty
                ? 'This hospital hasn\'t added any doctors yet'
                : 'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/doctor/detail', extra: {"doctor": doctor});
          // Navigate to doctor detail page
          // You can implement this based on your existing doctor detail navigation
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Doctor Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.kprimaryColor500.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: doctor.profileUrl != null &&
                          doctor.profileUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: doctor.profileUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.kprimaryColor500.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.kprimaryColor500,
                              size: 30,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.kprimaryColor500.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.kprimaryColor500,
                              size: 30,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.kprimaryColor500,
                          size: 30,
                        ),
                ),
              ),
              const Gap(16),
              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (doctor.specialization != null) ...[
                      const Gap(4),
                      Text(
                        doctor.specialization!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kprimaryColor500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (doctor.experienceYears != null) ...[
                      const Gap(4),
                      Text(
                        '${doctor.experienceYears} years experience',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                    if (doctor.qualification != null) ...[
                      const Gap(4),
                      Text(
                        doctor.qualification!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Action Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.kprimaryColor500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.kprimaryColor500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalShimmer() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital info shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(height: 20, width: 150),
                const Gap(8),
                const ShimmerWidget(height: 16, width: 200),
                const Gap(16),
                const ShimmerWidget(height: 40, width: double.infinity),
              ],
            ),
          ),
          const Gap(24),
          // Search bar shimmer
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const ShimmerWidget(height: 50, width: double.infinity),
          ),
          const Gap(16),
          // Doctors list shimmer
          Expanded(child: _buildDoctorsListShimmer()),
        ],
      ),
    );
  }

  Widget _buildDoctorsListShimmer() {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar shimmer
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ShimmerWidget(height: 60, width: 60),
              ),
              const Gap(16),
              // Doctor info shimmer
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
              // Action button shimmer
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const ShimmerWidget(height: 30, width: 50),
              ),
            ],
          ),
        );
      },
    );
  }
}
