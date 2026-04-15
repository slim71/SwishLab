import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:swish_lab/constants.dart';
import 'package:swish_lab/functions/add_animation.dart';
import 'package:swish_lab/functions/load_json_remote_or_app_state.dart';
import 'package:swish_lab/logger.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/widgets/app_bar.dart';
import 'package:swish_lab/widgets/background.dart';
import 'package:swish_lab/widgets/light_button.dart';
import 'package:swish_lab/widgets/settings_item.dart';
import 'package:swish_lab/widgets/settings_row.dart';
import 'package:swish_lab/widgets/social_icon_button.dart';

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

class _SettingsState extends ConsumerState<Settings>
    with TickerProviderStateMixin {
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
      appBar: MyAppBar(
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // "Follow us on" text
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 8),
                          child: Text(
                            'Follow us on',
                            style: AppTextStyles.labelMedium(context, color: Colors.black),
                          ),
                                  ),

                                  // Row with socials buttons
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Twitter button
                                    SocialIconButton(
                                            icon: FontAwesomeIcons.twitter,
                                      onTap: () {
                                  logger.d('twitterButton pressed ...');
                                },
                                    ),
                                    const SizedBox(width: 8),

                                          // Instagram button
                                          SocialIconButton(
                                            icon: FontAwesomeIcons.instagram,
                                            onTap: () {
                                  logger.d('instagramButton pressed ...');
                                },
                                          ),
                                          const SizedBox(width: 8),

                                          // Facebook button
                                    SocialIconButton(
                                            icon: FontAwesomeIcons.facebookF,
                                      onTap: () {
                                  logger.d('facebookButton pressed ...');
                                },
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "App version" text
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'App Versions',
                            style: AppTextStyles.titleLarge(context),
                          ),
                            ),

                                  // App version
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                          child: Text(
                            'v0.0.1',
                            style: AppTextStyles.labelMedium(context, color: Colors.black),
                          ),
                                  ),

                                  // Logout button
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                          child: LightButton(
                            onPressed: () async {
                              await ref.read(supabaseProvider).auth.signOut();
                            },
                                  text: 'Log Out',
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
