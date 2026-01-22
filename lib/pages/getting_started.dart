import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;

/// Page to help the user understand how the system works
class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key});

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> with TickerProviderStateMixin {
  PageController? stepSlideShowController;

  int get stepSlideShowCurrentIndex =>
      stepSlideShowController != null && stepSlideShowController!.hasClients && stepSlideShowController!.page != null
          ? stepSlideShowController!.page!.round()
          : 0;

  @override
  void initState() {
    super.initState();
  }

  Widget addAnimation({required Widget widget, Offset? scaleOffset, Offset? moveOffset}) {
    Animate anim = widget.animate().fadeIn(duration: 600.ms, curve: Curves.easeInOut);

    if (scaleOffset != null) {
      anim = anim.scale(
        begin: scaleOffset,
        end: const Offset(1.0, 1.0),
        duration: 600.ms,
        curve: Curves.easeInOut,
      );
    }

    if (moveOffset != null) {
      anim = anim.move(
        begin: moveOffset,
        end: Offset.zero,
        duration: 600.ms,
        curve: Curves.easeInOut,
      );
    }

    return anim;
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: appColors.primaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'Getting started',
        ),
        body:
            // Background container
            Semantics(
          label: 'Background container',
          child: Container(
            decoration: BoxDecoration(
              gradient: appColors.gradientBackground(),
            ),
            child:
                // Page view depicting the basic steps to use the app
                Semantics(
              label: 'Basic steps pages',
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    PageView(
                      controller: stepSlideShowController ??= PageController(initialPage: 0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Column to position the content of the first page
                        Semantics(
                          label: 'First page content column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Image depicting the choose angle step
                              Semantics(
                                label: 'Choose angle step image',
                                child: addAnimation(
                                    widget: Image.asset(
                                      'assets/images/gs_1.png',
                                      width: double.infinity,
                                      height: 500,
                                      fit: BoxFit.contain,
                                    ),
                                    scaleOffset: Offset(1.2, 1.2)),
                              ),

                              // Column to place the text for the choose angle page
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Semantics(
                                  label: 'Choose angle text column',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step title
                                      Semantics(
                                        label: 'Step title',
                                        child: addAnimation(
                                            widget: Text(
                                              'Pick your angle',
                                              style: AppTextStyles.headlineMedium(context),
                                            ),
                                            moveOffset: Offset(0, 60)),
                                      ),

                                      // Step description
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                        child: Semantics(
                                          label: 'Step description',
                                          child: addAnimation(
                                              widget: Text(
                                                'Every angle gives you a new way to level up your shot with SwishLab.\nUse the Front view to spot and eliminate any sideways movement holding you back.\nSwitch to the Side view to understand your ball path and fine-tune your shooting form with confidence.',
                                                style: AppTextStyles.labelMedium(context),
                                              ),
                                              moveOffset: Offset(0, 80)),
                                        ),
                                      ),

                                      // Row to place the next button
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                        child: Semantics(
                                          label: 'Next button row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Next button
                                              Semantics(
                                                label: 'Next button',
                                                child: addAnimation(
                                                    widget: IconActionButton(
                                                      borderColor: Colors.transparent,
                                                      borderRadius: 30,
                                                      borderWidth: 1,
                                                      icon: Icons.navigate_next_rounded,
                                                      iconColor: appColors.secondaryText,
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        await stepSlideShowController?.nextPage(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.ease,
                                                        );
                                                      },
                                                    ),
                                                    scaleOffset: Offset(0.4, 0.4)),
                                              ),
                                            ],
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

                        // Column to position the content of the second page
                        Semantics(
                          label: 'Second page content column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Column to position the content of the second page
                              Semantics(
                                label: 'Upload video step image',
                                child: addAnimation(
                                    widget: Image.asset(
                                      'assets/images/gs_2.png',
                                      width: double.infinity,
                                      height: 540,
                                      fit: BoxFit.contain,
                                    ),
                                    scaleOffset: Offset(1.2, 1.2)),
                              ),

                              // Column to place the text for the upload video page
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Semantics(
                                  label: 'Upload video text column',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step title
                                      Semantics(
                                        label: 'Step title',
                                        child: addAnimation(
                                            widget: Text(
                                              'Upload a video',
                                              style: AppTextStyles.headlineMedium(context),
                                            ),
                                            moveOffset: Offset(0, 60)),
                                      ),

                                      // Step description
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                        child: Semantics(
                                          label: 'Step description',
                                          child: addAnimation(
                                              widget: Text(
                                                'Shoot a new clip or pick one straight from your gallery - whatever works best for you.\nFor tips on getting the most out of your shots, check out the Help section and learn what makes a great video for SwishLab.',
                                                style: AppTextStyles.labelMedium(context),
                                              ),
                                              moveOffset: Offset(0, 80)),
                                        ),
                                      ),

                                      // Row to place the next button
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                        child: Semantics(
                                          label: 'Next button row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Next button
                                              Semantics(
                                                label: 'Next button',
                                                child: addAnimation(
                                                    widget: IconActionButton(
                                                      borderColor: Colors.transparent,
                                                      borderRadius: 30,
                                                      borderWidth: 1,
                                                      icon: Icons.navigate_next_rounded,
                                                      iconColor: appColors.secondaryText,
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        await stepSlideShowController?.nextPage(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.ease,
                                                        );
                                                      },
                                                    ),
                                                    scaleOffset: Offset(0.5, 0.5)),
                                              ),
                                            ],
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

                        // Column to position the content of the third page
                        Semantics(
                          label: 'Third page content column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Column to position the content of the third page
                              Semantics(
                                label: 'Third page image',
                                child: addAnimation(
                                    widget: Image.asset(
                                      'assets/images/gs_3.png',
                                      width: double.infinity,
                                      height: 540,
                                      fit: BoxFit.cover,
                                    ),
                                    scaleOffset: Offset(1.2, 1.2)),
                              ),

                              // Column to place the text for the make your clip page
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Semantics(
                                  label: 'Make your clip text column',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step title
                                      Semantics(
                                        label: 'Step title',
                                        child: addAnimation(
                                            widget: Text(
                                              'Make your clip yours',
                                              style: AppTextStyles.headlineMedium(context),
                                            ),
                                            moveOffset: Offset(0, 60)),
                                      ),

                                      // Step description
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                        child: Semantics(
                                          label: 'Step description',
                                          child: addAnimation(
                                              widget: Text(
                                                'Add a few quick details about your video - like a name and a short description - to keep everything organized.\nDon’t worry, SwishLab takes care of the rest and fills in the remaining info automatically.',
                                                style: AppTextStyles.labelMedium(context),
                                              ),
                                              moveOffset: Offset(0, 80)),
                                        ),
                                      ),

                                      // Row to place the next button
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                        child: Semantics(
                                          label: 'Next button row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Next button
                                              Semantics(
                                                label: 'Next button',
                                                child: addAnimation(
                                                    widget: IconActionButton(
                                                      borderColor: Colors.transparent,
                                                      borderRadius: 30,
                                                      borderWidth: 1,
                                                      icon: Icons.navigate_next_rounded,
                                                      iconColor: appColors.secondaryText,
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        await stepSlideShowController?.nextPage(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.ease,
                                                        );
                                                      },
                                                    ),
                                                    scaleOffset: Offset(0.5, 0.5)),
                                              ),
                                            ],
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

                        // Column to position the content of the fourth page
                        Semantics(
                          label: 'Fourth page column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Column to position the content of the fourth page
                              Semantics(
                                label: 'Fourth page image',
                                child: addAnimation(
                                    widget: Image.asset(
                                      'assets/images/gs_4.png',
                                      width: double.infinity,
                                      height: 540,
                                      fit: BoxFit.contain,
                                    ),
                                    scaleOffset: Offset(1.2, 1.2)),
                              ),

                              // Column to place the text for the processing page
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Semantics(
                                  label: 'Processing page text column',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step title
                                      Semantics(
                                        label: 'Step title',
                                        child: addAnimation(
                                            widget: Text(
                                              'Processing your shot',
                                              style: AppTextStyles.headlineMedium(context),
                                            ),
                                            moveOffset: Offset(0, 60)),
                                      ),

                                      // Step title
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                        child: Semantics(
                                          label: 'Step title',
                                          child: addAnimation(
                                              widget: Text(
                                                'The magic is happening!\nThis is a perfect moment to breathe, stretch, or dive right into the rest of your training session while SwishLab works for you.',
                                                style: AppTextStyles.labelMedium(context),
                                              ),
                                              moveOffset: Offset(0, 80)),
                                        ),
                                      ),

                                      // Row to place the next button
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                        child: Semantics(
                                          label: 'Next button row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Next button
                                              Semantics(
                                                label: 'Next button',
                                                child: addAnimation(
                                                    widget: IconActionButton(
                                                      borderColor: Colors.transparent,
                                                      borderRadius: 30,
                                                      borderWidth: 1,
                                                      icon: Icons.navigate_next_rounded,
                                                      iconColor: appColors.secondaryText,
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        await stepSlideShowController?.nextPage(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.ease,
                                                        );
                                                      },
                                                    ),
                                                    scaleOffset: Offset(0.5, 0.5)),
                                              ),
                                            ],
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

                        // Column to position the content of the fifth page
                        Semantics(
                          label: 'Fifth page content column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Image depicting the review performance step
                              Semantics(
                                label: 'Review performance step image',
                                child: addAnimation(
                                    widget: Image.asset(
                                      'assets/images/gs_5.png',
                                      width: double.infinity,
                                      height: 500,
                                      fit: BoxFit.contain,
                                    ),
                                    scaleOffset: Offset(1.2, 1.2)),
                              ),

                              // Column to place the text for the review performance page
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Semantics(
                                  label: 'Review performance text column',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step title
                                      Semantics(
                                        label: 'Step title',
                                        child: addAnimation(
                                            widget: Text(
                                              'Review your performance',
                                              style: AppTextStyles.headlineMedium(context),
                                            ),
                                            moveOffset: Offset(0, 60)),
                                      ),

                                      // Step description
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                        child: Semantics(
                                          label: 'Step description',
                                          child: addAnimation(
                                              widget: Text(
                                                'Your breakdown is ready!\nExplore your performance data and read personalized feedback to help you sharpen your form and grow your game.\nStay consistent - every rep moves you forward!',
                                                style: AppTextStyles.labelMedium(context),
                                              ),
                                              moveOffset: Offset(0, 80)),
                                        ),
                                      ),

                                      // Row to place the next button
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                        child: Semantics(
                                          label: 'Next button row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Next button
                                              Semantics(
                                                label: 'Next button',
                                                child: addAnimation(
                                                    widget: DarkButton(
                                                      onPressed: () async {
                                                        context.goNamed('home');
                                                      },
                                                      text: 'Get Started',
                                                    ),
                                                    scaleOffset: Offset(0.8, 0.8),
                                                    moveOffset: Offset(0, 100)),
                                              ),
                                            ],
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
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.85, 0.85),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: smooth_page_indicator.SmoothPageIndicator(
                          controller: stepSlideShowController ??= PageController(initialPage: 0),
                          count: 5,
                          axisDirection: Axis.horizontal,
                          onDotClicked: (i) async {
                            await stepSlideShowController!.animateToPage(
                              i,
                              duration: Duration(milliseconds: 500),
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
        ),
      ),
    );
  }
}
