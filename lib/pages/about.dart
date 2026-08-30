import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/icon_action_button.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Glassmorphic Header with Parallax
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: Stack(
                    alignment: const AlignmentDirectional(0, -1),
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Transform.translate(
                          offset: Offset(0, _scrollOffset * 0.4),
                          child: Image.asset(
                            'assets/images/me_on_bike.jpg',
                            width: double.infinity,
                            height: 280,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.5),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Simone Vollaro',
                                        style: AppTextStyles.headlineMedium(context, color: Colors.white),
                                      )
                                          .animate(onPlay: (controller) => controller.repeat())
                                          .shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.24)),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconActionButton(
                                            const Icon(Icons.paypal),
                                            iconColor: Colors.white,
                                            onPressed: () async {
                                              HapticFeedback.lightImpact();
                                              await launchUrl(Uri.parse(
                                                  'https://www.paypal.com/donate/?hosted_button_id=TCJL6TZHSYJU8'));
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          IconActionButton(
                                            const Icon(Icons.email),
                                            iconColor: Colors.white,
                                            onPressed: () async {
                                              HapticFeedback.lightImpact();
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
                                          const SizedBox(width: 12),
                                          IconActionButton(
                                            const FaIcon(FontAwesomeIcons.github),
                                            iconColor: Colors.white,
                                            onPressed: () async {
                                              HapticFeedback.lightImpact();
                                              await launchUrl(Uri.parse('https://github.com/slim71/'));
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          IconActionButton(
                                            const FaIcon(FontAwesomeIcons.linkedinIn),
                                            iconColor: Colors.white,
                                            onPressed: () async {
                                              HapticFeedback.lightImpact();
                                              await launchUrl(
                                                  Uri.parse('https://www.linkedin.com/in/simone-vollaro-325185152/'));
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          IconActionButton(
                                            const Icon(Icons.reddit_sharp),
                                            iconColor: Colors.white,
                                            onPressed: () async {
                                              HapticFeedback.lightImpact();
                                              await launchUrl(Uri.parse('https://www.reddit.com/user/feller94/'));
                                            },
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
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),

                // Who am I? Title
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
                ).animate().fadeIn(delay: 200.ms).slideX(),

                // Introduction Card
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: CustomTextSpan(
                              context,
                              children: [
                                CustomTextSpan(
                                  context,
                                  text: 'Hi, I’m Simone.\n',
                                  style: AppTextStyles.titleMedium(context),
                                ),
                                CustomTextSpan(
                                  context,
                                  text:
                                      '\nI’m a software engineer with a background in robotics, automation, and programming — and someone who',
                                ),
                                CustomTextSpan(context, text: ' has always loved building things. ', italic: true),
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
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)).slideY(begin: 0.1, end: 0),

                // Basketball Roots Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: const AlignmentDirectional(0, 1),
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/team_pic.jpg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    'Basketball has been part of my life since I was a kid. It made me more social, helped me find confidence, and gave me a way to stay in shape. ',
                                    style: AppTextStyles.bodySmall(context, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
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
                                  CustomTextSpan(context, text: 'All-Star Toscana game', italic: true, bold: true),
                                  CustomTextSpan(
                                    context,
                                    text: ' when I was 14.',
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/trophy.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)).slideY(begin: 0.1, end: 0),

                // University / Return to form
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      'When I moved to Pisa for university, life changed a bit and basketball slipped more into the background. But in 2020 I found my way back, and even joined an amateur team in Rome for a year — and it reminded me how much I had missed it.',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ),
                ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)).slideY(begin: 0.1, end: 0),

                // Reddit Tips / Current Journey
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/gifs/me_shooting.gif',
                          width: 100,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
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
                    ],
                  ),
                ).animate().fadeIn(delay: 1000.ms).scale(begin: const Offset(0.9, 0.9)).slideY(begin: 0.1, end: 0),

                // Final Vision Card
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 44),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
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
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 3.seconds, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05))
                    .fadeIn(delay: 1200.ms)
                    .scale(begin: const Offset(0.95, 0.95)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
