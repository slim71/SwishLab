import 'dart:convert';

import 'package:SwishLab/constants.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/debug_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page with debug utilities
class DebugUtilities extends ConsumerStatefulWidget {
  const DebugUtilities({super.key});

  @override
  ConsumerState<DebugUtilities> createState() => _DebugUtilitiesState();
}

class _DebugUtilitiesState extends ConsumerState<DebugUtilities> {
  dynamic defaultJson;

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
            child: Background(
              child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 970,
                    ),
                    child:
                        // Column to place debug utilities
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "Available debug functionalities" text
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 10, 0, 10),
                        child: Text(
                          'Available debug functionalities',
                          style: AppTextStyles.titleSmall(context),
                        ),
                            ),

                            // List of available debug utilities
                      ListView(
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
                                    style: TextStyle(color: AppThemeManager.primaryText),
                                  ),
                                          duration: Duration(milliseconds: 4000),
                                  backgroundColor: AppThemeManager.primaryBackground,
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
                                      final defaultJson = jsonDecode(kDefaultResultsJson);

                                      context.go(
                                        'results',
                                        extra: defaultJson,
                                      );
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
    );
  }
}
