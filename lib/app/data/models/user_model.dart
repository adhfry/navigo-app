class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final String? profilePictureUrl;
  final String? bio;
  final double averageRating;
  final bool isTravelerVerified;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
    this.bio,
    required this.averageRating,
    required this.isTravelerVerified,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: json['gender'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      bio: json['bio'] as String?,
      averageRating: double.parse(json['averageRating'].toString()),
      isTravelerVerified: json['isTravelerVerified'] as bool,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'averageRating': averageRating,
      'isTravelerVerified': isTravelerVerified,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
