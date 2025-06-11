import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant/SchimmerWidget.dart';
import '../../domain/states/hospitalStates.dart';
import '../widgets/hospitalBox.dart';
import '../provider/getHospitalProvider.dart';

class SpecificHospital extends ConsumerStatefulWidget {
  final String title;
  const SpecificHospital({super.key, required this.title});

  @override
  ConsumerState<SpecificHospital> createState() => _SpecificHospitalState();
}

class _SpecificHospitalState extends ConsumerState<SpecificHospital> {
  late final String ownershipKey;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ownershipKey = widget.title;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // trigger load of this category
      ref.read(hospitalprovider).getMoreSpecificHospitals(ownershipKey);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(hospitalprovider).getMoreSpecificHospitals(ownershipKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(hospitalprovider);
    final state = provider.hospitalResultMore.state;

    // filter base items
    final base = provider.hospitalData
        .where((h) => h.ownershiptype == ownershipKey)
        .toList();

    // loading first batch
    if (provider.hospitalResult.state == HospitalResultStates.isLoading &&
        base.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: _buildShimmer(count: 10),
      );
    }

    // error
    if (provider.hospitalResult.state == HospitalResultStates.isError) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: Text('Something Went Wrong')),
      );
    }

    final loadingMore =
        state == HospitalResultStates.isLoading && base.isNotEmpty;
    final itemCount =
        base.length + (loadingMore ? 4 : 0) + (provider.hasMoreData ? 0 : 1);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 7,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: itemCount,
                itemBuilder: (context, i) {
                  if (i >= base.length) {
                    if (i == itemCount - 1 && !provider.hasMoreData) {
                      return const SizedBox();
                    }
                    return const ShimmerWidget.rectangle(
                        width: 130, height: 158);
                  }
                  final hospital = base[i];
                  return InkWell(
                    onTap: () {
                      context.push('/hospital/more-detail',
                          extra: {"hospital": hospital});
                    },
                    child: HospitalWidget(
                      ref: ref,
                      hospital: hospital,
                      enableHero: false,
                    ),
                  );
                },
              ),
            ),
            if (!provider.hasMoreData && base.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'You have reached the end of the list',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0.1,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins'),
        title: Text(
          '$ownershipKey Hospitals',
          style: const TextStyle(fontSize: 17),
        ),
      );

  Widget _buildShimmer({int count = 4}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 6 / 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: count,
      itemBuilder: (_, __) =>
          const ShimmerWidget.rectangle(width: 130, height: 158),
    );
  }
}
