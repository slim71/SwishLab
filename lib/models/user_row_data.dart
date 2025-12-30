class UserRowData {
  final String userID;
  final String firstName;
  final String lastName;
  final String eMail;
  final String profilePicture;
  final DateTime? registrationDate;
  final String? shootingHand;

  const UserRowData({
    this.userID = '<User>',
    this.firstName = 'UserName',
    this.lastName = 'UserSurname',
    this.eMail = 'email@default.com',
    this.profilePicture =
        'https://ccqvtpiltowjpogbjmpd.supabase.co/storage/v1/object/public/profile_pictures/defaults/default_profile_male.png',
    this.registrationDate,
    this.shootingHand,
  });

  // optional: factory from JSON if you store/load it
  factory UserRowData.fromJson(Map<String, dynamic> json) => UserRowData(
        userID: json['UserID'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        eMail: json['eMail'],
        profilePicture: json['profilePicture'],
        registrationDate: json['registrationDate'] != null
            ? DateTime.parse(json['registrationDate'])
            : null,
        shootingHand: json['shootingHand'],
      );

  Map<String, dynamic> toJson() => {
        'UserID': userID,
        'firstName': firstName,
        'lastName': lastName,
        'eMail': eMail,
        'profilePicture': profilePicture,
        'registrationDate': registrationDate?.toIso8601String(),
        'shootingHand': shootingHand,
      };

  UserRowData copyWith({
    String? userID,
    String? firstName,
    String? lastName,
    String? eMail,
    String? profilePicture,
    DateTime? registrationDate,
    String? shootingHand,
  }) {
    return UserRowData(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      eMail: eMail ?? this.eMail,
      profilePicture: profilePicture ?? this.profilePicture,
      registrationDate: registrationDate ?? this.registrationDate,
      shootingHand: shootingHand ?? this.shootingHand,
    );
  }
}
