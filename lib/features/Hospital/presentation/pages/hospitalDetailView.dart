import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/Hospital/domain/entities/DoctorsResponse.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';
import 'package:h_smart/features/Hospital/presentation/widgets/hospital_detail/hospital_header.dart';
import 'package:h_smart/features/Hospital/presentation/widgets/hospital_detail/hospital_info_section.dart';
import 'package:h_smart/features/Hospital/presentation/widgets/hospital_detail/doctors_section.dart';

import '../../domain/states/hospitalStates.dart';

class HospitalDetailView extends ConsumerStatefulWidget {
  final Hospital hospital;
  const HospitalDetailView({super.key, required this.hospital});

  @override
  ConsumerState<HospitalDetailView> createState() => _HospitalDetailViewState();
}

class _HospitalDetailViewState extends ConsumerState<HospitalDetailView> {
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hospitalprovider).callDoctorsbyhospitalid(widget.hospital.id);
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
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    DoctorsResponse doctorsResponse =
        ref.watch(hospitalprovider).doctorResult.response;
    DoctorResultStates doctorResultStates =
        ref.watch(hospitalprovider).doctorResult.state;
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.blue, size: 20),
                          const Gap(4),
                          Text(
                            '${widget.hospital.city}, ${widget.hospital.state}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      // Join Hospital Button
                      Container(
                        width: double.infinity,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Join Hospital functionality coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text(
                            'Connect to Hospital',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kprimaryColor500,
                            foregroundColor: Colors.white,
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
              HospitalInfoSection(hospital: widget.hospital),
              const Gap(20),
              DoctorsSection(
                doctorsResponse: doctorsResponse,
                doctorResultStates: doctorResultStates,
                onRetry: () => ref
                    .read(hospitalprovider)
                    .callDoctorsbyhospitalid(widget.hospital.id),
              ),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
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
