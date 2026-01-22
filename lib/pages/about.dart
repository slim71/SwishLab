import 'dart:ui';

import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  DateTime? datePicked;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: appColors.secondaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'About Us',
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: appColors.gradientBackground(),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Stack(
                    alignment: AlignmentDirectional(0, -1),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Image.asset(
                          'assets/images/me_on_bike.jpg',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          alignment: Alignment(0, -0.5),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 1),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4,
                              sigmaY: 10,
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                width: double.infinity,
                                height: 105,
                                decoration: BoxDecoration(
                                  color: Color(0x7F1D428A),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15, 0, 15, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Simone Vollaro',
                                              style: AppTextStyles.headlineMedium(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: IconActionButton(
                                                icon: Icons.paypal,
                                                iconColor:
                                                    appColors.secondaryText,
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(
                                                      'https://www.paypal.com/donate/?hosted_button_id=TCJL6TZHSYJU8'));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: IconActionButton(
                                                icon: Icons.email,
                                                iconColor:
                                                    appColors.secondaryText,
                                                onPressed: () async {
                                                  await launchUrl(Uri(
                                                      scheme: 'mailto',
                                                      path:
                                                          'slim71sv@gmail.com',
                                                      query: {
                                                        'subject':
                                                            'Enter the subject',
                                                        'body': 'AMA',
                                                      }
                                                          .entries
                                                          .map((MapEntry<String,
                                                                      String>
                                                                  e) =>
                                                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                          .join('&')));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: IconActionButton(
                                                icon: FontAwesomeIcons.github,
                                                iconColor:
                                                    appColors.secondaryText,
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(
                                                      'https://github.com/slim71/'));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: IconActionButton(
                                                icon:
                                                    FontAwesomeIcons.linkedinIn,
                                                iconColor:
                                                    appColors.secondaryText,
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(
                                                      'https://www.linkedin.com/in/simone-vollaro-325185152/'));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: IconActionButton(
                                                icon: Icons.reddit_sharp,
                                                iconColor:
                                                    appColors.secondaryText,
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(
                                                      'https://www.reddit.com/user/feller94/'));
                                                },
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Who am I?',
                        style: AppTextStyles.titleLarge(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 44),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColors.primaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x301D2429),
                          offset: Offset(
                            0.0,
                            1,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Hi, I’m Simone.\n',
                                        style: AppTextStyles.bodyMedium(),
                                      ),
                                      TextSpan(
                                        text:
                                            'I’m a software engineer with a background in robotics, automation, and programming — and someone who',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text:
                                            ' has always loved building things. ',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Over the years I’ve worked on all kinds of personal projects, from drones to 3D printers, and this app is simply the latest creation that grew from that same curiosity.\n\nI’ve also been wanting to give something back to the community for a while. Working on an open-source project felt like the right way to do that — something useful, but also something personal.',
                                        style: TextStyle(),
                                      )
                                    ],
                                    style: AppTextStyles.bodyMedium(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Stack(
                                    alignment: AlignmentDirectional(0, 1),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            'assets/images/team_pic.jpg',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 1),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 4,
                                                sigmaY: 10,
                                              ),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Color(0x330C0C0C),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0, 1),
                                                            child: Text(
                                                              'Basketball has been part of my life since I was a kid. I played throughout my childhood and teenage years, and it had a huge impact on me. It made me more social, helped me find confidence around people, and gave me a way to stay in shape. ',
                                                              style: AppTextStyles.bodyMedium(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'I was never a professional player, but I did reach some moments I’m still proud of, like being selected for the ',
                                            style: AppTextStyles.bodyMedium(),
                                          ),
                                          TextSpan(
                                            text: 'All-Star Toscana game',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' when I was 14.',
                                            style: TextStyle(),
                                          )
                                        ],
                                        style: AppTextStyles.bodyMedium(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/trophy.jpg',
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'When I moved to Pisa for university, life changed a bit and basketball slipped more into the background. I still kept in touch with it, just not as much as before. But in 2020 I found my way back, and even joined an amateur team in Rome for a year — and it reminded me how much I had missed it.',
                                  style: AppTextStyles.bodyMedium(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/gifs/me_shooting.gif',
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Over the last couple of years, I’ve been trying to return to the form I had in my younger days… or maybe even better. I also joined the  ',
                                        style: AppTextStyles.bodyMedium(),
                                      ),
                                      TextSpan(
                                        text:
                                            'r/BasketballTips community on Reddit, ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        mouseCursor: SystemMouseCursors.click,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await launchUrl(Uri.parse(
                                                'https://www.reddit.com/r/BasketballTips/'));
                                          },
                                      ),
                                      TextSpan(
                                        text:
                                            'where I saw many people asking for feedback on their shooting form, footwork, and general technique.',
                                        style: TextStyle(),
                                      )
                                    ],
                                    style: AppTextStyles.bodyMedium(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'That’s when the idea for this app started to form: ',
                                          style: AppTextStyles.bodyMedium(),
                                        ),
                                        TextSpan(
                                          text:
                                              'a simple tool to help people understand their movement and improve, even if they don’t have a coach watching them all the time.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '\n\nThis project is my way of combining the things I care about — technology, learning, and basketball — and hopefully',
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text:
                                              ' making something that can help others along the way.',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      ],
                                      style: AppTextStyles.bodyMedium(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
