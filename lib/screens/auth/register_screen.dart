import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nanden/widgets/custom_form_fields.dart';
import 'package:nanden/widgets/gender_selection_widget.dart';
import '../../themes/input_field_decoration.dart';
import '../../utils/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey=GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  late String userName;
  late String firstName;
  late String email;
  late String password;
  String phone='';
  String? address;
  String? lastName;
  String? selectedAcademicLevel;
  String? birthdate;
  String gender='';
  bool isSigningUp = false;
  bool _isPasswordVisible=false;
  bool _isConfirmPasswordVisible=false;


  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  Widget customHeight = const SizedBox(height: 16.0,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
            onTap:(){FocusScope.of(context).unfocus();},
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 60.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     AppLocalizations.of(context)!.signup_header,
                      style: const TextStyle(fontWeight: FontWeight.w600  ,fontSize:24,color: Colors.black87),
                  ),
                  const SizedBox(height:12.0,),
                   SizedBox(width: 200.0,
                    child: Text(
                      AppLocalizations.of(context)!.signup_header,
                      style: const TextStyle(fontWeight: FontWeight.w400  ,fontSize:14,color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 32,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstnameController,
                                style: InputFieldStyle().inputTextStyle,
                                decoration:  InputFieldStyle().decoration(hint: AppLocalizations.of(context)!.signup_firstName_hint),
                                validator: (value){
                                  if(value==null||value.isEmpty){
                                    return 'this field require.';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  firstName=_firstnameController.text;
                                },
                              ),
                            ),
                            const SizedBox(width: 13.0,),
                            Expanded(
                              child: TextFormField(
                                controller: _lastnameController,
                                style: InputFieldStyle().inputTextStyle,
                                decoration:  InputFieldStyle().decoration(hint: AppLocalizations.of(context)!.signup_lastName_hint
                                ),
                                onSaved: (value){
                                  lastName=_lastnameController.text;
                                },
                              ),
                            ),
                          ],
                        ),
                        customHeight,
                        TextFormField(
                          controller: _emailController,
                          style: InputFieldStyle().inputTextStyle,
                          decoration:  InputFieldStyle().decoration(hint: AppLocalizations.of(context)!.signup_email_hint
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
                            email=_emailController.text;
                          },
                        ),
                        customHeight,
                        customPhoneField(
                          controller: _phoneController,
                          label: 'phone',
                          onSaved: (value) {
                            phone = _phoneController.text.trim();
                          },
                        ),
                        customHeight,
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: DropdownButtonFormField<String>(
                                value: selectedAcademicLevel,
                                decoration: InputFieldStyle().decoration(hint: 'Academic level'),
                                icon: const SizedBox.shrink(),
                                items: academicLevels
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value){
                                  if(value == null) {
                                    return 'Please select your academic level';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  selectedAcademicLevel = value!;
                                },
                                onChanged: (String? value) {
                                  selectedAcademicLevel = value!;
                                },
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              flex: 4,
                              child: GestureDetector( // Use GestureDetector instead of InkWell for better response
                                onTap: () => _selectBirthdate(context),
                                child: AbsorbPointer( // Prevents manual input but allows tap
                                  child: TextFormField(
                                    controller: _birthdateController,
                                    decoration: InputFieldStyle().decoration(hint: 'Birthdate'),
                                    readOnly: true, 
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your birthdate';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      birthdate = _birthdateController.text;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        customHeight,
                        customTextField(
                          controller: _addressController,
                          context: context,
                          hint: 'Address',
                          onSaved: (value){
                            address=_addressController.text;
                          },
                        ),
                        customHeight,
                        customPasswordField(
                          controller: _passwordController,
                          context: context,
                          isPasswordVisible: _isPasswordVisible,
                          togglePasswordVisibility:  () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value){
                            if(value==null||value.length<8){
                              return "Password must be grater or equal than 8 char";
                            }
                            else if(value !=_passwordController.text){
                              return "Passwrod is not mutch confirm passwrod";
                            }
                            return null;
                          },
                          onSaved: (value){
                          password=_passwordController.text;
                        },
                        ),
                        customHeight,
                        customPasswordField(
                          controller: _confirmPasswordController,
                          context: context,
                          isPasswordVisible: _isConfirmPasswordVisible,
                          togglePasswordVisibility:  () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                          validator: (value){
                            if(value==null||value.length<8){
                              return "Password must be grater or equal than 8 char";
                            }
                            else if(value !=_passwordController.text){
                              return "Passwrod is not mutch confirm passwrod";
                            }
                            return null;
                          },
                          onSaved: (value){
                          password=_confirmPasswordController.text;
                        },
                        ),
                        customHeight,
                        Text(AppLocalizations.of(context)!.signup_gender_Female,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8.0,),
                        GenderSelectionWidget(
                          selectedGender: gender,
                          onGenderChanged: (value) {
                            setState(() {
                              gender=value;
                            });
                          },
                          
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed:(){_register(ref);},
                    child: Center(
                        child: isSigningUp
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            :  Text(
                          AppLocalizations.of(context)!.signup_btn,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(height: 12.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text(AppLocalizations.of(context)!.signup_having_account,
                          style:const TextStyle(
                              fontSize: 14,fontWeight: FontWeight.w400,color: Color(0XFF555F6D)
                          )
                      ),
                      const SizedBox(width: 8.0,),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:   Text(
                          AppLocalizations.of(context)!.signup_login_option,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),

                      ),
                    ],
                  ),
                  SizedBox(width: 278.0,height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.signup_bottom_text1,
                            style: const TextStyle(color: Colors.black, fontSize: 10.0,fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)!.signup_terms,
                                style: const TextStyle(
                                  color: Color(0XFF9A58F0),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (kDebugMode) {
                                      print('Text button clicked!');
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.signup_bottom_text2,
                          style:const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

Future<void> _register(WidgetRef ref) async {
  final supabaseClient = Supabase.instance.client;

  // Validate the form fields
  if (!_formKey.currentState!.validate()) {
    return;
  }
  _formKey.currentState!.save();
  userName = '$firstName $lastName';
  if (phone.startsWith('0')) {
    phone = phone.substring(1);
  }
  // Show loading state
  setState(() {
    isSigningUp = true;
  });

  try {
    // Register user with Supabase Auth
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': userName,
        'gender': gender,
        'mobile': phone,
        'academic_level': selectedAcademicLevel,
        'address': address,
        'birthdate': birthdate,
        'profile_photo_path': '', // Placeholder if no image is provided
      },
    );

    if (response.user != null) {
      // Successfully signed up, prompt user to log in
      if (mounted) {
        showToast(context: context, message: "Successfully signed up. Please log in.");
        if(kDebugMode){
          print("Successfully signed up. Please log in.");
        }
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      // Sign-up failed
      if (mounted) {
        showToast(context: context, message: "Failed to register user. Please try again.");
        if(kDebugMode){
          print("Failed to register user. Please try again.");
        }
      }
    }
  } catch (e) {
    // Handle any errors
    if (mounted) {
      showToast(context: context, message: "An error occurred: ${e.toString()}");
      if(kDebugMode){
          print("An error occurred: ${e.toString()}");
        }
    }
  } finally {
    // Hide loading state
    setState(() {
      isSigningUp = false;
    });
  }
}
Future<void> _selectBirthdate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null && mounted) {
    setState(() {
      birthdate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _birthdateController.text=birthdate.toString();
    });
  }
}

List<String> academicLevels = [
  'Beginner',  // For users new to cooking
  'Intermediate',  // For users with some cooking experience
  'Advanced',  // For experienced cooks
  'Professional Chef',  // For users pursuing a professional cooking career
  'Culinary School Graduate',  // For users who have completed formal cooking training
];


}