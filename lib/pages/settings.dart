import 'package:SwishLab/constants.dart';
import 'package:SwishLab/functions/load_json_remote_or_app_state.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:SwishLab/widgets/settings_item.dart';
import 'package:SwishLab/widgets/settings_row.dart';
import 'package:SwishLab/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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

  Widget animatedItem(Widget child, int index) {
    const slideDuration = 500;
    const settleDuration = 250;
    const delaySingle = 100;

    return child
        .animate()
        // Enter from bottom (no bounce)
        .slide(
          begin: const Offset(0, 100),
          end: Offset.zero,
          delay: (delaySingle * index).ms,
          duration: slideDuration.ms,
          curve: Curves.easeOutCubic,
        )
        // Small elastic settle
        .moveY(
          begin: 100,
          end: 0,
          delay: (delaySingle * index).ms + slideDuration.ms,
          curve: Curves.bounceOut,
          duration: settleDuration.ms,
        );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return Scaffold(
      backgroundColor: appColors.secondaryBackground,
      appBar: MyAppBar(
        style: MyAppBarStyle.titleOnly,
        title: 'Settings',
      ),
      body:
          // Container used to have a colored background
          Semantics(
        label: 'Background container',
              child: Background(
                child: Semantics(
                  label: 'Main column content',
            child: SingleChildScrollView(
              child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List of available settings
                        Semantics(
                          label: 'List of available settings',
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return animatedItem(
                                SettingsRow(
                                  item: items[index],
                                ),
                                index,
                              );
                            },
                          ),
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
                                    child: Semantics(
                                      label: '"Follow us on" text',
                                      child: Text(
                                        'Follow us on',
                                        style: AppTextStyles.labelMedium(),
                                      ),
                                    ),
                                  ),

                                  // Row with socials buttons
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Semantics(
                                label: 'Row with socials buttons',
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Twitter button
                                    SocialIconButton(
                                      borderColor: appColors.primaryBackground,
                                      backgroundColor:
                                      appColors.secondaryBackground,
                                      icon: FontAwesomeIcons.twitter,
                                      iconColor: appColors.secondaryText,
                                      onTap: () {
                                        print('twitterButton pressed ...');
                                      },
                                    ),
                                    const SizedBox(width: 8),

                                          // Instagram button
                                          SocialIconButton(
                                            borderColor: appColors.primaryBackground,
                                            backgroundColor: appColors.secondaryBackground,
                                            icon: FontAwesomeIcons.instagram,
                                            iconColor: appColors.secondaryText,
                                            onTap: () {
                                              print('instagramButton pressed ...');
                                            },
                                          ),
                                          const SizedBox(width: 8),

                                          // Facebook button
                                    SocialIconButton(
                                      borderColor: appColors.primaryBackground,
                                      backgroundColor:
                                      appColors.secondaryBackground,
                                      icon: FontAwesomeIcons.facebookF,
                                      iconColor: appColors.secondaryText,
                                      onTap: () {
                                        print('facebookButton pressed ...');
                                      },
                                    ),
                                  ],
                                ),
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
                              child: Semantics(
                                label: '"App version" text',
                                child: Text(
                                  'App Versions',
                                  style: AppTextStyles.titleLarge(),
                                ),
                              ),
                            ),

                                  // App version
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                                    child: Semantics(
                                      label: 'App version',
                                      child: Text(
                                        'v0.0.1',
                                        style: AppTextStyles.labelMedium(),
                                      ),
                                    ),
                                  ),

                                  // Logout button
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                              child: Semantics(
                                label: 'Logout button',
                                child: LightButton(
                                  onPressed: () async {
                                    // GoRouter.of(context).prepareAuthEvent();
                                    // await authManager.signOut();
                                    // GoRouter.of(context)
                                    //     .clearRedirectLocation();
                                    //
                                    // context.goNamedAuth(
                                    //     SplashScreenWidget.routeName,
                                    //     context.mounted);
                                    // AuthStorage.setLoggedIn(false);
                                  },
                                  text: 'Log Out',
                                ),
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
              )),
    );
  }
}
