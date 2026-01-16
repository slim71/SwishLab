import 'dart:io';

import 'package:SwishLab/functions/upload_video_to_gradio.dart';
import 'package:SwishLab/models/analysis_response.dart';
import 'package:SwishLab/models/custom_enums.dart';
import 'package:SwishLab/models/results_response.dart';
import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/models/video_source.dart';
import 'package:SwishLab/providers/shooting_analysis_provider.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/choice_chips_group.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:SwishLab/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page to preview the file to upload and to add some info to it
class VideoPreUpload extends ConsumerStatefulWidget {
  /// Which functionality triggered the navigation to this page
  final OriginFunc? perspective;
  final File videoFile;

  const VideoPreUpload({
    super.key,
    required this.perspective,
    required this.videoFile,
  });

  @override
  ConsumerState<VideoPreUpload> createState() => _VideoPreUploadState();
}

class _VideoPreUploadState extends ConsumerState<VideoPreUpload> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String? analysisFinalJson;

  // State field(s) for videoName widget.
  FocusNode? videoNameFocusNode;
  late final TextEditingController videoNameTextController;

  // State field(s) for videoDescription widget.
  FocusNode? videoDescriptionFocusNode;
  late final TextEditingController videoDescriptionTextController;

  // Stores action output result for [Custom Action - uploadVideoToGradio] action in uploadButton widget.
  String? gradioTempUrl;

  // Stores action output result for [Backend Call - API (AnalyzeShootingForm)] action in uploadButton widget.
  AnalysisResponse? analysisJsonEventId;

  // Stores action output result for [Backend Call - API (GetShootingFormResults)] action in uploadButton widget.
  AnalysisResults? analysisJsonResults;

  // Stores action output result for [Backend Call - Insert Row] action in uploadButton widget.
  StatisticsRow? insertionReturnValue;

  @override
  void initState() {
    super.initState();
    videoNameTextController = TextEditingController();
    videoDescriptionTextController = TextEditingController();

    videoNameFocusNode ??= FocusNode();
    videoDescriptionFocusNode ??= FocusNode();
  }

  Future<String?> uploadVideo(BuildContext context) async {
    final gradioTempUrl = await uploadVideoToGradio(widget.videoFile);

    if (gradioTempUrl == null || gradioTempUrl.isEmpty) {
      if (!context.mounted) return null;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upload failed'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Ok'),
            ),
          ],
        ),
      );

      // Exit loading page
      if (context.mounted && context.canPop()) {
        context.pop();
      }
      return null;
    }

    return gradioTempUrl;
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
        backgroundColor: appColors.secondaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Upload video',
        ),
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
                  // Form containing all the content of the Upload Video page
                  Semantics(
                label: 'Main form content',
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child:
                      // Column to place the content on the Upload Video page
                      Semantics(
                    label: 'Main column content',
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Column to place the content on screen
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Semantics(
                              label: 'Content column',
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Wrap to gracefully organize content
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                      child: Semantics(
                                        label: 'Content wrap',
                                        child: Wrap(
                                          spacing: 16,
                                          runSpacing: 16,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.center,
                                          verticalDirection: VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children: [
                                            // Column to place video and related info
                                            Semantics(
                                              label: 'Video column',
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  // Player to preview the chosen video
                                                  Semantics(
                                                      label: 'Video player',
                                                      child: VideoPreview(
                                                        source: FileVideoSource(widget.videoFile),
                                                      )),
                                                  const SizedBox(height: 12),

                                                  // Video name - TODO: change
                                                  Semantics(
                                                    label: 'Video name',
                                                    child: InputField(
                                                      label: 'Video name',
                                                      controller: videoNameTextController,
                                                      focusNode: videoNameFocusNode,
                                                      textCapitalization: TextCapitalization.words,
                                                      obscureText: false,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),

                                                  // Video description - TODO: not used for now
                                                  Semantics(
                                                    label: 'Video description',
                                                    child: InputField(
                                                      label: 'Description...',
                                                      controller: videoDescriptionTextController,
                                                      focusNode: videoDescriptionFocusNode,
                                                      textCapitalization: TextCapitalization.words,
                                                      obscureText: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Container to show labels
                                            Semantics(
                                              label: 'Labels container',
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 570,
                                                ),
                                                decoration: BoxDecoration(),
                                                child:
                                                    // Column to place labels
                                                    Semantics(
                                                  label: 'Labels column',
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // "Category" text
                                                      Semantics(
                                                        label: '"Category" text',
                                                        child: Text(
                                                          'Category',
                                                          style: AppTextStyles.labelMedium(context),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),

                                                      // Label to differentiate the functionality chosen, which is
                                                      // related to the video perspective
                                                      Semantics(
                                                          label: 'Perspective label',
                                                          child: ChoiceChipsGroup(
                                                            labels: OriginFunc.values.map((e) => e.name).toList(),
                                                            selectedIndex: widget.perspective!.index,
                                                            // preselect "side"
                                                            onChanged: (_) {}, // no interaction
                                                          )),
                                                    ],
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
                            ),
                          ),
                        ),

                        // Column to place the upload button
                        Semantics(
                          label: 'Button column',
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Button to upload the video and start the analysis
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                                child: Semantics(
                                  label: 'Upload and analyze button',
                                  child: DarkButton(
                                    text: 'Upload and Analyze',
                                    onPressed: () async {
                                      final appState = ref.watch(appStateProvider);

                                      // Check required parameters
                                      final shootingHand = appState.userData?.shootingHand;
                                      final perspective = widget.perspective?.name;
                                      if (shootingHand == null || perspective == null) {
                                        if (!context.mounted) return;

                                        await showDialog(
                                          context: context,
                                          builder: (context) => const AlertDialog(
                                            title: Text('Invalid data'),
                                            content: Text('Missing shooting hand or point of view.'),
                                          ),
                                        );
                                        return;
                                      }

                                      // Upload video to Gradio
                                      final gradioUrl = await uploadVideo(context);
                                      if (gradioUrl == null) return;

                                      // Trigger analysis
                                      ref.read(shootingAnalysisProvider.notifier).start(
                                            sourceVideo: gradioUrl,
                                            shootingHand: shootingHand,
                                            pointOfView: perspective,
                                          );

                                      // Navigate to loading page
                                      if (!context.mounted) return;
                                      context.pushNamed('loading');
                                    },
                                  ),
                                ).animate().scale(
                                      begin: const Offset(1.0, 1.0),
                                      end: const Offset(1.1, 1.1),
                                      duration: 600.ms,
                                      curve: Curves.easeIn,
                                      delay: 500.ms,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(
                            duration: 600.ms,
                            curve: Curves.easeIn,
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
