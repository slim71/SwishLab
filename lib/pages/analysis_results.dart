import 'package:SwishLab/constants.dart';
import 'package:SwishLab/functions/get_border_color.dart';
import 'package:SwishLab/functions/process_analysis_results.dart';
import 'package:SwishLab/functions/score_to_rating.dart';
import 'package:SwishLab/models/analysis_state.dart';
import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/models/video_source.dart';
import 'package:SwishLab/providers/shooting_analysis_provider.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/dynamic_icon_image.dart';
import 'package:SwishLab/widgets/section_details.dart';
import 'package:SwishLab/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    if (state is! AnalysisSuccess) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Analysis results',
        ),
        body: SafeArea(
          top: true,
          child:
              // Container used to have a colored background
              Semantics(
            label: 'Background container',
                  child: Background(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Semantics(
                  label: 'Main column content',
                  child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Column containing the Analysis results content
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Semantics(
                                  label: 'Page content column',
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Player to view the annotated video with analysis data
                                        Semantics(
                                          label: 'Annotated video preview',
                                          child: VideoPreview(
                                            source: NetworkVideoSource(
                                                'https://www.pexels.com/video/low-angle-view-of-a-man-playing-basketball-5192077/'),
                                          ),
                                        ),

                                        // Divider between the video preview and the scores
                                  Semantics(
                                    label: 'Simple divider',
                                    child: Divider(
                                      height: 32,
                                      thickness: 1,
                                      color: appColors.alternateOne,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(
                                    duration: 600.ms,
                                    curve: Curves.easeInOut,
                                  )
                                      .move(
                                    begin: const Offset(50, 0),
                                    end: Offset.zero,
                                    duration: 600.ms,
                                    curve: Curves.easeInOut,
                                  ),

                                        // Wrap to dynamically generate scores and data from the analysis results
                                        Builder(
                                          builder: (context) {
                                            final analysisResultListed =
                                                processAnalysisResults(widget.videoDataJson['analysis']).toList();

                                            return Semantics(
                                        label: 'Analysis results generator',
                                        child: Wrap(
                                          spacing: 20,
                                          runSpacing: 0,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.start,
                                          verticalDirection: VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children:
                                          List.generate(analysisResultListed.length, (analysisResultListedIndex) {
                                            final Map<String, dynamic> analysisResultListedItem =
                                            analysisResultListed[analysisResultListedIndex];
                                            return
                                              // Container used to customize the item's colors
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                child: Semantics(
                                                  label: 'Item colors container',
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: appColors.primaryBackground,
                                                      borderRadius: BorderRadius.circular(24),
                                                      border: Border.all(
                                                        color:
                                                        getBorderColor(kMyColors.toList(), analysisResultListedIndex),
                                                        width: 3,
                                                      ),
                                                    ),
                                                    child:
                                                    // Column containing scores for each category of the analized video
                                                    Semantics(
                                                      label: 'Scores column',
                                                      child: InkWell(
                                                        splashColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        onTap: () async {
                                                          await showModalBottomSheet(
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
                                                                    height: MediaQuery
                                                                        .sizeOf(context)
                                                                        .height * 0.9,
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
                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                              child: Semantics(
                                                                label: 'Category icon',
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 50,
                                                                  child: DynamicIconImage(
                                                                    width: 50,
                                                                    height: 50,
                                                                    imageName:
                                                                    analysisResultListedItem['section'].toString(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                                // Category name
                                                                Padding(
                                                                  padding: EdgeInsets.all(10),
                                                                  child: Semantics(
                                                                    label: 'Category name',
                                                                    child: Text(
                                                                      scoreToRating(
                                                                        (((analysisResultListedItem['scores'] as List?)
                                                                                    ?.firstWhere(
                                                                              (e) => e['name'] == 'Total',
                                                                              orElse: () => null,
                                                                            )?['value'] as num?)
                                                                                ?.toDouble() ??
                                                                            0.0),
                                                                      ),
                                                                      style: AppTextStyles.bodyLarge(),
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Category score
                                                            Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                              child: Semantics(
                                                                label: 'Category score',
                                                                child: Text(
                                                                  (((analysisResultListedItem['scores'] as List?)
                                                                      ?.firstWhere(
                                                                        (e) => e['name'] == 'Total',
                                                                    orElse: () => null,
                                                                  )?['value'])
                                                                      ?.toString() ??
                                                                      ''),
                                                                  style: AppTextStyles.bodySmall(),
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
                                          }),
                                        ),
                                      ).animate().move(
                                        begin: const Offset(0, 100),
                                        end: Offset.zero,
                                        duration: 600.ms,
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                  )),
        ),
      ),
    );
  }
}
