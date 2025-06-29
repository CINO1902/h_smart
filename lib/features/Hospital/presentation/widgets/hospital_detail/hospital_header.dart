import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/constant/AutoScrollText.dart';

class HospitalHeader extends StatelessWidget {
  final Hospital hospital;
  final double imageHeight;
  final double logoSize;
  final double logoPosition;
  final double logoTopPosition;
  final double borderRadius;
  final double titleOpacity;
  final double titleTopPosition;
  final bool showInitialLogo;
  final bool isScrolled;

  const HospitalHeader({
    super.key,
    required this.hospital,
    required this.imageHeight,
    required this.logoSize,
    required this.logoPosition,
    required this.logoTopPosition,
    required this.borderRadius,
    required this.titleOpacity,
    required this.titleTopPosition,
    required this.showInitialLogo,
    required this.isScrolled,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover Image
        Container(
          height: imageHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: hospital.id ?? '',
                  child: hospital.hospitalsCoverImage != null &&
                          hospital.hospitalsCoverImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: hospital.hospitalsCoverImage!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: imageHeight,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        )
                      : Image.asset(
                          'images/hospital1.png',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: imageHeight,
                        ),
                ),
                // Animated Title
                Positioned(
                  top: titleTopPosition,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: titleOpacity,
                    child: SafeArea(
                      bottom: false,
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AutoScrollText(
                                text: hospital.hospitalName ?? '',
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(0, -1),
                                      blurRadius: 3,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(1, 0),
                                      blurRadius: 3,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(-1, 0),
                                      blurRadius: 3,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  AutoScrollText(
                                    text: '${hospital.city}, ${hospital.state}',
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.4,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                          color: Colors.black87,
                                        ),
                                        Shadow(
                                          offset: Offset(0, -1),
                                          blurRadius: 3,
                                          color: Colors.black87,
                                        ),
                                        Shadow(
                                          offset: Offset(1, 0),
                                          blurRadius: 3,
                                          color: Colors.black87,
                                        ),
                                        Shadow(
                                          offset: Offset(-1, 0),
                                          blurRadius: 3,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Logo
        Positioned(
          top: logoTopPosition,
          left: logoPosition,
          child: isScrolled
              ? SafeArea(
                  bottom: false,
                  child: _buildLogo(),
                )
              : AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: showInitialLogo ? 1.0 : 0.0,
                  child: SafeArea(child: _buildLogo()),
                ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(logoSize / 2),
        child: hospital.logo != null && hospital.logo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: hospital.logo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.business, size: 30),
              )
            : const Icon(Icons.business, size: 30),
      ),
    );
  }
}
