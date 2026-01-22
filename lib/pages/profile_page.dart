import 'package:SwishLab/constants.dart';
import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/stats_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Profile page with user data
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with TickerProviderStateMixin {
  // Stores action output result for [Backend Call - Query Rows] action in ProfilePage widget.
  List<StatisticsRow>? statisticsDataDecreasing;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body:
            // Container used for background purposes
            Align(
          alignment: AlignmentDirectional(0, 0),
          child: Semantics(
            label: 'Container used for background purposes',
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: appColors.gradientBackground(),
              ),
              child:
                  // Column containing the whole content on screen
                  Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Semantics(
                  label: 'Main column with content',
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Row to place the profile picture
                      Semantics(
                        label: 'Profile picture row',
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Colored border around the profile picture
                            Semantics(
                              label: 'Border around the profile picture',
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: appColors.gradientBackground(
                                    stops: [0.3, 0.4, 0.9],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                alignment: AlignmentDirectional(0, 0),
                                child:
                                    // Container with profile picture inside
                                    Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Semantics(
                                      label: 'Profile picture container',
                                      child: ClipOval(
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: appColors.altContBorders,
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                              // Actual profile picture
                                              Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Semantics(
                                              label: 'Actual profile picture',
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed('pic');
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    appState.userData
                                                            ?.profilePicture ??
                                                        kDefaultProfilePictureUrl,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().moveY(
                                  begin: 100,
                                  end: 0,
                                  curve: Curves.bounceOut,
                                  duration: 1.seconds,
                                ),
                          ],
                        ),
                      ),

                      // Complete user name
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Semantics(
                          label: 'Complete user name',
                          child: Text(
                              '${appState.userData?.firstName} ${appState.userData?.lastName}',
                              // "null null" if data missing
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headlineSmall(context)),
                        ),
                      ),

                      // User email address
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                        child: Semantics(
                          label: 'User email address',
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return appColors.gradientText().createShader(
                                    Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height),
                                  );
                            },
                            child: Text(
                              appState.userData?.eMail ?? "user@email.com",
                              style: AppTextStyles.labelSmall(context).copyWith(
                                color: Colors
                                    .white, // required, actual color comes from shader
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Container with user statistics
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                          child: Semantics(
                            label: 'Container with user statistics',
                            child: Container(
                              width: double.infinity,
                              height: 400,
                              decoration: BoxDecoration(
                                color: appColors.secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0,
                                      -1,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child:
                                  // Column with user statistics
                                  Semantics(
                                label: 'Column with user statistics',
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Statistics section title
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Semantics(
                                        label: 'Statistics section title',
                                        child: Text(
                                          'Latest Stats',
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.headlineMedium(
                                              context),
                                        ),
                                      ),
                                    ),

                                    // Expanded container to allow inner column to scroll on its own
                                    Expanded(
                                      child: Semantics(
                                        label:
                                            'Container allowing scrollable action',
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child:
                                              // Low-level column where user statistics are shown
                                              Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 0, 16, 16),
                                            child: Semantics(
                                              label:
                                                  'Column where user statistics are shown',
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Wrap to show stats cleanly
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 16,
                                                                    0, 0),
                                                        child: Semantics(
                                                          label:
                                                              'Wrap to show stats cleanly',
                                                          child: Wrap(
                                                            spacing: 16,
                                                            runSpacing: 16,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.horizontal,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            verticalDirection:
                                                                VerticalDirection
                                                                    .down,
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              // Container for setpoint statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for setpoint statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor:
                                                                      appColors
                                                                          .alternateOne,
                                                                  title:
                                                                      'Set point',
                                                                  iconName:
                                                                      'set_point',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.setPointTotalScore
                                                                      ?.toString(),
                                                                ),
                                                              ),

                                                              // Container for jump statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for jump statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor:
                                                                      appColors
                                                                          .alternateTwo,
                                                                  title: 'Jump',
                                                                  iconName:
                                                                      'jump',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.jumpTotalScore
                                                                      ?.toString(),
                                                                ),
                                                              ),

                                                              // Container for elbow position statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for elbow position statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor: appColors
                                                                          .alternateThree ??
                                                                      Colors
                                                                          .white,
                                                                  title:
                                                                      'Elbow position',
                                                                  iconName:
                                                                      'elbow_position',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.elbowPositionTotalScore
                                                                      ?.toString(),
                                                                ),
                                                              ),

                                                              // Container for feet direction statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for feet direction statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor:
                                                                      appColors
                                                                          .retroOne,
                                                                  title:
                                                                      'Feet direction',
                                                                  iconName:
                                                                      'feet_direction',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.feetDirectionTotalScore
                                                                      ?.toString(),
                                                                ),
                                                              ),

                                                              // Container for shot path statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for shot path statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor:
                                                                      appColors
                                                                          .retroTwo,
                                                                  title:
                                                                      'Shot path',
                                                                  iconName:
                                                                      'shot_path',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.shotPathTotalScore
                                                                      ?.toString(),
                                                                ),
                                                              ),

                                                              // Container for follow through statistics
                                                              Semantics(
                                                                label:
                                                                    'Container for follow through statistics',
                                                                child:
                                                                    StatsContainer(
                                                                  borderColor:
                                                                      appColors
                                                                              .retroThree ??
                                                                          Colors
                                                                              .red,
                                                                  title:
                                                                      'Follow through',
                                                                  iconName:
                                                                      'follow_through',
                                                                  text: statisticsDataDecreasing
                                                                      ?.firstOrNull
                                                                      ?.followThroughTotalScore
                                                                      ?.toString(),
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
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().moveY(
                                        begin: 100,
                                        end: 0,
                                        curve: Curves.bounceOut,
                                        duration: 1.seconds,
                                      ),
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
        ),
      ),
    );
  }
}
