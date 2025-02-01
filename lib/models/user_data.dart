class UserData {
  final int id;
  final String name;
  final String email;
  final bool hasVerifiedEmail;
  final String gender;
  final String mobile1;
  final String? address;
  final String academicLevel;
  final String? birthdate;
  final String profilePhotoPath;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.hasVerifiedEmail,
    required this.gender,
    required this.mobile1,
    this.address,
    required this.academicLevel,
    this.birthdate,
    required this.profilePhotoPath,
  });

  // Factory method to create a User from a Supabase response
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      hasVerifiedEmail: json['email_verified_at'] != null,
      gender: json['gender'] as String? ?? '',
      mobile1: json['mobile1'] as String? ?? '',
      address: json['address'] as String?,
      academicLevel: json['academic_level'] as String? ?? '',
      birthdate: json['birthdate'] as String?,
      profilePhotoPath: json['profile_photo_path'] as String? ?? '',
    );
  }

  // Method to convert User back to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'mobile1': mobile1,
      'address': address,
      'academic_level': academicLevel,
      'birthdate': birthdate,
      'profile_photo_path': profilePhotoPath,
    };
  }
}
