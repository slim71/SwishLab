import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/analysis_state.dart';
import '../providers/shooting_analysis_provider.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/dynamic_asset.dart';
import '../widgets/transparent_button.dart';

class ProcessingVideo extends ConsumerStatefulWidget {
  final File videoFile;
  final String shootingHand;
  final String pointOfView;

  const ProcessingVideo({
    super.key,
    required this.videoFile,
    required this.shootingHand,
    required this.pointOfView,
  });

  @override
  ConsumerState<ProcessingVideo> createState() => _ProcessingVideoState();
}

class _ProcessingVideoState extends ConsumerState<ProcessingVideo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shootingAnalysisProvider.notifier).start(
            videoFile: widget.videoFile,
            shootingHand: widget.shootingHand,
            pointOfView: widget.pointOfView,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    ref.listen<AnalysisState>(
      shootingAnalysisProvider,
      (previous, next) {
        if (next is AnalysisSuccess) {
          context.goNamed('results', extra: next.result.raw);
        }

        if (next is AnalysisFailure) {
          String errorMessage = next.error.toString();
          if (next.error is DioException) {
            final e = next.error as DioException;
            errorMessage =
                'Network Error: ${e.type}\nStatus: ${e.response?.statusCode}\nURL: ${e.requestOptions.uri}\nMessage: ${e.message}';
          }

          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Analysis failed'),
              content: SingleChildScrollView(
                child: Text('Reason: $errorMessage'),
              ),
              actions: [
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
        backgroundColor: AppThemeManager.secondaryBackground,
        body: SafeArea(
          top: true,
          child:
              // Container with the content for the loading page
              Background(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:
                  // Column to place the content for the loading page
                  Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Loading animation
                    const DynamicAsset(
                      name: 'loader_basketball.json',
                      type: 'animation',
                      width: 300,
                      height: 300,
                    ),

                    // "Processing Video" text
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
                      child: Text(
                        'Processing Video',
                        style: AppTextStyles.headlineLarge(context, color: Colors.black),
                      ),
                    ),

                    // Text to ask the user to wait a bit
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 8, 32, 0),
                      child: Text(
                        'Please wait while we prepare your video',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge(context, color: Colors.black),
                      ),
                    ),

                    // Container used to place a custom divider
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 0),
                      child: Container(
                        width: 240,
                        height: 8,
                        decoration: BoxDecoration(
                          color: appColors.alternateOne,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            // Container used as colored divider
                            Container(
                          width: 120,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: appColors.gradientLinear(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Text stating that the loading might take a while
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 24, 32, 0),
                      child: Text(
                        'This may take a moment depending on the video size',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge(context, color: Colors.black),
                      ),
                    ),

                    // Back button to stop waiting and discard results
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                      child: TransparentButton(
                        onPressed: () async {
                          context.pop();
                        },
                        text: 'Go back',
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
