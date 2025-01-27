import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputFieldStyle {
  TextStyle inputTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF1A1A1A),
  );
  InputDecoration decoration({String? hint,String? label}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 17.0),
      hintText: hint,
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: Color(0xFF555F6D),
      ),
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        gapPadding: 0.0,
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFCBD5E1),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          width: 1.1,
          color: Color(0xFF262526),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          width: 0.5,
          color: Color(0xFFED4956),
        ),
      ),
    );
  }

  InputDecoration passwordInputDecoration(String hint, {bool isPasswordVisible=false,
    VoidCallback? togglePasswordVisibility}) {
    return InputDecoration(focusColor: Colors.black,
      hintText: hint,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFCBD5E1),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          width: 1.1,
          color: Color(0xFF262526),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          width: 0.5,
          color: Color(0xFFED4956),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 17.0),
      suffixIcon: IconButton(
        icon: SvgPicture.asset(
          (isPasswordVisible ? 'assets/icons/passwordVisible.svg': 'assets/icons/passwordVisibleOff.svg') ,
        ),
          color: const Color(0XFF7E8B99),
        onPressed: togglePasswordVisibility,
      ),
    );
  }
}
