class UserData {
  final String id;
  final String name;
  final String email;
  final bool hasVerifiedEmail;
  final String gender;
  final String mobile;
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
  return UserData(
    id: json['id'] ?? '', 
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    hasVerifiedEmail: json['email_verified'] == true,
    gender: json['gender'] ?? '',
    mobile: json['phone'] ?? '',
    address: json['address'] ,
    academicLevel: json['academic_level'] ?? '',
    birthdate: json['birthdate'] as String?,
    userAvatarPath: json['profile_photo_path'] ?? '',
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