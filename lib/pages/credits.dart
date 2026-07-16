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
          child:
              // Container with all the Credits page content
              Background(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container for a small introduction
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppThemeManager.secondaryBackground,
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Small page introduction
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: CustomTextSpan(
                              context,
                              children: [
                                CustomTextSpan(
                                  context,
                                  text:
                                      'This project uses a mix of freely available icons, illustrations, and animations created by ',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'amazing designers and developers around the world.\n\n',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'I’ve done my best to give ',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'proper credit',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: ' to everyone whose work helped bring this project to life. You can',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: ' click on any item ',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'to visit the author\'s page.\n\n',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'If I’ve missed anyone or got something wrong, please let me know - ',
                                ),
                                CustomTextSpan(
                                  context,
                                  text: 'any correction or contribution is always appreciated!',
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final List<Credit> creditsList = appState.credits;

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: creditsList.length,
                        itemBuilder: (context, creditsListIndex) {
                          if (creditsListIndex >= creditsList.length) {
                            // return an empty container or SizedBox if index is invalid
                            return const SizedBox.shrink();
                          }
                          final Credit creditsItem = creditsList[creditsListIndex]; // now non-null

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppThemeManager.primaryBackground,
                                  borderRadius: BorderRadius.circular(25),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: appColors.containersBorders,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    final String urlString = creditsItem.url.trim();
                                    if (urlString.isEmpty) return;
                                    final Uri url = Uri.parse(urlString);
                                    try {
                                      // Try launching externally first
                                      final success = await launchUrl(url, mode: LaunchMode.externalApplication);
                                      if (!success) {
                                        // Fallback to in-app if external fails
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: DynamicAsset(
                                          width: 60,
                                          height: 60,
                                          name: creditsItem.asset,
                                          type: creditsItem.type,
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        height: 8,
                                        color: appColors.alternateOne,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                        child: Text(
                                          creditsItem.author,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.bodySmall(context),
                                        ),
                                      ),
                                    ],
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
