
class User {
  final int id;
  final String name;
  final String email;
  final String emailVerifiedAt;
  final String gender;
  final String mobile1;
  final String address;
  final String academicLevel;
  final String? birthdate;
  final String profilePhotoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool hasVerifiedEmail=false;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.gender,
    required this.mobile1,
    required this.address,
    required this.academicLevel,
    this.birthdate,
    required this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    required this.hasVerifiedEmail,
  });

  // Factory method to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']??0,
      name: json['name']??'',
      email: json['email']??'',
      emailVerifiedAt: json['email_verified_at']??'',
      gender: json['gender']??'',
      mobile1: json['mobile1']??'',
      address: json['address']??'',
      academicLevel: json['academic_level']??'',
      birthdate: json['birthdate']??'',
      profilePhotoPath: json['profile_photo_path']??'',
      createdAt: DateTime.parse(json['created_at']??''),
      updatedAt: DateTime.parse(json['updated_at']??''),
      hasVerifiedEmail:false,
    );
  }

  // Method to convert User back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'gender': gender,
      'mobile1': mobile1,
      'address': address,
      'academic_level': academicLevel,
      'birthdate': birthdate,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'hasVerifiedEmail':hasVerifiedEmail
    };
  }
}
