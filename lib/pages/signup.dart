import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

/// Page to create a new account
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      if (!RegExp(r"^[a-zA-ZÀ-ÿ \'-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    lastnameController = TextEditingController();
    lastnameFocusNode ??= FocusNode();
    lastnameValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Last name required';
      if (value.length < 2) return 'Last name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ \'-]+$").hasMatch(value)) {
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
      return null;
    };
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
            // Row used to locate the whole signup page content
            Semantics(
          label: 'Main content row',
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Container with the whole signup page form
              Expanded(
                flex: 6,
                child: Semantics(
                  label: 'Main container content',
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: appColors.gradientBackground(),
                    ),
                    alignment: AlignmentDirectional(0, -1),
                    child:
                        // Scrolling column to allow scrolling for smaller devices
                        Semantics(
                      label: 'Scrolling column',
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
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

                            // Container with the signup form
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Semantics(
                                label: 'Signup form container',
                                child: Container(
                                  width: double.infinity,
                                  constraints: BoxConstraints(
                                    maxWidth: 570,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appColors.secondaryBackground,
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
                                      // Column with the signup form
                                      Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Semantics(
                                        label: 'Signup form column',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Greeting text
                                            Semantics(
                                              label: 'Greeting text',
                                              child: Text(
                                                'Get Started',
                                                textAlign: TextAlign.center,
                                                style:
                                                    AppTextStyles.displaySmall(
                                                        context),
                                              ),
                                            ),

                                            // Text to guide signup
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 12, 0, 24),
                                              child: Semantics(
                                                label: 'Signup instructions',
                                                child: Text(
                                                  'Fill out the data below',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTextStyles.labelLarge(
                                                          context),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 16),
                                              child: Semantics(
                                                label: 'First name field',
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: InputField(
                                                      controller:
                                                          firstnameController,
                                                      focusNode:
                                                          firstnameFocusNode,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      label: 'First Name',
                                                      validator: (value) => firstnameValidator.call(context, value),
                                                      allowRegex: RegExp('^[A-Za-z\' -]+\$')),
                                                ),
                                              ),
                                            ),

                                            // Last name field
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 16),
                                              child: Semantics(
                                                label: 'Last name field',
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: InputField(
                                                      controller:
                                                          lastnameController,
                                                      focusNode:
                                                          lastnameFocusNode,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      label: 'Last Name',
                                                      validator: (value) => lastnameValidator.call(context, value),
                                                      allowRegex: RegExp('^[A-Za-z\' -]+\$')),
                                                ),
                                              ),
                                            ),

                                            // Email address field
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 16),
                                              child: Semantics(
                                                label: 'Email address field',
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: InputField(
                                                    controller:
                                                        emailAddressController,
                                                    focusNode:
                                                        emailAddressFocusNode,
                                                    label: 'Email',
                                                    autofillHints: [
                                                      AutofillHints.email
                                                    ],
                                                    validator: (value) => emailValidator.call(context, value),
                                                    allowRegex: RegExp(r'[a-zA-Z0-9@._%+-]'),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Password field
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 16),
                                              child: Semantics(
                                                label: 'Password field',
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: InputField(
                                                    controller:
                                                        passwordController,
                                                    focusNode:
                                                        passwordFocusNode,
                                                    label: 'Password',
                                                    autofillHints: [
                                                      AutofillHints.password
                                                    ],
                                                    obscureText: true,
                                                    validator: (value) => passwordValidator.call(context, value),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Confirm password field
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 16),
                                              child: Semantics(
                                                label: 'Confirm password field',
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: InputField(
                                                    controller:
                                                        confpswdController,
                                                    focusNode:
                                                        confpswdFocusNode,
                                                    label: 'Confirm password',
                                                    autofillHints: [
                                                      AutofillHints.password
                                                    ],
                                                    obscureText: true,
                                                    validator: (value) => confpswdValidator.call(context, value),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Button to create an account with inserted data
                                            Semantics(
                                              label: 'Manual signup',
                                              child: DarkButton(
                                                onPressed: () async {
                                                  // Check all required fields are filled
                                                  if (emailAddressController
                                                          .text.isEmpty ||
                                                      passwordController
                                                          .text.isEmpty ||
                                                      confpswdController
                                                          .text.isEmpty ||
                                                      firstnameController
                                                          .text.isEmpty ||
                                                      lastnameController
                                                          .text.isEmpty) {
                                                    if (!mounted) return;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Please fill all fields!'),
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  // Password check
                                                  if (passwordController.text !=
                                                      confpswdController.text) {
                                                    if (!mounted) return;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Passwords don\'t match!',
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  // Create auth user
                                                  final authService = ref.read(
                                                      authServiceProvider);
                                                  final user =
                                                      await authService.signUp(
                                                    email:
                                                        emailAddressController
                                                            .text,
                                                    password:
                                                        passwordController.text,
                                                  );

                                                  if (user == null ||
                                                      !mounted) {
                                                    return;
                                                  }

                                                  // Update app state
                                                  ref
                                                      .read(appStateProvider
                                                          .notifier)
                                                      .setHasOpenedBefore(true);

                                                  // Insert into Users table
                                                  final usersRepo = ref.read(
                                                      usersRepositoryProvider);

                                                  await usersRepo.insertUser(
                                                    id: user.id,
                                                    email:
                                                        emailAddressController
                                                            .text,
                                                    firstName:
                                                        firstnameController
                                                            .text,
                                                    lastName:
                                                        lastnameController.text,
                                                  );

                                                  // Navigate
                                                  if (!context.mounted) return;
                                                  context.goNamed('success');
                                                },
                                                text: 'Create Account',
                                              ),
                                            ),

                                            // Or
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 15, 16, 15),
                                              child: Semantics(
                                                label: 'Or',
                                                child: Text(
                                                  'Or',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTextStyles.labelLarge(
                                                          context),
                                                ),
                                              ),
                                            ),

                                            // Button to create an account using Google
                                            Semantics(
                                              label: 'Google signup button',
                                              child: LightButton(
                                                onPressed: () async {
                                                  final authService = ref.read(
                                                      authServiceProvider);
                                                  await authService
                                                      .signInWithGoogle();
                                                },
                                                text: 'Signup with Google',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.google,
                                                  size: 15,
                                                ),
                                              ),
                                            ),

                                            // Instructions to redirect to login
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 15, 0, 15),
                                              child: Semantics(
                                                label: 'Redirect to login text',
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    context.goNamed('login');
                                                  },
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Already have an account?  ',
                                                          style: TextStyle(),
                                                        ),
                                                        TextSpan(
                                                          text: 'Login here',
                                                          style: AppTextStyles
                                                              .bodyMedium(
                                                                  context),
                                                        )
                                                      ],
                                                      style: AppTextStyles
                                                          .bodyMedium(context),
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
                                  // Fade
                                  .fade(
                                    begin: 0,
                                    end: 1,
                                    duration: 300.ms,
                                    curve: Curves.easeInOut,
                                  )
                                  // Move up
                                  .move(
                                    begin: const Offset(0, 140),
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
                                  // Approximate TiltEffect (2D)
                                  .rotate(
                                    begin: -0.05,
                                    // visual approximation of -0.349 tilt
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
