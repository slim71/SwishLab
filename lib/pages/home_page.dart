import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../logger.dart';
import '../models/statistics_row.dart';
import '../models/users_row.dart';
import '../providers/statistics_provider.dart';
import '../providers/users_provider.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';

/// Home page
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void _showShootingHandPrompt() {
    AppLogger.scope('HomePage').i('Showing shooting hand prompt.');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppThemeManager.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Info needed'),
        content: Text(
          'One quick step before you continue: tell us your shooting hand.',
          style: AppTextStyles.bodyLarge(context, color: AppThemeManager.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(appStateProvider.notifier).setSessionInitialized(true);
              Navigator.pop(ctx);
              context.goNamed('user');
            },
            child: Text('Ok', style: TextStyle(color: AppThemeManager.currentColors.primaryOne)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.forClass(this);
    final appState = ref.watch(appStateProvider);
    final sessionInitialized = appState.sessionInitialized;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    // Listen for user data changes to trigger the one-time prompt
    ref.listen<AsyncValue<UsersRow?>>(appUserProvider, (previous, next) {
      // If we are already showing a dialog, don't trigger another one
      if (ModalRoute.of(context)?.isCurrent != true) return;

      next.whenData((user) {
        if (user == null) return;
        final isRequired = (user.shootingHand == null || user.shootingHand!.isEmpty);

        if (!sessionInitialized && isRequired) {
          _showShootingHandPrompt();
        } else if (!sessionInitialized && !isRequired) {
          // If they already have it, just mark session as initialized
          ref.read(appStateProvider.notifier).setSessionInitialized(true);
        }
      });
    });

    final hasShootingHand = (userInfo?.shootingHand?.isNotEmpty ?? false);
    final appColors = AppThemeManager.currentColors;
    final statsAsync = ref.watch(userStatisticsProvider);
    final statsData = statsAsync.value;
    final List<StatisticsRow> checkedForms = statsData?.items ?? const <StatisticsRow>[];

    // Total count now comes directly from the backend via provider state
    final totalSessions = statsData?.totalCount ?? 0;

    // latest session is now the first item due to descending order in repository
    final last = checkedForms.firstOrNull;

    final lastSessionScore = _calculateRowAvg(last);

    double totalOfAll = 0;
    for (var form in checkedForms) {
      totalOfAll += _calculateRowAvg(form);
    }
    final overallAvgScore = checkedForms.isEmpty ? 0.0 : totalOfAll / checkedForms.length;

    Color getScoreColor(double score) {
      return score >= 0.8
          ? Colors.greenAccent
          : score >= 0.5
              ? Colors.yellowAccent
              : Colors.redAccent;
    }

    final overallColor = getScoreColor(overallAvgScore);
    final lastColor = getScoreColor(lastSessionScore);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppThemeManager.primaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.titleWithProfileImage,
          title: 'Home',
          height: 80,
          onProfilePressed: () async {
            logger.d('Navigating...');
            context.goNamed('profile');
          },
          profileImageUrl: userInfo?.profilePic ?? kDefaultProfilePictureUrl,
        ),
        body: Background(
          child: Stack(
            children: [
              // Premium Animated Mesh Background Elements
              Positioned.fill(
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      right: -100,
                      child: _buildBlurCircle(300, appColors.primaryOne.withValues(alpha: 0.06)),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .move(duration: 10.seconds, begin: const Offset(-50, 50), end: const Offset(50, -50)),
                    Positioned(
                      bottom: -50,
                      left: -50,
                      child: _buildBlurCircle(250, appColors.alternateTwo.withValues(alpha: 0.04)),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .move(duration: 8.seconds, begin: const Offset(30, -30), end: const Offset(-30, 30)),
                  ],
                ),
              ),

              // --- Scrollable Content ---
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Glassmorphic Hero Card ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: AppTextStyles.labelMedium(context,
                                            color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                                      ),
                                      Text(
                                        userInfo?.firstName ?? 'Athlete',
                                        style: AppTextStyles.headlineMedium(context, color: AppThemeManager.primaryText)
                                            .copyWith(fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  _buildHeroStat(
                                    context,
                                    label: 'Sessions',
                                    value: totalSessions.toString(),
                                    icon: Icons.analytics_outlined,
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(height: 1, thickness: 0.5, color: Colors.black12),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Overall Health
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _buildShotHealthIndicator(overallAvgScore, overallColor),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Overall Avg',
                                                style: AppTextStyles.labelSmall(context,
                                                    color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                                              ),
                                              Text(
                                                '${(overallAvgScore * 100).toInt()}%',
                                                style: AppTextStyles.titleMedium(context, color: overallColor)
                                                    .copyWith(fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Last Session
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _buildShotHealthIndicator(lastSessionScore, lastColor),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Last Session',
                                                style: AppTextStyles.labelSmall(context,
                                                    color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                                              ),
                                              Text(
                                                '${(lastSessionScore * 100).toInt()}%',
                                                style: AppTextStyles.titleMedium(context, color: lastColor)
                                                    .copyWith(fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 600.ms).slideY(begin: 0.1, curve: Curves.easeOutBack),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
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
                                    'SHOOT ANALYSIS MODES',
                                    style:
                                        AppTextStyles.labelSmall(context, color: AppThemeManager.primaryText).copyWith(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),

                      if (!hasShootingHand) _buildActionRequiredBanner(),

                      _buildFeatureCard(
                        context,
                        title: 'Front View',
                        description:
                            'Helps identify lateral deviations in the shot path and arm alignment ("chicken wing")',
                        imagePath: 'assets/images/thompson_front.jpg',
                        isLocked: !hasShootingHand,
                        onTap: () => context.pushNamed('front'),
                        color: appColors.primaryOne,
                      ).animate(delay: 200.ms).fade().slideX(begin: 0.1),

                      _buildFeatureCard(
                        context,
                        title: 'Side View',
                        description:
                            'Focuses on ball motion toward/away from the body - useful for refining release consistency',
                        imagePath: 'assets/images/curry_side.jpg',
                        isLocked: !hasShootingHand,
                        onTap: () => context.pushNamed('side'),
                        color: appColors.alternateTwo,
                      ).animate(delay: 400.ms).fade().slideX(begin: 0.1),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (c) => c.repeat()).blurXY(begin: 40, end: 80, duration: 5.seconds);
  }

  Widget _buildGlassCard({required Widget child, Color? borderColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppThemeManager.secondaryBackground.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: (borderColor ?? Colors.white).withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: (borderColor ?? Colors.black).withValues(alpha: 0.1),
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

  Widget _buildHeroStat(BuildContext context, {required String label, required String value, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppThemeManager.primaryText.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTextStyles.labelSmall(context, color: AppThemeManager.primaryText.withValues(alpha: 0.4))),
            Text(value,
                style: AppTextStyles.titleLarge(context, color: AppThemeManager.primaryText)
                    .copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  Widget _buildShotHealthIndicator(double score, Color color) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            color: color.withValues(alpha: 0.1),
          ),
          CircularProgressIndicator(
            value: score,
            strokeWidth: 4,
            color: color,
            strokeCap: StrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required bool isLocked,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: _buildGlassCard(
          borderColor: color,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleLarge(context, color: AppThemeManager.primaryText)
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style:
                          AppTextStyles.bodySmall(context, color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isLocked)
                Icon(Icons.lock_outline_rounded, color: AppThemeManager.primaryText.withValues(alpha: 0.3))
              else
                Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRequiredBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You can\'t use these yet - tell us your shooting hand first!',
                style: AppTextStyles.bodyMedium(context, color: Colors.redAccent).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => context.pushNamed('user'),
              child: const Text('Setup', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ).animate().shake(duration: 500.ms),
    );
  }

  double _calculateRowAvg(StatisticsRow? row) {
    if (row == null) return 0.0;
    return ((row.setPointTotalScore ?? 0.0) +
            (row.jumpTotalScore ?? 0.0) +
            (row.elbowPositionTotalScore ?? 0.0) +
            (row.feetDirectionTotalScore ?? 0.0) +
            (row.shotPathTotalScore ?? 0.0) +
            (row.followThroughTotalScore ?? 0.0)) /
        6;
  }
}
