import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/shadow_from_color.dart';
import '../styles/styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/icon_action_button.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: const MyAppBar(
            style: MyAppBarStyle.backButtonTitleLeft,
            title: 'About Us',
          ),
          body: Background(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      alignment: const AlignmentDirectional(0, -1),
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Image.asset(
                            'assets/images/me_on_bike.jpg',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.5),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 4,
                                sigmaY: 10,
                              ),
                              child: InkWell(
                                child: Container(
                                  width: double.infinity,
                                  height: 105,
                                  decoration: BoxDecoration(
                                    color: shadowFromColor(Colors.indigo),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Simone Vollaro',
                                                style: AppTextStyles.headlineMedium(context, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                                child: IconActionButton(
                                                  const Icon(Icons.paypal),
                                                  iconColor: Colors.white,
                                                  onPressed: () async {
                                                    await launchUrl(Uri.parse(
                                                        'https://www.paypal.com/donate/?hosted_button_id=TCJL6TZHSYJU8'));
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                                child: IconActionButton(
                                                  const Icon(Icons.email),
                                                  iconColor: Colors.white,
                                                  onPressed: () async {
                                                    await launchUrl(Uri(
                                                        scheme: 'mailto',
                                                        path: 'slim71sv@gmail.com',
                                                        query: {
                                                          'subject': 'Enter the subject',
                                                          'body': 'AMA',
                                                        }
                                                            .entries
                                                            .map((MapEntry<String, String> e) =>
                                                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                            .join('&')));
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                                child: IconActionButton(
                                                  const FaIcon(FontAwesomeIcons.github),
                                                  iconColor: Colors.white,
                                                  onPressed: () async {
                                                    await launchUrl(Uri.parse('https://github.com/slim71/'));
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                                child: IconActionButton(
                                                  const FaIcon(FontAwesomeIcons.linkedinIn),
                                                  iconColor: Colors.white,
                                                  onPressed: () async {
                                                    await launchUrl(Uri.parse(
                                                        'https://www.linkedin.com/in/simone-vollaro-325185152/'));
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                                child: IconActionButton(
                                                  const Icon(Icons.reddit_sharp),
                                                  iconColor: Colors.white,
                                                  onPressed: () async {
                                                    await launchUrl(Uri.parse('https://www.reddit.com/user/feller94/'));
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
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Who am I?',
                          style: AppTextStyles.titleLarge(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 44),
                    child: Container(
                      decoration: BoxWithShadow(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: CustomTextSpan(
                                      context,
                                      children: [
                                        CustomTextSpan(
                                          context,
                                          text: 'Hi, I’m Simone.\n',
                                        ),
                                        CustomTextSpan(
                                          context,
                                          text:
                                              'I’m a software engineer with a background in robotics, automation, and programming — and someone who',
                                        ),
                                        CustomTextSpan(context,
                                            text: ' has always loved building things. ', italic: true),
                                        CustomTextSpan(
                                          context,
                                          text:
                                              'Over the years I’ve worked on all kinds of personal projects, from drones to 3D printers, and this app is simply the latest creation that grew from that same curiosity.\n\nI’ve also been wanting to give something back to the community for a while. Working on an open-source project felt like the right way to do that — something useful, but also something personal.',
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Stack(
                                      alignment: const AlignmentDirectional(0, 1),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/team_pic.jpg',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(0, 1),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 4,
                                                  sigmaY: 10,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: shadowFromColor(Colors.black),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment: const AlignmentDirectional(0, 1),
                                                              child: Text(
                                                                'Basketball has been part of my life since I was a kid. I played throughout my childhood and teenage years, and it had a huge impact on me. It made me more social, helped me find confidence around people, and gave me a way to stay in shape. ',
                                                                style: AppTextStyles.bodyMedium(context,
                                                                    color: Colors.white),
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
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: CustomTextSpan(
                                      context,
                                      children: [
                                        CustomTextSpan(
                                          context,
                                          text:
                                              'I was never a professional player, but I did reach some moments I’m still proud of, like being selected for the ',
                                        ),
                                        CustomTextSpan(context,
                                            text: 'All-Star Toscana game', italic: true, bold: true),
                                        CustomTextSpan(
                                          context,
                                          text: ' when I was 14.',
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/trophy.jpg',
                                    width: MediaQuery.sizeOf(context).width * 0.2,
                                    fit: BoxFit.cover,
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
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'When I moved to Pisa for university, life changed a bit and basketball slipped more into the background. I still kept in touch with it, just not as much as before. But in 2020 I found my way back, and even joined an amateur team in Rome for a year — and it reminded me how much I had missed it.',
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/gifs/me_shooting.gif',
                                    width: MediaQuery.sizeOf(context).width * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                  child: RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: CustomTextSpan(
                                      context,
                                      children: [
                                        CustomTextSpan(
                                          context,
                                          text:
                                              'Over the last couple of years, I’ve been trying to return to the form I had in my younger days… or maybe even better. I also joined the  ',
                                        ),
                                        CustomTextSpan(
                                          context,
                                          text: 'r/BasketballTips community on Reddit, ',
                                          bold: true,
                                          underline: true,
                                          mouseCursor: SystemMouseCursors.click,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await launchUrl(Uri.parse('https://www.reddit.com/r/BasketballTips/'));
                                            },
                                        ),
                                        CustomTextSpan(
                                          context,
                                          text:
                                              'where I saw many people asking for feedback on their shooting form, footwork, and general technique.',
                                        )
                                      ],
                                      style: AppTextStyles.bodyMedium(context),
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
                                  decoration: const BoxDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: RichText(
                                      textScaler: MediaQuery.of(context).textScaler,
                                      text: CustomTextSpan(
                                        context,
                                        children: [
                                          CustomTextSpan(
                                            context,
                                            text: 'That’s when the idea for this app started to form: ',
                                            style: AppTextStyles.bodyMedium(context),
                                          ),
                                          CustomTextSpan(
                                            context,
                                            text:
                                                'a simple tool to help people understand their movement and improve, even if they don’t have a coach watching them all the time.',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          CustomTextSpan(
                                            context,
                                            text:
                                                '\n\nThis project is my way of combining the things I care about — technology, learning, and basketball — and hopefully',
                                            style: const TextStyle(),
                                          ),
                                          CustomTextSpan(
                                            context,
                                            text: ' making something that can help others along the way.',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        ],
                                        style: AppTextStyles.bodyMedium(context),
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
          )),
    );
  }
}
