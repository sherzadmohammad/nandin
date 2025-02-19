import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanden/widgets/custom_form_fields.dart';
import 'package:nanden/widgets/gender_selection_widget.dart';
import 'package:nanden/widgets/profile_image_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/user_provider.dart';
import '../../utils/toast.dart';
import '../../widgets/dialogs/delete_acount_dialog.dart';
import '../../widgets/dialogs/alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _profileFormKey=GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  static Widget customHeight= const SizedBox(height: 12.0,);

  late String firstName;
  late String lastName;
  late String email;
  late String address;
  late String selectedAcademicLevel;
  late String birthdate;
  late String mobile;
  late String gender;
  bool isSigningUp = false;
  late String profilePhotoUrl;
  File? _selectedImage;
  void _removeImage() async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null || profilePhotoUrl.isEmpty) return;

  try {
    //  Extract the correct file path from the URL
    final fileName = '${user.id}.${profilePhotoUrl.split('.').last}';
    final filePath = 'profile_pictures/$fileName';

    // Delete the image from Supabase storage
    await supabase.storage.from('profile_pictures').remove([filePath]);

    // Update state
    setState(() {
      profilePhotoUrl = "";
      _selectedImage = null;
    });

    if (kDebugMode) print("Profile image removed successfully.");
    if (mounted) showToast(context: context, message: "Profile image removed.");
  } catch (e) {
    if (kDebugMode) print("Failed to remove profile image: $e");
    if (mounted) showToast(context: context, message: "Failed to remove image.");
  }
}

  @override
  void initState() {
    final initUserData=ref.read(userProvider.notifier).currentUser;
    String fullName = initUserData!.name;
    List<String> nameParts = fullName.split(' ');
     firstName = nameParts.isNotEmpty ? nameParts.first : '';
     lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
     selectedAcademicLevel=initUserData.academicLevel;
     birthdate=initUserData.birthdate;
     profilePhotoUrl=initUserData.userAvatarPath;
    _firstnameController.text=firstName;
    _lastnameController.text=lastName;
    _emailController.text = initUserData.email;
    _phoneController.text = initUserData.mobile;
    _addressController.text = initUserData.address;
    gender = initUserData.gender;
    super.initState();
  }
  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerBottomSheet(BuildContext context) async {
    final XFile? pickedImage = await showModalBottomSheet<XFile>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ShowBottomSheetDialog(onRemoveImage:(){ _removeImage();});
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      if (kDebugMode) {
        print(_selectedImage);
      }
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future<String?> _uploadProfilePhoto(File image) async {
  try {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = image.path.split('.').last;
    final fileName = '${user.id}.$fileExt';
    final filePath = 'profile_pictures/$fileName';

    final response = await supabase.storage
        .from('profile_pictures')
        .upload(
          filePath,
          image,
          fileOptions: const FileOptions(upsert: true),
        );

    if (response.isEmpty){
      if(kDebugMode){
        print("failed to upload image.");
      }
      if(mounted){
      showToast(context: context, message: "failed to upload image." );
      }
    }
    
    return supabase.storage.from('profile_pictures').getPublicUrl(filePath);
  } catch (e) {
    if (kDebugMode) print('Image upload failed: $e');
    return null;
  }
}


  void _updateProfile() async {
    
  if (!_profileFormKey.currentState!.validate()) {
    showToast(context: context, message: "Please fill in all fields correctly.");
    if (kDebugMode) print('Please fill in all fields correctly.');
    return;
  }

  _profileFormKey.currentState!.save();
  setState(() {
    isSigningUp = true;
  });

  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) {
    setState(() {
      isSigningUp = false;
    });
    showToast(context: context, message: "User not authenticated.");
    if (kDebugMode) print('User not authenticated.');
    return;
  }

  final name = '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}';

  if (_selectedImage != null) {
    final uploadedUrl = await _uploadProfilePhoto(_selectedImage!);
    if (uploadedUrl != null) {
      profilePhotoUrl = uploadedUrl;
    } else {
      if (mounted) {
        showToast(context: context, message: "Failed to upload image.");
      }
    }
  }

  try {

    // ✏️ Update user profile in Supabase
    final response = await supabase.auth.updateUser(
      UserAttributes(
        data: {
          'name': name,
          'gender': gender,
          'mobile': mobile,
          'academic_level': selectedAcademicLevel,
          'address': address,
          'birthdate': birthdate,
          'profile_photo_path': profilePhotoUrl,
        },
      ),
    );

    setState(() {
      isSigningUp = false;
    });

    if (response.user != null) {
      ref.read(userProvider.notifier).fetchUserDetails();
      if (mounted) {
        showToast(context: context, message: "Profile updated successfully");
        if (kDebugMode) print('Profile updated successfully');
      }
      if (mounted) Navigator.of(context).pop();
    } else {
      if (mounted) {
        showToast(context: context, message: "Profile update failed.");
        if (kDebugMode) print('Profile update failed.');
      }
    }
  } catch (e) {
    setState(() {
      isSigningUp = false;
    });
    if (mounted) {
      showToast(context: context, message: 'An error occurred: $e');
      if (kDebugMode) print('An error occurred: $e');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color:Colors.black,size: 24,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(AppLocalizations.of(context)!.profile_profile,style:
          const TextStyle(
            fontSize: 16,fontWeight: FontWeight.w500,color:Colors.black
          )
          ,),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.5, 0.0, 15.0, 0.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  _selectedImage !=null?
                  ProfileImageWidget(
                    file: _selectedImage,
                    size: 160,
                    borderRadius: 80.0,
                  ):
                  ProfileImageWidget(
                    imageUrl: profilePhotoUrl,
                    size: 160,
                    borderRadius: 80.0,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20),
                        color: Colors.white,
                        onPressed: () {
                          _showImagePickerBottomSheet(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35,),
            Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                    controller: _firstnameController,
                    context: context,
                    hint: AppLocalizations.of(context)!.signup_firstName_hint,
                    onSaved: (value){
                      lastName=_firstnameController.text.trim();
                    }
                  ),
                  customHeight,
                  customTextField(
                    controller: _lastnameController,
                    context: context,
                    hint: AppLocalizations.of(context)!.signup_lastName_hint,
                    onSaved: (value){
                      lastName=_lastnameController.text.trim();
                    }
                  ),
                  customHeight,
                  customEmailField(
                    controller: _emailController,
                    context: context,
                    onSaved: (value) {
                      email = _emailController.text.trim();
                    },
                  ),
                  customHeight,
                  customTextField(
                    controller: _addressController,
                    context: context,
                    hint: 'Address',
                    onSaved: (value){
                      address=_addressController.text.trim();
                    }
                  ),
                  customHeight,
                  customPhoneField(
                    controller: _phoneController,
                    label: 'phone',
                    onSaved: (value) {
                      mobile = _phoneController.text.trim();
                    },
                  ),
                  customHeight,
                ],
              ),
            ),
            const SizedBox(height: 14.0,),
            Text(AppLocalizations.of(context)!.signup_gender_hint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0,),
            GenderSelectionWidget(
              selectedGender: gender,
               onGenderChanged: (value){
                setState(() {
                  gender=value;
                });
               })
               ,

            const SizedBox(height: 30.0,),
            GestureDetector(
              onTap:_updateProfile,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      AppLocalizations.of(context)!.editProfile_btn,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            const SizedBox(height: 12,),
            TextButton(
              style:  ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.redAccent)
              ),
              onPressed: () {
                showDialog(context: context, builder: (context)=>const DeleteAccountDialog());
              },
              child: Text(AppLocalizations.of(context)!.editProfile_delete_btn),
            ),
          ],
        ),
      ),
    );
  }
}

