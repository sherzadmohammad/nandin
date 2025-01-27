import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/api_service_provider.dart';
class UpdatePasswordDialog extends ConsumerWidget {
  const UpdatePasswordDialog({super.key,});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),

      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Password updated',
            style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 8.0,),
          Text('Please press sign in to continue',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0XFF6B7280)),),
          const SizedBox(height: 24.0,),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: (){
                  final apiService=ref.read(apiServiceProvider);
                  apiService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (Route<dynamic> route)=>false,
                  );
                }
                , child: const Text('Sign in',
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),)),
          )

        ],
      ),

    );
  }
}
