import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/dark_button.dart';
import '../widgets/light_button.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // State field(s) for pageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex =>
      pageViewController != null && pageViewController!.hasClients && pageViewController!.page != null
          ? pageViewController!.page!.round()
          : 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppThemeManager.secondaryBackground,
        body: SafeArea(
          top: true,
          child:
              // Container to have a colored background
              Background(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Page view with different pages and content
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                          child: PageView(
                            controller: pageViewController ??= PageController(initialPage: 0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Column to place the content for the first page
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First page image, AI generated on Canva
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(
                                            'assets/images/ai_general.jpg',
                                            width: double.infinity,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // First page title
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Text(
                                        'Understand Your Form',
                                        style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                      ),
                                    ),

                                    // Introduction on the first page
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                                      child: RichText(
                                        textScaler: MediaQuery.of(context).textScaler,
                                        text: CustomTextSpan(
                                          context,
                                          children: [
                                            CustomTextSpan(
                                              context,
                                              text:
                                                  'Your personal AI coach helps you understand your shot. \nTrack your ',
                                              style: AppTextStyles.labelLarge(context),
                                              color: Colors.black,
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'form, ball path,',
                                              italic: true,
                                              color: Colors.black,
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ' and ',
                                              color: Colors.black,
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'movement ',
                                              color: Colors.black,
                                              italic: true,
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'to get simple, actionable insights that make ',
                                              color: Colors.black,
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'every rep count.',
                                              bold: true,
                                              italic: true,
                                              color: Colors.black,
                                            )
                                          ],
                                          style: AppTextStyles.labelLarge(context),
                                          color: AppThemeManager.primaryBackground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Column to place the content for the second page
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Second page image, AI generated on Canva
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(
                                            'assets/images/ai_front.jpg',
                                            width: double.infinity,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Second page title
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Text(
                                        'Keep It Straight',
                                        style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                      ),
                                    ),

                                    // Introduction on the second page
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                                      child: RichText(
                                        textScaler: MediaQuery.of(context).textScaler,
                                        text: CustomTextSpan(
                                          context,
                                          children: [
                                            CustomTextSpan(
                                              context,
                                              text: 'Use the ',
                                              style: AppTextStyles.labelLarge(context,
                                                  color: AppThemeManager.primaryBackground),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'front view ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'to keep your shot straight and balanced. Spot',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ' side drift, arm flare',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ', or ',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: '“chicken wing” ',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'motion, and build a clean, consistent shooting line every time.',
                                              style: const TextStyle(),
                                            )
                                          ],
                                          style: AppTextStyles.labelLarge(context,
                                              color: AppThemeManager.primaryBackground),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Column to place the content for the third page
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Third page image, AI generated on Canva
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(
                                            'assets/images/ai_side.png',
                                            width: double.infinity,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Third page title
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Text(
                                        'Perfect the Flow',
                                        style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                      ),
                                    ),

                                    // Introduction on the third page
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                                      child: RichText(
                                        textScaler: MediaQuery.of(context).textScaler,
                                        text: CustomTextSpan(
                                          context,
                                          children: [
                                            CustomTextSpan(
                                              context,
                                              text: 'See your shot in full motion. The ',
                                              style: AppTextStyles.labelLarge(context,
                                                  color: AppThemeManager.primaryBackground),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'side view',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ' shows ',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'how close',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ' the ball stays to your body, your ',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'set ',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'and ',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'release points',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: ', and whether your shot follows a ',
                                              style: const TextStyle(),
                                            ),
                                            CustomTextSpan(
                                              context,
                                              text: 'smooth forward path.',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            )
                                          ],
                                          style: AppTextStyles.labelLarge(context,
                                              color: AppThemeManager.primaryBackground),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: smooth_page_indicator.SmoothPageIndicator(
                              controller: pageViewController ??= PageController(initialPage: 0),
                              count: 3,
                              axisDirection: Axis.horizontal,
                              onDotClicked: (i) async {
                                await pageViewController!.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              effect: smooth_page_indicator.ExpandingDotsEffect(
                                expansionFactor: 2,
                                spacing: 8,
                                radius: 16,
                                dotWidth: 16,
                                dotHeight: 4,
                                dotColor: appColors.primaryOne,
                                activeDotColor: appColors.primaryTwo,
                                paintStyle: PaintingStyle.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Wrap to place the login and register buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      // Login button
                      LightButton(
                        onPressed: () async {
                          context.goNamed('login');
                        },
                        text: 'Login',
                      ),

                      // Register button
                      DarkButton(
                        onPressed: () async {
                          context.goNamed('signup');
                        },
                        text: 'Register',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
