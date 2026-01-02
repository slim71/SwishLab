import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
                                                  style: AppTextStyles
                                                      .headlineLarge(context,
                                                          color: appColors
                                                              .secondaryBackground),
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
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Your personal AI coach helps you understand your shot. \nTrack your ',
                                                        style: AppTextStyles
                                                            .labelLarge(context,
                                                                color: appColors
                                                                    .secondaryBackground),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'form, ball path,',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' and ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'movement ',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'to get simple, actionable insights that make ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'every rep count.',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(
                                                        context,
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
                                                  style: AppTextStyles
                                                      .headlineLarge(context,
                                                          color: appColors
                                                              .secondaryBackground),
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
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Use the ',
                                                        style: AppTextStyles
                                                            .labelLarge(context,
                                                                color: appColors
                                                                    .secondaryBackground),
                                                      ),
                                                      TextSpan(
                                                        text: 'front view ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'to keep your shot straight and balanced. Spot',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' side drift, arm flare',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ', or ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: '“chicken wing” ',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'motion, and build a clean, consistent shooting line every time.',
                                                        style: TextStyle(),
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(
                                                        context,
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
                                                  style: AppTextStyles
                                                      .headlineLarge(context,
                                                          color: appColors
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
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'See your shot in full motion. The ',
                                                        style: AppTextStyles
                                                            .labelLarge(context,
                                                                color: appColors
                                                                    .secondaryBackground),
                                                      ),
                                                      TextSpan(
                                                        text: 'side view',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' shows ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'how close',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' the ball stays to your body, your ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'set ',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'and ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: 'release points',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ', and whether your shot follows a ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'smooth forward path.',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      )
                                                    ],
                                                    style: AppTextStyles.labelLarge(
                                                        context,
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
                                      dotColor: appColors.secondaryBackground,
                                      // TODO: check
                                      activeDotColor:
                                          appColors.primaryBackground,
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
                                  context.goNamed('login'); // TODO: bottom2top
                                },
                                text: 'Login',
                              ),
                            ),

                            // Register button
                            Semantics(
                              label: 'Register button',
                              child: DarkButton(
                                onPressed: () async {
                                  context.goNamed(
                                      'signup'); // TODO: bottobottom2top
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
