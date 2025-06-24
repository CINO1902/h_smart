import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/Hospital/presentation/provider/getHospitalProvider.dart';

import '../../domain/states/hospitalStates.dart';
import '../widgets/hospitalBox.dart';

class Hospital extends ConsumerStatefulWidget {
  const Hospital({super.key});

  @override
  ConsumerState<Hospital> createState() => _HospitalState();
}

class _HospitalState extends ConsumerState<Hospital> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hospitalprovider).getHospital();
    });
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    if (text.isEmpty) {
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
      });
      ref.read(hospitalprovider).searchHospital(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hospitalProv = ref.watch(hospitalprovider);
    final data =
        isSearching ? hospitalProv.searchData : hospitalProv.hospitalData;

    // Group hospitals by ownershipType
    final Map<String, List> grouped = {};
    for (var h in data) {
      final key = h.ownershiptype ?? 'Unknown';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(h);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.1,
        title: Text(
          'Hospitals',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Search Field
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Hospitals',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Search for hospitals in your area',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                  const Gap(20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 12),
                        border: InputBorder.none,
                        hintText: 'Search hospitals',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SEARCH LOADING SHIMMER
          if (isSearching &&
              hospitalProv.searchResult.state == HospitalResultStates.isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(top: 20, bottom: 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) =>
                      const ShimmerWidget.rectangle(width: 130, height: 158),
                  childCount: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            )
          // SEARCH EMPTY STATE
          else if (isSearching &&
              hospitalProv.searchResult.state == HospitalResultStates.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hospitals found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try searching with different keywords',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          // NORMAL LOADING SHIMMER
          else if (!isSearching &&
              hospitalProv.hospitalResult.state ==
                  HospitalResultStates.isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(top: 20, bottom: 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) =>
                      const ShimmerWidget.rectangle(width: 130, height: 158),
                  childCount: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            )
          // NORMAL/SEARCH RESULTS
          else ...[
            // Sticky headers per section
            for (var entry in grouped.entries)
              if (entry.value.isNotEmpty)
                SliverStickyHeader(
                  header: Container(
                    color: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry.key} Hospitals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        if (entry.value.length > 3)
                          InkWell(
                            onTap: () {
                              context.push('/hospital/specific',
                                  extra: {"title": entry.key});
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(top: 10, bottom: 30),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, idx) {
                          final items = entry.value;
                          final hospital = items[idx];
                          return InkWell(
                            onTap: () {
                              context.push('/hospital/more-detail',
                                  extra: {"hospital": hospital});
                            },
                            child: HospitalWidget(
                              ref: ref,
                              hospital: hospital,
                            ),
                          );
                        },
                        childCount:
                            entry.value.length > 4 ? 4 : entry.value.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 6 / 7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
