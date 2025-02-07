import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nanden/themes/input_field_decoration.dart'; // Import localization if used

Widget customPhoneField({
  required TextEditingController controller,
  required String label,
  required Function(String?)? onSaved,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      labelText: label,
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      prefixText: '+964 ',
      prefixStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF1A1A1A),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1.1, color: Color(0xFF262526)),
      ),
    ),
    validator: (phone) {
      if (phone == null || phone.isEmpty) {
        return 'Phone number is required.';
      } else if (phone.startsWith('0')) {
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
    onSaved: onSaved,
  );
}


Widget customEmailField({
  required TextEditingController controller,
  required BuildContext context,
  required Function(String?)? onSaved,
}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(fontSize: 14, color: Colors.black), // Define a consistent text style
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      labelText: AppLocalizations.of(context)!.signup_email_hint, // Localized label
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(width: 1.1, color: Color(0xFF262526)),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Email address cannot be empty.';
      }
      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
        return 'Invalid email address';
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget customTextField({
  required TextEditingController controller,
  required BuildContext context,
  required String hint,
  required Function(String?)? onSaved,
}){
  return TextFormField(
      controller: controller,
      style: InputFieldStyle().inputTextStyle,
      decoration:  InputFieldStyle().decoration(
        hint:hint).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 14.0)
      ),
      validator:(value){
        if(value==null||value.isEmpty) {
          return 'this field require.';
        }
        return null;
      },
      onSaved: onSaved
  );
}
Widget customPasswordField({
  required TextEditingController controller,
  required BuildContext context,
  required bool isPasswordVisible,
  required VoidCallback togglePasswordVisibility,
  required FormFieldValidator<String>? validator,
  required Function(String?)? onSaved,
}){
  return TextFormField(
      controller: controller,
        obscureText: !isPasswordVisible,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,color: Color(0xFF1A1A1A)
      ),
      decoration:  InputFieldStyle().passwordInputDecoration(
        AppLocalizations.of(context)!.signup_password_hint,
        isPasswordVisible: isPasswordVisible,
        togglePasswordVisibility:togglePasswordVisibility
      ),
      validator:validator,
      onSaved: onSaved
    );
}