import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/features/Hospital/domain/entities/Doctor.dart';

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
      }
    });
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
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 90,
                              ),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                final time =
                                    DateTime.now().add(Duration(days: index));
                                return _buildTimeSlot(time, theme);
                              },
                            ),
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
                                _buildInfoRow(Icons.email,
                                    widget.doctor.email ?? 'N/A', theme),
                                const Gap(8),
                                _buildInfoRow(Icons.phone,
                                    widget.doctor.phone ?? 'N/A', theme),
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
                                _buildQualificationItem(
                                  'Medical Degree',
                                  widget.doctor.qualification ?? 'N/A',
                                  theme,
                                ),
                                const Gap(8),
                                _buildQualificationItem(
                                  'Experience',
                                  '${widget.doctor.experienceYears ?? 0} years',
                                  theme,
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

  Widget _buildInfoRow(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualificationItem(String title, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(DateTime date, ThemeData theme) {
    final isToday = date.day == DateTime.now().day;
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.2),
          width: isToday ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isWeekend) {
              _showTimeSelectionDialog(context, date);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getDayName(date.weekday),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    if (isToday)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(4),
                Text(
                  '${date.day} ${_getMonthName(date.month)}',
                  style: TextStyle(
                    color: isWeekend
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWeekend
                        ? theme.colorScheme.surface
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isWeekend ? 'Not Available' : 'Available',
                    style: TextStyle(
                      color: isWeekend
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onPrimaryContainer,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  void _showTimeSelectionDialog(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Time for ${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  _DigitalClockSelector(
                    onTimeSelected: (time) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Appointment booked for $time'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitalClockSelector extends StatefulWidget {
  final Function(String) onTimeSelected;

  const _DigitalClockSelector({required this.onTimeSelected});

  @override
  State<_DigitalClockSelector> createState() => _DigitalClockSelectorState();
}

class _DigitalClockSelectorState extends State<_DigitalClockSelector> {
  int _selectedHour = 9;
  int _selectedMinute = 0;
  String _period = 'AM';
  bool _isHourSelected = true;

  void _updateTime() {
    setState(() {
      if (_isHourSelected) {
        _selectedHour = (_selectedHour % 12) + 1;
      } else {
        _selectedMinute = (_selectedMinute + 15) % 60;
      }
    });
  }

  void _togglePeriod() {
    setState(() {
      _period = _period == 'AM' ? 'PM' : 'AM';
    });
  }

  void _toggleSelection() {
    setState(() {
      _isHourSelected = !_isHourSelected;
    });
  }

  String _getFormattedTime() {
    final hour = _selectedHour > 12 ? _selectedHour - 12 : _selectedHour;
    final minute = _selectedMinute.toString().padLeft(2, '0');
    return '$hour:$minute $_period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimePart(
                  _selectedHour.toString(),
                  _isHourSelected,
                  'HOUR',
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                _buildTimePart(
                  _selectedMinute.toString().padLeft(2, '0'),
                  !_isHourSelected,
                  'MIN',
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _togglePeriod,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _period,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _updateTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isHourSelected ? 'Change Hour' : 'Change Minute',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: () => widget.onTimeSelected(_getFormattedTime()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePart(String value, bool isSelected, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }
}
