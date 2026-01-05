import 'package:SwishLab/constants.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum MyAppBarStyle {
  titleOnly,
  titleWithProfileImage,
  backButtonTitleLeft,
  backButtonTitleCentered,
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MyAppBarStyle style;
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onProfilePressed;
  final String? profileImageUrl;
  final double height;

  const MyAppBar({
    super.key,
    required this.style,
    required this.title,
    this.onBackPressed,
    this.onProfilePressed,
    this.profileImageUrl,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height); // 56px in material.dart

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return AppBar(
      backgroundColor: appColors.primaryOne,
      automaticallyImplyLeading: false,
      centerTitle: _isTitleCentered,
      elevation: 10,
      toolbarHeight: height,
      title: Text(
        title,
        style: AppTextStyles.displaySmall(context, color: appColors.primaryTwo),
      ),
      leading: _buildLeading(context),
      actions: _buildActions(context),
    );
  }

  // ---------- Helpers ----------

  bool get _isTitleCentered => style == MyAppBarStyle.backButtonTitleCentered;

  Widget? _buildLeading(BuildContext context) {
    if (style == MyAppBarStyle.backButtonTitleLeft ||
        style == MyAppBarStyle.backButtonTitleCentered) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: IconActionButton(
          icon: Icons.arrow_back_rounded,
          iconColor: Colors.white,
          onPressed: onBackPressed ??
              () {
                if (GoRouter.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
        ),
      );
    }
    return null;
  }

  List<Widget> _buildActions(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    if (style != MyAppBarStyle.titleWithProfileImage) {
      return const [];
    }

    return [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onProfilePressed,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: height,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appColors.alternateTwo,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: ClipOval(
              child: Image.network(
                profileImageUrl ?? kDefaultProfilePictureUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
