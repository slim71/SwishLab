import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/custom_text_span.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // State field(s) for pageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
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
        backgroundColor: appColors.primaryBackground,
        body: SafeArea(
          top: true,
          child:
              // Container to have a colored background
              Semantics(
            label: 'Background container',
            child: Container(
              decoration: BoxDecoration(
                gradient: appColors.gradientBackground(),
              ),
              child:
                  // Column to place the entire Splash Screen content
                  Semantics(
                label: 'Main column content',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Page view with different pages and content
                    Expanded(
                      child: Semantics(
                        label: 'Page view',
                        child: SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                                child: PageView(
                                  controller: pageViewController ??=
                                      PageController(initialPage: 0),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // Column to place the content for the first page
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Semantics(
                                        label: 'First page content column',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // First page image, AI generated on Canva
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 12),
                                                child: Semantics(
                                                  label: 'First page image',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.asset(
                                                      'assets/images/ai_general.jpg',
                                                      width: double.infinity,
                                                      height: 300,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // First page title
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 0, 0),
                                              child: Semantics(
                                                label: 'First page title',
                                                child: Text(
                                                  'Understand Your Form',
                                                  style:
                                                      AppTextStyles.headlineLarge(color: appColors.secondaryBackground),
                                                ),
                                              ),
                                            ),

                                            // Introduction on the first page
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 4, 12, 0),
                                              child: Semantics(
                                                label:
                                                    'First page introduction',
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: CustomTextSpan(
                                                    children: [
                                                      CustomTextSpan(
                                                        text:
                                                            'Your personal AI coach helps you understand your shot. \nTrack your ',
                                                        style: AppTextStyles.labelLarge(),
                                                        color: appColors.secondaryBackground,
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'form, ball path,',
                                                        italic: true,
                                                      ),
                                                      CustomTextSpan(
                                                        text: ' and ',
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'movement ',
                                                        italic: true,
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            'to get simple, actionable insights that make ',
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'every rep count.',
                                                        bold: true,
                                                        italic: true,
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(),
                                                    color: appColors.secondaryBackground,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Column to place the content for the second page
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Semantics(
                                        label: 'Second page content column',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Second page image, AI generated on Canva
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 12),
                                                child: Semantics(
                                                  label: 'Second page image',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.asset(
                                                      'assets/images/ai_front.jpg',
                                                      width: double.infinity,
                                                      height: 300,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Second page title
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 0, 0),
                                              child: Semantics(
                                                label: 'Second page title',
                                                child: Text(
                                                  'Keep It Straight',
                                                  style:
                                                      AppTextStyles.headlineLarge(color: appColors.secondaryBackground),
                                                ),
                                              ),
                                            ),

                                            // Introduction on the second page
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 4, 12, 0),
                                              child: Semantics(
                                                label:
                                                    'Second page introduction',
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: CustomTextSpan(
                                                    children: [
                                                      CustomTextSpan(
                                                        text: 'Use the ',
                                                        style: AppTextStyles.labelLarge(
                                                            color: appColors.secondaryBackground),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'front view ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            'to keep your shot straight and balanced. Spot',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            ' side drift, arm flare',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text: ', or ',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text: '“chicken wing” ',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            'motion, and build a clean, consistent shooting line every time.',
                                                        style: TextStyle(),
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(
                                                        color: appColors
                                                            .secondaryBackground),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Column to place the content for the third page
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Semantics(
                                        label: 'Third page content column',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Third page image, AI generated on Canva
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 12),
                                                child: Semantics(
                                                  label: 'Third page image',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.asset(
                                                      'assets/images/ai_side.png',
                                                      width: double.infinity,
                                                      height: 300,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Third page title
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 0, 0, 0),
                                              child: Semantics(
                                                label: 'Third page title',
                                                child: Text(
                                                  'Perfect the Flow',
                                                  style: AppTextStyles.headlineLarge(color: appColors
                                                              .secondaryBackground),
                                                ),
                                              ),
                                            ),

                                            // Introduction on the third page
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 4, 12, 0),
                                              child: Semantics(
                                                label:
                                                    'Third page introduction',
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: CustomTextSpan(
                                                    children: [
                                                      CustomTextSpan(
                                                        text:
                                                            'See your shot in full motion. The ',
                                                        style: AppTextStyles.labelLarge(
                                                            color: appColors
                                                                    .secondaryBackground),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'side view',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text: ' shows ',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'how close',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            ' the ball stays to your body, your ',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'set ',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'and ',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'release points',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            ', and whether your shot follows a ',
                                                        style: TextStyle(),
                                                      ),
                                                      CustomTextSpan(
                                                        text:
                                                            'smooth forward path.',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(
                                                        color: appColors
                                                            .secondaryBackground),
                                                  ),
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
                              Align(
                                alignment: AlignmentDirectional(0, 1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child:
                                      smooth_page_indicator.SmoothPageIndicator(
                                    controller: pageViewController ??=
                                        PageController(initialPage: 0),
                                    count: 3,
                                    axisDirection: Axis.horizontal,
                                    onDotClicked: (i) async {
                                      await pageViewController!.animateToPage(
                                        i,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    effect: smooth_page_indicator
                                        .ExpandingDotsEffect(
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

                    // Wrap to place the login and register buttons
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Semantics(
                        label: 'Buttons wrap',
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
                            Semantics(
                              label: 'Login button',
                              child: LightButton(
                                onPressed: () async {
                                  context.goNamed('login');
                                },
                                text: 'Login',
                              ),
                            ),

                            // Register button
                            Semantics(
                              label: 'Register button',
                              child: DarkButton(
                                onPressed: () async {
                                  context.goNamed('signup');
                                },
                                text: 'Register',
                              ),
                            ),
                          ],
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
