import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CheckEmailDialog extends StatelessWidget {
  const CheckEmailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      icon:  CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.black,
          child: SvgPicture.asset('assets/icons/Email.svg')
      ),
      title: const Text('Check your email',
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
      ),
      content:  Text('We have send password recovery instruction to your email',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.30),
        textAlign: TextAlign.center,
      ),
    );
  }
}
