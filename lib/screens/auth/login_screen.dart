
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/services/api_services.dart';
import 'package:nanden/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:nanden/screens/auth/register_screen.dart';
import 'package:nanden/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../themes/input_field_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isSigning = false;
  final ApiService apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _loginForm = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 95.0, 16.0, 17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.login_header,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Text(AppLocalizations.of(context)!.login_title,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32,),
              Form(
                key: _loginForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: InputFieldStyle().inputTextStyle,
                      decoration: InputFieldStyle().decoration(
                        hint:AppLocalizations.of(context)!.login_email_hint
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email address can not be empty.';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = _emailController.text;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      controller: _passwordController,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14, color: Color(0xFF1A1A1A)
                      ),
                      decoration: InputFieldStyle().passwordInputDecoration(
                        AppLocalizations.of(context)!.login_password_hint,
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid Password.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = _passwordController.text;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.login_forgetPassword_textButton,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 42.0,),
              GestureDetector(
                onTap: () {
                  _login(ref);
                },
                child: Container(
                  width: 344.0,
                  height: 50,
                  decoration: BoxDecoration(
                    color: materialButtonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text( AppLocalizations.of(context)!.login_btn,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.login_label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF555F6D)
                      )
                  ),
                  const SizedBox(width: 8.0,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login_signup_textButton,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                  ),
                ],
              ),
              const SizedBox(height: 78.0,),
              Row(
                children: [
                  const Expanded(
                      child: Divider(color: Color(0XFFCFD6DD), thickness: 1.2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      AppLocalizations.of(context)!.login_division_line,
                      style: const TextStyle(color: Color(0XFF64748B)),),
                  ),
                  const Expanded(child: Divider(
                    color: Color(0XFFCFD6DD), thickness: 1.2,)),

                ],
              ),
              const SizedBox(height: 16.0,),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSecondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black87),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/google.jpg', fit: BoxFit.fill,),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                            AppLocalizations.of(context)!.login_signupWithGoogle_btn,
                            style: const TextStyle(fontSize: 16.0,
                                fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 278.0, height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By using this app you agree to the',
                        style: const TextStyle(color: Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms and Condition',
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
                    const Text('All rights reserved © Nanden 2024',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void _login(WidgetRef ref) async {
    if (!_loginForm.currentState!.validate()) {
      return;
    }
    _loginForm.currentState!.save();

    try {
      setState(() {
        _isSigning = true;
      });

      // Perform Supabase login
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email!,
        password: password!,
      );

      // Check if login is successful
      if (response.session != null) {
        final user = response.user;
        final token = response.session!.accessToken;

        if (kDebugMode) {
          print('Login successful! Token: $token');
          print('User ID: ${user?.id}');
        }

        // Fetch user details from Supabase
        ref.read(userProvider.notifier).fetchUserDetails();

        // Show success message
        if (mounted) {
          showToast(context: context, message: "Login successful! User ID: ${user?.id}");
        }
        // Navigate to home screen
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
                (route) => false,
          );
        }
      }
    } on AuthException catch (e) {
      // Handle login failure
      if (kDebugMode) {
        print('Login failed: ${e.message}');
      }
      if (mounted) {
        showToast(context: context, message: "Login failed: ${e.message}");
      }
    } catch (e) {
      // Handling any other exceptions
      if (kDebugMode) {
        print('Error during login: $e');
      }
      if (mounted) {
        showToast(context: context, message: "Login failed: ${e.toString()}");
      }
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
  }
}