class UserData {
  final String id; // UUID
  final String name;
  final String email;
  final bool hasVerifiedEmail;
  final String gender;
  final String mobile; // Changed to match Supabase field
  final String? address;
  final String academicLevel;
  final String? birthdate;
  final String userAvatarPath;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.hasVerifiedEmail,
    required this.gender,
    required this.mobile,
    this.address,
    required this.academicLevel,
    this.birthdate,
    required this.userAvatarPath,
  });

  // Factory method to create a User from Supabase response
  factory UserData.fromJson(Map<String, dynamic> json) {
  final rawUserData = json['raw_user_meta_data'] ?? {}; // Safe access to raw_user_meta_data

  return UserData(
    id: json['id'] as String? ?? '', 
    name: rawUserData['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    hasVerifiedEmail: json['email_verified'] == true,
    gender: rawUserData['gender'] as String? ?? '',
    mobile: rawUserData['phone'] as String? ?? '',
    address: rawUserData['address'] as String?,
    academicLevel: rawUserData['academic_level'] as String? ?? '',
    birthdate: rawUserData['birthdate'] as String?,
    userAvatarPath: rawUserData['profile_photo_path'] as String? ?? '',
  );
}


  // Convert UserData to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'phone': mobile, // Adjust to match Supabase
      'address': address,
      'academic_level': academicLevel,
      'birthdate': birthdate,
      'profile_photo_path': userAvatarPath,
    };
  }
}
