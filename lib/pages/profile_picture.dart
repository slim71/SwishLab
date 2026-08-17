import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../providers/users_provider.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dark_button.dart';
import '../widgets/input_field.dart';
import '../widgets/light_button.dart';

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
    final appState = ref.read(appStateProvider);
    final userInfo = ref.read(appUserProvider).value;

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        imgNetwork = userInfo?.profilePic ?? appState.userData?.profilePicture;
      });
    });

    urlFieldTextController = TextEditingController();
    urlFieldFocusNode = FocusNode();

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
          duration: const Duration(milliseconds: 4000),
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
  void dispose() {
    urlFieldTextController.dispose();
    urlFieldFocusNode?.dispose();
    super.dispose();
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
        extendBodyBehindAppBar: true,
        backgroundColor: AppThemeManager.primaryBackground,
        appBar: const MyAppBar(
          title: 'Profile Picture',
          style: MyAppBarStyle.backButtonTitleLeft,
        ),
        body: Background(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // --- GLASSMORPHIC IMAGE CARD ---
                    _buildGlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Subtle Outer Glow
                              Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColors.primaryOne.withValues(alpha: 0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              // Image Border
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: appColors.primaryOne.withValues(alpha: 0.5),
                                    width: 4,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: pickLocalImage,
                                  borderRadius: BorderRadius.circular(100),
                                  child: ClipOval(
                                    child: _buildImageContent(),
                                  ),
                                ),
                              ),
                              // Camera Icon Overlay
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: appColors.primaryOne,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 24),
                          Text(
                            'Personalize Your Profile',
                            style: AppTextStyles.headlineSmall(context).copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose a photo from your device or use a direct URL.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelMedium(context, color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- OPTIONS SECTION ---
                    Text(
                      'SOURCE SELECTION',
                      style: AppTextStyles.labelSmall(context).copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: AppThemeManager.primaryText.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildGlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildSourceButton(
                            icon: Icons.photo_library_rounded,
                            label: 'Gallery',
                            onTap: pickLocalImage,
                            color: appColors.primaryOne,
                          ),
                          Container(width: 1, height: 40, color: Colors.white10),
                          _buildSourceButton(
                            icon: Icons.link_rounded,
                            label: 'URL',
                            onTap: () => setState(() => showUrlField = !showUrlField),
                            color: appColors.alternateTwo,
                          ),
                        ],
                      ),
                    ).animate(delay: 200.ms).fade().slideY(begin: 0.1),

                    if (showUrlField) ...[
                      const SizedBox(height: 16),
                      _buildGlassCard(
                        child: Column(
                          children: [
                            InputField(
                              label: 'Direct Image URL',
                              controller: urlFieldTextController,
                              focusNode: urlFieldFocusNode,
                              autofillHints: const [AutofillHints.url],
                              validator: (value) => urlFieldTextControllerValidator.call(context, value),
                            ),
                            const SizedBox(height: 16),
                            DarkButton(
                              onPressed: () {
                                final url = urlFieldTextController.text.trim();
                                if (isValidImageUrl(url)) {
                                  setState(() {
                                    imgNetwork = url;
                                    imgLocal = null;
                                    imgLocalBytes = null;
                                  });
                                }
                              },
                              text: 'Load URL',
                            ),
                          ],
                        ),
                      ).animate().fade().slideY(begin: -0.1),
                    ],

                    const SizedBox(height: 48),

                    // --- ACTION BUTTONS ---
                    Row(
                      children: [
                        Expanded(
                          child: LightButton(
                            onPressed: () => context.pop(),
                            text: 'Cancel',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DarkButton(
                            isLoading: isDataUploading,
                            onPressed: _savePicture,
                            text: 'Save Changes',
                          ),
                        ),
                      ],
                    ).animate(delay: 400.ms).fade().slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (imgLocalBytes != null) {
      return Image.memory(imgLocalBytes!, fit: BoxFit.cover);
    }
    return Image.network(
      imgNetwork ?? kDefaultProfilePictureUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
      errorBuilder: (_, __, ___) => Image.asset('assets/images/error_image.jpg', fit: BoxFit.cover),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
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

  Widget _buildSourceButton({required IconData icon, required String label, required VoidCallback onTap, required Color color}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.labelSmall(context).copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _savePicture() async {
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

      final appState = ref.read(appStateProvider);
      ref.read(appStateProvider.notifier).setUserData(
            appState.userData!.copyWith(profilePicture: newUrl),
          );

      ref.invalidate(appUserProvider);
      if (!mounted) return;
      context.goNamed('home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error uploading profile picture'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isDataUploading = false);
    }
  }
}
