import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/load_json_remote_or_app_state.dart';
import '../logger.dart';
import '../providers/debug_provider.dart';
import '../providers/supabase_provider.dart';
import '../providers/users_provider.dart';
import '../router/central_routing.dart' show rootScaffoldMessengerKey;
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/light_button.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_row.dart';
import '../widgets/social_icon_button.dart';

const slideDurationMs = 500; // [ms]
const settleDurationMs = 250; // [ms]
const singleDelayMs = 100; // [ms]

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
            context.pushNamed('appearance');
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
              context.pushNamed('user');
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
            context.pushNamed('getting-started');
          },
        ),
        _SettingsItemData(
          title: 'About Us',
          icon: Icons.info_rounded,
          onTap: (context) async {
            context.pushNamed('about');
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
            context.pushNamed('help');

            setState(() {});
          },
        ),
        _SettingsItemData(
          title: 'Credits',
          icon: Icons.favorite_rounded,
          onTap: (context) async {
            context.pushNamed('credits');
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
            context.pushNamed('document', pathParameters: {'name': 'PRIVACY'});
          },
        ),
        _SettingsItemData(
          title: 'Terms & Conditions',
          icon: Icons.description_rounded,
          onTap: (context) async {
            context.pushNamed('document', pathParameters: {'name': 'TAC'});
          },
        ),
        _SettingsItemData(
          title: 'EULA',
          icon: Icons.gavel_rounded,
          onTap: (context) async {
            context.pushNamed('document', pathParameters: {'name': 'EULA'});
          },
        ),
        _SettingsItemData(
          title: 'Disclaimer',
          icon: Icons.warning_rounded,
          onTap: (context) async {
            context.pushNamed('document', pathParameters: {'name': 'DISCLAIMER'});
          },
        ),
        _SettingsItemData(
          title: 'Acceptable Use Policy',
          icon: Icons.rule_rounded,
          onTap: (context) async {
            context.pushNamed('document', pathParameters: {'name': 'USE'});
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
            context.pushNamed('debug');
          },
        ),
      ],
    ),
  ];

  Widget _buildSectionHeader(String title, int animationIndex) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 16, 8),
      child: addAnimation(
        widget: Text(
          title.toUpperCase(),
          style: AppTextStyles.labelSmall(
            context,
            color: AppThemeManager.primaryText.withValues(alpha: 0.5),
          ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
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
          backgroundColor: AppThemeManager.primaryBackground,
          appBar: const MyAppBar(
            style: MyAppBarStyle.titleOnly,
            title: 'Settings',
          ),
          body: Builder(
            builder: (innerContext) {
              return Background(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...visibleSections.expand((section) {
                        final sectionIndex = visibleSections.indexOf(section);
                        int animationIndex = 0;
                        for (int i = 0; i < sectionIndex; i++) {
                          animationIndex += visibleSections[i].items.length + 1;
                        }

                        return [
                          _buildSectionHeader(section.title, animationIndex),
                          ...List.generate(section.items.length, (index) {
                            final data = section.items[index];
                            final color =
                                settingsItemBackgrounds[(animationIndex + index) % settingsItemBackgrounds.length];
                            final itemAnimationIndex = animationIndex + index + 1;

                            final settingsItem = SettingsItem(
                              title: data.title,
                              background: color,
                              icon: data.icon,
                              onTap: data.onTap,
                            );

                            return addAnimation(
                              widget: SettingsRow(item: settingsItem),
                              withFade: false,
                              slide: SlideConfig(
                                  begin: const Offset(0, 100),
                                  delay: Duration(milliseconds: singleDelayMs * itemAnimationIndex),
                                  duration: const Duration(milliseconds: slideDurationMs)),
                              moveY: MoveYConfig(
                                  begin: 100,
                                  delay: Duration(milliseconds: (singleDelayMs * itemAnimationIndex) + slideDurationMs),
                                  duration: const Duration(milliseconds: settleDurationMs)),
                            );
                          }),
                        ];
                      }),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 8),
                                  child: addAnimation(
                                    widget: Text(
                                      'Follow us on',
                                      style: AppTextStyles.labelMedium(context, color: AppThemeManager.primaryText),
                                    ),
                                    withFade: false,
                                    slide: SlideConfig(
                                        begin: const Offset(0, 100),
                                        delay: Duration(
                                            milliseconds: singleDelayMs * (_totalItemsCount + _sections.length)),
                                        duration: const Duration(milliseconds: slideDurationMs)),
                                    moveY: MoveYConfig(
                                        begin: 100,
                                        delay: Duration(
                                            milliseconds: (singleDelayMs * (_totalItemsCount + _sections.length)) +
                                                slideDurationMs),
                                        duration: const Duration(milliseconds: settleDurationMs)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      addAnimation(
                                        widget: SocialIconButton(
                                          const FaIcon(FontAwesomeIcons.twitter),
                                          onTap: () {
                                            logger.d('twitterButton pressed ...');
                                          },
                                        ),
                                        withFade: false,
                                        slide: SlideConfig(
                                            begin: const Offset(0, 100),
                                            delay: Duration(
                                                milliseconds:
                                                    singleDelayMs * (_totalItemsCount + _sections.length + 1)),
                                            duration: const Duration(milliseconds: slideDurationMs)),
                                        moveY: MoveYConfig(
                                            begin: 100,
                                            delay: Duration(
                                                milliseconds:
                                                    (singleDelayMs * (_totalItemsCount + _sections.length + 1)) +
                                                        slideDurationMs),
                                            duration: const Duration(milliseconds: settleDurationMs)),
                                      ),
                                      const SizedBox(width: 8),
                                      addAnimation(
                                        widget: SocialIconButton(
                                          const FaIcon(FontAwesomeIcons.instagram),
                                          onTap: () {
                                            logger.d('instagramButton pressed ...');
                                          },
                                        ),
                                        withFade: false,
                                        slide: SlideConfig(
                                            begin: const Offset(0, 100),
                                            delay: Duration(
                                                milliseconds:
                                                    singleDelayMs * (_totalItemsCount + _sections.length + 2)),
                                            duration: const Duration(milliseconds: slideDurationMs)),
                                        moveY: MoveYConfig(
                                            begin: 100,
                                            delay: Duration(
                                                milliseconds:
                                                    (singleDelayMs * (_totalItemsCount + _sections.length + 2)) +
                                                        slideDurationMs),
                                            duration: const Duration(milliseconds: settleDurationMs)),
                                      ),
                                      const SizedBox(width: 8),
                                      addAnimation(
                                        widget: SocialIconButton(
                                          const FaIcon(FontAwesomeIcons.facebookF),
                                          onTap: () {
                                            logger.d('facebookButton pressed ...');
                                          },
                                        ),
                                        withFade: false,
                                        slide: SlideConfig(
                                            begin: const Offset(0, 100),
                                            delay: Duration(
                                                milliseconds:
                                                    singleDelayMs * (_totalItemsCount + _sections.length + 3)),
                                            duration: const Duration(milliseconds: slideDurationMs)),
                                        moveY: MoveYConfig(
                                            begin: 100,
                                            delay: Duration(
                                                milliseconds:
                                                    (singleDelayMs * (_totalItemsCount + _sections.length + 3)) +
                                                        slideDurationMs),
                                            duration: const Duration(milliseconds: settleDurationMs)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                  child: addAnimation(
                                    widget: Text(
                                      'App Versions',
                                      style: AppTextStyles.titleLarge(context, color: AppThemeManager.primaryText),
                                    ),
                                    withFade: false,
                                    slide: SlideConfig(
                                        begin: const Offset(0, 100),
                                        delay: Duration(
                                            milliseconds: singleDelayMs * (_totalItemsCount + _sections.length + 4)),
                                        duration: const Duration(milliseconds: slideDurationMs)),
                                    moveY: MoveYConfig(
                                        begin: 100,
                                        delay: Duration(
                                            milliseconds: (singleDelayMs * (_totalItemsCount + _sections.length + 4)) +
                                                slideDurationMs),
                                        duration: const Duration(milliseconds: settleDurationMs)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                                  child: GestureDetector(
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
                                                content: Text('Developer mode enabled!'),
                                                backgroundColor: Colors.green),
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                      child: Text(
                                        'v0.0.1',
                                        style: AppTextStyles.labelMedium(context, color: AppThemeManager.primaryText),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                                  child: addAnimation(
                                    widget: LightButton(
                                      onPressed: () async {
                                        logger.w('LOGOUT triggered. Resetting states...');
                                        final supabase = ref.read(supabaseProvider);
                                        final debugNotifier = ref.read(debugProvider.notifier);
                                        final appStateNotifier = ref.read(appStateProvider.notifier);
                                        final container = ProviderScope.containerOf(context);

                                        await supabase.auth.signOut();
                                        debugNotifier.reset();
                                        appStateNotifier.reset();
                                        container.invalidate(appUserProvider);
                                        logger.i('Logout reset complete.');
                                      },
                                      text: 'Log Out',
                                    ),
                                    withFade: false,
                                    slide: SlideConfig(
                                        begin: const Offset(0, 100),
                                        delay: Duration(
                                            milliseconds: singleDelayMs * (_totalItemsCount + _sections.length + 6)),
                                        duration: const Duration(milliseconds: slideDurationMs)),
                                    moveY: MoveYConfig(
                                        begin: 100,
                                        delay: Duration(
                                            milliseconds: (singleDelayMs * (_totalItemsCount + _sections.length + 6)) +
                                                slideDurationMs),
                                        duration: const Duration(milliseconds: settleDurationMs)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
