import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/auth_providers.dart';
import 'package:SwishLab/providers/users_provider.dart';
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
  late TextEditingController firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;

  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  late TextEditingController lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  late TextEditingController emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  late TextEditingController passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // State field(s) for confpswd widget.
  FocusNode? confpswdFocusNode;
  late TextEditingController confpswdTextController;
  String? Function(BuildContext, String?)? confpswdTextControllerValidator;

  // Stores action output result for [Backend Call - Insert Row] action in manualSignupButton widget.
  UsersRow? backendResult;

  @override
  void initState() {
    super.initState();

    firstnameTextController = TextEditingController();
    firstnameFocusNode ??= FocusNode();

    lastnameTextController = TextEditingController();
    lastnameFocusNode ??= FocusNode();

    emailAddressTextController = TextEditingController();
    emailAddressFocusNode ??= FocusNode();

    passwordTextController = TextEditingController();
    passwordFocusNode ??= FocusNode();

    confpswdTextController = TextEditingController();
    confpswdFocusNode ??= FocusNode();
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
                                                          firstnameTextController,
                                                      focusNode:
                                                          firstnameFocusNode,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      label: 'First Name',
                                                      validator:
                                                          firstnameTextControllerValidator ==
                                                                  null
                                                              ? null
                                                              : (value) =>
                                                                  firstnameTextControllerValidator!(
                                                                      context,
                                                                      value),
                                                      regex: RegExp(
                                                          '^[A-Za-z\' -]+\$')),
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
                                                          lastnameTextController,
                                                      focusNode:
                                                          lastnameFocusNode,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      label: 'Last Name',
                                                      validator:
                                                          lastnameTextControllerValidator ==
                                                                  null
                                                              ? null
                                                              : (value) =>
                                                                  lastnameTextControllerValidator!(
                                                                      context,
                                                                      value),
                                                      regex: RegExp(
                                                          '^[A-Za-z\' -]+\$')),
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
                                                        emailAddressTextController,
                                                    focusNode:
                                                        emailAddressFocusNode,
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
                                                                    context,
                                                                    value),
                                                    regex: RegExp(
                                                        '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[A-Za-z]{2,}\$'),
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
                                                        passwordTextController,
                                                    focusNode:
                                                        passwordFocusNode,
                                                    label: 'Password',
                                                    autofillHints: [
                                                      AutofillHints.password
                                                    ],
                                                    obscureText: true,
                                                    validator:
                                                        passwordTextControllerValidator ==
                                                                null
                                                            ? null
                                                            : (value) =>
                                                                passwordTextControllerValidator!(
                                                                    context,
                                                                    value),
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
                                                        confpswdTextController,
                                                    focusNode:
                                                        confpswdFocusNode,
                                                    label: 'Confirm password',
                                                    autofillHints: [
                                                      AutofillHints.password
                                                    ],
                                                    obscureText: true,
                                                    validator:
                                                        confpswdTextControllerValidator ==
                                                                null
                                                            ? null
                                                            : (value) =>
                                                                confpswdTextControllerValidator!(
                                                                    context,
                                                                    value),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Button to create an account with inserted data
                                            Semantics(
                                              label: 'Manual signup',
                                              child: DarkButton(
                                                onPressed: () async {
                                                  // Password check
                                                  if (passwordTextController
                                                          .text !=
                                                      confpswdTextController
                                                          .text) {
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
                                                        emailAddressTextController
                                                            .text,
                                                    password:
                                                        passwordTextController
                                                            .text,
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
                                                        emailAddressTextController
                                                            .text,
                                                    firstName:
                                                        firstnameTextController
                                                            .text,
                                                    lastName:
                                                        lastnameTextController
                                                            .text,
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
