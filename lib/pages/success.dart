import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page showing a confirmation of the account creation
class SuccessAfterSignup extends ConsumerStatefulWidget {
  const SuccessAfterSignup({super.key});

  @override
  ConsumerState<SuccessAfterSignup> createState() => _SuccessAfterSignupState();
}

class _SuccessAfterSignupState extends ConsumerState<SuccessAfterSignup>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: appColors.primaryBackground,
          automaticallyImplyLeading: false,
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child:
              // Column with content for the whole Success page
              Semantics(
            label: 'Main column content',
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Container with content for the whole Success page
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, -1),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
                      child: Semantics(
                        label: 'Main container content',
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: 770,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: appColors.containersBorders,
                                offset: Offset(1, 1),
                                spreadRadius: 3,
                              )
                            ],
                            gradient: appColors.gradientBackground(),
                            borderRadius: BorderRadius.circular(12),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: appColors.secondaryText,
                            ),
                          ),
                          child:
                              // Column to place the page content
                              Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
                            child: Semantics(
                              label: 'Column to place the page content',
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Container used to place the success bubble with some color
                                  Align(
                                    alignment: AlignmentDirectional(0, -1),
                                    child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 44, 0, 0),
                                        child: Semantics(
                                          label:
                                              'Container used to place the success bubble',
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: appColors.altContBorders,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: appColors.retroOne,
                                                width: 4,
                                              ),
                                            ),
                                            child:
                                                // Actual container with the success icon
                                                Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Semantics(
                                                label:
                                                    'Actual container with the success icon',
                                                child: Container(
                                                  width: 140,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: appColors
                                                        .altContBorders,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: appColors
                                                          .containersBorders,
                                                      width: 4,
                                                    ),
                                                  ),
                                                  child:
                                                      // Success Icon
                                                      Semantics(
                                                    label: 'Success Icon',
                                                    child: Icon(
                                                      Icons.check_rounded,
                                                      color: appColors
                                                          .containersBorders,
                                                      size: 64,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            .animate()
                                            .fade(
                                              begin: 0,
                                              end: 1,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .scale(
                                              begin: const Offset(0.8, 0.8),
                                              end: const Offset(1.0, 1.0),
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .move(
                                              begin: const Offset(0, 40),
                                              end: Offset.zero,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .rotate(
                                              begin: -0.08,
                                              // approximation of TiltEffect(0, 1.396)
                                              end: 0,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )),
                                  ),
                                  const SizedBox(width: 8),

                                  // "Success!" text
                                  Align(
                                      alignment: AlignmentDirectional(0, -1),
                                      child: Semantics(
                                        label: '"Success!" text',
                                        child: Text(
                                          'Success!',
                                          style: AppTextStyles.displaySmall(
                                              context,
                                              color: appColors.secondaryText),
                                        ),
                                      )
                                          .animate()
                                          .fade(
                                            begin: 0,
                                            end: 1,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )
                                          .move(
                                            begin: const Offset(0, 20),
                                            end: Offset.zero,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )),
                                  const SizedBox(width: 8),

                                  // "Account created" text
                                  Align(
                                      alignment: AlignmentDirectional(0, -1),
                                      child: Semantics(
                                        label: '"Account created" text',
                                        child: Text(
                                          'Account created',
                                          style: AppTextStyles.labelMedium(
                                              context,
                                              color: appColors.secondaryText),
                                        ),
                                      )
                                          .animate()
                                          .fade(
                                            begin: 0,
                                            end: 1,
                                            delay: 150.ms,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )
                                          .scale(
                                            begin: const Offset(0.8, 0.8),
                                            end: const Offset(1.0, 1.0),
                                            delay: 150.ms,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )
                                          .move(
                                            begin: const Offset(0, 40),
                                            end: Offset.zero,
                                            delay: 150.ms,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )
                                          .rotate(
                                            begin: -0.08,
                                            // approximation of TiltEffect(0, 1.396)
                                            end: 0,
                                            delay: 150.ms,
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          )),
                                  const SizedBox(width: 8),

                                  // Simple divider
                                  Semantics(
                                    label: 'Simple divider',
                                    child: Divider(
                                      height: 44,
                                      thickness: 2,
                                      color: appColors.alternateOne,
                                    ),
                                  )
                                      .animate()
                                      .fade(
                                        begin: 0,
                                        end: 1,
                                        delay: 200.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .scale(
                                        begin: const Offset(0.8, 0.8),
                                        end: const Offset(1.0, 1.0),
                                        delay: 200.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .move(
                                        begin: const Offset(0, 40),
                                        end: Offset.zero,
                                        delay: 200.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .rotate(
                                        begin: -0.08,
                                        // approximation of TiltEffect(0, 1.396)
                                        end: 0,
                                        delay: 200.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      ),
                                  const SizedBox(width: 8),

                                  // Column used to place the newly created user data
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Semantics(
                                          label: 'New user data column',
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // "Your new user ID is" text
                                              Semantics(
                                                label:
                                                    '"Your new user ID is" text',
                                                child: Text(
                                                  'Your registered email is',
                                                  style:
                                                      AppTextStyles.labelMedium(
                                                          context,
                                                          color: appColors
                                                              .secondaryText),
                                                ),
                                              ),
                                              const SizedBox(width: 4),

                                              // User email
                                              Semantics(
                                                label: 'User email',
                                                child: Text(
                                                  userInfo?.email ??
                                                      'na@email.com',
                                                  textAlign: TextAlign.end,
                                                  style:
                                                      AppTextStyles.labelMedium(
                                                          context,
                                                          color: appColors
                                                              .secondaryText),
                                                ),
                                              ),
                                              const SizedBox(width: 4),

                                              // Instructions in profile customization
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 50, 0, 0),
                                                child: Semantics(
                                                  label:
                                                      'Instructions in profile customization',
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Navigate to ',
                                                          style: AppTextStyles
                                                              .labelMedium(
                                                                  context,
                                                                  color: appColors
                                                                      .secondaryText),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              'Settings > User Info',
                                                          style: TextStyle(
                                                            color: appColors
                                                                .secondaryText,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' page to customize your profile',
                                                          style: TextStyle(
                                                            color: appColors
                                                                .secondaryText,
                                                          ),
                                                        )
                                                      ],
                                                      style: AppTextStyles
                                                          .labelMedium(context),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                            ],
                                          ),
                                        )
                                            .animate()
                                            .fade(
                                              begin: 0,
                                              end: 1,
                                              delay: 250.ms,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .scale(
                                              begin: const Offset(0.8, 0.8),
                                              end: const Offset(1.0, 1.0),
                                              delay: 250.ms,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .move(
                                              begin: const Offset(0, 40),
                                              end: Offset.zero,
                                              delay: 250.ms,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )
                                            .rotate(
                                              begin: -0.08,
                                              // approximation of TiltEffect(0, 1.396)
                                              end: 0,
                                              delay: 250.ms,
                                              duration: 300.ms,
                                              curve: Curves.easeInOut,
                                            )),
                                  ),
                                  const SizedBox(width: 8),

                                  // Home button
                                  Semantics(
                                    label: 'Home button',
                                    child: DarkButton(
                                      onPressed: () async {
                                        context.goNamed('home');
                                      },
                                      text: 'Go Home',
                                    ),
                                  )
                                      .animate()
                                      .fade(
                                        begin: 0,
                                        end: 1,
                                        delay: 350.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .scale(
                                        begin: const Offset(0.8, 0.8),
                                        end: const Offset(1.0, 1.0),
                                        delay: 350.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .move(
                                        begin: const Offset(0, 40),
                                        end: Offset.zero,
                                        delay: 350.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      )
                                      .rotate(
                                        begin: 0.08,
                                        // approximation of FlutterFlow TiltEffect(1.222, 0)
                                        end: 0,
                                        delay: 350.ms,
                                        duration: 300.ms,
                                        curve: Curves.easeInOut,
                                      ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
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
    );
  }
}
