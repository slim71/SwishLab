import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:SwishLab/widgets/settings_item.dart';
import 'package:SwishLab/widgets/settings_row.dart';
import 'package:SwishLab/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Settings page
class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Stores action output result for [Custom Action - loadJsonRemoteOrAppState] action in helpContainer widget.
  List<dynamic>? faqsJsonList;
  final List<SettingsItem> items = [
    SettingsItem(
        title: 'User Info',
        background: const Color(0x33FFC72C),
        onTap: () async {
          // context.pushNamed(UserDataWidget.routeName);
        }),
    SettingsItem(
      title: 'Getting Started',
      background: const Color(0x340C0C0C),
      onTap: () async {
        // context.pushNamed(
        //     GettingStartedPageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'About Us',
      background: const Color(0x35BE3A34),
      onTap: () async {
        // context.pushNamed(AboutUsWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Help',
      background: const Color(0x33FFC72C),
      onTap: () async {
        // _model.faqsJsonList =
        // await actions.loadJsonRemoteOrAppState(
        //   'faqs',
        //   FFAppConstants.defaultFaqs,
        // );
        // FFAppState().loadedFaqs = _model.faqsJsonList!
        //     .toList()
        //     .cast<dynamic>();
        //
        // context.pushNamed(HelpPageWidget.routeName);
        //
        // safeSetState(() {});
      },
    ),
    SettingsItem(
      title: 'Privacy Policy',
      background: const Color(0x340C0C0C),
      onTap: () async {
        // context.pushNamed(
        //     PrivacyPolicyPageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Terms & Conditions',
      background: const Color(0x35BE3A34),
      onTap: () async {
        // context.pushNamed(TacPageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'EULA',
      background: const Color(0x33FFC72C),
      onTap: () async {
        // context.pushNamed(EulaPageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Disclaimer',
      background: const Color(0x340C0C0C),
      onTap: () async {
        // context
        //     .pushNamed(DisclaimerPageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Acceptable Use Policy',
      background: const Color(0x35BE3A34),
      onTap: () async {
        // context.pushNamed(
        //     AcceptableUsePageWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Credits',
      background: const Color(0x33FFC72C),
      onTap: () async {
        // context.pushNamed(CreditsWidget.routeName);
      },
    ),
    SettingsItem(
      title: 'Debug utilities',
      background: const Color(0x340C0C0C),
      onTap: () async {
        // context
        //     .pushNamed(DebugUtilitiesWidget.routeName);
      },
    ),
  ];

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
        // 1️⃣ enter from bottom (no bounce)
        .slide(
          begin: const Offset(0, 100),
          end: Offset.zero,
          delay: (delaySingle * index).ms,
          duration: slideDuration.ms,
          curve: Curves.easeOutCubic,
        )
        // 2️⃣ small elastic settle
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
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: appColors.primaryOne,
        automaticallyImplyLeading: false,
        title:
            // Settings page title
            Semantics(
          label: 'Settings page title',
          child: Text(
            'Settings',
            style: AppTextStyles.displaySmall(context),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 10,
      ),
      body:
          // Container used to have a colored background
          Semantics(
        label: 'Background container',
        child: Container(
          decoration: BoxDecoration(gradient: appColors.gradientBackground()),
          child:
              // Main column with the settings page content
              Semantics(
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 4, 0, 8),
                              child: Semantics(
                                label: '"Follow us on" text',
                                child: Text(
                                  'Follow us on',
                                  style: AppTextStyles.labelMedium(context),
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
                                      backgroundColor:
                                          appColors.secondaryBackground,
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
                                  style: AppTextStyles.titleLarge(context),
                                ),
                              ),
                            ),

                            // App version
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                              child: Semantics(
                                label: 'App version',
                                child: Text(
                                  'v0.0.1',
                                  style: AppTextStyles.labelMedium(context),
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
        ),
      ),
    );
  }
}
