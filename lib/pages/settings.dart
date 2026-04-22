import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/load_json_remote_or_app_state.dart';
import '../logger.dart';
import '../providers/supabase_provider.dart';
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
  final Future<void> Function(BuildContext context) onTap;

  const _SettingsItemData({
    required this.title,
    required this.onTap,
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

  late final List<_SettingsItemData> _settingsData = [
    _SettingsItemData(
        title: 'User Info',
        onTap: (context) async {
          context.pushNamed('user');
        }),
    _SettingsItemData(
      title: 'Getting Started',
      onTap: (context) async {
        context.pushNamed('getting-started');
      },
    ),
    _SettingsItemData(
      title: 'About Us',
      onTap: (context) async {
        context.pushNamed('about');
      },
    ),
    _SettingsItemData(
      title: 'Help',
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
      title: 'Privacy Policy',
      onTap: (context) async {
        context.pushNamed('document', pathParameters: {'name': 'PRIVACY'});
      },
    ),
    _SettingsItemData(
      title: 'Terms & Conditions',
      onTap: (context) async {
        context.pushNamed('document', pathParameters: {'name': 'TAC'});
      },
    ),
    _SettingsItemData(
      title: 'EULA',
      onTap: (context) async {
        context.pushNamed('document', pathParameters: {'name': 'EULA'});
      },
    ),
    _SettingsItemData(
      title: 'Disclaimer',
      onTap: (context) async {
        context.pushNamed('document', pathParameters: {'name': 'DISCLAIMER'});
      },
    ),
    _SettingsItemData(
      title: 'Acceptable Use Policy',
      onTap: (context) async {
        context.pushNamed('document', pathParameters: {'name': 'USE'});
      },
    ),
    _SettingsItemData(
      title: 'Credits',
      onTap: (context) async {
        context.pushNamed('credits');
      },
    ),
    _SettingsItemData(
      title: 'Debug utilities',
      onTap: (context) async {
        context.pushNamed('debug');
      },
    ),
  ];

  List<SettingsItem> get items => List.generate(_settingsData.length, (index) {
        final data = _settingsData[index];
        final color = settingsItemBackgrounds[index % settingsItemBackgrounds.length];

        return SettingsItem(
          title: data.title,
          background: color,
          onTap: data.onTap,
        );
      });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.forClass(this);

    return Scaffold(
      backgroundColor: AppThemeManager.primaryBackground,
      appBar: const MyAppBar(
        style: MyAppBarStyle.titleOnly,
        title: 'Settings',
      ),
      body:
          // Container used to have a colored background
          Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // List of available settings
              ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return addAnimation(
                    widget: SettingsRow(item: items[index]),
                    withFade: false,
                    slide: SlideConfig(
                        begin: const Offset(0, 100),
                        delay: Duration(milliseconds: singleDelayMs * index),
                        duration: const Duration(milliseconds: slideDurationMs)),
                    moveY: MoveYConfig(
                        begin: 100,
                        delay: Duration(milliseconds: (singleDelayMs * index) + slideDurationMs),
                        duration: const Duration(milliseconds: settleDurationMs)),
                  );
                },
              ),
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
                        // "Follow us on" text
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 8),
                          child: addAnimation(
                            widget: Text(
                              'Follow us on',
                              style: AppTextStyles.labelMedium(context, color: Colors.black),
                            ),
                            withFade: false,
                            slide: SlideConfig(
                                begin: const Offset(0, 100),
                                delay: Duration(milliseconds: singleDelayMs * items.length),
                                duration: const Duration(milliseconds: slideDurationMs)),
                            moveY: MoveYConfig(
                                begin: 100,
                                delay: Duration(milliseconds: (singleDelayMs * items.length) + slideDurationMs),
                                duration: const Duration(milliseconds: settleDurationMs)),
                          ),
                        ),

                        // Row with socials buttons
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Twitter button
                              addAnimation(
                                widget: SocialIconButton(
                                  icon: FontAwesomeIcons.twitter,
                                  onTap: () {
                                    logger.d('twitterButton pressed ...');
                                  },
                                ),
                                withFade: false,
                                slide: SlideConfig(
                                    begin: const Offset(0, 100),
                                    delay: Duration(milliseconds: singleDelayMs * (items.length + 1)),
                                    duration: const Duration(milliseconds: slideDurationMs)),
                                moveY: MoveYConfig(
                                    begin: 100,
                                    delay:
                                        Duration(milliseconds: (singleDelayMs * (items.length + 1)) + slideDurationMs),
                                    duration: const Duration(milliseconds: settleDurationMs)),
                              ),
                              const SizedBox(width: 8),

                              // Instagram button
                              addAnimation(
                                widget: SocialIconButton(
                                  icon: FontAwesomeIcons.instagram,
                                  onTap: () {
                                    logger.d('instagramButton pressed ...');
                                  },
                                ),
                                withFade: false,
                                slide: SlideConfig(
                                    begin: const Offset(0, 100),
                                    delay: Duration(milliseconds: singleDelayMs * (items.length + 2)),
                                    duration: const Duration(milliseconds: slideDurationMs)),
                                moveY: MoveYConfig(
                                    begin: 100,
                                    delay:
                                        Duration(milliseconds: (singleDelayMs * (items.length + 2)) + slideDurationMs),
                                    duration: const Duration(milliseconds: settleDurationMs)),
                              ),
                              const SizedBox(width: 8),

                              // Facebook button
                              addAnimation(
                                widget: SocialIconButton(
                                  icon: FontAwesomeIcons.facebookF,
                                  onTap: () {
                                    logger.d('facebookButton pressed ...');
                                  },
                                ),
                                withFade: false,
                                slide: SlideConfig(
                                    begin: const Offset(0, 100),
                                    delay: Duration(milliseconds: singleDelayMs * (items.length + 3)),
                                    duration: const Duration(milliseconds: slideDurationMs)),
                                moveY: MoveYConfig(
                                    begin: 100,
                                    delay:
                                        Duration(milliseconds: (singleDelayMs * (items.length + 3)) + slideDurationMs),
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
                        // "App version" text
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: addAnimation(
                            widget: Text(
                              'App Versions',
                              style: AppTextStyles.titleLarge(context),
                            ),
                            withFade: false,
                            slide: SlideConfig(
                                begin: const Offset(0, 100),
                                delay: Duration(milliseconds: singleDelayMs * (items.length + 4)),
                                duration: const Duration(milliseconds: slideDurationMs)),
                            moveY: MoveYConfig(
                                begin: 100,
                                delay: Duration(milliseconds: (singleDelayMs * (items.length + 4)) + slideDurationMs),
                                duration: const Duration(milliseconds: settleDurationMs)),
                          ),
                        ),

                        // App version
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: addAnimation(
                            widget: Text(
                              'v0.0.1',
                              style: AppTextStyles.labelMedium(context, color: Colors.black),
                            ),
                            withFade: false,
                            slide: SlideConfig(
                                begin: const Offset(0, 100),
                                delay: Duration(milliseconds: singleDelayMs * (items.length + 5)),
                                duration: const Duration(milliseconds: slideDurationMs)),
                            moveY: MoveYConfig(
                                begin: 100,
                                delay: Duration(milliseconds: (singleDelayMs * (items.length + 5)) + slideDurationMs),
                                duration: const Duration(milliseconds: settleDurationMs)),
                          ),
                        ),

                        // Logout button
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                          child: addAnimation(
                            widget: LightButton(
                              onPressed: () async {
                                await ref.read(supabaseProvider).auth.signOut();
                              },
                              text: 'Log Out',
                            ),
                            withFade: false,
                            slide: SlideConfig(
                                begin: const Offset(0, 100),
                                delay: Duration(milliseconds: singleDelayMs * (items.length + 6)),
                                duration: const Duration(milliseconds: slideDurationMs)),
                            moveY: MoveYConfig(
                                begin: 100,
                                delay: Duration(milliseconds: (singleDelayMs * (items.length + 6)) + slideDurationMs),
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
      ),
    );
  }
}
