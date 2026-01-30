import 'package:SwishLab/functions/add_animation.dart';
import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/box_with_shadow.dart';
import 'package:SwishLab/widgets/custom_text_span.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: appColors.secondaryBackground,
        appBar: AppBar(
          backgroundColor: appColors.secondaryBackground,
          automaticallyImplyLeading: false,
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child:
              // Column with content for the whole Success page
              Column(
            mainAxisSize: MainAxisSize.max,
              children: [
                // Container with content for the whole Success page
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, -1),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
                    child: Container(
                      width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: 770,
                          ),
                          decoration: BoxWithShadow(
                            gradient: appColors.gradientBackground(),
                            border: Border.all(color: appColors.secondaryText),
                          ),
                          child:
                              // Column to place the page content
                              Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
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
                                  child: addAnimation(
                                    widget: Container(
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
                                            Icon(
                                          Icons.check_rounded,
                                                      color: appColors
                                                          .containersBorders,
                                                      size: 64,
                                                    ),
                                      ),
                                    ),
                                    ),
                                    fade: FadeConfig(duration: 300.ms),
                                    scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                                    move: const MoveConfig(begin: Offset(0, 40)),
                                    rotate: const RotateConfig(begin: -0.08),
                                  )),
                            ),
                                  const SizedBox(width: 8),

                                  // "Success!" text
                                  Align(
                                      alignment: AlignmentDirectional(0, -1),
                                child: addAnimation(
                                  widget: Text(
                                    'Success!',
                                    style: AppTextStyles.displaySmall(color: appColors.secondaryText),
                                  ),
                                  fade: FadeConfig(duration: 300.ms),
                                  move: const MoveConfig(begin: Offset(0, 20)),
                                )),
                            const SizedBox(width: 8),

                                  // "Account created" text
                                  Align(
                                alignment: AlignmentDirectional(0, -1),
                                child: addAnimation(
                                  widget: Text(
                                    'Account created',
                                    style: AppTextStyles.labelMedium(color: appColors.secondaryText),
                                  ),
                                  fade: FadeConfig(delay: 150.ms, duration: 300.ms),
                                  scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                                  move: const MoveConfig(begin: Offset(0, 40)),
                                  rotate: const RotateConfig(begin: -0.08),
                                )),
                            const SizedBox(width: 8),

                                  // Simple divider
                            addAnimation(
                              widget: Divider(
                                height: 44,
                                      thickness: 2,
                                      color: appColors.alternateOne,
                              ),
                              fade: FadeConfig(delay: 200.ms, duration: 300.ms),
                              scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                              move: const MoveConfig(begin: Offset(0, 40)),
                              rotate: const RotateConfig(begin: -0.08),
                            ),
                                  const SizedBox(width: 8),

                                  // Column used to place the newly created user data
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                  child: addAnimation(
                                    widget: Column(
                                      mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // "Your new user ID is" text
                                      Text(
                                        'Your registered email is',
                                                  style:
                                                      AppTextStyles.labelMedium(
                                                          color: appColors
                                                              .secondaryText),
                                                ),
                                              const SizedBox(width: 4),

                                              // User email
                                      Text(
                                        userInfo?.email ??
                                                      'na@email.com',
                                                  textAlign: TextAlign.end,
                                                  style:
                                                      AppTextStyles.labelMedium(
                                                          color: appColors
                                                              .secondaryText),
                                                ),
                                              const SizedBox(width: 4),

                                              // Instructions in profile customization
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 50, 0, 0),
                                        child: RichText(
                                          textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: CustomTextSpan(
                                                      children: [
                                                        CustomTextSpan(
                                                          text: 'Navigate to ',
                                                          style: AppTextStyles.labelMedium(),
                                                          color: appColors.secondaryText,
                                                        ),
                                                        CustomTextSpan(
                                                          text: 'Settings > User Info',
                                                          color: appColors.secondaryText,
                                                          bold: true,
                                                          italic: true,
                                                        ),
                                                        CustomTextSpan(
                                                          text: ' page to customize your profile',
                                                          color: appColors.secondaryText,
                                                        )
                                                      ],
                                                      style: AppTextStyles.labelMedium(),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                              ),
                                              const SizedBox(width: 12),
                                            ],
                                    ),
                                    fade: FadeConfig(delay: 250.ms, duration: 300.ms),
                                    scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                                    move: const MoveConfig(begin: Offset(0, 40)),
                                    rotate: const RotateConfig(begin: -0.08),
                                  )),
                                  ),
                                  const SizedBox(width: 8),

                                  // Home button
                            addAnimation(
                              widget: DarkButton(
                                onPressed: () async {
                                        context.goNamed('home');
                                      },
                                      text: 'Go Home',
                              ),
                              fade: FadeConfig(delay: 350.ms, duration: 300.ms),
                              scale: const ScaleConfig(begin: Offset(0.8, 0.8)),
                              move: const MoveConfig(begin: Offset(0, 40)),
                              rotate: const RotateConfig(begin: 0.08),
                            ),
                                  const SizedBox(width: 8),
                                ],
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
    );
  }
}
