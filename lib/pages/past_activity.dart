import 'dart:async';

import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page to show past user activity
class PastActivity extends ConsumerStatefulWidget {
  const PastActivity({super.key});

  @override
  ConsumerState<PastActivity> createState() => _PastActivityState();
}

class _PastActivityState extends ConsumerState<PastActivity> {
  ScrollController? activityListScrollController;

  @override
  void initState() {
    super.initState();
    activityListScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return Scaffold(
      backgroundColor: appColors.secondaryBackground,
      appBar: MyAppBar(
        style: MyAppBarStyle.titleOnly,
        title: 'Past activity',
      ),
      body: SafeArea(
        top: true,
        child:
            // Column to place actual content
            Semantics(
          label: 'Actual content column',
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Container to have a colored background
                Semantics(
                  label: 'Background container',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: appColors.gradientBackground(),
                    ),
                    child:
                        // Main column with all the Activity page content
                        Semantics(
                      label: 'Main column content',
                      child: GestureDetector(
                        onVerticalDragStart: (details) async {
                          unawaited(
                            () async {
                              await activityListScrollController?.animateTo(
                                activityListScrollController!
                                    .position.maxScrollExtent,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.ease,
                              );
                            }(),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "All Activity from this past month." text
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                              child: Semantics(
                                label:
                                    '"All activity from this past month." text',
                                child: Text(
                                  'All activity from this past month.',
                                  style: AppTextStyles.titleSmall(context),
                                ),
                              ),
                            ),

                            // List of activities to show
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Semantics(
                                label: 'List of activities',
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  controller: activityListScrollController,
                                  children: [
                                    // Row for a general item in the activity list
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 0, 0),
                                      child: Semantics(
                                        label: 'General list item row',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // Colum to place the timeline related to an activity
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: Semantics(
                                                label:
                                                    'Activity timeline column',
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Container to create a dot as starting point of the timeline
                                                    Semantics(
                                                      label:
                                                          'Timeline dot container',
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appColors
                                                              .alternateOne,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),

                                                    // Timeline for a general activity
                                                    Semantics(
                                                      label:
                                                          'General activity timeline',
                                                      child: Container(
                                                        width: 2,
                                                        height: 110,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appColors
                                                              .alternateOne,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Container to show activity related data
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 12, 0, 0),
                                              child: Semantics(
                                                label:
                                                    'Activity data container',
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.85,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child:
                                                      // Column to place activity related data
                                                      Semantics(
                                                    label:
                                                        'Activity data column',
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Row to place the activity timestamp and the access icon
                                                        Semantics(
                                                          label:
                                                              'Timestamp and icon row',
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // Timestamp related to the activity item
                                                              Semantics(
                                                                label:
                                                                    'Activity item timestamp',
                                                                child: Text(
                                                                  '15, Jan. 2026',
                                                                  style: AppTextStyles
                                                                      .labelMedium(
                                                                          context),
                                                                ),
                                                              ),

                                                              // Icon to show the activity
                                                              Semantics(
                                                                label:
                                                                    'Show activity icon',
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_right_rounded,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 24,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // Row to place the activity information
                                                        Semantics(
                                                          label:
                                                              'Row to place the activity information',
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              // Example test for an activity
                                                              Semantics(
                                                                label:
                                                                    'Activity example text',
                                                                child: Text(
                                                                  'Created New User',
                                                                  style: AppTextStyles
                                                                      .bodyLarge(
                                                                          context),
                                                                ),
                                                              ),

                                                              // Example test for an activity, part 2
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            4,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Semantics(
                                                                  label:
                                                                      'Activity example text part 2',
                                                                  child: Text(
                                                                    '<User>',
                                                                    style: AppTextStyles
                                                                        .titleMedium(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // Row to place activity data
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Semantics(
                                                            label:
                                                                'Activity data row',
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Example of an image related to the activity
                                                                Semantics(
                                                                  label:
                                                                      'Activity related image',
                                                                  child:
                                                                      Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/icons/default_icon.png',
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Example description of an activity
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      Semantics(
                                                                    label:
                                                                        'Activity description example',
                                                                    child: Text(
                                                                      '<User>',
                                                                      style: AppTextStyles
                                                                          .labelMedium(
                                                                              context),
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
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Row for the first item in the list in temporal order
                                    Semantics(
                                      label: 'First item row',
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Column to place the timeline for the first item
                                          Semantics(
                                            label: 'First item timeline column',
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Timeline for the fist item in temporal order
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(23, 0, 0, 0),
                                                  child: Semantics(
                                                    label:
                                                        'Earliest item timeline',
                                                    child: Container(
                                                      width: 2,
                                                      height: 152,
                                                      decoration: BoxDecoration(
                                                        color: appColors
                                                            .alternateOne,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Container for the activity image
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 24, 0, 0),
                                            child: Semantics(
                                              label:
                                                  'Activity section image container',
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child:
                                                    // Image to showcase the activity section
                                                    Semantics(
                                                  label:
                                                      'Activity section image',
                                                  child: Image.asset(
                                                    'assets/images/tasks.png',
                                                    width: 300,
                                                    height: 100,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // "Beginning of Activity" text
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 24, 0, 0),
                              child: Semantics(
                                label: '"Beginning of Activity" text',
                                child: Text(
                                  'Beginning of Activity',
                                  style: AppTextStyles.bodyLarge(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Column to place the WIP image
                Semantics(
                  label: 'WIP image column',
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Work in progress image
                      Semantics(
                        label: 'Work in progress image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/wip.png',
                            fit: BoxFit.cover,
                          ),
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
    );
  }
}
