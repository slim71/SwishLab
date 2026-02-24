import 'package:SwishLab/constants.dart';
import 'package:SwishLab/functions/add_animation.dart';
import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/box_with_shadow.dart';
import 'package:SwishLab/widgets/stats_container.dart';
import 'package:flutter/material.dart';
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
    final appColors = AppThemeManager.currentColors;

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
          child: Background(
            child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child:
                      // Column containing the whole content on screen
                  Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                    children: [
                      // Row to place the profile picture
                    Row(
                      mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Colored border around the profile picture
                        addAnimation(
                            widget: Container(
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
                                    child: InkWell(
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
                            withFade: false,
                            moveY: const MoveYConfig(begin: 100, duration: Duration(seconds: 1))),
                          ],
                        ),

                      // Complete user name
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text('${appState.userData?.firstName} ${appState.userData?.lastName}',
                              // "null null" if data missing
                              textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall(context)),
                    ),

                      // User email address
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
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

                      // Container with user statistics
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                        child: Container(
                          width: double.infinity,
                              height: 400,
                                  decoration: BoxWithShadow(
                                    shadowOffset: Offset(0, -10),
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child:
                                  // Column with user statistics
                              addAnimation(
                            widget: Column(
                              mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Statistics section title
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                child: Text(
                                  'Latest Stats',
                                          textAlign: TextAlign.start,
                                    style: AppTextStyles.headlineMedium(context),
                                  ),
                                    ),

                                    // Expanded container to allow inner column to scroll on its own
                                    Expanded(
                                child: Container(
                                  decoration: BoxDecoration(),
                                          child:
                                              // Low-level column where user statistics are shown
                                              Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 0, 16, 16),
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

                                                              // Container for jump statistics
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

                                                              // Container for elbow position statistics
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

                                                              // Container for feet direction statistics
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

                                                              // Container for shot path statistics
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

                                                              // Container for follow through statistics
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
                            withFade: false,
                            moveY: const MoveYConfig(begin: 100, duration: Duration(seconds: 1)),
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
    );
  }
}
