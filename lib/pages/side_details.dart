import 'dart:io';

import 'package:SwishLab/models/custom_enums.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Page with overview of the side view analysis
class SideDetails extends ConsumerStatefulWidget {
  const SideDetails({super.key});

  @override
  ConsumerState<SideDetails> createState() => _SideDetailsState();
}

class _SideDetailsState extends ConsumerState<SideDetails> with TickerProviderStateMixin {
  bool isDataUploading = false;
  File? chosenSideVideo;

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
        body:
            // Container with all content on the Front Details page
            Semantics(
          label: 'Container with all content on the Front Details page',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: appColors.primaryBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: AlignmentDirectional(0.3, 0),
                image: Image.asset(
                  'assets/gifs/curry.gif',
                ).image,
              ),
            ),
            child:
                // Column with all content on the Side Details page
                Semantics(
              label: 'Column with all content on the Side Details page',
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row to place action buttons
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 44, 16, 0),
                    child: Semantics(
                      label: 'Action buttons row',
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button row
                          Semantics(
                            label: 'Back button row',
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Back button
                                Semantics(
                                  label: 'Back button',
                                  child: IconActionButton(
                                    borderColor: appColors.containersBorders,
                                    size: 60,
                                    backgroundColor: appColors.primaryBackground,
                                    icon: Icons.arrow_back_rounded,
                                    iconColor: appColors.primaryText,
                                    iconSize: 25,
                                    onPressed: () async {
                                      context.pop();
                                    },
                                  ),
                                )
                                    .animate()
                                    .fadeIn(
                                      duration: 300.ms,
                                      curve: Curves.easeInOut,
                                    )
                                    .scale(
                                      begin: const Offset(0.5, 1.0),
                                      end: const Offset(1.0, 1.0),
                                      duration: 300.ms,
                                      curve: Curves.easeInOut,
                                    ),
                              ],
                            ),
                          ),

                          // Upload button row
                          Semantics(
                            label: 'Upload button row',
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Upload button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                                  child: Semantics(
                                    label: 'Upload button',
                                    child: IconActionButton(
                                      borderColor: appColors.containersBorders,
                                      size: 60,
                                      backgroundColor: appColors.primaryBackground,
                                      icon: FontAwesomeIcons.upload,
                                      iconColor: appColors.primaryText,
                                      iconSize: 25,
                                      onPressed: () async {
                                        final picker = ImagePicker();

                                        // Pick video
                                        final XFile? video = await picker.pickVideo(
                                          source: ImageSource.gallery,
                                        );
                                        if (!context.mounted || video == null) return;

                                        setState(() => isDataUploading = true);

                                        try {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Uploading file...')),
                                          );

                                          final File videoFile = File(video.path);

                                          // Save locally or prepare preview path
                                          chosenSideVideo = videoFile;
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to upload data')),
                                          );
                                          return;
                                        } finally {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          setState(() => isDataUploading = false);
                                        }

                                        if (chosenSideVideo == null) return;

                                        // Navigate
                                        context.pushNamed(
                                          'pre-upload',
                                          extra: {
                                            'originFunc': OriginFunc.front,
                                            'videoFile': chosenSideVideo!,
                                          },
                                        );
                                      },
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .scale(
                                        begin: const Offset(0.5, 1.0),
                                        end: const Offset(1.0, 1.0),
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Column to place the overview of the side functionality
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Semantics(
                      label: 'Column to place the overview of the side functionality',
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container to have a colored background for some text
                          Semantics(
                            label: 'Text background container',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0x800C0C0C),
                                shape: BoxShape.rectangle,
                              ),
                              child:
                                  // Section title
                                  Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                child: Semantics(
                                    label: 'Section title',
                                    child: ShaderMask(
                                      shaderCallback: (bounds) => appColors.gradientText().createShader(bounds),
                                      blendMode: BlendMode.srcIn,
                                      child: Text(
                                        'Side view analysis',
                                        style: AppTextStyles.displaySmall(),
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: 600.ms,
                                          curve: Curves.easeInOut,
                                        )
                                        .move(
                                          begin: const Offset(0, 60),
                                          end: Offset.zero,
                                          duration: 600.ms,
                                          curve: Curves.easeInOut,
                                        )),
                              ),
                            ),
                          ),

                          // Section overview
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 24),
                            child: Semantics(
                              label: 'Section overview',
                              child: Text(
                                'Take a video with the camera on either side.\nThis will analyze your body posture and flow when shooting.\nUseful to detect incorrect ball paths, flow ruptures, etc...',
                                style: AppTextStyles.titleSmall(),
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
                                )
                                .move(
                                  begin: const Offset(0, 120),
                                  end: Offset.zero,
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
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
    );
  }
}
