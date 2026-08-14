import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../functions/add_animation.dart';
import '../models/users_row.dart';
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

/// Page to create a new account
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with TickerProviderStateMixin {
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  late TextEditingController firstnameController;
  late String? Function(BuildContext, String?) firstnameValidator;

  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  late TextEditingController lastnameController;
  late String? Function(BuildContext, String?) lastnameValidator;

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  late TextEditingController emailAddressController;
  late String? Function(BuildContext, String?) emailValidator;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  late TextEditingController passwordController;
  late String? Function(BuildContext, String?) passwordValidator;

  // State field(s) for confpswd widget.
  FocusNode? confpswdFocusNode;
  late TextEditingController confpswdController;
  late String? Function(BuildContext, String?) confpswdValidator;

  final formKey = GlobalKey<FormState>();

  // Stores action output result for [Backend Call - Insert Row] action in manualSignupButton widget.
  UsersRow? backendResult;

  @override
  void initState() {
    super.initState();

    firstnameController = TextEditingController();
    firstnameFocusNode ??= FocusNode();
    firstnameValidator = (context, value) {
      if (value == null || value.isEmpty) return 'First name required';
      if (value.length < 2) return 'First name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    lastnameController = TextEditingController();
    lastnameFocusNode ??= FocusNode();
    lastnameValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Last name required';
      if (value.length < 2) return 'Last name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    emailAddressController = TextEditingController();
    emailAddressFocusNode ??= FocusNode();
    emailValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Email required';
      if (!EmailValidator.validate(value)) return 'Enter a valid email';
      return null;
    };

    passwordController = TextEditingController();
    passwordFocusNode ??= FocusNode();
    passwordValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Password required';
      if (value.length < 8) return 'Password must be at least 8 characters';
      // Optional: enforce at least one number and one letter
      if (!RegExp(r'(?=.*[A-Za-z])').hasMatch(value)) {
        return 'Password must contain a letter';
      }
      if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
        return 'Password must contain a number';
      }
      return null;
    };

    confpswdController = TextEditingController();
    confpswdFocusNode ??= FocusNode();
    confpswdValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Password required';
      if (value.length < 8) return 'Password must be at least 8 characters';
      // Optional: enforce at least one number and one letter
      if (!RegExp(r'(?=.*[A-Za-z])').hasMatch(value)) {
        return 'Password must contain a letter';
      }
      if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
        return 'Password must contain a number';
      }
      if (value != passwordController.text) {
        return 'Passwords don\'t match';
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
            // Row used to locate the whole signup page content
            Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Container with the whole signup page form
            Expanded(
              flex: 6,
              child: Background(
                child: Container(
                  width: 100,
                  height: double.infinity,
                  alignment: const AlignmentDirectional(0, -1),
                  child:
                      // Scrolling column to allow scrolling for smaller devices
                      SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
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

                        // Container with the signup form
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
                                  // Column with the signup form
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
                                        // Greeting text
                                        Text(
                                          'Get Started',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.displaySmall(context),
                                        ),

                                        // Text to guide signup
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                                          child: Text(
                                            'Fill out the data below',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelLarge(context),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: InputField(
                                                controller: firstnameController,
                                                focusNode: firstnameFocusNode,
                                                autofillHints: const [AutofillHints.name],
                                                textCapitalization: TextCapitalization.words,
                                                label: 'First Name',
                                                validator: (value) => firstnameValidator.call(context, value),
                                                allowRegex: RegExp('^[A-Za-z\' -]+\$')),
                                          ),
                                        ),

                                        // Last name field
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: InputField(
                                                controller: lastnameController,
                                                focusNode: lastnameFocusNode,
                                                autofillHints: const [AutofillHints.name],
                                                textCapitalization: TextCapitalization.words,
                                                label: 'Last Name',
                                                validator: (value) => lastnameValidator.call(context, value),
                                                allowRegex: RegExp('^[A-Za-z\' -]+\$')),
                                          ),
                                        ),

                                        // Email address field
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: InputField(
                                              controller: emailAddressController,
                                              focusNode: emailAddressFocusNode,
                                              label: 'Email',
                                              autofillHints: const [AutofillHints.email],
                                              validator: (value) => emailValidator.call(context, value),
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
                                              controller: passwordController,
                                              focusNode: passwordFocusNode,
                                              label: 'Password',
                                              autofillHints: const [AutofillHints.password],
                                              obscureText: true,
                                              validator: (value) => passwordValidator.call(context, value),
                                            ),
                                          ),
                                        ),

                                        // Confirm password field
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: InputField(
                                              controller: confpswdController,
                                              focusNode: confpswdFocusNode,
                                              label: 'Confirm password',
                                              autofillHints: const [AutofillHints.password],
                                              obscureText: true,
                                              validator: (value) => confpswdValidator.call(context, value),
                                            ),
                                          ),
                                        ),

                                        // Button to create an account with inserted data
                                        DarkButton(
                                          onPressed: () async {
                                            // Check all required fields are filled
                                            if (!formKey.currentState!.validate()) {
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please fill all fields!'),
                                                ),
                                              );
                                              return;
                                            }

                                            // Create auth user
                                            try {
                                              final authService = ref.read(authServiceProvider);
                                              final user = await authService.signUp(
                                                email: emailAddressController.text,
                                                password: passwordController.text,
                                              );

                                              if (user == null || !mounted) {
                                                return;
                                              }

                                              // Insert into Users table
                                              final usersRepo = ref.read(usersRepositoryProvider);

                                              await usersRepo.insertUser(
                                                id: user.id,
                                                email: emailAddressController.text,
                                                firstName: firstnameController.text,
                                                lastName: lastnameController.text,
                                              );

                                              // Ensure onboarding shows for new users
                                              ref.read(appStateProvider.notifier).setHasOpenedBefore(false);

                                              // Invalidate user provider so it fetches the new row
                                              ref.invalidate(appUserProvider);

                                              // Navigate to root to trigger correct redirect
                                              if (!context.mounted) return;
                                              context.go('/');
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
                                          text: 'Create Account',
                                        ),

                                        // Or
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16, 15, 16, 15),
                                          child: Text(
                                            'Or',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelLarge(context),
                                          ),
                                        ),

                                        // Button to create an account using Google
                                        LightButton(
                                          onPressed: () async {
                                            final authService = ref.read(authServiceProvider);
                                            await authService.signInWithGoogle();
                                          },
                                          text: 'Signup with Google',
                                          icon: const FaIcon(
                                            FontAwesomeIcons.google,
                                            size: 15,
                                          ),
                                        ),

                                        // Instructions to redirect to login
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                                          child: InkWell(
                                            onTap: () async {
                                              context.goNamed('login');
                                            },
                                            child: RichText(
                                              textScaler: MediaQuery.of(context).textScaler,
                                              text: CustomTextSpan(
                                                context,
                                                children: [
                                                  CustomTextSpan(
                                                    context,
                                                    text: 'Already have an account?  ',
                                                  ),
                                                  CustomTextSpan(
                                                    context,
                                                    text: 'Login here',
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
                            move: const MoveConfig(begin: Offset(0, 140)),
                            scale: const ScaleConfig(begin: Offset(0.9, 1.0)),
                            rotate: const RotateConfig(begin: -0.05), // visual approximation of -0.349 tilt
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
    );
  }
}
