import 'package:SwishLab/functions/load_credits.dart';
import 'package:SwishLab/models/credit_item.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/custom_text_span.dart';
import 'package:SwishLab/widgets/dynamic_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

      if (appState.credits.isNotEmpty) {
        final creditsLoaded = await loadCredits();
        appStateNotifier.setCredits(creditsLoaded);
        setState(() {}); // if needed, to update UI
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
        appBar: MyAppBar(
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
                            padding: EdgeInsets.all(10),
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
                                      padding: EdgeInsets.all(10),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                                          text: CustomTextSpan(
                              context: context,
                              children: [
                                              CustomTextSpan(
                                  context: context,
                                  text:
                                                    'This project uses a mix of freely available icons, illustrations, and animations created by ',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text: 'amazing designers and developers around the world.\n\n',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text: 'I’ve done my best to give ',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text: 'proper credit',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text:
                                                    ' to everyone whose work helped bring this project to life. You can',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text: ' click on any item ',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text: 'to visit the author\'s page.\n\n',
                                              ),
                                              CustomTextSpan(
                                  context: context,
                                  text:
                                                    'If I’ve missed anyone or got something wrong, please let me know - ',
                                              ),
                                              CustomTextSpan(
                                  context: context,
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
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                      padding: EdgeInsets.all(10),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                  color: AppThemeManager.primaryBackground,
                                  borderRadius: BorderRadius.circular(25),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: appColors.containersBorders,
                                            ),
                                          ),
                                          alignment: AlignmentDirectional(0, 1),
                                          child: InkWell(
                                            onTap: () async {
                                              await launchUrl(creditsItem.url as Uri);
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: DynamicAsset(
                                                    width: 50,
                                                    height: 50,
                                                    name: creditsItem.asset,
                                                    type: creditsItem.type,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                  color: appColors.alternateOne,
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                                  child: Text(
                                                    creditsItem.author,
                                                    textAlign: TextAlign.center,
                                          style: AppTextStyles.titleSmall(context),
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
