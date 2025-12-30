class UsersRow {
  final String id;
  final DateTime? createdAt;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePic;
  final String? shootingHand;

  const UsersRow({
    required this.id, // primary key
    this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePic,
    this.shootingHand,
  });

  factory UsersRow.fromJson(Map<String, dynamic> json) {
    return UsersRow(
      id: json['id'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      profilePic: json['profile_pic'] as String?,
      shootingHand: json['shooting_hand'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_pic': profilePic,
      'shooting_hand': shootingHand,
    };
  }

  UsersRow copyWith({
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePic,
    String? shootingHand,
  }) {
    return UsersRow(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      shootingHand: shootingHand ?? this.shootingHand,
    );
  }

  @override
  String toString() {
    return 'UsersRow(id: $id, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsersRow && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
