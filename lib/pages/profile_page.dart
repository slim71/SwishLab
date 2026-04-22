import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../models/users_row.dart';
import '../providers/statistics_provider.dart';
import '../providers/users_provider.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/stats_container.dart';

/// Profile page with user data
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    final statsAsync = ref.watch(userStatisticsProvider);
    final statisticsDataDecreasing = statsAsync.maybeWhen(
      data: (data) => data.reversed.toList(),
      orElse: () => null,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body:
            // Container used for background purposes
            Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Background(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:
                  // Column containing the whole content on screen
                  Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                              alignment: const AlignmentDirectional(0, 0),
                              child:
                                  // Container with profile picture inside
                                  Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
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
                                        padding: const EdgeInsets.all(4),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed('pic');
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.network(
                                              userInfo?.profilePic ?? kDefaultProfilePictureUrl,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text('${userInfo?.firstName} ${userInfo?.lastName}',
                          // "null null" if data missing
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineMedium(context)),
                    ),

                    // User email address
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return appColors.gradientText().createShader(
                                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                              );
                        },
                        child: Text(userInfo?.email ?? "user@email.com",
                            style: AppTextStyles.labelSmall(context, color: Colors.black)),
                      ),
                    ),

                    // Container with user statistics
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          decoration: BoxWithShadow(
                            shadowOffset: const Offset(0, -10),
                            borderRadius: const BorderRadius.only(
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                                  child: Text(
                                    'Latest Stats',
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.headlineMedium(context),
                                  ),
                                ),

                                // Expanded container to allow inner column to scroll on its own
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child:
                                        // Low-level column where user statistics are shown
                                        Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Wrap to show stats cleanly
                                            Align(
                                              alignment: const AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                                child: Wrap(
                                                  spacing: 16,
                                                  runSpacing: 16,
                                                  alignment: WrapAlignment.start,
                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment: WrapAlignment.start,
                                                  verticalDirection: VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    // Container for setpoint statistics
                                                    StatsContainer(
                                                      borderColor: appColors.alternateOne,
                                                      title: 'Set point',
                                                      iconName: 'set_point',
                                                      text: statisticsDataDecreasing?.firstOrNull?.setPointTotalScore
                                                          ?.toString(),
                                                    ),

                                                    // Container for jump statistics
                                                    StatsContainer(
                                                      borderColor: appColors.alternateTwo,
                                                      title: 'Jump',
                                                      iconName: 'jump',
                                                      text: statisticsDataDecreasing?.firstOrNull?.jumpTotalScore
                                                          ?.toString(),
                                                    ),

                                                    // Container for elbow position statistics
                                                    StatsContainer(
                                                      borderColor: appColors.alternateThree ?? Colors.white,
                                                      title: 'Elbow position',
                                                      iconName: 'elbow_position',
                                                      text: statisticsDataDecreasing
                                                          ?.firstOrNull?.elbowPositionTotalScore
                                                          ?.toString(),
                                                    ),

                                                    // Container for feet direction statistics
                                                    StatsContainer(
                                                      borderColor: appColors.retroOne,
                                                      title: 'Feet direction',
                                                      iconName: 'feet_direction',
                                                      text: statisticsDataDecreasing
                                                          ?.firstOrNull?.feetDirectionTotalScore
                                                          ?.toString(),
                                                    ),

                                                    // Container for shot path statistics
                                                    StatsContainer(
                                                      borderColor: appColors.retroTwo,
                                                      title: 'Shot path',
                                                      iconName: 'shot_path',
                                                      text: statisticsDataDecreasing?.firstOrNull?.shotPathTotalScore
                                                          ?.toString(),
                                                    ),

                                                    // Container for follow through statistics
                                                    StatsContainer(
                                                      borderColor: appColors.retroThree ?? Colors.red,
                                                      title: 'Follow through',
                                                      iconName: 'follow_through',
                                                      text: statisticsDataDecreasing
                                                          ?.firstOrNull?.followThroughTotalScore
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
