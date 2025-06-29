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
import 'package:h_smart/features/medical_record/presentation/widgets/homeViews/prescriptionChip.dart';

import '../../domain/usecases/userStates.dart';
import 'dart:async';
import '../widgets/homeViews/QuickActionButton.dart';
import '../widgets/homeViews/ScheduleCard.dart';

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
  Timer? _prescriptionAutoScrollTimer;

  // Static variable to persist across widget rebuilds

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _prescriptionController = ScrollController();
    _appointmentController = PageController();

    final isInitialized = ref.read(authProvider).isHomePageInitialized;
    if (!isInitialized) {
      // Schedule your async calls after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.read(authProvider.notifier).loadSavedPayload();
        ref.read(authProvider.notifier).fetchUserInfo();
        ref.read(medicalRecordProvider.notifier).getOverview();
        ref.read(authProvider.notifier).markhometarget(true);
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
    _prescriptionAutoScrollTimer?.cancel();
    super.dispose();
  }

  void _startPrescriptionAutoScroll() {
    _prescriptionAutoScrollTimer?.cancel();
    _prescriptionAutoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_prescriptionController.hasClients) return;
      final maxScroll = _prescriptionController.position.maxScrollExtent;
      final current = _prescriptionController.offset;
      double next = current + 1;
      if (next >= maxScroll) {
        next = 0;
      }
      _prescriptionController.jumpTo(next);
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
        // Only start auto scroll if controller has clients
        if (_prescriptionController.hasClients) {
          _startPrescriptionAutoScroll();
        }
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
                                      child: Builder(
                                        builder: (context) {
                                          // Schedule the auto-scroll after the frame is built
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (_prescriptionController
                                                    .hasClients &&
                                                _prescriptionAutoScrollTimer ==
                                                    null) {
                                              _startPrescriptionAutoScroll();
                                            }
                                          });
                                          return ListView.builder(
                                            controller: _prescriptionController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                prescription?.length ?? 0,
                                            itemBuilder: (context, index) =>
                                                PrescriptionChip(
                                              text:
                                                  '${prescription?[index].dosage ?? ''} of ${prescription?[index].name ?? ''} to be taken ${prescription?[index].frequency ?? ''}',
                                            ),
                                          );
                                        },
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
                    child: ScheduleCard(
                      appointments: ref
                          .watch(medicalRecordProvider)
                          .overview
                          .data
                          .payload
                          ?.appointments,
                      appointmentController: _appointmentController,
                      currentAppointmentIndex: _currentAppointmentIndex,
                      onPageChanged: (int value) {
                        setState(() {
                          _currentAppointmentIndex = value;
                        });
                      },
                    ),
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
                      QuickActionButton(
                        image: 'images/bookappoint.png',
                        title: 'Book Appointment',
                        backgroundColor: const Color(0xffE6EEFF),
                        onTap: () => context.push('/book-appointment'),
                      ),
                      QuickActionButton(
                        image: 'images/Doctors.png',
                        title: 'Doctors',
                        backgroundColor: AppColors.kSuccessColor50,
                        onTap: () => context.push('/doctors'),
                      ),
                      QuickActionButton(
                        image: 'images/medandpres.png',
                        title: 'Medicine & Prescription',
                        backgroundColor: const Color(0xffFDFCED),
                        onTap: () =>
                            context.push('/medical-record/prescriptions'),
                      ),
                      QuickActionButton(
                        image: 'images/symptoms.png',
                        title: 'Symptoms Checker',
                        backgroundColor: const Color(0xffFFF7EB),
                        onTap: () => context.push('/symptoms-checker'),
                      ),
                      QuickActionButton(
                        image: 'images/firstaid.png',
                        title: 'First Aid',
                        backgroundColor: const Color(0xffFFEFEF),
                        onTap: () => SnackBarService.notifyAction(
                          context,
                          message: 'Coming soon!',
                          status: SnackbarStatus.info,
                        ),
                      ),
                      QuickActionButton(
                        image: 'images/hospital.png',
                        title: 'Hospital',
                        backgroundColor: const Color(0xffFDFCED),
                        onTap: () => context.push('/hospital'),
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
}
