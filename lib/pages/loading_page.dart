import 'package:SwishLab/models/analysis_state.dart';
import 'package:SwishLab/providers/shooting_analysis_provider.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/transparent_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    ref.listen<AnalysisState>(
      shootingAnalysisProvider,
      (previous, next) {
        if (next is AnalysisSuccess) {
          context.goNamed('results');
        }

        if (next is AnalysisFailure) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Analysis failed'),
              content: const Text('Error! Navigate home?'),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.goNamed('home');
                  },
                  child: const Text('Go home'),
                ),
              ],
            ),
          );
        }
      },
    );

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
              // Container with the content for the loading page
              Semantics(
            label: 'Main container content',
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: appColors.gradientBackground(),
              ),
              child:
                  // Column to place the content for the loading page
                  Padding(
                padding: EdgeInsets.all(16),
                child: Semantics(
                  label: 'Main column content',
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Loading animation
                      Semantics(
                        label: 'Loading animation',
                        child: Lottie.asset(
                          'assets/jsons/Loader_basketball.json',
                          width: 400,
                          height: 400,
                          fit: BoxFit.contain,
                          animate: true,
                        ),
                      ),

                      // "Processing Video" text
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
                        child: Semantics(
                          label: '"Processing Video" text',
                          child: Text(
                            'Processing Video',
                            style: AppTextStyles.headlineLarge(context),
                          ),
                        ),
                      ),

                      // Text to ask the user to wait a bit
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 8, 32, 0),
                        child: Semantics(
                          label: '"Please wait" text',
                          child: Text(
                            'Please wait while we prepare your video',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelLarge(context),
                          ),
                        ),
                      ),

                      // Container used to place a custom divider
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 0),
                        child: Semantics(
                          label: 'Container used to place a custom divider',
                          child: Container(
                            width: 240,
                            height: 8,
                            decoration: BoxDecoration(
                              color: appColors.alternateOne,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                // Container used as colored divider
                                Semantics(
                              label: 'Container used as colored divider',
                              child: Container(
                                width: 120,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: appColors.gradientLinear(),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Text stating that the loading might take a while
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 24, 32, 0),
                        child: Semantics(
                          label: '"Might take a while" text',
                          child: Text(
                            'This may take a moment depending on the video size',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelLarge(context),
                          ),
                        ),
                      ),

                      // Back button to stop waiting and discard results
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                        child: Semantics(
                          label: 'Back button',
                          child: TransparentButton(
                            onPressed: () async {
                              context.pop();
                            },
                            text: 'Go back',
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
      ),
    );
  }
}
