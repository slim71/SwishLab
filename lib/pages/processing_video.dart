import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/central_routing.dart';
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
  late final Stopwatch _stopwatch;
  late final Timer _timer;
  String _elapsedTime = '00:00';

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final minutes = _stopwatch.elapsed.inMinutes.toString().padLeft(2, '0');
        final seconds = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
        setState(() {
          _elapsedTime = '$minutes:$seconds';
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shootingAnalysisProvider.notifier).start(
            videoFile: widget.videoFile,
            shootingHand: widget.shootingHand,
            pointOfView: widget.pointOfView,
          );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    ref.listen<AnalysisState>(
      shootingAnalysisProvider,
      (previous, next) {
        if (next is AnalysisSuccess) {
          ref.read(routerProvider).goNamed('results', extra: next.result.raw);
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
                    Navigator.of(context, rootNavigator: true).pop(); // dismiss dialog
                    ref.read(routerProvider).goNamed('home');
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Loading animation in Glass Card
                    _buildGlassCard(
                      padding: const EdgeInsets.all(8),
                      child: const DynamicAsset(
                        name: 'loader_basketball.gif',
                        type: 'gif',
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Processing Text in Glass Pill
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppThemeManager.secondaryBackground.withValues(alpha: 0.8), // Increased opacity
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Processing Video',
                                style:
                                    AppTextStyles.headlineMedium(context, color: AppThemeManager.primaryText).copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please wait while we prepare your video',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.labelMedium(context,
                                    color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Progress Visualization
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        width: 240,
                        height: 8,
                        decoration: BoxDecoration(
                          color: appColors.alternateOne.withValues(alpha: 0.2),
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

                    const SizedBox(height: 32),

                    // Extra Hint text in matching style (Glass Bubble)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Elapsed Time: $_elapsedTime',
                                  style: AppTextStyles.titleMedium(context, color: AppThemeManager.primaryText)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This may take a moment depending on the video size',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.labelSmall(context,
                                      color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Back button to stop waiting and discard results
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                      child: TransparentButton(
                        onPressed: () async {
                          final shouldPop = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Stop Analysis?'),
                              content:
                                  const Text('Going back will discard the current shooting analysis. Are you sure?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Stay'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Stop', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (shouldPop == true && context.mounted) {
                            ref.read(shootingAnalysisProvider.notifier).cancel();
                            ref.read(routerProvider).pop();
                          }
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

  Widget _buildGlassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding ?? const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
