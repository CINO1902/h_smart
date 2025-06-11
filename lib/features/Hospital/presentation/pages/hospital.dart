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
  late TextEditingController _searchController;
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0.1,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        title: const Text('Hospitals', style: TextStyle(fontSize: 17)),
      ),
      body: CustomScrollView(
        slivers: [
          // Search Field
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.grey,
                        hintText: 'Search',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ),

          // SEARCH LOADING SHIMMER
          if (isSearching &&
              hospitalProv.searchResult.state == HospitalResultStates.isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(top: 10, bottom: 30),
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
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hospitals found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try searching with different keywords',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
                  .copyWith(top: 10, bottom: 30),
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
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry.key} Hospitals',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        if (entry.value.length > 3)
                          InkWell(
                            onTap: () {
                              // ref.read(hospitalprovider).disablehero();
                              context.push('/hospital/specific',
                                  extra: {"title": entry.key});
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
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
                          // final globalIndex = data.indexOf(hospital);
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
