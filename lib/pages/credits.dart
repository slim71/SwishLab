import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/load_credits.dart';
import '../models/credit_item.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/dynamic_asset.dart';

/// Page to give credit where it's due
class Credits extends ConsumerStatefulWidget {
  const Credits({super.key});

  @override
  ConsumerState<Credits> createState() => _CreditsState();
}

class _CreditsState extends ConsumerState<Credits> {
  List<dynamic>? creditsLoaded;

  @override
  void initState() {
    super.initState();

    // On page load action, only once
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final appState = ref.read(appStateProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);

      if (appState.credits.isEmpty) {
        final creditsLoaded = await loadCredits();
        appStateNotifier.setCredits(creditsLoaded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Credits',
        ),
        body: SafeArea(
          top: true,
          child: Background(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glassmorphism Introduction
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppThemeManager.secondaryBackground.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: CustomTextSpan(
                              context,
                              style: AppTextStyles.bodyMedium(context, color: AppThemeManager.primaryText),
                              children: [
                                CustomTextSpan(
                                  context,
                                  text:
                                      'This project is built upon the incredible work of designers and developers worldwide.\n\n',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'Tap on any item ',
                                  style: AppTextStyles.titleSmall(context, color: appColors.primaryTwo),
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'to visit the author\'s page and show some love.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final List<Credit> creditsList = appState.credits;

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: creditsList.length,
                        itemBuilder: (context, index) {
                          if (index >= creditsList.length) return const SizedBox.shrink();
                          final creditsItem = creditsList[index];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    final String urlString = creditsItem.url.trim();
                                    if (urlString.isEmpty) return;
                                    final Uri url = Uri.parse(urlString);
                                    try {
                                      final success = await launchUrl(url, mode: LaunchMode.externalApplication);
                                      if (!success) {
                                        await launchUrl(url, mode: LaunchMode.platformDefault);
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppThemeManager.secondaryBackground.withValues(alpha: 0.8),
                                          AppThemeManager.secondaryBackground.withValues(alpha: 0.5),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: appColors.containersBorders.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: DynamicAsset(
                                              name: creditsItem.asset,
                                              type: creditsItem.type,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 12),
                                          child: Text(
                                            creditsItem.author,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.labelSmall(context,
                                                color: AppThemeManager.primaryText.withValues(alpha: 0.8)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
