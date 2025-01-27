import 'package:flutter/material.dart';
class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0)
      ),
      title: const Center(child: Text('Warning!',
        style: TextStyle(color: Color(0xFFE11C1C),
            fontSize: 18,fontWeight: FontWeight.w600
        ),
      )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Are you sure you want to delete your account? this cannot be undone.',
            style: TextStyle(color: Color(0xFF6B7280),
                fontSize: 14,fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0,),
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color:const Color(0XFFCFD6DD) ),
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: const Center(child: Text('yes,i want to delete my account',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,fontWeight: FontWeight.w500
                    ),
                  )),
                ),
              ),
              const SizedBox(height: 12.0,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:  const Center(child: Text('No, I’ll give FerPro another try',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,fontWeight: FontWeight.w400
                    ),
                  )
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
