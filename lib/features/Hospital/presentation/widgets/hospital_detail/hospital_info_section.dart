import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/AutoScrollText.dart';

class HospitalInfoSection extends StatelessWidget {
  final Hospital hospital;

  const HospitalInfoSection({
    super.key,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final isTablet = constraints.maxWidth > 600;
        final itemWidth = isTablet ? (constraints.maxWidth - 40) / 3 : 200.0;

        return Column(
          children: [
            // Hospital Capacity Section
            _buildSection(
              'Hospital Capacity',
              [
                isTablet
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildCapacityItem(
                              'Total Beds',
                              '${hospital.totalBeds}',
                              Icons.bed,
                              context,
                              width: itemWidth,
                            ),
                          ),
                          Expanded(
                            child: _buildCapacityItem(
                              'ICU Beds',
                              '${hospital.icuBeds}',
                              Icons.medical_services,
                              context,
                              width: itemWidth,
                            ),
                          ),
                          Expanded(
                            child: _buildCapacityItem(
                              'Operation Theaters',
                              '${hospital.operationTheaters}',
                              Icons.meeting_room,
                              context,
                              width: itemWidth,
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCapacityItem(
                              'Total Beds',
                              '${hospital.totalBeds}',
                              Icons.bed,
                              context,
                              width: itemWidth,
                            ),
                            _buildCapacityItem(
                              'ICU Beds',
                              '${hospital.icuBeds}',
                              Icons.medical_services,
                              context,
                              width: itemWidth,
                            ),
                            _buildCapacityItem(
                              'Operation Theaters',
                              '${hospital.operationTheaters}',
                              Icons.meeting_room,
                              context,
                              width: itemWidth,
                            ),
                          ],
                        ),
                      ),
              ],
              context,
            ),
            const Gap(20),
            // Facilities Section
            _buildSection(
              'Facilities',
              [
                Container(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: hospital.facilities
                            ?.map((facility) => Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: _buildFacilityItem(facility, context),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
              ],
              context,
            ),
            const Gap(20),
            // Registration Details Section
            _buildSection(
              'Registration Details',
              [
                _buildInfoItem(
                  'License Number',
                  hospital.licenseNumber ?? '',
                  Icons.verified,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Registration Number',
                  hospital.registrationNumber ?? '',
                  Icons.numbers,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Ownership Type',
                  hospital.ownershiptype ?? '',
                  Icons.business,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Status',
                  hospital.status ?? '',
                  Icons.circle,
                  context,
                  fullWidth: true,
                ),
              ],
              context,
            ),
            const Gap(20),
            // Administrator Section
            _buildSection(
              'Administrator',
              [
                _buildInfoItem(
                  'Name',
                  '${hospital.adminFirstName} ${hospital.adminLastName}',
                  Icons.person,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Email',
                  hospital.adminEmail ?? '',
                  Icons.email,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Phone',
                  hospital.adminPhone ?? '',
                  Icons.phone,
                  context,
                  fullWidth: true,
                ),
              ],
              context,
            ),
            const Gap(20),
            // Contact Information Section
            _buildSection(
              'Contact Information',
              [
                _buildInfoItem(
                  'Email',
                  hospital.email ?? '',
                  Icons.email,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Phone',
                  hospital.phone ?? '',
                  Icons.phone,
                  context,
                  fullWidth: true,
                ),
                _buildInfoItem(
                  'Address',
                  '${hospital.street}, ${hospital.city}, ${hospital.state}, ${hospital.zipcode}',
                  Icons.location_on,
                  context,
                  fullWidth: true,
                ),
              ],
              context,
            ),
            const Gap(30),
          ],
        );
      },
    );
  }

  Widget _buildSection(
      String title, List<Widget> children, BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        const Gap(15),
        ...children,
      ],
    );
  }

  Widget _buildFacilityItem(String facility, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_circle,
                color: theme.colorScheme.primary, size: 20),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              facility,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityItem(
      String label, String value, IconData icon, BuildContext context,
      {double? width}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      width: width ?? 200,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoScrollText(
                  text: label,
                  maxWidth: 100,
                  align: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, IconData icon, BuildContext context,
      {bool fullWidth = false, double? width}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      width: fullWidth ? double.infinity : width ?? 200,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoScrollText(
                  text: label,
                  maxWidth: MediaQuery.of(context).size.width * 0.8 - 100,
                  align: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
