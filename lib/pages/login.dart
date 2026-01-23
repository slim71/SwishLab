import 'package:SwishLab/constants.dart';
import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/state/persisted_states.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/custom_text_span.dart';
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
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with TickerProviderStateMixin {
  late final TextEditingController emailAddressTextController;
  late final TextEditingController passwordTextController;
  FocusNode? emailAddressFocusNode;
  FocusNode? passwordFocusNode;
  late bool passwordVisibility;
  late String? Function(BuildContext, String?) emailAddressTextControllerValidator;
  late String? Function(BuildContext, String?) passwordTextControllerValidator;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
    emailAddressTextController = TextEditingController();
    passwordTextController = TextEditingController();
    emailAddressFocusNode ??= FocusNode();
    passwordFocusNode ??= FocusNode();

    emailAddressTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Email required';

      final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[a-zA-Z]{2,}$');

      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email';
      }

      return null;
    };
    passwordTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Password required';
      if (value.length < passwordMinSize) return 'At least $passwordMinSize characters';
      if (!RegExp(r'(?=.*[A-Za-z])').hasMatch(value)) {
        return 'Must contain a letter';
      }
      if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
        return 'Must contain a number';
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body:
            // Container used for background purposes
            Semantics(
          label: 'Page container with background',
                child: Background(
                  child: Container(
                    height: double.infinity,
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
                                          style: AppTextStyles.displaySmall(),
                                        ),
                                      ),

                                          // Text telling the user to insert their credential below
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                                            child: Semantics(
                                              label: 'Login instructions',
                                              child: Text(
                                                'Insert credentials to login',
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles.labelMedium(),
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
                                              validator: (value) => emailAddressTextControllerValidator(context, value),
                                              allowRegex: RegExp(r'[a-zA-Z0-9@._%+-]'),
                                            ),
                                          ),
                                        ),
                                      ),

                                          // Password field
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                            child: Semantics(
                                              label: 'Password field',
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: InputField(
                                                  controller: passwordTextController,
                                                  focusNode: passwordFocusNode,
                                                  label: 'Password',
                                                  autofillHints: [AutofillHints.password],
                                                  obscureText: !passwordVisibility,
                                                  validator: (value) => passwordTextControllerValidator(context, value),
                                                  denyRegex: RegExp(r'\s'),
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

                                                ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                                                AuthStorage.setLoggedIn(true);

                                                context.goNamed('home');
                                          },
                                          text: 'Log In',
                                        ),
                                      ),

                                          // Brief text to point the user to the Google login button
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16, 15, 16, 15),
                                            child: Semantics(
                                              label: 'Text for Google login button',
                                              child: Text(
                                                'Or sign in with',
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles.labelMedium(),
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
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                                            child: Semantics(
                                              label: 'Text redirecting to signup page',
                                              child: InkWell(
                                                onTap: () async {
                                                  context.goNamed('signup');
                                                },
                                                child: RichText(
                                                  textScaler: MediaQuery.of(context).textScaler,
                                                  text: CustomTextSpan(
                                                    children: [
                                                      CustomTextSpan(
                                                        text: 'Don\'t have an account?  ',
                                                      ),
                                                      CustomTextSpan(
                                                        text: 'Sign Up',
                                                      )
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
                                ),
                              ),
                            )
                                .animate()
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
                                  begin: -0.05, // radians ~ small tilt
                                  end: 0,
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
