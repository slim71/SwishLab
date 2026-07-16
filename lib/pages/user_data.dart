import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/dropdown_controller.dart';
import '../functions/is_field_valid.dart';
import '../models/user_info_validation.dart';
import '../models/users_row.dart';
import '../providers/users_provider.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dark_button.dart';
import '../widgets/drop_down.dart';
import '../widgets/input_field.dart';

/// Page showing user info and allowing changes
class UserData extends ConsumerStatefulWidget {
  const UserData({super.key});

  @override
  ConsumerState<UserData> createState() => _UserDataState();
}

class _UserDataState extends ConsumerState<UserData> with TickerProviderStateMixin {
  /// Storage for validation states
  UserInfoValidation? validationStruct;

  void updateValidationStructStruct(dynamic Function(UserInfoValidation) updateFn) {
    updateFn(validationStruct ??= UserInfoValidation());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for firstNameField widget.
  FocusNode? firstNameFieldFocusNode;
  late final TextEditingController firstNameFieldTextController;
  late String? Function(BuildContext, String?) firstNameFieldTextControllerValidator;

  // State field(s) for lastNameField widget.
  FocusNode? lastNameFieldFocusNode;
  late final TextEditingController lastNameFieldTextController;
  late String? Function(BuildContext, String?) lastNameFieldTextControllerValidator;

  // State field(s) for emailField widget.
  FocusNode? emailFieldFocusNode;
  late final TextEditingController emailFieldTextController;
  late String? Function(BuildContext, String?) emailFieldTextControllerValidator;

  // State field(s) for shootingHandDropDown widget.
  String? shootingHandDropDownValue;
  DropdownController<String>? shootingHandDropDownValueController;

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  late UsersRow updatedRow;
  late final AnimationController firstNameAnim;
  late final AnimationController lastNameAnim;
  late final AnimationController emailAnim;
  late final AnimationController shootingHandAnim;

  @override
  void initState() {
    super.initState();
    final userInfoAsync = ref.read(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    // On page load action.
    validationStruct = UserInfoValidation(
      firstNameValid: true,
      lastNameValid: true,
      emailValid: true,
      shootingHandValid: true,
    );

    firstNameFieldTextController = TextEditingController(text: userInfo?.firstName);
    firstNameFieldFocusNode ??= FocusNode();
    firstNameFieldTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'First name required';
      if (value.length < 2) return 'First name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    lastNameFieldTextController = TextEditingController(text: userInfo?.lastName);
    lastNameFieldFocusNode ??= FocusNode();
    lastNameFieldTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Last name required';
      if (value.length < 2) return 'Last name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    emailFieldTextController = TextEditingController(text: userInfo?.email);
    emailFieldFocusNode ??= FocusNode();
    emailFieldTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'Email required';

      final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[a-zA-Z]{2,}$');

      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email';
      }

      return null;
    };

    shootingHandDropDownValue = userInfo?.shootingHand;
    shootingHandDropDownValueController = DropdownController<String>(
      value: shootingHandDropDownValue,
    );

    firstNameAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    lastNameAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    emailAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    shootingHandAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    firstNameAnim.dispose();
    lastNameAnim.dispose();
    emailAnim.dispose();
    shootingHandAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;
    final userId = userInfo?.id;

    return Scaffold(
      backgroundColor: AppThemeManager.primaryBackground,
      appBar: const MyAppBar(
        style: MyAppBarStyle.backButtonTitleLeft,
        title: 'User info',
      ),
      body: SafeArea(
        top: true,
        child: Background(
          child: SizedBox(
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Text(
                          'Your information',
                          style: AppTextStyles.headlineMedium(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Row containing the error message for the first name in case it is invalid
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // "Valid First Name required" text
                                    if (validationStruct?.firstNameValid == false)
                                      Text(
                                        'Valid First Name required',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.labelMedium(context),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: InputField(
                                          label: 'First Name',
                                          controller: firstNameFieldTextController,
                                          focusNode: firstNameFieldFocusNode,
                                          autofillHints: const [AutofillHints.name],
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          validator: (value) =>
                                              firstNameFieldTextControllerValidator.call(context, value),
                                          allowRegex: RegExp('^[A-Za-z\' -]+\$'),
                                          fillColor: AppThemeManager.primaryBackground,
                                        ).animate(controller: firstNameAnim).shake(
                                              duration: 1000.ms,
                                              hz: 5,
                                              rotation: 0.017,
                                              curve: Curves.easeInOut,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Row containing the error message for the last name in case it is invalid
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // "Valid Last Name required" text
                                    if (validationStruct?.lastNameValid == false)
                                      Text(
                                        'Valid Last Name required',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.labelMedium(context),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: InputField(
                                          label: 'Last Name',
                                          controller: lastNameFieldTextController,
                                          focusNode: lastNameFieldFocusNode,
                                          autofillHints: const [AutofillHints.name],
                                          textCapitalization: TextCapitalization.words,
                                          obscureText: false,
                                          validator: (value) =>
                                              lastNameFieldTextControllerValidator.call(context, value),
                                          fillColor: AppThemeManager.primaryBackground,
                                        ).animate(controller: lastNameAnim).shake(
                                              duration: 1000.ms,
                                              hz: 5,
                                              rotation: 0.017,
                                              curve: Curves.easeInOut,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Row containing the error message for the email in case it is invalid
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // "Valid Email required" text
                                    if (validationStruct?.emailValid == false)
                                      Text(
                                        'Valid Email required',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.labelMedium(context),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: InputField(
                                          label: 'Email',
                                          controller: emailFieldTextController,
                                          focusNode: emailFieldFocusNode,
                                          autofillHints: const [AutofillHints.email],
                                          textCapitalization: TextCapitalization.none,
                                          obscureText: false,
                                          validator: (value) => emailFieldTextControllerValidator.call(context, value),
                                          fillColor: AppThemeManager.primaryBackground,
                                        ).animate(controller: emailAnim).shake(
                                              duration: 1000.ms,
                                              hz: 5,
                                              rotation: 0.017,
                                              curve: Curves.easeInOut,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Row containing the error message for the shooting han in case it is invalid
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // "Please select a valid Shooting Hand" text
                                    if (validationStruct?.shootingHandValid == false)
                                      Text(
                                        'Please select a valid Shooting Hand',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.labelMedium(context),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: Dropdown<String>(
                                            controller: shootingHandDropDownValueController!,
                                            options: const ['Left', 'Right'],
                                            onChanged: (val) => setState(() => shootingHandDropDownValue = val),
                                            hintText: 'Select your shooting hand',
                                            fillColor: AppThemeManager.primaryBackground,
                                          ).animate(controller: shootingHandAnim).shake(
                                                duration: 1000.ms,
                                                hz: 5,
                                                rotation: 0.017,
                                                curve: Curves.easeInOut,
                                              )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  child: DarkButton(
                    onPressed: () async {
                      validationStruct = UserInfoValidation(
                        firstNameValid: firstNameFieldTextController.text.isNotEmpty &&
                            isFieldValid(
                              firstNameFieldTextController.text,
                              r"^[A-Za-z' -]+$",
                            ),
                        lastNameValid: lastNameFieldTextController.text.isNotEmpty &&
                            isFieldValid(
                              lastNameFieldTextController.text,
                              r"^[A-Za-z' -]+$",
                            ),
                        emailValid: emailFieldTextController.text.isNotEmpty &&
                            isFieldValid(
                              emailFieldTextController.text,
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[A-Za-z]{2,}$',
                            ),
                        shootingHandValid: shootingHandDropDownValue != null && shootingHandDropDownValue!.isNotEmpty,
                      );

                      setState(() {});

                      if (validationStruct?.isAllValid ?? false) {
                        // Update the user's info in the DB
                        updatedRow = await ref.read(updateUserProvider).execute(
                          userId: userId!,
                          data: {
                            'first_name': firstNameFieldTextController.text,
                            'last_name': lastNameFieldTextController.text,
                            'email': emailFieldTextController.text,
                            'shooting_hand': shootingHandDropDownValue,
                          },
                        );

                        // Update the related app state
                        ref.read(appStateProvider.notifier).setUserData(
                              appState.userData!.copyWith(
                                firstName: updatedRow.firstName,
                                lastName: updatedRow.lastName,
                                eMail: updatedRow.email,
                                shootingHand: updatedRow.shootingHand,
                              ),
                            );

                        // Refresh appUserProvider
                        ref.invalidate(appUserProvider);

                        setState(() {});

                        // Show success
                        if (!context.mounted) return;
                        await showDialog<void>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: Text('New data has been set successfully',
                                  style: AppTextStyles.bodyLarge(context, color: Colors.black)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(alertDialogContext),
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      } else {
                        HapticFeedback.lightImpact();

                        await Future.wait([
                          if (validationStruct?.firstNameValid == false) firstNameAnim.forward(from: 0),
                          if (validationStruct?.lastNameValid == false) lastNameAnim.forward(from: 0),
                          if (validationStruct?.emailValid == false) emailAnim.forward(from: 0),
                          if (validationStruct?.shootingHandValid == false) shootingHandAnim.forward(from: 0),
                        ]);
                      }

                      setState(() {});
                    },
                    text: 'Save Changes',
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
