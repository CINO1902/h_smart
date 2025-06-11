import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/Hospital/domain/entities/GetHospital.dart';
import 'package:h_smart/core/utils/appColor.dart';

class HospitalInfoSection extends StatelessWidget {
  final Hospital hospital;

  const HospitalInfoSection({
    super.key,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hospital Capacity Section
        _buildSection(
          'Hospital Capacity',
          [
            _buildInfoItem(
              'Total Beds',
              '${hospital.totalBeds}',
              Icons.bed,
            ),
            _buildInfoItem(
              'ICU Beds',
              '${hospital.icuBeds}',
              Icons.medical_services,
            ),
            _buildInfoItem(
              'Operation Theaters',
              '${hospital.operationTheaters}',
              Icons.meeting_room,
            ),
          ],
        ),
        const Gap(20),
        // Facilities Section
        _buildSection(
          'Facilities',
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: hospital.facilities
                        ?.map((facility) => _buildFacilityItem(facility))
                        .toList() ??
                    [],
              ),
            ),
          ],
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
            ),
            _buildInfoItem(
              'Registration Number',
              hospital.registrationNumber ?? '',
              Icons.numbers,
            ),
            _buildInfoItem(
              'Ownership Type',
              hospital.ownershiptype ?? '',
              Icons.business,
            ),
            _buildInfoItem(
              'Status',
              hospital.status ?? '',
              Icons.circle,
            ),
          ],
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
            ),
            _buildInfoItem(
              'Email',
              hospital.adminEmail ?? '',
              Icons.email,
            ),
            _buildInfoItem(
              'Phone',
              hospital.adminPhone ?? '',
              Icons.phone,
            ),
          ],
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
            ),
            _buildInfoItem(
              'Phone',
              hospital.phone ?? '',
              Icons.phone,
            ),
            _buildInfoItem(
              'Address',
              '${hospital.street}, ${hospital.city}, ${hospital.state}, ${hospital.zipcode}',
              Icons.location_on,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(15),
        ...children,
      ],
    );
  }

  Widget _buildFacilityItem(String facility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.kprimaryColor500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_circle,
                color: AppColors.kprimaryColor500, size: 20),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              facility,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.kprimaryColor500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.kprimaryColor500, size: 24),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
