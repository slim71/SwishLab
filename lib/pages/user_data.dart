import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
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
import '../widgets/box_with_shadow.dart';
import '../widgets/dark_button.dart';
import '../widgets/drop_down.dart';
import '../widgets/input_field.dart';

class _UserDataField {
  final String label;
  final IconData icon;
  final String errorText;
  final Widget Function(BuildContext context, Color iconColor) builder;
  final AnimationController animationController;
  final bool Function() isValid;

  _UserDataField({
    required this.label,
    required this.icon,
    required this.errorText,
    required this.builder,
    required this.animationController,
    required this.isValid,
  });
}

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

  List<_UserDataField>? _fields;

  void _initFields() {
    if (_fields != null) return;

    _fields = [
      _UserDataField(
        label: 'First Name',
        icon: Icons.person_outline_rounded,
        errorText: 'Valid First Name required',
        animationController: firstNameAnim,
        isValid: () => validationStruct?.firstNameValid ?? true,
        builder: (context, iconColor) => InputField(
          label: 'First Name',
          prefixIcon: Icon(Icons.person_outline_rounded, color: iconColor),
          controller: firstNameFieldTextController,
          focusNode: firstNameFieldFocusNode,
          autofillHints: const [AutofillHints.name],
          textCapitalization: TextCapitalization.words,
          validator: (value) => firstNameFieldTextControllerValidator.call(context, value),
          allowRegex: RegExp('^[A-Za-z\' -]+\$'),
          fillColor: Colors.transparent,
        ),
      ),
      _UserDataField(
        label: 'Last Name',
        icon: Icons.badge_outlined,
        errorText: 'Valid Last Name required',
        animationController: lastNameAnim,
        isValid: () => validationStruct?.lastNameValid ?? true,
        builder: (context, iconColor) => InputField(
          label: 'Last Name',
          prefixIcon: Icon(Icons.badge_outlined, color: iconColor),
          controller: lastNameFieldTextController,
          focusNode: lastNameFieldFocusNode,
          autofillHints: const [AutofillHints.name],
          textCapitalization: TextCapitalization.words,
          validator: (value) => lastNameFieldTextControllerValidator.call(context, value),
          fillColor: Colors.transparent,
        ),
      ),
      _UserDataField(
        label: 'Email',
        icon: Icons.email_outlined,
        errorText: 'Valid Email required',
        animationController: emailAnim,
        isValid: () => validationStruct?.emailValid ?? true,
        builder: (context, iconColor) => InputField(
          label: 'Email',
          prefixIcon: Icon(Icons.email_outlined, color: iconColor),
          controller: emailFieldTextController,
          focusNode: emailFieldFocusNode,
          autofillHints: const [AutofillHints.email],
          textCapitalization: TextCapitalization.none,
          validator: (value) => emailFieldTextControllerValidator.call(context, value),
          fillColor: Colors.transparent,
        ),
      ),
      _UserDataField(
        label: 'Shooting Hand',
        icon: Icons.front_hand_outlined,
        errorText: 'Please select a valid Shooting Hand',
        animationController: shootingHandAnim,
        isValid: () => validationStruct?.shootingHandValid ?? true,
        builder: (context, iconColor) => Dropdown<String>(
          controller: shootingHandDropDownValueController!,
          options: const ['Left', 'Right'],
          prefixIcon: Icon(Icons.front_hand_outlined, color: iconColor),
          onChanged: (val) => setState(() => shootingHandDropDownValue = val),
          hintText: 'Select your shooting hand',
          fillColor: Colors.transparent,
        ),
      ),
    ];
  }

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

    _initFields();
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

    _initFields();

    return Scaffold(
      backgroundColor: AppThemeManager.primaryBackground,
      appBar: const MyAppBar(
        style: MyAppBarStyle.backButtonTitleLeft,
        title: 'User info',
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Background(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Your information'.toUpperCase(),
                      style: AppTextStyles.labelSmall(context, color: Colors.white.withValues(alpha: 0.7)).copyWith(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Container(
                      decoration: BoxWithShadow(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppThemeManager.secondaryBackground.withValues(alpha: 0.85),
                            AppThemeManager.primaryBackground.withValues(alpha: 0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppThemeManager.currentColors.containersBorders.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        shadowOffset: const Offset(0, 8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(_fields!.length, (index) {
                            final field = _fields![index];
                            final iconColor = settingsItemBackgrounds[index % settingsItemBackgrounds.length];

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!field.isValid())
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      field.errorText,
                                      style: AppTextStyles.labelSmall(context, color: Colors.red),
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: index == _fields!.length - 1 ? 8 : 24),
                                  child: field
                                      .builder(context, iconColor)
                                      .animate(controller: field.animationController)
                                      .shake(
                                        duration: 1000.ms,
                                        hz: 5,
                                        rotation: 0.017,
                                        curve: Curves.easeInOut,
                                      ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Save Changes Button (Docked)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppThemeManager.primaryBackground.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
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
                        try {
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
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update. Check your internet connection.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        HapticFeedback.lightImpact();

                      await Future.wait(
                          _fields!.where((f) => !f.isValid()).map((f) => f.animationController.forward(from: 0)));
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
    );
  }
}
