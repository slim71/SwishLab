import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/get_border_color.dart';
import '../functions/process_analysis_results.dart';
import '../functions/score_to_rating.dart';
import '../models/analysis_state.dart';
import '../models/statistics_row.dart';
import '../models/video_source.dart';
import '../providers/shooting_analysis_provider.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dynamic_icon_image.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/section_details.dart';
import '../widgets/video_preview.dart';

class AnalysisResults extends ConsumerStatefulWidget {
  final Map<String, dynamic> videoDataJson;

  const AnalysisResults({
    super.key,
    required this.videoDataJson,
  });

  @override
  ConsumerState<AnalysisResults> createState() => _AnalysisResultsState();
}

class _AnalysisResultsState extends ConsumerState<AnalysisResults> with TickerProviderStateMixin {
  // Stores action output result for [Backend Call - Insert Row] action in pageTitle widget.
  StatisticsRow? testInsertionReturn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final state = ref.watch(shootingAnalysisProvider);

    // To be sure we have data to show
    if (state is! AnalysisSuccess && (widget.videoDataJson.isEmpty)) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Process analysis data ONCE with strict ordering to ensure consistency
    final analysisResultRaw =
        processAnalysisResults((widget.videoDataJson['analysis'] as Map<String, dynamic>? ?? {})).toList();

    // Sort alphabetically by section name to ensure the chart axis and grid cards match perfectly
    analysisResultRaw.sort((a, b) => a['section'].toString().compareTo(b['section'].toString()));
    final analysisResultListed = analysisResultRaw;

