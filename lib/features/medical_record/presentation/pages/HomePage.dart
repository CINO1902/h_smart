import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/medical_record/presentation/provider/medicalRecord.dart';

import '../widgets/AutoScrollText.dart';
import '../widgets/StickyHeader.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _verticalController;
  late final ScrollController _prescriptionController; // NEW

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _prescriptionController =
        ScrollController(); // initialize the dedicated controller
    _startPrescriptionAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authProvider).loadSavedPayload();
      ref.read(authProvider).fetchUserInfo();
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  void _startPrescriptionAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prescriptionController.hasClients) {
        final minExt = _prescriptionController.position.minScrollExtent;
        final maxExt = _prescriptionController.position.maxScrollExtent;
        // Only start auto‐scroll if there is actually something to scroll.
        if (maxExt > minExt) {
          _autoScrollLoop(maxExt, minExt, maxExt);
        }
      }
    });
  }

  void _autoScrollLoop(double max, double min, double target) {
    // Prevent infinite recursion when max == min:
    if (max == min) return;

    _prescriptionController
        .animateTo(target,
            duration: const Duration(seconds: 3), curve: Curves.linear)
        .then((_) {
      // Toggle target between min and max
      final next = (target == max) ? min : max;
      _autoScrollLoop(max, min, next);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for logout state inside build:
    ref.listen<AuthProvider>(authProvider, (previous, next) {
      if (next.isLoggedOut && mounted) {
        SnackBarService.notifyAction(context,
            message: 'Access token has expired', status: SnackbarStatus.fail);
        ref.read(authProvider).resetLoggedOutUser();
        ref.read(authProvider).logout();
        context.go('/login');
      }
    });

    final userdata = ref.watch(authProvider).userData;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────── Top fixed section ───────────
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(5),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 188,
                          height: 64,
                          child: Text(
                            'Welcome back,\n${userdata?.firstName ?? ''}',
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Image.asset(
                          "images/notification.png",
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),

                  // ─── Horizontal prescription scroller ───
                  ref.watch(medicalRecordProvider).loading
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(25, 20, 0, 20),
                          child: SizedBox(
                            height: 25,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap:
                                  true, // optional, but sometimes useful
                              controller: _prescriptionController,
                              children: const [
                                ShimmerWidget.rectangle(width: 100, height: 25),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: SizedBox(
                            height: 25,
                            child: ListView(
                              controller: _prescriptionController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                const SizedBox(width: 20),
                                _buildPrescriptionChip(
                                    "Arthocare Forte: One caplet 2 times /day",
                                    context),
                                const SizedBox(width: 10),
                                _buildPrescriptionChip(
                                    "Paracetamol: Two tablet 2 times /day",
                                    context),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),

            // ─────────── Scrollable section ───────────
            Expanded(
              child: CustomScrollView(
                controller: _verticalController,
                slivers: [
                  // 1) Upcoming schedule card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.027,
                            ),
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color.fromARGB(255, 197, 214, 249)
                                  .withOpacity(.5),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.018,
                            ),
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color.fromARGB(255, 197, 214, 249)
                                  .withOpacity(.5),
                            ),
                          ),
                          Stack(
                            children: [
                              Image.asset('images/background.png'),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTag('Upcoming Schedule', context),
                                    const Gap(20),
                                    const Text(
                                      'Dr. Barbara Emma',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Text(
                                      'General practitioner',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const Gap(15),
                                    _buildTag('July 22, 9:00am', context,
                                        background: const Color(0xff17306B),
                                        textColor: Colors.white,
                                        icon: 'images/calendar.png'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2) Sticky “Quick Action” header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyHeaderDelegate(
                      height: 56,
                      child: const Text(
                        'Quick Action',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // 3) The grid of quick‐action buttons
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    sliver: SliverGrid(
                      delegate: SliverChildListDelegate([
                        QuickAction('images/emergency.png',
                            const Color(0xffFFEFEF), 'Emergency'),
                        QuickAction('images/bookappoint.png',
                            const Color(0xffE6EEFF), 'Book an appointment'),
                        InkWell(
                          onTap: () => Navigator.pushNamed(context, '/Doctor'),
                          child: QuickAction('images/Doctors.png',
                              const Color(0xffF2FBFB), 'Doctors'),
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/MedicineAndPres'),
                          child: QuickAction(
                              'images/medandpres.png',
                              const Color(0xffFDFCED),
                              'Medicine & Prescription'),
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/SymptomsChecker'),
                          child: QuickAction('images/symptoms.png',
                              const Color(0xffFFF7EB), 'Symptoms Checker'),
                        ),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/firstAid'),
                          child: QuickAction('images/firstaid.png',
                              const Color(0xffFFEFEF), 'First Aid'),
                        ),
                        InkWell(
                          onTap: () => context.push('/hospital'),
                          child: QuickAction('images/hospital.png',
                              const Color(0xffFDFCED), 'Hospital'),
                        ),
                      ]),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionChip(String text, BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTag(String label, BuildContext context,
      {Color background = Colors.white,
      Color textColor = Colors.black,
      String? icon}) {
    return Container(
      height: 24,
      width: icon == null ? 107 : null,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Image.asset(icon, height: 15, width: 15),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Container QuickAction(image, color, title) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 87,
            width: 108,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              image,
              scale: 4,
            ),
          ),
          const Gap(5),
          SizedBox(
            width: 90,
            height: 15,
            child: AutoScrollText(
              text: title,
              maxWidth: 90,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
