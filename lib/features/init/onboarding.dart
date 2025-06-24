import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h_smart/core/utils/appColor.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = [
    const _OnboardingStep(
      image: 'images/1stOboarding.svg',
      title: 'Welcome to H-Smart',
      desc:
          "From scheduling appointments to real-time communication with your doctors, we've got you covered.",
    ),
    const _OnboardingStep(
      image: 'images/2ndOnboading.svg',
      title: 'Explore H-Smart Features',
      desc:
          'Explore features like appointment scheduling for convenient healthcare access, real-time communication with your healthcare providers, and emergency services for peace of mind.',
    ),
    const _OnboardingStep(
      image: 'images/3rdOnboarding.svg',
      title: 'A Central Hub for Your Health',
      desc:
          'Explore additional features like telemedicine for virtual consultations, access to your medical records at your fingertips, and the ability to rate and review your healthcare experiences.',
    ),
  ];

  void _nextPage() async {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      if (mounted) {
        context.go('/welcome');
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _steps.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final step = _steps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Gap(100),
                      SvgPicture.asset(
                        step.image,
                        height: MediaQuery.of(context).size.height * 0.32,
                        fit: BoxFit.contain,
                      ),
                      const Gap(48),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          const Gap(16),
                          Text(
                            step.desc,
                            textAlign: TextAlign.start,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // Page indicators and next button
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.kprimaryColor500
                          : AppColors.kprimaryColor500.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 32,
              child: GestureDetector(
                onTap: _nextPage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: (_currentPage + 1) / _steps.length,
                        strokeWidth: 3,
                        backgroundColor:
                            AppColors.kprimaryColor500.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kprimaryColor500),
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.kprimaryColor500.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.kprimaryColor500,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final String image;
  final String title;
  final String desc;
  const _OnboardingStep({
    required this.image,
    required this.title,
    required this.desc,
  });
}
