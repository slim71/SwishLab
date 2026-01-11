import 'dart:ui';

import 'package:SwishLab/constants.dart';
import 'package:SwishLab/functions/parse_json.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/debug_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Page with debug utilities
class DebugUtilities extends ConsumerStatefulWidget {
  const DebugUtilities({super.key});

  @override
  ConsumerState<DebugUtilities> createState() => _DebugUtilitiesState();
}

class _DebugUtilitiesState extends ConsumerState<DebugUtilities> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic defaultJson;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appColors.secondaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Debug utilities',
        ),
        body: SafeArea(
          top: true,
          child:
              // Main container containing the debug utilities page content
              Align(
            alignment: AlignmentDirectional(0, -1),
            child: Semantics(
              label: 'Main container content',
              child: Container(
                width: double.infinity,
                height: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: 970,
                ),
                decoration: BoxDecoration(
                  gradient: appColors.gradientBackground(),
                ),
                child:
                    // Column to place debug utilities
                    Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Semantics(
                    label: 'Column to place debug utilities',
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Available debug functionalities" text
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 10, 0, 10),
                          child: Semantics(
                            label: '"Available debug functionalities" text',
                            child: Text(
                              'Available debug functionalities',
                              style: AppTextStyles.titleSmall(context),
                            ),
                          ),
                        ),

                        // List of available debug utilities
                        Semantics(
                          label: 'List of available debug utilities',
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 44),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              // Container for the reset flag functionality
                              DebugItem(
                                title: 'Reset hasBeenOpened flag',
                                buttonText: 'Unset',
                                onPressed: () async {
                                  // Reset flag
                                  ref.read(appStateProvider.notifier).setHasOpenedBefore(false);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Done',
                                        style: TextStyle(color: appColors.primaryText),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor: appColors.secondaryBackground,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 1),

                              // Container for the "test results page" functionality
                              DebugItem(
                                title: 'Test results page',
                                buttonText: 'Test',
                                onPressed: () async {
                                  defaultJson = parseJson(kDefaultResultsJson);

                                  context.pushNamed(
                                    VideoResultsWidget.routeName,
                                    queryParameters: {
                                      'videoDataJson': serializeParam(
                                        defaultJson,
                                        ParamType.JSON,
                                      ),
                                    }.withoutNulls,
                                  );
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
            ),
          ),
        ),
      ),
    );
  }
}
