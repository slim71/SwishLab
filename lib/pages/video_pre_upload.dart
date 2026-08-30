import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/custom_enums.dart';
import '../models/video_source.dart';
import '../providers/users_provider.dart';
import '../router/central_routing.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/choice_chips_group.dart';
import '../widgets/dark_button.dart';
import '../widgets/input_field.dart';
import '../widgets/video_preview.dart';

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
  final formKey = GlobalKey<FormState>();

  late final TextEditingController videoNameTextController;
  late final TextEditingController videoDescriptionTextController;
  late final FocusNode videoNameFocusNode;
  late final FocusNode videoDescriptionFocusNode;

  int? selectedHandIndex;

  @override
  void initState() {
    super.initState();
    videoNameTextController = TextEditingController();
    videoDescriptionTextController = TextEditingController();
    videoNameFocusNode = FocusNode();
    videoDescriptionFocusNode = FocusNode();

    // Initialize shooting hand from user profile
    final userInfo = ref.read(appUserProvider).value;
    if (userInfo?.shootingHand != null) {
      final handStr = userInfo!.shootingHand!.toLowerCase();
      selectedHandIndex = Handedness.values.indexWhere((e) => e.name == handStr);
      if (selectedHandIndex == -1) selectedHandIndex = null;
    }
  }

  @override
  void dispose() {
    videoNameTextController.dispose();
    videoDescriptionTextController.dispose();
    videoNameFocusNode.dispose();
    videoDescriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'Review Upload',
        ),
        body: Background(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- VIDEO PREVIEW CARD ---
                    _buildGlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                            child: VideoPreview(
                              source: FileVideoSource(widget.videoFile),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.movie_filter_rounded, color: appColors.primaryOne, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  'Video Capture Ready',
                                  style: AppTextStyles.titleSmall(context, color: AppThemeManager.primaryText)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade().slideY(begin: 0.1),

                    const SizedBox(height: 32),

                    // --- DETAILS SECTION ---
                    _buildSectionLabel('SESSION DETAILS'),
                    const SizedBox(height: 12),
                    _buildGlassCard(
                      child: Column(
                        children: [
                          InputField(
                            label: 'Session Name',
                            controller: videoNameTextController,
                            focusNode: videoNameFocusNode,
                            textCapitalization: TextCapitalization.words,
                            prefixIcon: Icon(Icons.edit_rounded, size: 18, color: appColors.primaryOne),
                          ),
                          const SizedBox(height: 20),
                          InputField(
                            label: 'Notes (Optional)',
                            controller: videoDescriptionTextController,
                            focusNode: videoDescriptionFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            prefixIcon: Icon(Icons.notes_rounded, size: 18, color: appColors.primaryOne),
                          ),
                        ],
                      ),
                    ).animate(delay: 200.ms).fade().slideY(begin: 0.1),

                    const SizedBox(height: 32),

                    // --- CONFIGURATION SECTION ---
                    _buildSectionLabel('ANALYSIS CONFIG'),
                    const SizedBox(height: 12),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perspective',
                            style: AppTextStyles.labelSmall(context,
                                    color: AppThemeManager.primaryText.withValues(alpha: 0.5))
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ChoiceChipsGroup<String>(
                            labels: OriginFunc.values.map((e) => e.name.toUpperCase()).toList(),
                            selectedIndex: widget.perspective!.index,
                            onChanged: (_) {}, // fixed based on entry
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Shooting Hand',
                            style: AppTextStyles.labelSmall(context,
                                    color: AppThemeManager.primaryText.withValues(alpha: 0.5))
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ChoiceChipsGroup<String>(
                            labels: Handedness.values.map((e) => e.name == 'left' ? 'LEFT' : 'RIGHT').toList(),
                            selectedIndex: selectedHandIndex,
                            onChanged: (idx) => setState(() => selectedHandIndex = idx),
                          ),
                        ],
                      ),
                    ).animate(delay: 400.ms).fade().slideY(begin: 0.1),

                    const SizedBox(height: 48),

                    // --- UPLOAD BUTTON ---
                    DarkButton(
                      text: 'Start AI Analysis',
                      onPressed: _handleUpload,
                    ).animate(delay: 600.ms).fade().scale(begin: const Offset(0.9, 0.9)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 4),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppThemeManager.secondaryBackground.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall(context, color: AppThemeManager.primaryText).copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(24),
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

  Future<void> _handleUpload() async {
    final userInfo = ref.read(appUserProvider).value;
    final shootingHand =
        selectedHandIndex != null ? Handedness.values[selectedHandIndex!].name : userInfo?.shootingHand;
    final perspective = widget.perspective?.name;

    if (shootingHand == null || perspective == null) {
      _showErrorDialog('Missing Data', 'Please select your shooting hand to proceed.');
      return;
    }

    ref.read(routerProvider).pushNamed(
      'processing',
      extra: {
        'videoFile': widget.videoFile,
        'shootingHand': shootingHand,
        'pointOfView': perspective,
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppThemeManager.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title),
        content: Text(message, style: AppTextStyles.bodyLarge(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK', style: TextStyle(color: AppThemeManager.currentColors.primaryOne)),
          ),
        ],
      ),
    );
  }
}
