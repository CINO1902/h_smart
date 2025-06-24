import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/usecases/userStates.dart';
import '../widgets/AutoScrollText.dart';
import 'dart:async';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _verticalController;
  late final ScrollController _prescriptionController;
  late final PageController _appointmentController;
  int _countdown = 5;
  Timer? _countdownTimer;
  int _reloadAttempts = 0;
  static const int maxReloadAttempts = 5;
  bool _exceededMaxAttempts = false;
  int _currentAppointmentIndex = 0;
  Timer? _appointmentTimer;

  // Static variable to persist across widget rebuilds
  static bool _isHomePageInitialized = false;

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _prescriptionController = ScrollController();
    _appointmentController = PageController();
    _startPrescriptionAutoScroll();
    _startAppointmentAutoScroll();

    // Only initialize once
    if (!_isHomePageInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.read(authProvider).loadSavedPayload();
        ref.read(authProvider).fetchUserInfo();
        ref.read(medicalRecordProvider).getOverview();
        _isHomePageInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _prescriptionController.dispose();
    _appointmentController.dispose();
    _countdownTimer?.cancel();
    _appointmentTimer?.cancel();
    super.dispose();
  }

  void _startPrescriptionAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prescriptionController.hasClients) {
        final minExt = _prescriptionController.position.minScrollExtent;
        final maxExt = _prescriptionController.position.maxScrollExtent;
        if (maxExt > minExt) {
          _autoScrollLoop(maxExt, minExt, maxExt);
        }
      }
    });
  }

  void _autoScrollLoop(double max, double min, double target) {
    if (max == min) return;

    // Calculate duration based on distance to maintain consistent speed
    // Target speed: 50 pixels per second
    const double pixelsPerSecond = 20.0;
    final double distance = (target == max) ? (max - min) : (max - min);
    final int durationMs = (distance / pixelsPerSecond * 1000).round();

    _prescriptionController
        .animateTo(target,
            duration: Duration(milliseconds: durationMs), curve: Curves.linear)
        .then((_) {
      final next = (target == max) ? min : max;
      _autoScrollLoop(max, min, next);
    });
  }

  void _startCountdown() {
    _countdown = 5;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          timer.cancel();
          if (_reloadAttempts < maxReloadAttempts) {
            _reloadAttempts++;
            ref.read(medicalRecordProvider).getOverview();
            // Restart countdown for next attempt
            if (_reloadAttempts < maxReloadAttempts) {
              _startCountdown();
            } else {
              // We've reached max attempts
              _exceededMaxAttempts = true;
            }
          }
        }
      }
    });
  }

  void _manualReload() {
    // Don't reset _reloadAttempts or _exceededMaxAttempts
    // Just attempt to reload
    ref.read(medicalRecordProvider).getOverview();
  }

  void _startAppointmentAutoScroll() {
    final appointments =
        ref.read(medicalRecordProvider).overview.data.payload?.appointments;
    if (appointments == null || appointments.isEmpty) return;

    _appointmentTimer?.cancel();
    _appointmentTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && appointments.isNotEmpty) {
        setState(() {
          _currentAppointmentIndex =
              (_currentAppointmentIndex + 1) % appointments.length;
        });
        _appointmentController.animateToPage(
          _currentAppointmentIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthProvider>(authProvider, (previous, next) {
      if (next.isLoggedOut && mounted) {
        SnackBarService.notifyAction(context,
            message: 'Access token has expired', status: SnackbarStatus.fail);
        ref.read(authProvider).resetLoggedOutUser();
        ref.read(authProvider).logout();
        context.go('/login');
      }
    });

    // Listen to medical record provider to reset countdown when status changes
    ref.listen(medicalRecordProvider, (previous, next) {
      // Cancel timer if overview is loaded (success)
      if (next.overview.status == GetOverResultStates.success) {
        _countdownTimer?.cancel();
        _countdown = 5;
        _reloadAttempts = 0;
        _exceededMaxAttempts = false;
        _startPrescriptionAutoScroll();
        _startAppointmentAutoScroll();
      }
      // If transitioning from fail to success, also reset
      else if (previous?.overview.status == GetOverResultStates.fail &&
          next.overview.status == GetOverResultStates.success) {
        _countdownTimer?.cancel();
        _countdown = 5;
        _reloadAttempts = 0;
        _exceededMaxAttempts = false;
      }
    });

    final userdata = ref.watch(authProvider).userData;
    final theme = Theme.of(context);
    final prescription =
        ref.watch(medicalRecordProvider).overview.data.payload?.prescriptions;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────── Enhanced Header Section ───────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(0.7),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              userdata?.firstName ?? 'User',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                fontFamily: 'Poppins',
                                color: AppColors.kprimaryColor500,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.kprimaryColor500.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.kprimaryColor500.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.kprimaryColor500,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Enhanced Prescription Scroller ───
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: ref.watch(medicalRecordProvider).overview.status ==
                          GetOverResultStates.loading
                      ? const Row(
                          children: [
                            ShimmerWidget.rectangle(width: 120, height: 32),
                            Gap(8),
                            ShimmerWidget.rectangle(width: 140, height: 32),
                          ],
                        )
                      : ref.watch(medicalRecordProvider).overview.status ==
                              GetOverResultStates.idle
                          ? const SizedBox()
                          : ref.watch(medicalRecordProvider).overview.status ==
                                  GetOverResultStates.success
                              ? prescription?.isEmpty ?? false
                                  ? const SizedBox()
                                  : Container(
                                      height: 36,
                                      child: ListView.builder(
                                        controller: _prescriptionController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: prescription?.length ?? 0,
                                        itemBuilder: (context, index) =>
                                            _buildEnhancedPrescriptionChip(
                                          '${prescription?[index].dosage ?? ''} of ${prescription?[index].name ?? ''} to be taken ${prescription?[index].frequency ?? ''}',
                                          context,
                                        ),
                                      ),
                                    )
                              : ref
                                          .watch(medicalRecordProvider)
                                          .overview
                                          .status ==
                                      GetOverResultStates.fail
                                  ? Builder(
                                      builder: (context) {
                                        // Start countdown when fail state is detected and attempts remaining
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (_countdown == 5 &&
                                              _reloadAttempts <
                                                  maxReloadAttempts &&
                                              !_exceededMaxAttempts) {
                                            _startCountdown();
                                          }
                                        });

                                        if (_exceededMaxAttempts) {
                                          // Show tap to reload after max attempts
                                          return GestureDetector(
                                            onTap: _manualReload,
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.refresh,
                                                  size: 16,
                                                  color:
                                                      AppColors.kErrorColor500,
                                                ),
                                                Gap(8),
                                                Text(
                                                  'Failed to load prescription. Tap to reload',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors
                                                        .kErrorColor500,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // Show countdown for automatic reload
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.refresh,
                                                size: 16,
                                                color: AppColors.kErrorColor500,
                                              ),
                                              const Gap(8),
                                              Text(
                                                'Failed to load prescription. Reloading in $_countdown seconds... (Attempt ${_reloadAttempts + 1}/$maxReloadAttempts)',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.kErrorColor500,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    )
                                  : const SizedBox(),
                ),
              ],
            ),
          ),

          // ─────────── Enhanced Scrollable Content ───────────
          Expanded(
            child: CustomScrollView(
              controller: _verticalController,
              slivers: [
                // Enhanced Upcoming Schedule Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: _buildEnhancedScheduleCard(context),
                  ),
                ),

                // Enhanced Quick Action Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.kprimaryColor500.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.flash_on_rounded,
                            color: AppColors.kprimaryColor500,
                            size: 20,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: 'Poppins',
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Enhanced Quick Action Grid
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    delegate: SliverChildListDelegate([
                      _buildEnhancedQuickAction(
                        'images/bookappoint.png',
                        'Book Appointment',
                        const Color(0xffE6EEFF),
                        () => context.push('/book-appointment'),
                      ),
                      _buildEnhancedQuickAction(
                        'images/Doctors.png',
                        'Doctors',
                        AppColors.kSuccessColor50,
                        () => context.push('/doctors'),
                      ),
                      _buildEnhancedQuickAction(
                        'images/medandpres.png',
                        'Medicine & Prescription',
                        const Color(0xffFDFCED),
                        () => context.push('/medicine-prescription'),
                      ),
                      _buildEnhancedQuickAction(
                        'images/symptoms.png',
                        'Symptoms Checker',
                        const Color(0xffFFF7EB),
                        () => context.push('/symptoms-checker'),
                      ),
                      _buildEnhancedQuickAction(
                        'images/firstaid.png',
                        'First Aid',
                        const Color(0xffFFEFEF),
                        () => SnackBarService.notifyAction(
                          context,
                          message: 'Coming soon!',
                          status: SnackbarStatus.info,
                        ),
                      ),
                      _buildEnhancedQuickAction(
                        'images/hospital.png',
                        'Hospital',
                        const Color(0xffFDFCED),
                        () => context.push('/hospital'),
                      ),
                    ]),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Gap(20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPrescriptionChip(String text, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.kprimaryColor500.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.kprimaryColor500.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kprimaryColor500.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor500.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 16,
              color: AppColors.kprimaryColor500,
            ),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.kprimaryColor500,
                fontFamily: 'Poppins',
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedScheduleCard(BuildContext context) {
    final appointments =
        ref.watch(medicalRecordProvider).overview.data.payload?.appointments;

    if (appointments == null || appointments.isEmpty) {
      // Show empty state
      return SizedBox(
        height: 180,
        child: Stack(
          children: [
            // Background color and SVG patterns
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor100,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Up SVG at top right
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/up.svg',
                width: 48,
                height: 48,
              ),
            ),
            // Down SVG at bottom right
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/down.svg',
                width: 48,
                height: 48,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: 16,
                        ),
                        Gap(6),
                        Text(
                          'Upcoming Schedule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'No upcoming appointments',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Book your next appointment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sideMargin = width * 0.03; // 3% of the width
        final svgSize = width * 0.3; // 25% of the width

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Background fills, with relative horizontal padding
            Positioned.fill(
              // left: sideMargin,
              // right: sideMargin,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kprimaryColor500,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // "Up" SVG aligned to the top right, sized proportionally
            Positioned(
              top: 0, // slight overlap
              right: sideMargin - svgSize * 0.005,
              child: SvgPicture.asset(
                'images/up.svg',
                width: svgSize,
                height: svgSize,
              ),
            ),

            // "Down" SVG at bottom right
            Positioned(
              bottom: 0,
              right: sideMargin - svgSize * 0.005,
              child: SvgPicture.asset(
                'images/down.svg',
                width: svgSize,
                height: svgSize,
              ),
            ),
            // Appointment carousel
            PageView.builder(
              controller: _appointmentController,
              onPageChanged: (index) {
                setState(() {
                  _currentAppointmentIndex = index;
                });
              },
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final appointmentDate = appointment.date;
                final appointmentTime = appointment.time;

                // Format date
                String formattedDate = 'No date set';
                String formattedTime = 'No time set';

                if (appointmentDate != null) {
                  formattedDate =
                      '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}';
                }

                if (appointmentTime != null) {
                  formattedTime = appointmentTime;
                }

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const Gap(6),
                                Text(
                                  'Appointment ${index + 1} of ${appointments.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Text(
                        appointment.doctorName ?? 'Doctor Name',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialization ?? 'Specialization',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const Gap(6),
                                Text(
                                  '$formattedDate, $formattedTime',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(appointment.status)
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appointment.status ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // Page indicator dots
            if (appointments.length > 1)
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    appointments.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentAppointmentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEnhancedQuickAction(
      String image, String title, Color backgroundColor, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: backgroundColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                image,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(12),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 25,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? Colors.black
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
