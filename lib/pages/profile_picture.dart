import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swish_lab/functions/add_animation.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/widgets/app_bar.dart';
import 'package:swish_lab/widgets/background.dart';
import 'package:swish_lab/widgets/dark_button.dart';
import 'package:swish_lab/widgets/input_field.dart';
import 'package:swish_lab/widgets/light_button.dart';
import 'package:swish_lab/widgets/transparent_button.dart';

/// Page where the user can change their profile picture
class ProfilePicturePage extends ConsumerStatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  ConsumerState<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends ConsumerState<ProfilePicturePage> with TickerProviderStateMixin {
  bool showUrlField = false;
  File? imgLocal;
  Uint8List? imgLocalBytes;
  String? imgNetwork;

  bool isImageUploading = false;
  bool isDataUploading = false;

  // State field(s) for urlField widget.
  FocusNode? urlFieldFocusNode;
  late final TextEditingController urlFieldTextController;
  late String? Function(BuildContext, String?) urlFieldTextControllerValidator;

  @override
  void initState() {
    super.initState();
    final appState = ref.watch(appStateProvider);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        imgNetwork = appState.userData?.profilePicture;
      });
    });

    urlFieldTextController = TextEditingController();
    urlFieldFocusNode ??= FocusNode();

    urlFieldTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'URL required';
      }

      final uri = Uri.tryParse(value);

      if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https') || uri.host.isEmpty) {
        return 'Enter a valid URL';
      }

      return null;
    };
  }

  bool isValidImageFormat(String path) {
    final extension = path.toLowerCase();
    return extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.png') ||
        extension.endsWith('.webp');
  }

  bool isValidImageUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png') || url.endsWith('.webp'));
  }

  Future<ImageSource?> showImageSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickLocalImage() async {
    //  Show bottom sheet choice
    final source = await showImageSourceSheet(context);
    if (source == null) return;

    // Let the user choose an image
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 300,
    );
    if (pickedFile == null) return;

    // Check file format
    if (!isValidImageFormat(pickedFile.path)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid image format. Please select another one',
            style: TextStyle(color: AppThemeManager.primaryText),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: AppThemeManager.primaryBackground,
        ),
      );
      return;
    }

    setState(() => isImageUploading = true);

    try {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();

      setState(() {
        imgLocal = file;
        imgLocalBytes = bytes;
        imgNetwork = null;
      });
    } finally {
      if (mounted) {
        setState(() => isImageUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Profile Picture',
          style: MyAppBarStyle.backButtonTitleCentered,
        ),
        body: SafeArea(
          top: true,
          child:
              // Container used to have a colored background
              Background(
            child: Padding(
                      padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Column containing the profile picture
                  Column(
                    mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Container for the profile picture
                      Container(
                        width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                          color: AppThemeManager.secondaryBackground,
                          shape: BoxShape.circle,
                                        border: Border.all(
                                          color: appColors.alternateTwo,
                                          width: 3,
                                        ),
                                      ),
                                      child:
                                          // Stack to have multiple image uploads widgets together
                            Stack(
                          children: [
                                            // Circle image for local file
                                            if (imgNetwork == null || imgNetwork == '')
                              InkWell(
                                onTap: pickLocalImage,
                                                  child: Container(
                                                    width: 200,
                                                    height: 200,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.memory(
                                                      imgLocalBytes!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),

                                            // Circle image for a remote image
                                      if (imgNetwork != null && imgNetwork != '')
                              InkWell(
                                onTap: pickLocalImage,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                imgNetwork!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return const Center(child: CircularProgressIndicator());
                                                },
                                                errorBuilder: (_, __, ___) =>
                                                    Image.asset(
                                                      'assets/images/error_image.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                      ),
                      const SizedBox(height: 24),

                                  // Instructions on how to select a picture
                      Text(
                        'Tap to select a picture',
                                      textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(context),
                      ),
                                ],
                              ),
                            const SizedBox(height: 32),

                            // Options to choose a profile picture
                  Column(
                    mainAxisSize: MainAxisSize.max,
                          children: [
                            // Container with picture selection options
                      Container(
                        width: double.infinity,
                                decoration: BoxDecoration(
                          color: AppThemeManager.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: appColors.altContBorders,
                                    width: 1,
                                  ),
                                ),
                                child:
                                // Column to have a structure for picture selection options
                                Padding(
                                  padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // Simple text to guide picture selection
                              Text(
                                'Select Image Source',
                                style: AppTextStyles.labelMedium(context),
                              ),
                                        const SizedBox(height: 12),

                                              // Row containing selection options
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    // Button to choose a local picture
                                                    Expanded(
                                    child: TransparentButton(
                                      onPressed: pickLocalImage,
                                                          text: 'From Device',
                                                          icon: Icon(
                                                            Icons.photo_library_outlined,
                                                            size: 15,
                                                          ),
                                                        ),
                                                    ),

                                                    // Button to show the URL field for a remote picture
                                              Expanded(
                                    child: TransparentButton(
                                      onPressed: () async {
                                                      showUrlField = !showUrlField;
                                                      setState(() {});
                                                    },
                                                    text: 'From URL',
                                                    icon: Icon(
                                                      Icons.link_rounded,
                                                      size: 15,
                                                    ),
                                                  ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                        ),
                      ),
                      const SizedBox(height: 16),

                                  // Container with the URL field
                                  if (showUrlField == true)
                        addAnimation(
                          widget: Container(
                            width: double.infinity,
                                        decoration: BoxDecoration(
                              color: AppThemeManager.secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: appColors.altContBorders,
                                            width: 1,
                                          ),
                                        ),
                                        child:
                                            // Column with the URL field
                                            Padding(
                                          padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // Text to guide the URL insertion
                                Text(
                                  'Enter Image URL',
                                    style: AppTextStyles.labelMedium(context),
                                  ),
                                                const SizedBox(height: 12),

                                                // Field where to put the image URL
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                  child: InputField(
                                    label: 'https://example.com/image.jpg',
                                                controller: urlFieldTextController,
                                                focusNode: urlFieldFocusNode,
                                                autofillHints: [AutofillHints.url],
                                                validator: (value) =>
                                                    urlFieldTextControllerValidator.call(context, value),
                                              ),
                                          ),
                                          const SizedBox(height: 12),

                                                // Button to load the image pointed by the URL
                                DarkButton(
                                  onPressed: () async {
                                                      final url = urlFieldTextController.text.trim();

                                                      if (!isValidImageUrl(url)) {
                                                  // optionally show a SnackBar
                                                  return;
                                                }

                                                      setState(() {
                                                        imgNetwork = url;
                                                        imgLocal = null;
                                                        imgLocalBytes = null;
                                                      });
                                                    },
                                                    text: 'Load Image From URL',
                                                  ),
                                              ],
                                            ),
                          ),
                          ),
                          withFade: false,
                          move: const MoveConfig(begin: Offset(0, -20)),
                        ),
                                ],
                              ),
                            const SizedBox(height: 32),

                            // Row with action buttons
                  Row(
                    mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Button to cancel the operation and navigate back
                            Expanded(
                        child: LightButton(
                          onPressed: () async {
                                    context.pop();
                                  },
                                  text: 'Cancel',
                                ),
                            ),
                            const SizedBox(width: 16),

                                  // Button to confirm the choice and upload the profile picture
                                  Expanded(
                        child: DarkButton(
                          onPressed: () async {
                                          final userInfoAsync = ref.read(appUserProvider);
                                          final user = userInfoAsync.value;

                                          if (user == null) return;

                                          setState(() => isDataUploading = true);

                                          try {
                                      final useCase = ref.read(changeProfilePictureProvider);

                                            final newUrl = await useCase.execute(
                                              userId: user.id,
                                              localFile: imgLocal,
                                              networkUrl: imgNetwork,
                                            );

                                            ref.read(appStateProvider.notifier).setUserData(
                                        appState.userData!.copyWith(profilePicture: newUrl),
                                      );

                                            if (!context.mounted) return;
                                            context.goNamed('home');
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                const SnackBar(
                                                  content: Text('Error uploading profile picture'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                          } finally {
                                            if (mounted) {
                                              setState(() => isDataUploading = false);
                                            }
                                          }
                                        },
                                        text: 'Save Picture',
                                      ),
                                  ),
                                ],
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
