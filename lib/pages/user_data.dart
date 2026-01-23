import 'package:SwishLab/controllers/dropdown_controller.dart';
import 'package:SwishLab/functions/is_field_valid.dart';
import 'package:SwishLab/models/user_info_validation.dart';
import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/drop_down.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page showing user info and allowing changes
class UserData extends ConsumerStatefulWidget {
  const UserData({super.key});

  @override
  ConsumerState<UserData> createState() => _UserDataState();
}

class _UserDataState extends ConsumerState<UserData> with TickerProviderStateMixin {
  /// Storage for validation states
  UserInfoValidation? validationStruct;

  void updateValidationStructStruct(Function(UserInfoValidation) updateFn) {
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
    final appState = ref.watch(appStateProvider);
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      validationStruct = UserInfoValidation(
        firstNameValid: true,
        lastNameValid: true,
        emailValid: true,
        shootingHandValid: true,
      );
      setState(() {});
    });

    firstNameFieldTextController = TextEditingController(text: appState.userData?.firstName);
    firstNameFieldFocusNode ??= FocusNode();
    firstNameFieldTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) return 'First name required';
      if (value.length < 2) return 'First name too short';
      if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) {
        return 'Invalid characters';
      }
      return null;
    };

    lastNameFieldTextController = TextEditingController(text: appState.userData?.lastName);
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
    final appColors = AppThemeManager.currentColors;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;
    final userId = userInfo?.id;

    return Scaffold(
      backgroundColor: appColors.secondaryBackground,
      appBar: MyAppBar(
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
                    padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Text(
                            'Your information',
                            style: AppTextStyles.headlineMedium(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Row containing the error message for the first name in case it is invalid
                                  Semantics(
                                    label: 'First Name error row',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // "Valid First Name required" text
                                        if (!validationStruct!.firstNameValid)
                                          Semantics(
                                            label: '"Valid First Name required" text',
                                            child: Text(
                                              'Valid First Name required',
                                              textAlign: TextAlign.end,
                                              style: AppTextStyles.labelMedium(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: InputField(
                                            label: 'First Name',
                                            controller: firstNameFieldTextController,
                                            focusNode: firstNameFieldFocusNode,
                                            autofillHints: [AutofillHints.name],
                                            textCapitalization: TextCapitalization.words,
                                            obscureText: false,
                                            validator: (value) =>
                                                firstNameFieldTextControllerValidator.call(context, value),
                                            allowRegex: RegExp('^[A-Za-z\' -]+\$'),
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
                                  Semantics(
                                    label: 'Last Name error row',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // "Valid Last Name required" text
                                        if (!validationStruct!.lastNameValid)
                                          Semantics(
                                            label: '"Valid Last Name required" text',
                                            child: Text(
                                              'Valid Last Name required',
                                              textAlign: TextAlign.end,
                                              style: AppTextStyles.labelMedium(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: InputField(
                                            label: 'Last Name',
                                            controller: lastNameFieldTextController,
                                            focusNode: lastNameFieldFocusNode,
                                            autofillHints: [AutofillHints.name],
                                            textCapitalization: TextCapitalization.words,
                                            obscureText: false,
                                            validator: (value) =>
                                                lastNameFieldTextControllerValidator.call(context, value),
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
                                  Semantics(
                                    label: 'Email error row',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // "Valid Email required" text
                                        if (!validationStruct!.emailValid)
                                          Semantics(
                                            label: '"Valid Email required" text',
                                            child: Text(
                                              'Valid Email required',
                                              textAlign: TextAlign.end,
                                              style: AppTextStyles.labelMedium(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                          child: InputField(
                                            label: 'Email',
                                            controller: emailFieldTextController,
                                            focusNode: emailFieldFocusNode,
                                            autofillHints: [AutofillHints.email],
                                            textCapitalization: TextCapitalization.none,
                                            obscureText: false,
                                            validator: (value) =>
                                                emailFieldTextControllerValidator.call(context, value),
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
                                  Semantics(
                                    label: 'Shooting Hand error row',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // "Please select a valid Shooting Hand" text
                                        if (!validationStruct!.shootingHandValid)
                                          Semantics(
                                            label: '"Please select a valid Shooting Hand" text',
                                            child: Text(
                                              'Please select a valid Shooting Hand',
                                              textAlign: TextAlign.end,
                                              style: AppTextStyles.labelMedium(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                            child: Dropdown<String>(
                                              controller: shootingHandDropDownValueController ??=
                                                  DropdownController<String>(
                                                value: appState.userData?.shootingHand,
                                              ),
                                              options: ['Left', 'Right'],
                                              onChanged: (val) => setState(() => shootingHandDropDownValue = val),
                                              hintText: 'Select your shooting hand',
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
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

                        if (!validationStruct!.isAllValid) return;

                        if ((validationStruct?.firstNameValid == true) &&
                            (validationStruct?.lastNameValid == true) &&
                            (validationStruct?.emailValid == true) &&
                            (validationStruct?.shootingHandValid == true)) {
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

                          setState(() {});

                          // Show success
                          if (!context.mounted) return;
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: Text('New data has been set successfully'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          HapticFeedback.lightImpact();

                          await Future.wait([
                            if (!validationStruct!.firstNameValid) firstNameAnim.forward(from: 0),
                            if (!validationStruct!.lastNameValid) lastNameAnim.forward(from: 0),
                            if (!validationStruct!.emailValid) emailAnim.forward(from: 0),
                            if (!validationStruct!.shootingHandValid) shootingHandAnim.forward(from: 0),
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
          )),
    );
  }
}
