import 'dart:io';
import 'dart:ui';

import 'package:SwishLab/functions/add_animation.dart';
import 'package:SwishLab/models/custom_enums.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: AppThemeManager.secondaryBackground,
        body:
            // Container with all content on the Front Details page
            Container(
          width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
            color: AppThemeManager.secondaryBackground,
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
              Column(
            mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row to place action buttons
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 44, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button row
                    Row(
                      mainAxisSize: MainAxisSize.max,
                              children: [
                                // Back button
                        addAnimation(
                            widget: IconActionButton(
                              borderColor: appColors.containersBorders,
                                    size: 60,
                              backgroundColor: AppThemeManager.secondaryBackground,
                              icon: Icons.arrow_back_rounded,
                              iconColor: AppThemeManager.primaryText,
                              iconSize: 25,
                                    onPressed: () async {
                                      context.pop();
                                    },
                            ),
                            scale: const ScaleConfig(begin: Offset(0.5, 1.0))),
                              ],
                            ),

                          // Upload button row
                    Row(
                      mainAxisSize: MainAxisSize.max,
                              children: [
                                // Upload button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                          child: addAnimation(
                              widget: IconActionButton(
                                borderColor: appColors.containersBorders,
                                      size: 60,
                                backgroundColor: AppThemeManager.secondaryBackground,
                                icon: FontAwesomeIcons.upload,
                                iconColor: AppThemeManager.primaryText,
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
                              scale: const ScaleConfig(begin: Offset(0.5, 1.0))),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ),

                  // Column to place the overview of the side functionality
                  Padding(
                    padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container to have a colored background for some text
                    Container(
                      decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3), // subtle semi-transparent overlay
                                  borderRadius: BorderRadius.circular(8), // rounded corners
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // soft blur behind text
                                    child:
                                        // Section title
                                        Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: addAnimation(
                              widget: ShaderMask(
                                shaderCallback: (bounds) => appColors.gradientText().createShader(bounds),
                                            blendMode: BlendMode.srcIn,
                                            child: Text(
                                              'Side view analysis',
                                  style: AppTextStyles.displaySmall(context),
                                ),
                              ),
                              move: const MoveConfig(begin: Offset(0, 60)),
                            ),
                          ),
                                  ),
                                ),
                    ),

                    // Section overview
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 24),
                      child: addAnimation(
                        widget: Text(
                          'Take a video with the camera on either side.\nThis will analyze your body posture and flow when shooting.\nUseful to detect incorrect ball paths, flow ruptures, etc...',
                          style: AppTextStyles.titleSmall(context),
                        ),
                        move: const MoveConfig(begin: Offset(0, 120)),
                      ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