    // Debugging values plotted in the Radar Chart
    for (var res in analysisResultListed) {
      final scores = res['scores'] as List;
      final totalScoreMap = scores.firstWhere(
        (e) => e['name'] == 'Total',
        orElse: () => <String, dynamic>{},
      );
      final value = (totalScoreMap['value'] as num?)?.toDouble() ?? 0.0;
      debugPrint('RADAR_PLOT: ${res['section']} -> $value');
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const MyAppBar(
            style: MyAppBarStyle.backButtonTitleLeft, title: 'Analysis Results', backIcon: Icons.home),
        body: Background(
          child: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const VideoPreview(
                              source: NetworkVideoSource(
                                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                            ),

                            // Radar Chart Section (Hidable)
                            if (ref.watch(appStateProvider).showRadarChart == true)
                              addAnimation(
                                widget: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 32),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Form Signature',
                                            style: AppTextStyles.headlineSmall(context).copyWith(
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(Icons.visibility_off_rounded,
                                                size: 20, color: AppThemeManager.primaryText.withValues(alpha: 0.3)),
                                            onPressed: () {
                                              ref.read(appStateProvider.notifier).setShowRadarChart(false);
                                              HapticFeedback.lightImpact();
                                            },
                                            tooltip: 'Hide Profile',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        height: 280,
                                        child: RadarChart(
                                          RadarChartData(
                                            radarShape: RadarShape.circle,
                                            dataSets: [
                                              // Real data set
                                              RadarDataSet(
                                                fillColor: appColors.primaryOne.withValues(alpha: 0.35),
                                                borderColor: appColors.primaryOne,
                                                borderWidth: 3.5,
                                                entryRadius: 6,
                                                dataEntries: analysisResultListed.map((section) {
                                                  final scores = section['scores'] as List;
                                                  final totalScoreMap = scores.firstWhere(
                                                    (e) => e['name'] == 'Total',
                                                    orElse: () => <String, dynamic>{},
                                                  );
                                                  final value = (totalScoreMap['value'] as num?)?.toDouble() ?? 0.0;
                                                  return RadarEntry(value: value);
                                                }).toList(),
                                              ),
                                              // Scale constraint (Invisible 1.0 outer boundary)
                                              RadarDataSet(
                                                fillColor: Colors.transparent,
                                                borderColor: Colors.transparent,
                                                entryRadius: 0,
                                                dataEntries: List.generate(
                                                    analysisResultListed.length, (_) => const RadarEntry(value: 1.0)),
                                              ),
                                              // Scale constraint (Invisible 0.0 center point)
                                              RadarDataSet(
                                                fillColor: Colors.transparent,
                                                borderColor: Colors.transparent,
                                                entryRadius: 0,
                                                dataEntries: List.generate(
                                                    analysisResultListed.length, (_) => const RadarEntry(value: 0.0)),
                                              ),
                                            ],
                                            radarBackgroundColor:
                                                AppThemeManager.secondaryBackground.withValues(alpha: 0.1),
                                            borderData: FlBorderData(show: false),
                                            radarBorderData: BorderSide(
                                                color: appColors.alternateOne.withValues(alpha: 0.4), width: 2),
                                            tickCount: 5,
                                            ticksTextStyle: const TextStyle(color: Colors.transparent),
                                            tickBorderData: BorderSide(
                                                color: appColors.alternateOne.withValues(alpha: 0.2), width: 1),
                                            gridBorderData: BorderSide(
                                                color: appColors.alternateOne.withValues(alpha: 0.2), width: 1),
                                            getTitle: (index, angle) {
                                              if (index >= analysisResultListed.length) {
                                                return const RadarChartTitle(text: '');
                                              }
                                              final label = analysisResultListed[index]['section'].toString();
                                              // Simplified labels for the chart
                                              return RadarChartTitle(
                                                text: label,
                                                angle: angle,
                                              );
                                            },
                                            titleTextStyle: AppTextStyles.labelSmall(context).copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: AppThemeManager.primaryText.withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                move: const MoveConfig(begin: Offset(0, 50)),
                              )
                            else
                              addAnimation(
                                widget: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: InkWell(
                                    onTap: () {
                                      ref.read(appStateProvider.notifier).setShowRadarChart(true);
                                      HapticFeedback.lightImpact();
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.analytics_rounded,
                                              size: 28, color: appColors.primaryOne.withValues(alpha: 0.8)),
                                          const SizedBox(width: 12),
                                          Text(
                                            'SHOW FORM SIGNATURE',
                                            style: AppTextStyles.labelMedium(context,
                                                    color: AppThemeManager.primaryText.withValues(alpha: 0.6))
                                                .copyWith(
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                move: const MoveConfig(begin: Offset(0, 30)),
                              ),

                            addAnimation(
                              widget: Column(
                                children: [
                                  Divider(
                                    height: 32,
                                    thickness: 1,
                                    color: appColors.alternateOne,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.touch_app_rounded,
                                            size: 16, color: AppThemeManager.primaryText.withValues(alpha: 0.4)),
                                        const SizedBox(width: 8),
                                        Text(
                                          'TAP FOR DETAILS',
                                          style: AppTextStyles.labelSmall(context,
                                                  color: AppThemeManager.primaryText.withValues(alpha: 0.4))
                                              .copyWith(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              move: const MoveConfig(begin: Offset(50, 0)),
                            ),

                            Wrap(
                              spacing: 20,
                              runSpacing: 0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: List.generate(analysisResultListed.length, (analysisResultListedIndex) {
                                final analysisResultListedItem =
                                    analysisResultListed[analysisResultListedIndex] as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: (MediaQuery.sizeOf(context).width - 64) / 2,
                                        decoration: BoxWithShadow(
                                          color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(
                                            color: getBorderColor(kMyColors.toList(), analysisResultListedIndex)
                                                .withValues(alpha: 0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            await showModalBottomSheet<void>(
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding: MediaQuery.viewInsetsOf(context),
                                                    child: SizedBox(
                                                      height: MediaQuery.sizeOf(context).height * 0.9,
                                                      child: SectionDetails(
                                                        sectionJson: analysisResultListedItem,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then((value) => setState(() {}));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: DynamicIconImage(
                                                    width: 40,
                                                    height: 40,
                                                    imageName: analysisResultListedItem['section'].toString(),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  analysisResultListedItem['section'].toString(),
                                                  style: AppTextStyles.bodyMedium(context).copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  scoreToRating(
                                                    (((analysisResultListedItem['scores'] as List?)?.firstWhere(
                                                          (e) => e['name'] == 'Total',
                                                          orElse: () => <String, dynamic>{},
                                                        )?['value'] as num?)
                                                            ?.toDouble() ??
                                                        0.0),
                                                  ),
                                                  style: AppTextStyles.bodySmall(context).copyWith(
                                                    color:
                                                        getBorderColor(kMyColors.toList(), analysisResultListedIndex),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  (((analysisResultListedItem['scores'] as List?)?.firstWhere(
                                                        (e) => e['name'] == 'Total',
                                                        orElse: () => <String, dynamic>{},
                                                      )?['value'])
                                                          ?.toDouble()
                                                          .toStringAsFixed(1)
                                                          .toString() ??
                                                      ''),
                                                  style: AppTextStyles.titleLarge(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
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
    );
  }
}
