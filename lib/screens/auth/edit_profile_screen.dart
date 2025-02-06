import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/api_service_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/toast.dart';
import '../../widgets/dialogs/delete_acount_dialog.dart';
import '../../themes/input_field_decoration.dart';
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
  static Widget customHeight= const SizedBox(height: 12.0,);

  late String firstName;
  late String lastName;
  late String email;
  late String mob1;
  late String selectedCity;
  late String gender;
  bool isSigningUp = false;
  File? _selectedImage;
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }
  @override
  void initState() {
    final initUserData=ref.read(userProvider.notifier).currentUser;
    String fullName = initUserData!.name;
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _firstnameController.text=firstName;
    _lastnameController.text=lastName;
    _emailController.text = initUserData.email;
    _phoneController.text = initUserData.mobile;
    gender = 'Male';
    super.initState();
  }
  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  Future<void> _showImagePickerBottomSheet(BuildContext context) async {
    final pickedImage = await showModalBottomSheet<XFile>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ShowBottomSheetDialog(onRemoveImage: _removeImage);
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }
  void _updateProfile() async {
    if (!_profileFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields correctly.")),
      );
      return;
    }
    _profileFormKey.currentState!.save();
    final apiService= ref.read(apiServiceProvider);
    setState(() {
      isSigningUp = true;
    });
    final name = '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}';
    const mob2 = "1234567890";
    const address = "None";
    try {
      final response = await apiService.updateProfile(name, email, mob1, mob2, address, selectedCity);
      setState(() {
        isSigningUp = false;
      });
      if (response['success']) {
        ref.read(userProvider.notifier).fetchUserDetails();
        if(mounted){
        showToast(context: context, message: response['message']);
        }
      } else {
        if(mounted){
        showToast(context: context, message: response['message']);
        }
      }
    } catch (e) {
      setState(() {
        isSigningUp = false;
      });
      if(mounted){
      showToast(context: context, message: 'An error occurred');
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
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: _selectedImage == null ? Colors.grey : null,
                    ),
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
                  TextFormField(
                    controller: _firstnameController,
                    style: InputFieldStyle().inputTextStyle,
                    decoration:  InputFieldStyle().decoration(hint:AppLocalizations.of(context)!.signup_firstName_hint).copyWith(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0)
                    ),
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'this field require.';
                      }
                      return null;
                    },
                    onSaved: (value){
                      firstName=_firstnameController.text.trim();
                    },
                  ),
                  customHeight,
                  TextFormField(
                    controller: _lastnameController,
                    style: InputFieldStyle().inputTextStyle,
                    decoration:  InputFieldStyle().decoration(hint:AppLocalizations.of(context)!.signup_lastName_hint).copyWith(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0)
                    ),
                    validator:(value){
                      if(value==null||value.isEmpty) {
                        return 'this field require.';
                      }
                      return null;
                    },
                    onSaved: (value){
                      lastName=_lastnameController.text.trim();
                    },
                  ),
                  customHeight,
                  TextFormField(
                    controller: _emailController,
                    style: InputFieldStyle().inputTextStyle,
                    decoration:  InputFieldStyle().decoration(hint:AppLocalizations.of(context)!.signup_email_hint).copyWith(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0)
                    ),
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Email address can not be empty.';
                      }
                      if(!value.contains('@')||!value.contains('.')){
                        return 'Invalid email address';
                      }
                      return null;
                    },
                    onSaved: (value){
                      email=_emailController.text.trim();
                    },
                  ),
                  customHeight,
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      labelText: 'Phone number',
                      floatingLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      prefixText: '+964',
                      prefixStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1),width: 1)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          width: 1.1,
                          color: Color(0xFF262526),
                        ),
                      ),
                    ),
                    validator: (phone){
                      if (phone == null || phone.isEmpty) {
                        return 'Phone number is required.';
                      }
                      
                      if (phone.startsWith('0')) {
                        phone = phone.substring(1);
                      }

                      
                      if (phone.length != 10) {
                        return 'Phone number must be exactly 10 digits.';
                      }

                      
                      if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                        return 'Phone number must contain only digits.';
                      }

                      return null;
                    },
                    onSaved: (value){
                      mob1=_phoneController.text.trim();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'Female';
                      });
                    },
                    child: Container(
                      width: 150.0,height: 50,
                      decoration: BoxDecoration(
                        border:gender=='Female'? Border.all(width: 1.1,color: const Color(0xFF262526)) :
                        Border.all(
                            width: 1.0,color: const Color(0xFFCBD5E1)
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.female,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                              AppLocalizations.of(context)!.signup_gender_Female,
                            style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w400)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Space between the containers
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'Male';
                      });
                    },
                    child: Container(
                      width: 150.0,height: 50,
                      decoration: BoxDecoration(
                        border:gender=='Male'? Border.all(width: 1.1,color: const Color(0xFF262526)) :Border.all(
                            width: 1.0,color: const Color(0xFFCBD5E1)
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child:  Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.male,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                                AppLocalizations.of(context)!.signup_gender_male,
                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

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

