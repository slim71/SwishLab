import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../models/users_row.dart';
import '../providers/statistics_provider.dart';
import '../providers/users_provider.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/stats_container.dart';

/// Profile page with user data
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with TickerProviderStateMixin {
  final ValueNotifier<double> _sheetExtent = ValueNotifier(0.4);
  final double _minExtent = 0.4;
  final double _maxExtent = 0.9;

  String _getMonthName(int month) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    final statsAsync = ref.watch(userStatisticsProvider);
    final statisticsDataDecreasing = statsAsync.maybeWhen(
      data: (state) => state.items,
      orElse: () => null,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Background(
          child: Stack(
            children: [
              // --- BACKGROUND LAYER: User Info ---
              ValueListenableBuilder<double>(
                valueListenable: _sheetExtent,
                builder: (context, extent, child) {
                  // Normalize extent progress (0.0 collapsed, 1.0 expanded)
                  final progress = ((extent - _minExtent) / (_maxExtent - _minExtent)).clamp(0.0, 1.0);

                  return Opacity(
                    opacity: 1.0 - (progress * 0.8), // Fades to 20% opacity
                    child: Transform.translate(
                      offset: Offset(0, -progress * 100), // Moves up
                      child: Transform.scale(
                        scale: 1.0 - (progress * 0.2), // Shrinks to 80%
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Profile picture
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  addAnimation(
                                    widget: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          width: 180,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: appColors.primaryOne.withValues(alpha: 0.3),
                                                blurRadius: 30,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                            border: Border.all(
                                              color: appColors.primaryOne.withValues(alpha: 0.5),
                                              width: 4,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () => context.pushNamed('pic'),
                                            borderRadius: BorderRadius.circular(100),
                                            child: ClipOval(
                                              child: Image.network(
                                                userInfo?.profilePic ?? kDefaultProfilePictureUrl,
                                                width: 180,
                                                height: 180,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                  'assets/icons/default_profile_male.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: appColors.primaryOne,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    withFade: false,
                                    moveY: const MoveYConfig(begin: 100, duration: Duration(seconds: 1)),
                                  ),
                                ],
                              ),

                              // Name & Info Chips
                              addAnimation(
                                withFade: true,
                                moveY: const MoveYConfig(
                                  begin: 30,
                                  duration: Duration(milliseconds: 800),
                                  delay: Duration(milliseconds: 200),
                                ),
                                widget: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                      child: Text(
                                        (userInfo?.firstName != null && userInfo!.firstName.isNotEmpty)
                                            ? '${userInfo.firstName} ${userInfo.lastName}'.toUpperCase()
                                            : 'N/A',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.headlineLarge(context, color: Colors.white).copyWith(
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w900,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(alpha: 0.5),
                                              offset: const Offset(2, 2),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (userInfo?.createdAt != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'MEMBER SINCE ${_getMonthName(userInfo!.createdAt!.month)} ${userInfo.createdAt!.year}',
                                          style: AppTextStyles.labelSmall(context,
                                                  color: Colors.white.withValues(alpha: 0.8))
                                              .copyWith(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                    // Compactable Chips Area
                                    Opacity(
                                      opacity: (1.0 - progress * 2.0).clamp(0.0, 1.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: [
                                            _buildInfoChip(
                                              context,
                                              icon: Icons.email_rounded,
                                              text: userInfo?.email ?? "N/A",
                                              borderColor: appColors.alternateOne,
                                            ),
                                            _buildInfoChip(
                                              context,
                                              icon: Icons.front_hand_rounded,
                                              text: userInfo?.shootingHand != null && userInfo!.shootingHand!.isNotEmpty
                                                  ? '${userInfo.shootingHand} hand'
                                                  : 'Hand: N/A',
                                              borderColor: appColors.primaryTwo,
                                            ),
                                            InkWell(
                                              onTap: () => context.pushNamed('user'),
                                              child: _buildInfoChip(
                                                context,
                                                icon: Icons.edit_note_rounded,
                                                text: 'Edit',
                                                borderColor: appColors.retroThree ?? Colors.red,
                                                isAction: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // --- FOREGROUND LAYER: Draggable Stats Panel ---
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  _sheetExtent.value = notification.extent;
                  return true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: _minExtent,
                  minChildSize: _minExtent,
                  maxChildSize: _maxExtent,
                  snap: true,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxWithShadow(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppThemeManager.secondaryBackground,
                            AppThemeManager.primaryBackground.withValues(alpha: 0.9),
                          ],
                        ),
                        shadowOffset: const Offset(0, -10),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Handle
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: ListView(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                              children: [
                                Text(
                                  'Performance Overview',
                                  style:
                                      AppTextStyles.headlineSmall(context, color: AppThemeManager.primaryText).copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    StatsContainer(
                                      borderColor: appColors.alternateOne,
                                      title: 'Set point',
                                      iconName: 'set_point',
                                      text: statisticsDataDecreasing?.firstOrNull?.setPointTotalScore?.toString(),
                                    ),
                                    StatsContainer(
                                      borderColor: appColors.alternateTwo,
                                      title: 'Jump',
                                      iconName: 'jump',
                                      text: statisticsDataDecreasing?.firstOrNull?.jumpTotalScore?.toString(),
                                    ),
                                    StatsContainer(
                                      borderColor: appColors.alternateThree ?? Colors.white,
                                      title: 'Elbow position',
                                      iconName: 'elbow_position',
                                      text: statisticsDataDecreasing?.firstOrNull?.elbowPositionTotalScore?.toString(),
                                    ),
                                    StatsContainer(
                                      borderColor: appColors.retroOne,
                                      title: 'Feet direction',
                                      iconName: 'feet_direction',
                                      text: statisticsDataDecreasing?.firstOrNull?.feetDirectionTotalScore?.toString(),
                                    ),
                                    StatsContainer(
                                      borderColor: appColors.retroTwo,
                                      title: 'Shot path',
                                      iconName: 'shot_path',
                                      text: statisticsDataDecreasing?.firstOrNull?.shotPathTotalScore?.toString(),
                                    ),
                                    StatsContainer(
                                      borderColor: appColors.retroThree ?? Colors.red,
                                      title: 'Follow through',
                                      iconName: 'follow_through',
                                      text: statisticsDataDecreasing?.firstOrNull?.followThroughTotalScore?.toString(),
                                    ),
                                  ],
                                ),

                                // Extra space at bottom
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // --- FLOATING EDIT BUTTON ---
              ValueListenableBuilder<double>(
                valueListenable: _sheetExtent,
                builder: (context, extent, child) {
                  final progress = ((extent - _minExtent) / (_maxExtent - _minExtent)).clamp(0.0, 1.0);
                  final isVisible = progress > 0.5;

                  return Positioned(
                    right: 20,
                    top: MediaQuery.of(context).padding.top + 20,
                    child: AnimatedOpacity(
                      opacity: isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Visibility(
                        visible: isVisible,
                        child: FloatingActionButton.small(
                          heroTag: 'profile_edit_fab',
                          backgroundColor: appColors.retroThree ?? Colors.red,
                          onPressed: () => context.pushNamed('user'),
                          child: const Icon(Icons.edit_note_rounded, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color borderColor,
    bool isAction = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: borderColor),
              const SizedBox(width: 10),
              Text(
                text,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              if (isAction) ...[
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white70),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
