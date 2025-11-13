import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';

class HospitalShimmer extends StatelessWidget {
  const HospitalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital info shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(height: 20, width: 150),
                Gap(8),
                ShimmerWidget(height: 16, width: 200),
                Gap(16),
                ShimmerWidget(height: 40, width: double.infinity),
              ],
            ),
          ),
          const Gap(24),
          // Search bar shimmer
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const ShimmerWidget(height: 50, width: double.infinity),
          ),
          const Gap(16),
          // Doctors list shimmer
          const Expanded(child: DoctorsListShimmer()),
        ],
      ),
    );
  }
}

class DoctorsListShimmer extends StatelessWidget {
  const DoctorsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              // Avatar shimmer
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: ShimmerWidget(height: 60, width: 60),
              ),
              Gap(16),
              // Doctor info shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(height: 16, width: 120),
                    Gap(8),
                    ShimmerWidget(height: 14, width: 100),
                    Gap(8),
                    ShimmerWidget(height: 12, width: 80),
                  ],
                ),
              ),
              // Action button shimmer
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: ShimmerWidget(height: 30, width: 50),
              ),
            ],
          ),
        );
      },
    );
  }
}