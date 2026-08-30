import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/load_json_remote_or_app_state.dart';
import '../logger.dart';
import '../providers/auth_providers.dart';
import '../providers/debug_provider.dart';
import '../providers/users_provider.dart';
import '../router/central_routing.dart' show routerProvider, rootScaffoldMessengerKey;
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/light_button.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_row.dart';
import '../widgets/social_icon_button.dart';

const slideDurationMs = 500; // [ms]
const settleDurationMs = 250; // [ms]
const singleDelayMs = 80; // [ms]

class _SettingsItemData {
  final String title;
  final IconData icon;
  final Future<void> Function(BuildContext context) onTap;

  const _SettingsItemData({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _SettingsSection {
  final String title;
  final List<_SettingsItemData> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });
}

/// Settings page
class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> with TickerProviderStateMixin {
  List<Map<String, dynamic>>? faqsJsonList;
  int _debugTapCount = 0;

  late final List<_SettingsSection> _sections = [
    _SettingsSection(
      title: 'Preferences',
      items: [
        _SettingsItemData(
          title: 'Appearance',
          icon: Icons.palette_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('appearance');
          },
        ),
      ],
    ),
    _SettingsSection(
      title: 'Account',
      items: [
        _SettingsItemData(
            title: 'User Info',
            icon: Icons.person_rounded,
            onTap: (context) async {
              ref.read(routerProvider).pushNamed('user');
            }),
      ],
    ),
    _SettingsSection(
      title: 'Help & Support',
      items: [
        _SettingsItemData(
          title: 'Getting Started',
          icon: Icons.rocket_launch_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('getting-started');
          },
        ),
        _SettingsItemData(
          title: 'About Us',
          icon: Icons.info_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('about');
          },
        ),
        _SettingsItemData(
          title: 'Help',
          icon: Icons.help_rounded,
          onTap: (context) async {
            final appStateNotifier = ref.read(appStateProvider.notifier);

            faqsJsonList = await loadJsonRemoteOrAppState(
              'faqs',
              kDefaultFaqsJson,
            );
            appStateNotifier.setLoadedFaqs(faqsJsonList!);

            if (!context.mounted) return;
            ref.read(routerProvider).pushNamed('help');

            setState(() {});
          },
        ),
        _SettingsItemData(
          title: 'Credits',
          icon: Icons.favorite_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('credits');
          },
        ),
      ],
    ),
    _SettingsSection(
      title: 'Legal',
      items: [
        _SettingsItemData(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('document', pathParameters: {'name': 'PRIVACY'});
          },
        ),
        _SettingsItemData(
          title: 'Terms & Conditions',
          icon: Icons.description_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('document', pathParameters: {'name': 'TAC'});
          },
        ),
        _SettingsItemData(
          title: 'EULA',
          icon: Icons.gavel_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('document', pathParameters: {'name': 'EULA'});
          },
        ),
        _SettingsItemData(
          title: 'Disclaimer',
          icon: Icons.warning_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('document', pathParameters: {'name': 'DISCLAIMER'});
          },
        ),
        _SettingsItemData(
          title: 'Acceptable Use Policy',
          icon: Icons.rule_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('document', pathParameters: {'name': 'USE'});
          },
        ),
      ],
    ),
    _SettingsSection(
      title: 'Developer',
      items: [
        _SettingsItemData(
          title: 'Debug utilities',
          icon: Icons.bug_report_rounded,
          onTap: (context) async {
            ref.read(routerProvider).pushNamed('debug');
          },
        ),
      ],
    ),
  ];

  Widget _buildSectionHeader(String title, int animationIndex) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 16, 8),
      child: addAnimation(
        widget: ClipRRect(
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
                title.toUpperCase(),
                style: AppTextStyles.labelSmall(
                  context,
                  color: AppThemeManager.primaryText,
                ).copyWith(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        withFade: false,
        slide: SlideConfig(
            begin: const Offset(0, 100),
            delay: Duration(milliseconds: singleDelayMs * animationIndex),
            duration: const Duration(milliseconds: slideDurationMs)),
        moveY: MoveYConfig(
            begin: 100,
            delay: Duration(milliseconds: (singleDelayMs * animationIndex) + slideDurationMs),
            duration: const Duration(milliseconds: settleDurationMs)),
      ),
    );
  }

  Widget _buildIsland(List<Widget> children, int animationIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: addAnimation(
        widget: Container(
          decoration: BoxWithShadow(
            borderRadius: BorderRadius.circular(24),
            // Transparent background to let the row colors be the primary feature
            color: Colors.transparent,
            border: Border.all(
              color: AppThemeManager.currentColors.containersBorders.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Column(children: children),
            ),
          ),
        ),
        withFade: false,
        slide: SlideConfig(
            begin: const Offset(0, 100),
            delay: Duration(milliseconds: singleDelayMs * animationIndex),
            duration: const Duration(milliseconds: slideDurationMs)),
        moveY: MoveYConfig(
            begin: 100,
            delay: Duration(milliseconds: (singleDelayMs * animationIndex) + slideDurationMs),
            duration: const Duration(milliseconds: settleDurationMs)),
      ),
    );
  }

  int get _totalItemsCount => _sections.fold(0, (sum, section) => sum + section.items.length);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.forClass(this);
    final debugState = ref.watch(debugProvider);
    final showDebug = debugState.isDeveloperModeEnabled;
    final visibleSections = _sections.where((s) => s.title != 'Developer' || showDebug).toList();

    return ValueListenableBuilder<int>(
      valueListenable: AppThemeManager.notifier,
      builder: (context, _, __) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppThemeManager.primaryBackground,
          appBar: const MyAppBar(
            style: MyAppBarStyle.titleOnly,
            title: 'Settings',
          ),
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight + 40),
                  ...visibleSections.expand((section) {
                    final sectionIndex = visibleSections.indexOf(section);
                    int animationIndex = 0;
                    for (int i = 0; i < sectionIndex; i++) {
                      animationIndex += visibleSections[i].items.length + 1;
                    }

                    return [
                      _buildSectionHeader(section.title, animationIndex),
                      _buildIsland(
                        List.generate(section.items.length, (index) {
                          final data = section.items[index];
                          // Restore the distinctive colors from the lookup table
                          final color =
                              settingsItemBackgrounds[(animationIndex + index) % settingsItemBackgrounds.length];

                          return SettingsRow(
                            item: SettingsItem(
                              title: data.title,
                              background: color,
                              icon: data.icon,
                              onTap: data.onTap,
                            ),
                            showSeparator: index != section.items.length - 1,
                          );
                        }),
                        animationIndex + 1,
                      ),
                    ];
                  }),

                  // Redesigned Footer Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 80), // Increased bottom padding
                    child: addAnimation(
                      widget: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxWithShadow(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppThemeManager.secondaryBackground,
                              AppThemeManager.primaryBackground.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (showDebug) return;
                                    setState(() {
                                      _debugTapCount++;
                                      final stepsLeft = 10 - _debugTapCount;
                                      if (stepsLeft == 0) {
                                        ref.read(debugProvider.notifier).setDeveloperMode(true);
                                        _debugTapCount = 0;
                                        HapticFeedback.mediumImpact();
                                        rootScaffoldMessengerKey.currentState?.clearSnackBars();
                                        rootScaffoldMessengerKey.currentState?.showSnackBar(
                                          const SnackBar(
                                              content: Text('Developer mode enabled!'), backgroundColor: Colors.green),
                                        );
                                      } else if (stepsLeft > 0 && stepsLeft <= 3) {
                                        rootScaffoldMessengerKey.currentState?.clearSnackBars();
                                        rootScaffoldMessengerKey.currentState?.showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('You are now $stepsLeft steps away from being a developer.'),
                                              duration: const Duration(seconds: 1)),
                                        );
                                      }
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SwishLab',
                                        style: AppTextStyles.headlineSmall(context, color: AppThemeManager.primaryText)
                                            .copyWith(
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Version 0.0.1',
                                        style: AppTextStyles.labelSmall(context,
                                            color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SocialIconButton(
                                      const FaIcon(
                                        FontAwesomeIcons.twitter,
                                        size: 18,
                                        color: Color(0xFF1DA1F2),
                                      ),
                                      borderColor: const Color(0xFF1DA1F2).withValues(alpha: 0.3),
                                      backgroundColor: const Color(0xFF1DA1F2).withValues(alpha: 0.1),
                                      onTap: () => logger.d('twitter'),
                                    ),
                                    const SizedBox(width: 8),
                                    SocialIconButton(
                                      const FaIcon(
                                        FontAwesomeIcons.instagram,
                                        size: 18,
                                        color: Color(0xFFE1306C),
                                      ),
                                      borderColor: const Color(0xFFE1306C).withValues(alpha: 0.3),
                                      backgroundColor: const Color(0xFFE1306C).withValues(alpha: 0.1),
                                      onTap: () => logger.d('instagram'),
                                    ),
                                    const SizedBox(width: 8),
                                    SocialIconButton(
                                      const FaIcon(
                                        FontAwesomeIcons.facebookF,
                                        size: 18,
                                        color: Color(0xFF1877F2),
                                      ),
                                      borderColor: const Color(0xFF1877F2).withValues(alpha: 0.3),
                                      backgroundColor: const Color(0xFF1877F2).withValues(alpha: 0.1),
                                      onTap: () => logger.d('facebook'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 48),
                            Text(
                              'Made with ❤️ for the game',
                              style: AppTextStyles.labelMedium(context,
                                  color: AppThemeManager.primaryText.withValues(alpha: 0.3)),
                            ),
                            const SizedBox(height: 20),
                            LightButton(
                              onPressed: () async {
                                logger.w('LOGOUT triggered. Resetting states...');
                                final authService = ref.read(authServiceProvider);
                                final debugNotifier = ref.read(debugProvider.notifier);
                                final appStateNotifier = ref.read(appStateProvider.notifier);
                                final container = ProviderScope.containerOf(context);

                                await authService.signOut();
                                await debugNotifier.reset();
                                appStateNotifier.reset();
                                AppThemeManager.clearPreferences(); // Clear theme preferences
                                container.invalidate(appUserProvider);
                                container.invalidate(debugProvider);
                                logger.i('Logout reset complete.');
                              },
                              text: 'Log Out',
                            ),
                          ],
                        ),
                      ),
                      withFade: false,
                      slide: SlideConfig(
                        begin: const Offset(0, 100),
                        delay: Duration(milliseconds: singleDelayMs * (_totalItemsCount + _sections.length + 5)),
                        duration: const Duration(milliseconds: slideDurationMs),
                      ),
                      moveY: MoveYConfig(
                        begin: 100,
                        delay: Duration(
                            milliseconds:
                                (singleDelayMs * (_totalItemsCount + _sections.length + 5)) + slideDurationMs),
                        duration: const Duration(milliseconds: settleDurationMs),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Extra safety space at the very bottom
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
