class UserData {
  final String id; // UUID instead of int
  final String name;
  final String email;
  final bool hasVerifiedEmail;
  final String gender;
  final String mobile; // Changed from mobile1 to match Supabase table
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
      id: json['id'] as String, // UUID is a String
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      hasVerifiedEmail: json['email_verified_at'] != null,
      gender: json['gender'] ?? '',
      mobile: json['mobile'] ?? '', // Changed to match Supabase field
      address: json['address'],
      academicLevel: json['academic_level'] ?? '',
      birthdate: json['birthdate'],
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
      'mobile': mobile, // Changed key to match Supabase
      'address': address,
      'academic_level': academicLevel,
      'birthdate': birthdate,
      'profile_photo_path': userAvatarPath,
    };
  }
}
