import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;

import '../functions/add_animation.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dark_button.dart';
import '../widgets/icon_action_button.dart';

/// Page to help the user understand how the system works
class GettingStartedPage extends ConsumerStatefulWidget {
  const GettingStartedPage({super.key});

  @override
  ConsumerState<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends ConsumerState<GettingStartedPage> with TickerProviderStateMixin {
  PageController? stepSlideShowController;

  int get stepSlideShowCurrentIndex =>
      stepSlideShowController != null && stepSlideShowController!.hasClients && stepSlideShowController!.page != null
          ? stepSlideShowController!.page!.round()
          : 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    final hasOpenedBefore = ref.watch(appStateProvider.select((s) => s.hasOpenedBefore));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppThemeManager.secondaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'Getting started',
          onBackPressed: hasOpenedBefore
              ? null // Default behavior (pop to settings)
              : () {
                  ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                  context.goNamed('home');
                },
        ),
        body:
            // Background container
            Background(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                PageView(
                  controller: stepSlideShowController ??= PageController(initialPage: 0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Page 1
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Image depicting the choose angle step
                          addAnimation(
                              widget: Image.asset(
                                'assets/images/gs_1.png',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.45,
                                fit: BoxFit.contain,
                              ),
                              scale: const ScaleConfig(begin: Offset(1.2, 1.2))),

                          // Column to place the text for the choose angle page
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step title
                                addAnimation(
                                    widget: Text(
                                      'Pick your angle',
                                      style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 60))),

                                // Step description
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: addAnimation(
                                      widget: Text(
                                        'Every angle gives you a new way to level up your shot with SwishLab.\nUse the Front view to spot and eliminate any sideways movement holding you back.\nSwitch to the Side view to understand your ball path and fine-tune your shooting form with confidence.',
                                        style: AppTextStyles.labelMedium(context, color: Colors.black),
                                      ),
                                      move: const MoveConfig(begin: Offset(0, 80))),
                                ),

                                // Row to place the next button
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Next button
                                      addAnimation(
                                          widget: IconActionButton(
                                            const Icon(Icons.navigate_next_rounded),
                                            borderRadius: 30,
                                            iconColor: AppThemeManager.secondaryText,
                                            iconSize: 30,
                                            onPressed: () async {
                                              await stepSlideShowController?.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          scale: const ScaleConfig(begin: Offset(0.4, 0.4))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // Page 2
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Image depicting the upload video step
                          addAnimation(
                              widget: Image.asset(
                                'assets/images/gs_2.png',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.45,
                                fit: BoxFit.contain,
                              ),
                              scale: const ScaleConfig(begin: Offset(1.2, 1.2))),

                          // Column to place the text for the upload video page
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step title
                                addAnimation(
                                    widget: Text(
                                      'Upload a video',
                                      style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 60))),

                                // Step description
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: addAnimation(
                                      widget: Text(
                                        'Shoot a new clip or pick one straight from your gallery - whatever works best for you.\nFor tips on getting the most out of your shots, check out the Help section and learn what makes a great video for SwishLab.',
                                        style: AppTextStyles.labelMedium(context, color: Colors.black),
                                      ),
                                      move: const MoveConfig(begin: Offset(0, 80))),
                                ),

                                // Row to place the next button
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Next button
                                      addAnimation(
                                          widget: IconActionButton(
                                            const Icon(Icons.navigate_next_rounded),
                                            borderRadius: 30,
                                            iconColor: AppThemeManager.secondaryText,
                                            iconSize: 30,
                                            onPressed: () async {
                                              await stepSlideShowController?.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          scale: const ScaleConfig(begin: Offset(0.5, 0.5))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // Page 3
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Image depicting the make your clip yours step
                          addAnimation(
                              widget: Image.asset(
                                'assets/images/gs_3.png',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.45,
                                fit: BoxFit.contain,
                              ),
                              scale: const ScaleConfig(begin: Offset(1.2, 1.2))),

                          // Column to place the text for the make your clip page
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step title
                                addAnimation(
                                    widget: Text(
                                      'Make your clip yours',
                                      style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 60))),

                                // Step description
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: addAnimation(
                                      widget: Text(
                                        'Add a few quick details about your video - like a name and a short description - to keep everything organized.\nDon’t worry, SwishLab takes care of the rest and fills in the remaining info automatically.',
                                        style: AppTextStyles.labelMedium(context, color: Colors.black),
                                      ),
                                      move: const MoveConfig(begin: Offset(0, 80))),
                                ),

                                // Row to place the next button
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Next button
                                      addAnimation(
                                          widget: IconActionButton(
                                            const Icon(Icons.navigate_next_rounded),
                                            borderRadius: 30,
                                            iconColor: AppThemeManager.secondaryText,
                                            iconSize: 30,
                                            onPressed: () async {
                                              await stepSlideShowController?.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          scale: const ScaleConfig(begin: Offset(0.5, 0.5))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // Page 4
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Image depicting the processing step
                          addAnimation(
                              widget: Image.asset(
                                'assets/images/gs_4.png',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.45,
                                fit: BoxFit.contain,
                              ),
                              scale: const ScaleConfig(begin: Offset(1.2, 1.2))),

                          // Column to place the text for the processing page
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step title
                                addAnimation(
                                    widget: Text(
                                      'Processing your shot',
                                      style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 60))),

                                // Step title
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: addAnimation(
                                      widget: Text(
                                        'The magic is happening!\nThis is a perfect moment to breathe, stretch, or dive right into the rest of your training session while SwishLab works for you.',
                                        style: AppTextStyles.labelMedium(context, color: Colors.black),
                                      ),
                                      move: const MoveConfig(begin: Offset(0, 80))),
                                ),

                                // Row to place the next button
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Next button
                                      addAnimation(
                                          widget: IconActionButton(
                                            const Icon(Icons.navigate_next_rounded),
                                            borderRadius: 30,
                                            iconColor: AppThemeManager.secondaryText,
                                            iconSize: 30,
                                            onPressed: () async {
                                              await stepSlideShowController?.nextPage(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          scale: const ScaleConfig(begin: Offset(0.5, 0.5))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // Page 5
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Image depicting the review performance step
                          addAnimation(
                              widget: Image.asset(
                                'assets/images/gs_5.png',
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.45,
                                fit: BoxFit.contain,
                              ),
                              scale: const ScaleConfig(begin: Offset(1.2, 1.2))),

                          // Column to place the text for the review performance page
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step title
                                addAnimation(
                                    widget: Text(
                                      'Review your performance',
                                      style: AppTextStyles.headlineLarge(context, color: Colors.black),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 60))),

                                // Step description
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: addAnimation(
                                      widget: Text(
                                        'Your breakdown is ready!\nExplore your performance data and read personalized feedback to help you sharpen your form and grow your game.\nStay consistent - every rep moves you forward!',
                                        style: AppTextStyles.labelMedium(context, color: Colors.black),
                                      ),
                                      move: const MoveConfig(begin: Offset(0, 80))),
                                ),

                                // Row to place the next button
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Next button
                                      addAnimation(
                                          widget: DarkButton(
                                            onPressed: () async {
                                              ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                                              context.goNamed('home');
                                            },
                                            text: 'Get Started',
                                          ),
                                          scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                                          move: const MoveConfig(begin: Offset(0, 100))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0.85),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: smooth_page_indicator.SmoothPageIndicator(
                      controller: stepSlideShowController ??= PageController(initialPage: 0),
                      count: 5,
                      axisDirection: Axis.horizontal,
                      onDotClicked: (i) async {
                        await stepSlideShowController!.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                        setState(() {});
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
      ),
    );
  }
}
