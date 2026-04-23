import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/get_border_color.dart';
import '../functions/process_analysis_results.dart';
import '../functions/score_to_rating.dart';
import '../models/analysis_state.dart';
import '../models/statistics_row.dart';
import '../models/video_source.dart';
import '../providers/shooting_analysis_provider.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dynamic_icon_image.dart';
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
    if (state is! AnalysisSuccess && widget.videoDataJson.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Analysis results',
        ),
        body: SafeArea(
          top: true,
          child:
              // Container used to have a colored background
              Background(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Column containing the Analysis results content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Player to view the annotated video with analysis data
                            const VideoPreview(
                              source: NetworkVideoSource(
                                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                            ),

                            // Divider between the video preview and the scores
                            addAnimation(
                              widget: Divider(
                                height: 32,
                                thickness: 1,
                                color: appColors.alternateOne,
                              ),
                              move: const MoveConfig(begin: Offset(50, 0)),
                            ),

                            // Wrap to dynamically generate scores and data from the analysis results
                            Builder(
                              builder: (context) {
                                final analysisResultListed =
                                    processAnalysisResults(widget.videoDataJson['analysis'] as Map<String, dynamic>)
                                        .toList();

                                return addAnimation(
                                  widget: Wrap(
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
                                      return
                                          // Container used to customize the item's colors
                                          Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppThemeManager.secondaryBackground,
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: getBorderColor(kMyColors.toList(), analysisResultListedIndex),
                                              width: 3,
                                            ),
                                          ),
                                          child:
                                              // Column containing scores for each category of the analyzed video
                                              InkWell(
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
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // Icon related to the category in focus, dynamically generated from its name
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: DynamicIconImage(
                                                      width: 50,
                                                      height: 50,
                                                      imageName: analysisResultListedItem['section'].toString(),
                                                    ),
                                                  ),
                                                ),

                                                // Category name
                                                Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text(
                                                    scoreToRating(
                                                      (((analysisResultListedItem['scores'] as List?)?.firstWhere(
                                                            (e) => e['name'] == 'Total',
                                                            orElse: () => <String, dynamic>{},
                                                          )?['value'] as num?)
                                                              ?.toDouble() ??
                                                          0.0),
                                                    ),
                                                    style: AppTextStyles.bodyLarge(context),
                                                  ),
                                                ),

                                                // Category score
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                  child: Text(
                                                    (((analysisResultListedItem['scores'] as List?)?.firstWhere(
                                                          (e) => e['name'] == 'Total',
                                                          orElse: () => <String, dynamic>{},
                                                        )?['value'])
                                                            ?.toString() ??
                                                        ''),
                                                    style: AppTextStyles.bodySmall(context),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  withFade: false,
                                  move: const MoveConfig(begin: Offset(0, 100)),
                                );
                              },
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
