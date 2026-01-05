import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

/// Page where an already registered user can login
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController emailAddressTextController;
  late final TextEditingController passwordTextController;
  FocusNode? emailAddressFocusNode;
  FocusNode? passwordFocusNode;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
    emailAddressTextController = TextEditingController();
    passwordTextController = TextEditingController();
    emailAddressFocusNode ??= FocusNode();
    passwordFocusNode ??= FocusNode();
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
        body:
            // Container used for background purposes
            Semantics(
          label: 'Page container with background',
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: appColors.gradientBackground(),
            ),
            alignment: AlignmentDirectional(0, -1),
            child:
                // Column containing all content for the login page
                Semantics(
              label: 'Column with login form',
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container to allow padding around the page title
                  Semantics(
                    label: 'Spacing container around title',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: AlignmentDirectional(0, 0),
                      child:
                          // App logo
                          Semantics(
                        label: 'App logo',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/SwishLab_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Container with the login form
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Semantics(
                      label: 'Login form container',
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 570,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.primaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            // Column containing the login form
                            Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Semantics(
                              label: 'Login form',
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Simple text to greet the user
                                  Semantics(
                                    label: 'Welcome greet',
                                    child: Text(
                                      'Welcome Back',
                                      textAlign: TextAlign.center,
                                      style:
                                          AppTextStyles.displaySmall(context),
                                    ),
                                  ),

                                  // Text telling the user to insert their credential below
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 24),
                                    child: Semantics(
                                      label: 'Login instructions',
                                      child: Text(
                                        'Insert credentials to login',
                                        textAlign: TextAlign.center,
                                        style:
                                            AppTextStyles.labelMedium(context),
                                      ),
                                    ),
                                  ),

                                  // Email field
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Semantics(
                                      label: 'Email field',
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: InputField(
                                          controller:
                                              emailAddressTextController,
                                          focusNode: emailAddressFocusNode,
                                          label: 'Email',
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          validator:
                                              emailAddressTextControllerValidator ==
                                                      null
                                                  ? null
                                                  : (value) =>
                                                      emailAddressTextControllerValidator!(
                                                          context, value),
                                          regex: RegExp(r'[a-zA-Z0-9@._%+-]'),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Password field
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Semantics(
                                      label: 'Password field',
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: InputField(
                                          controller: passwordTextController,
                                          focusNode: passwordFocusNode,
                                          label: 'Password',
                                          autofillHints: [
                                            AutofillHints.password
                                          ],
                                          obscureText: !passwordVisibility,
                                          validator:
                                              passwordTextControllerValidator ==
                                                      null
                                                  ? null
                                                  : (value) =>
                                                      passwordTextControllerValidator!(
                                                          context, value),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Button to sign in with provided email and password
                                  Semantics(
                                    label: 'Sign in with email and password',
                                    child: DarkButton(
                                      onPressed: () async {
                                        final user = await ref
                                            .read(authServiceProvider)
                                            .signInWithEmail(
                                              emailAddressTextController.text,
                                              passwordTextController.text,
                                            );
                                        if (user == null || !context.mounted) {
                                          return;
                                        }

                                        ref
                                            .read(appStateProvider.notifier)
                                            .setHasOpenedBefore(true);

                                        context.goNamed('home');
                                      },
                                      text: 'Log In',
                                    ),
                                  ),

                                  // Brief text to point the user to the Google login button
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 15, 16, 15),
                                    child: Semantics(
                                      label: 'Text for Google login button',
                                      child: Text(
                                        'Or sign in with',
                                        textAlign: TextAlign.center,
                                        style:
                                            AppTextStyles.labelMedium(context),
                                      ),
                                    ),
                                  ),

                                  // Google login button
                                  Semantics(
                                    label: 'Google login button',
                                    child: LightButton(
                                      onPressed: () async {
                                        await ref
                                            .read(authServiceProvider)
                                            .signInWithGoogle();
                                        if (!context.mounted) return;
                                        context.goNamed('home');
                                      },
                                      text: 'Continue with Google',
                                      icon: FaIcon(
                                        FontAwesomeIcons.google,
                                        size: 15,
                                      ),
                                    ),
                                  ),

                                  // Text redirecting to signup page
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 15, 0, 15),
                                    child: Semantics(
                                      label: 'Text redirecting to signup page',
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.goNamed('signup');
                                        },
                                        child: RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Don\'t have an account?  ',
                                                style: TextStyle(),
                                              ),
                                              TextSpan(
                                                text: 'Sign Up',
                                                style: AppTextStyles.bodyMedium(
                                                    context),
                                              )
                                            ],
                                            style: AppTextStyles.bodyMedium(
                                                context),
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
                    )..animate()
                        // Fade in
                        .fade(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                          begin: 0,
                          end: 1,
                        )
                        // Slide from bottom
                        .move(
                          begin: const Offset(0, 140), // absolute pixels
                          end: Offset.zero,
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        )
                        // Scale
                        .scale(
                          begin: const Offset(0.9, 1.0),
                          end: const Offset(1.0, 1.0),
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        )
                        // Tilt simulation: small rotation around X axis
                        .rotate(
                          begin: -0.05, // radians ≈ small tilt
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
