import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/Doctor.dart';
import 'package:h_smart/features/doctorRecord/domain/usecases/doctorStates.dart';
import '../widgets/doctor_info_row.dart';
import '../widgets/qualification_item.dart';
import '../widgets/time_slot.dart';
import '../widgets/digital_clock_selector.dart';
import '../provider/doctorprovider.dart';

class DoctorDetailView extends ConsumerStatefulWidget {
  final Doctor doctor;
  const DoctorDetailView({super.key, required this.doctor});

  @override
  ConsumerState<DoctorDetailView> createState() => _DoctorDetailViewState();
}

class _DoctorDetailViewState extends ConsumerState<DoctorDetailView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _imageHeight = 300;
  double _logoSize = 100;
  double _logoPosition = 0;
  double _logoTopPosition = 0;
  double _borderRadius = 20;
  double _titleOpacity = 0;
  final double _minImageHeight = 120;
  final double _maxImageHeight = 300;
  final double _maxLogoSize = 100;
  final double _minLogoSize = 60;
  bool _showInitialLogo = false;
  bool _showCalendar = false;
  late AnimationController _calendarAnimationController;
  late Animation<double> _calendarAnimation;

  // Availability slots will be loaded from API
  List<AvailabilitySlot> _availabilitySlots = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _calendarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _calendarAnimation = CurvedAnimation(
      parent: _calendarAnimationController,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _logoPosition = (MediaQuery.of(context).size.width - _logoSize) / 2;
          _logoTopPosition = _imageHeight - (_logoSize / 2) - 60;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showInitialLogo = true;
            });
          }
        });
        // Load doctor bookings when page opens
        _loadDoctorBookings();
      }
    });
  }

  Future<void> _loadDoctorBookings() async {
    final doctorProvider = ref.read(doctorprovider);
    await doctorProvider.getdoctorBookings(widget.doctor.userId ?? '');
    _convertBookingDataToAvailabilitySlots();
  }

  void _convertBookingDataToAvailabilitySlots() {
    final doctorProvider = ref.read(doctorprovider);
    final bookingResult = doctorProvider.doctorBookingResult;

    if (bookingResult.state == DoctorBookingResultState.isData &&
        bookingResult.response.data != null) {
      setState(() {
        _availabilitySlots = bookingResult.response.data!.map((bookingData) {
          return AvailabilitySlot(
            id: bookingData.id ?? '',
            dayOfWeek: bookingData.dayOfWeek ?? '',
            startTime: bookingData.startTime ?? [],
            endTime: bookingData.endTime ?? [],
            sessionTime: bookingData.sessionTime ?? '1 hour',
            allowslotbetweenbreak: bookingData.allowslotbetweenbreak ?? false,
            chosenTime: [], // No chosen time initially
            doctorName: bookingData.doctorName ?? widget.doctor.fullName,
            hospitalName: bookingData.hospitalName ?? '',
          );
        }).toList();
      });
    } else {
      // If no booking data available, show empty slots or default message
      setState(() {
        _availabilitySlots = [];
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _calendarAnimationController.dispose();
    super.dispose();
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
      if (_showCalendar) {
        _calendarAnimationController.forward();
      } else {
        _calendarAnimationController.reverse();
      }
    });
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollPosition = _scrollController.position.pixels;
    const maxScroll = 200.0;

    final imageHeightProgress = (scrollPosition / maxScroll).clamp(0.0, 1.0);
    final newImageHeight = _maxImageHeight -
        (imageHeightProgress * (_maxImageHeight - _minImageHeight));

    final logoProgress = (scrollPosition / maxScroll).clamp(0.0, 1.0);
    final newLogoSize =
        _maxLogoSize - (logoProgress * (_maxLogoSize - _minLogoSize));

    final screenWidth = MediaQuery.of(context).size.width;
    final centerPosition = (screenWidth - _maxLogoSize) / 2;
    final rightPosition = screenWidth - _minLogoSize - 20;
    final newLogoPosition =
        centerPosition + (logoProgress * (rightPosition - centerPosition));

    final initialTopPosition = _maxImageHeight - (_maxLogoSize / 2) - 60;
    const finalTopPosition = 0.0;
    final newLogoTopPosition = initialTopPosition -
        (logoProgress * (initialTopPosition - finalTopPosition));

    final newTitleOpacity = logoProgress;

    final newBorderRadius = 20 - (imageHeightProgress * 20);

    setState(() {
      _imageHeight = newImageHeight;
      _logoSize = newLogoSize;
      _logoPosition = newLogoPosition;
      _logoTopPosition = newLogoTopPosition;
      _borderRadius = newBorderRadius;
      _titleOpacity = newTitleOpacity;
    });
  }

  Widget _buildBookingContent(ThemeData theme) {
    final doctorProvider = ref.watch(doctorprovider);
    final bookingResult = doctorProvider.doctorBookingResult;

    if (bookingResult.state == DoctorBookingResultState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (bookingResult.state == DoctorBookingResultState.isError) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const Gap(16),
            Text(
              'Failed to load booking information',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              bookingResult.response.message ?? 'Please try again later',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: _loadDoctorBookings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_availabilitySlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const Gap(16),
            Text(
              'No booking slots available',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'This doctor currently has no available booking slots. Please check back later or contact the hospital directly.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 90,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final time = DateTime.now().add(Duration(days: index));
        return TimeSlot(
          date: time,
          theme: theme,
          onTimeSlotTap: () {},
          doctor: widget.doctor,
          availableSlots: _availabilitySlots,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Scrollable Content
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: _imageHeight),
            children: [
              // Doctor Name and Specialization
              Opacity(
                opacity: 1 - _titleOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                  child: Column(
                    children: [
                      Text(
                        'Dr. ${widget.doctor.fullName}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        widget.doctor.specialization ?? 'General Practitioner',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(16),
                      // Book Appointment Button
                      Container(
                        width: double.infinity,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          onPressed: _toggleCalendar,
                          icon: Icon(_showCalendar
                              ? Icons.close
                              : Icons.calendar_today),
                          label: Text(
                            _showCalendar
                                ? 'Cancel Booking'
                                : 'Book Appointment',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showCalendar
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(30),
              // Content Section (About and Qualifications or Calendar)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showCalendar
                    ? Container(
                        key: const ValueKey('calendar'),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Select Available Time',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildBookingContent(theme),
                          ],
                        ),
                      )
                    : Column(
                        key: const ValueKey('info'),
                        children: [
                          // Doctor Information Section
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      theme.colorScheme.shadow.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(12),
                                Text(
                                  widget.doctor.qualification ??
                                      'No biography available.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                                const Gap(20),
                                Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(12),
                                DoctorInfoRow(
                                  icon: Icons.email,
                                  text: widget.doctor.email ?? 'N/A',
                                  theme: theme,
                                ),
                                const Gap(8),
                                DoctorInfoRow(
                                  icon: Icons.phone,
                                  text: widget.doctor.phone ?? 'N/A',
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          // Qualifications Section
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      theme.colorScheme.shadow.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Qualifications',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(12),
                                QualificationItem(
                                  title: 'Medical Degree',
                                  value: widget.doctor.qualification ?? 'N/A',
                                  theme: theme,
                                ),
                                const Gap(8),
                                QualificationItem(
                                  title: 'Experience',
                                  value:
                                      '${widget.doctor.experienceYears ?? 0} years',
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const Gap(30),
            ],
          ),
          // Header with Doctor Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.doctor.profileUrl ?? ''),
                  fit: BoxFit.cover,
                  onError: (_, __) => const Icon(Icons.person, size: 100),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(_borderRadius),
                    bottomRight: Radius.circular(_borderRadius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.shadow.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Doctor Profile Image
          Positioned(
            top: _logoTopPosition,
            left: _logoPosition,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showInitialLogo ? 1.0 : 0.0,
              child: SafeArea(
                child: Container(
                  width: _logoSize,
                  height: _logoSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: theme.colorScheme.surface, width: 3),
                    image: DecorationImage(
                      image: NetworkImage(widget.doctor.profileUrl ?? ''),
                      fit: BoxFit.cover,
                      onError: (_, __) => const Icon(Icons.person, size: 50),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: theme.colorScheme.onSurface),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
