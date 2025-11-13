import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DoctorsEmptyState extends StatelessWidget {
  final bool isSearching;

  const DoctorsEmptyState({
    super.key,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const Gap(16),
          Text(
            isSearching ? 'No Doctors Found' : 'No Doctors Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Gap(8),
          Text(
            isSearching
                ? 'Try adjusting your search terms'
                : 'This hospital hasn\'t added any doctors yet',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}