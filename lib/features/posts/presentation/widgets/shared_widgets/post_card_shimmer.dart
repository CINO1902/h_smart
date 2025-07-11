import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and title
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar shimmer
                ShimmerWidget.rectangle(
                  height: 48,
                  width: 48,
                ),
                Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name shimmer
                      ShimmerWidget.rectangle(
                        height: 14,
                        width: 120,
                      ),
                      const Gap(8),
                      // Category and time shimmer
                      Row(
                        children: [
                          ShimmerWidget.rectangle(
                            height: 12,
                            width: 60,
                          ),
                          Gap(12),
                          ShimmerWidget.rectangle(
                            height: 12,
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget.rectangle(
                  height: 12,
                  width: double.infinity,
                ),
                const Gap(8),
                const ShimmerWidget.rectangle(
                  height: 12,
                  width: double.infinity,
                ),
                const Gap(8),
                ShimmerWidget.rectangle(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ],
            ),
          ),
          const Gap(16),
          // Tags shimmer
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ShimmerWidget.rectangle(
                  height: 24,
                  width: 80,
                ),
                Gap(8),
                ShimmerWidget.rectangle(
                  height: 24,
                  width: 80,
                ),
              ],
            ),
          ),
          const Gap(16),
          // Image shimmer
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerWidget.rectangle(
              height: 200,
              width: double.infinity,
            ),
          ),
          // Action buttons shimmer
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ShimmerWidget.rectangle(
                  height: 32,
                  width: 80,
                ),
                Gap(16),
                ShimmerWidget.rectangle(
                  height: 32,
                  width: 80,
                ),
                Spacer(),
                ShimmerWidget.rectangle(
                  height: 32,
                  width: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
