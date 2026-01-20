class UserInfoValidation {
  bool firstNameValid;
  bool lastNameValid;
  bool emailValid;
  bool shootingHandValid;

  UserInfoValidation({
    this.firstNameValid = true,
    this.lastNameValid = true,
    this.emailValid = true,
    this.shootingHandValid = true,
  });

  /// Optional convenience getter
  bool get isAllValid => firstNameValid && lastNameValid && emailValid && shootingHandValid;
}
