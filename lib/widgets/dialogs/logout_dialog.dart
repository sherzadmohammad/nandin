import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/api_service_provider.dart';
import '../../providers/user_provider.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});


  void performLogout(BuildContext context,WidgetRef ref) async {
    final apiService = ref.read(apiServiceProvider);
    await apiService.logout();
    ref.read(userProvider.notifier).clearUserData();
    if(context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return  AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 32.0),
      title: const Center(
        child: Text('Log out',
          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to log out?',
            style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24,),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(color:const Color(0XFFCFD6DD) ),
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Center(child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,fontWeight: FontWeight.w400
                      ),
                    )),
                  ),
                ),
              ),
              const SizedBox(width: 10.0 ,),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    performLogout(context,ref);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child:  const Center(child: Text('Log out',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,fontWeight: FontWeight.w400
                      ),
                    )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
