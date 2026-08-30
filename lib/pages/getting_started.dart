import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;

import '../router/central_routing.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dark_button.dart';
import '../widgets/icon_action_button.dart';

class GettingStartedPage extends ConsumerStatefulWidget {
  const GettingStartedPage({super.key});

  @override
  ConsumerState<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends ConsumerState<GettingStartedPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted && _pageController.hasClients) {
        final page = _pageController.page ?? 0;
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<_OnboardingData> _slides = [
    const _OnboardingData(
      title: 'Pick your angle',
      description:
          'Every angle gives you a new way to level up your shot with SwishLab.\nUse the Front view to spot and eliminate any sideways movement holding you back.\nSwitch to the Side view to understand your ball path and fine-tune your shooting form with confidence.',
      imagePath: 'assets/images/gs_1.png',
    ),
    const _OnboardingData(
      title: 'Upload a video',
      description:
          'Shoot a new clip or pick one straight from your gallery - whatever works best for you.\nFor tips on getting the most out of your shots, check out the Help section and learn what makes a great video for SwishLab.',
      imagePath: 'assets/images/gs_2.png',
    ),
    const _OnboardingData(
      title: 'Make your clip yours',
      description:
          'Add a few quick details about your video - like a name and a short description - to keep everything organized.\nDon’t worry, SwishLab takes care of the rest and fills in the remaining info automatically.',
      imagePath: 'assets/images/gs_3.png',
    ),
    const _OnboardingData(
      title: 'Processing your shot',
      description:
          'The magic is happening!\nThis is a perfect moment to breathe, stretch, or dive right into the rest of your training session while SwishLab works for you.',
      imagePath: 'assets/images/gs_4.png',
    ),
    const _OnboardingData(
      title: 'Review your performance',
      description:
          'Your breakdown is ready!\nExplore your performance data and read personalized feedback to help you sharpen your form and grow your game.\nStay consistent - every rep moves you forward!',
      imagePath: 'assets/images/gs_5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final hasOpenedBefore = ref.watch(appStateProvider.select((s) => s.hasOpenedBefore));

    return Scaffold(
      backgroundColor: AppThemeManager.secondaryBackground,
      appBar: MyAppBar(
        style: MyAppBarStyle.backButtonTitleLeft,
        title: 'Getting Started',
        onBackPressed: hasOpenedBefore
            ? null
            : () {
                ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                ref.read(routerProvider).goNamed('home');
              },
      ),
      body: Background(
        child: Stack(
          children: [
            // Parallax Background Images
            ...List.generate(_slides.length, (index) {
              final data = _slides[index];
              final double offset = index - _currentPage;

              // Only render the current and adjacent slides for performance
              if (offset.abs() > 1.0) return const SizedBox.shrink();

              return Positioned.fill(
                child: Opacity(
                  opacity: (1 - offset.abs()).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(offset * MediaQuery.of(context).size.width * 0.7, 0),
                    child: Align(
                      alignment: const Alignment(0, -0.85), // Pushed to the top area
                      child: Image.asset(
                        data.imagePath,
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.45,
                        key: ValueKey('onboarding_img_$index'),
                      ),
                    ),
                  ),
                ),
              );
            }),
            // --- END Background layer ---

            // Foreground Content
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                final data = _slides[index];
                final isLast = index == _slides.length - 1;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Glassmorphic Card
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  style: AppTextStyles.headlineLarge(context, color: Colors.black).copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ).animate(key: ValueKey('title_$index')).fade(duration: 400.ms).slideX(begin: 0.2),
                                const SizedBox(height: 16),
                                Text(
                                  data.description,
                                  style: AppTextStyles.bodyMedium(context, color: Colors.black.withValues(alpha: 0.7))
                                      .copyWith(
                                    height: 1.5,
                                  ),
                                )
                                    .animate(key: ValueKey('desc_$index'))
                                    .fade(delay: 100.ms, duration: 400.ms)
                                    .slideX(begin: 0.1),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isLast)
                                      DarkButton(
                                        onPressed: () {
                                          ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                                          ref.read(routerProvider).goNamed('home');
                                        },
                                        text: 'Get Started',
                                      ).animate().scale(delay: 200.ms)
                                    else
                                      IconActionButton(
                                        const Icon(Icons.navigate_next_rounded),
                                        borderRadius: 30,
                                        iconColor: Colors.white,
                                        iconSize: 32,
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration: 600.ms,
                                            curve: Curves.easeOutQuart,
                                          );
                                        },
                                      ).animate().scale(delay: 200.ms),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Space for indicator
                  ],
                );
              },
            ),

            // Page Indicator
            SafeArea(
              child: Align(
                alignment: const AlignmentDirectional(0, 0.94),
                child: smooth_page_indicator.SmoothPageIndicator(
                  controller: _pageController,
                  count: _slides.length,
                  effect: smooth_page_indicator.ExpandingDotsEffect(
                    expansionFactor: 3,
                    spacing: 8,
                    radius: 16,
                    dotWidth: 10,
                    dotHeight: 6,
                    dotColor: appColors.primaryOne.withValues(alpha: 0.2),
                    activeDotColor: appColors.primaryOne,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  const _OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
