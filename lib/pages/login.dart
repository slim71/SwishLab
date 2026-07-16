import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../providers/auth_providers.dart';
import '../providers/users_provider.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../widgets/background.dart';
import '../widgets/box_with_shadow.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/dark_button.dart';
import '../widgets/input_field.dart';
import '../widgets/light_button.dart';

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
  final formKey = GlobalKey<FormState>();

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
      if (value.length < passwordMinSize) {
        return 'At least $passwordMinSize characters';
      }
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
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body:
              // Container used for background purposes
              SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Background(
                child: Container(
                  // height: double.infinity,
                  alignment: const AlignmentDirectional(0, -1),
                  child:
                      // Column containing all content for the login page
                      Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container to allow padding around the page title
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                        child:
                            // App logo
                            ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/SwishLab_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Container with the login form
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: addAnimation(
                          widget: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(
                              maxWidth: 570,
                            ),
                            decoration: BoxWithShadow(),
                            child:
                                // Column containing the login form
                                Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Simple text to greet the user
                                      Text(
                                        'Welcome Back',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.displaySmall(context),
                                      ),

                                      // Text telling the user to insert their credential below
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                                        child: Text(
                                          'Insert credentials to login',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.labelMedium(context),
                                        ),
                                      ),

                                      // Email field
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: InputField(
                                            controller: emailAddressTextController,
                                            focusNode: emailAddressFocusNode,
                                            label: 'Email',
                                            autofillHints: const [AutofillHints.email],
                                            validator: (value) => emailAddressTextControllerValidator(context, value),
                                            allowRegex: RegExp(r'[a-zA-Z0-9@._%+-]'),
                                          ),
                                        ),
                                      ),

                                      // Password field
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: InputField(
                                            controller: passwordTextController,
                                            focusNode: passwordFocusNode,
                                            label: 'Password',
                                            autofillHints: const [AutofillHints.password],
                                            obscureText: !passwordVisibility,
                                            validator: (value) => passwordTextControllerValidator(context, value),
                                            denyRegex: RegExp(r'\s'),
                                          ),
                                        ),
                                      ),

                                      // Button to sign in with provided email and password
                                      DarkButton(
                                        onPressed: () async {
                                          // Check all required fields are filled
                                          if (!formKey.currentState!.validate()) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fill all fields correctly!'),
                                              ),
                                            );
                                            return;
                                          }
                                          try {
                                            final user = await ref.read(authServiceProvider).signInWithEmail(
                                                  emailAddressTextController.text,
                                                  passwordTextController.text,
                                                );
                                            if (!context.mounted) return;
                                            if (user == null) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Login failed')),
                                              );
                                              return;
                                            }

                                            ref.read(appStateProvider.notifier).setHasOpenedBefore(true);
                                            ref.invalidate(appUserProvider);
                                            context.goNamed('home');
                                          } on AuthException catch (e) {
                                            if (!context.mounted) return;

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(e.message)),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) return;

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Unexpected error occurred')),
                                            );
                                          }
                                        },
                                        text: 'Log In',
                                      ),

                                      // Brief text to point the user to the Google login button
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16, 15, 16, 15),
                                        child: Text(
                                          'Or sign in with',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.labelMedium(context),
                                        ),
                                      ),

                                      // Google login button
                                      LightButton(
                                        onPressed: () async {
                                          await ref.read(authServiceProvider).signInWithGoogle();
                                          if (!context.mounted) return;
                                          context.goNamed('home');
                                        },
                                        text: 'Continue with Google',
                                        icon: const FaIcon(
                                          FontAwesomeIcons.google,
                                          size: 15,
                                        ),
                                      ),

                                      // Text redirecting to signup page
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                                        child: InkWell(
                                          onTap: () async {
                                            context.goNamed('signup');
                                          },
                                          child: RichText(
                                            textScaler: MediaQuery.of(context).textScaler,
                                            text: CustomTextSpan(
                                              context,
                                              children: [
                                                CustomTextSpan(
                                                  context,
                                                  text: 'Don\'t have an account?  ',
                                                ),
                                                CustomTextSpan(
                                                  context,
                                                  text: 'Sign Up',
                                                  italic: true,
                                                  underline: true,
                                                  color: Theme.of(context).colorScheme.primary,
                                                )
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
                          scale: const ScaleConfig(begin: Offset(0.9, 1.0)),
                          move: const MoveConfig(begin: Offset(0, 140)),
                          rotate: const RotateConfig(begin: -0.05), // radians ~ small tilt
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
