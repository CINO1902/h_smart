import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/doctorRecord/domain/entities/DoctorsResponse.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:h_smart/features/Hospital/presentation/widgets/hospital_detail/hospital_header.dart';
import 'package:h_smart/features/Hospital/presentation/widgets/hospital_detail/hospital_info_section.dart';
import 'package:h_smart/features/doctorRecord/presentation/widgets/doctors_section.dart';

import '../../domain/states/hospitalStates.dart';
import '../widgets/connectHospitalButton.dart';

class HospitalDetailView extends ConsumerStatefulWidget {
  final Hospital hospital;
  final WidgetRef homeref;
  const HospitalDetailView(
      {super.key, required this.hospital, required this.homeref});

  @override
  ConsumerState<HospitalDetailView> createState() => _HospitalDetailViewState();
}

class _HospitalDetailViewState extends ConsumerState<HospitalDetailView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _imageHeight = 400;
  double _logoSize = 90;
  double _logoPosition = 0;
  double _logoTopPosition = 0;
  double _borderRadius = 20;
  double _titleOpacity = 0;
  double _titleTopPosition = 0;
  final double _minImageHeight = 120;
  final double _maxImageHeight = 400;
  final double _maxLogoSize = 90;
  final double _minLogoSize = 50;
  bool _showInitialLogo = false;

  // Animation controllers for button transitions
  late AnimationController _buttonAnimationController;
  late AnimationController _iconAnimationController;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize animation controllers
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch doctors if user is connected to the hospital
      if (widget.hospital.isConnected == true) {
        ref.read(hospitalprovider).callDoctorsbyhospitalid(widget.hospital.id);
      }
      if (mounted) {
        setState(() {
          _logoPosition = (MediaQuery.of(context).size.width - _logoSize) / 2;
          _logoTopPosition = _imageHeight - (_logoSize / 2) - 60;
          _titleTopPosition = _imageHeight + 40;
        });
        // Add delay for initial logo appearance
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
  void deactivate() {
    // TODO: implement deactivate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.homeref.read(hospitalprovider).disposeTapToConnect();
      widget.homeref.read(hospitalprovider).disposeTapToDisconnect();
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _buttonAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollPosition = _scrollController.position.pixels;
    const maxScroll = 200.0; // Adjust this value to control animation speed

    // Calculate image height animation
    final imageHeightProgress = (scrollPosition / maxScroll).clamp(0.0, 1.0);
    final newImageHeight = _maxImageHeight -
        (imageHeightProgress * (_maxImageHeight - _minImageHeight));

    // Calculate logo size and position animation
    final logoProgress = (scrollPosition / maxScroll).clamp(0.0, 1.0);
    final newLogoSize =
        _maxLogoSize - (logoProgress * (_maxLogoSize - _minLogoSize));

    // Calculate new logo position - start from center and move to right
    final screenWidth = MediaQuery.of(context).size.width;
    final centerPosition = (screenWidth - _maxLogoSize) / 2;
    final rightPosition =
        screenWidth - _minLogoSize - 20; // 20 is the right margin
    final newLogoPosition =
        centerPosition + (logoProgress * (rightPosition - centerPosition));

    // Calculate logo vertical position
    final initialTopPosition = _maxImageHeight - (_maxLogoSize / 2) - 60;
    const finalTopPosition = 0.0; // Start from the very top
    final newLogoTopPosition = initialTopPosition -
        (logoProgress * (initialTopPosition - finalTopPosition));

    // Calculate title position and opacity
    final initialTitlePosition = _maxImageHeight + 40;
    const finalTitlePosition = 0.0; // Start from the very top
    final newTitleTopPosition = initialTitlePosition -
        (logoProgress * (initialTitlePosition - finalTitlePosition));
    final newTitleOpacity = logoProgress;

    // Calculate border radius animation
    final newBorderRadius = 20 - (imageHeightProgress * 20);

    setState(() {
      _imageHeight = newImageHeight;
      _logoSize = newLogoSize;
      _logoPosition = newLogoPosition;
      _logoTopPosition = newLogoTopPosition;
      _borderRadius = newBorderRadius;
      _titleOpacity = newTitleOpacity;
      _titleTopPosition = newTitleTopPosition;
    });
  }

  Widget _buildConnectionRequiredMessage(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Doctors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        const Gap(15),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(24),
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
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const Gap(16),
              Text(
                'Connect to Hospital Required',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'You need to connect to this hospital to view the list of doctors and their information.',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              Text(
                'Please use the "Connect to Hospital" button above to get access.',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectState =
        ref.watch(hospitalprovider).connectToHospitalResult.state;
    DoctorsResponse doctorsResponse =
        ref.watch(hospitalprovider).doctorResult.response;
    DoctorResultStates doctorResultStates =
        ref.watch(hospitalprovider).doctorResult.state;

    // Automatically fetch doctors when user successfully connects
    if (connectState == ConnectToHospitalResultStates.isData &&
        widget.hospital.isConnected == true &&
        doctorResultStates == DoctorResultStates.isIdle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(hospitalprovider).callDoctorsbyhospitalid(widget.hospital.id);
      });
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Scrollable Content
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: _imageHeight),
            children: [
              // Hospital Name and Location (only visible when not in header)
              Opacity(
                opacity: 1 - _titleOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                  child: Column(
                    children: [
                      Text(
                        widget.hospital.hospitalName ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              color: theme.colorScheme.primary, size: 20),
                          const Gap(4),
                          Text(
                            '${widget.hospital.city}, ${widget.hospital.state}',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      // Hospital Connection Button with Animation
                      Container(
                          width: double.infinity,
                          height: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: AnimatedConnectionButton(
                            hospital: widget.hospital,
                            iconAnimationController: _iconAnimationController,
                            iconRotationAnimation: _iconRotationAnimation,
                          )),
                    ],
                  ),
                ),
              ),
              const Gap(30),
              HospitalInfoSection(hospital: widget.hospital),
              const Gap(20),
              // Conditionally show doctors section based on connection status
              widget.hospital.isConnected == true
                  ? DoctorsSection(
                      doctorsResponse: doctorsResponse,
                      doctorResultStates: doctorResultStates,
                      onRetry: () => ref
                          .read(hospitalprovider)
                          .callDoctorsbyhospitalid(widget.hospital.id),
                    )
                  : _buildConnectionRequiredMessage(context),
              const Gap(30),
            ],
          ),
          // Header
          HospitalHeader(
            hospital: widget.hospital,
            imageHeight: _imageHeight,
            logoSize: _logoSize,
            logoPosition: _logoPosition,
            logoTopPosition: _logoTopPosition,
            borderRadius: _borderRadius,
            titleOpacity: _titleOpacity,
            titleTopPosition: _titleTopPosition,
            showInitialLogo: _showInitialLogo,
            isScrolled: _scrollController.hasClients &&
                _scrollController.position.pixels > 0,
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
                  onPressed: () => context.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
