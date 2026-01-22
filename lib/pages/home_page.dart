import 'package:SwishLab/constants.dart';
import 'package:SwishLab/models/statistics_row.dart';
import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/statistics_provider.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home page
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ///  Local state fields for this page.
  dynamic defaultJson;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final hasShootingHand =
        (appState.userData?.shootingHand?.isNotEmpty ?? false);
    final appColors = Theme.of(context).extension<AppColorSet>()!;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;
    final statsAsync = ref.watch(userStatisticsProvider);
    final List<StatisticsRow> checkedForms = statsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const [],
    );
    final last = checkedForms.lastOrNull;
    final avgScore = last == null
        ? 0.0
        : ((last.setPointTotalScore ?? 0.0) +
                (last.jumpTotalScore ?? 0.0) +
                (last.elbowPositionTotalScore ?? 0.0) +
                (last.feetDirectionTotalScore ?? 0.0) +
                (last.shotPathTotalScore ?? 0.0) +
                (last.followThroughTotalScore ?? 0.0)) /
            6;


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: appColors.primaryBackground,
        appBar: MyAppBar(
          style: MyAppBarStyle.titleWithProfileImage,
          title: 'Home',
          height: 100,
          onProfilePressed: () async {
            print('Navigating...');
            context.goNamed('profile');
          },
          profileImageUrl:
              appState.userData?.profilePicture ?? kDefaultProfilePictureUrl,
        ),
        body:
            // Container to have a colored background
            Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: appColors.gradientBackground(),
          ),
          child:
              // Main column with all the content of the home page
              SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container with user data
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appColors.secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x25090F13),
                          offset: Offset(
                            0.0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: appColors.containersBorders,
                      ),
                    ),
                    child:
                        // Column to place user data
                        Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User greeting
                          Text(
                            'Welcome Back,',
                            style: AppTextStyles.headlineMedium(context),
                          ),

                          // User name
                          Text(
                            userInfo?.firstName ?? '<User>',
                            style: AppTextStyles.headlineSmall(context),
                          ),

                          // Divider
                          Divider(
                            height: 24,
                            thickness: 2,
                            color: appColors.primaryBackground,
                          ),

                          // Row with user statistics
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Column with forms checked statistics
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "Forms checked" text
                                    Text(
                                      'Forms checked',
                                      style: AppTextStyles.bodyMedium(context),
                                    ),

                                    // Forms checked number
                                    Text(
                                      checkedForms.length.toString(),
                                      style:
                                          AppTextStyles.displaySmall(context),
                                    ),
                                  ],
                                ),
                              ),

                              // Column with latest score statistics
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "Latest score" text
                                    Text(
                                      'Latest score',
                                      style: AppTextStyles.bodyMedium(context),
                                    ),

                                    // Latest score
                                    Text(
                                      avgScore.toStringAsFixed(1), // 1 decimal
                                      style:
                                          AppTextStyles.displaySmall(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // "Available checks" text
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                  child: Text(
                    'Available checks',
                    style: AppTextStyles.titleMedium(context),
                  ),
                ),
                if (!hasShootingHand)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // "Available checks" text
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: Text(
                              'You can\'t use these yet - tell us your shooting hand first!',
                              style: AppTextStyles.titleMedium(context,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                        DarkButton(
                          onPressed: () async {
                            context.pushNamed('user');
                          },
                          text: 'Button',
                        ),
                      ],
                    ),
                  ),

                // List of functionalities available
                Column(
                  children: [
                    // Item related to the Front View functionality
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (hasShootingHand) {
                            context.pushNamed('front');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: appColors.secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: Color(0x411D2429),
                                offset: Offset(
                                  0.0,
                                  1,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: appColors.altContBorders,
                            ),
                          ),
                          child:
                              // Row with the Front View overview
                              Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Front View section image
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 1, 1, 1),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/thompson_front.jpg',
                                      width: 70,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),

                                // Column to place the Front View overview
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 4, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // "Front view" text
                                        Text(
                                          'Front view',
                                          style:
                                              AppTextStyles.titleLarge(context),
                                        ),

                                        // Front View functionality overview
                                        Text(
                                          'Helps identify lateral deviations in the shot path and arm alignment ("chicken wing")',
                                          style:
                                              AppTextStyles.bodyMedium(context),
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

                    // Item related to the Side View functionality
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (hasShootingHand) {
                            context.pushNamed("side");
                          }
                        },
                        child: Container(
                          // width: MediaQuery.sizeOf(context).width,
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: appColors.secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: Color(0x411D2429),
                                offset: Offset(
                                  0.0,
                                  1,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: appColors.altContBorders,
                            ),
                          ),
                          child:
                              // Row with the Side View overview
                              Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Side View section image
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 1, 1, 1),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/curry_side.jpg',
                                      width: 70,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),

                                // Column to place the Side View overview
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 4, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // "Side view" text
                                        Text(
                                          'Side view',
                                          style:
                                              AppTextStyles.titleLarge(context),
                                        ),

                                        // Side View functionality overview
                                        Text(
                                          'Focuses on ball motion toward/away from the body - useful for refining release consistency',
                                          style:
                                              AppTextStyles.bodyMedium(context),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
