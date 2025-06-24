import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/AutoScrollText.dart';

class HospitalWidget extends StatelessWidget {
  const HospitalWidget({
    super.key,
    required this.ref,
    required this.hospital,
    this.enableHero = true,
  });

  final WidgetRef ref;

  final Hospital hospital;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double cardHeight = 208;
    const double imageHeight = cardHeight * 0.55;
    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Top image section as background
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: enableHero
                    ? Hero(
                        tag: hospital.id ?? '',
                        child: _buildCoverImage(imageHeight, theme),
                      )
                    : _buildCoverImage(imageHeight, theme),
              ),
              // Logo avatar at bottom center
              Positioned(
                bottom: -15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: theme.colorScheme.surface, width: 2),
                      color: theme.colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: hospital.logo != null && hospital.logo!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: hospital.logo!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: theme.colorScheme.surfaceVariant,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.business,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : Icon(
                              Icons.business,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom content section

          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hospital Name
                    AutoScrollText(
                      text: hospital.hospitalName ?? '',
                      maxWidth: MediaQuery.of(context).size.width * 0.4 - 10,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // const Gap(3),
                    // Location row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/MapPin.png',
                          height: 15,
                          width: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const Gap(4),
                        Text(
                          hospital.city ?? '',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(3),
                    // Time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/dot.svg',
                          color: theme.colorScheme.primary,
                          height: 10,
                          width: 10,
                        ),
                        const Gap(6),
                        Text(
                          '10am - 3pm',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(double imageHeight, ThemeData theme) {
    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: hospital.hospitalsCoverImage != null &&
                  hospital.hospitalsCoverImage!.isNotEmpty
              ? CachedNetworkImageProvider(hospital.hospitalsCoverImage!)
              : const AssetImage('images/hospital1.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: hospital.hospitalsCoverImage == null ||
              hospital.hospitalsCoverImage!.isEmpty
          ? Center(child: Icon(Icons.error, color: theme.colorScheme.error))
          : null,
    );
  }
}
