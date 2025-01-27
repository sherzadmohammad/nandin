import 'package:flutter/material.dart';
class DeleteChatDialog extends StatelessWidget {
  const DeleteChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 32.0),
          title: const Center(
            child: Text('Delete Chat',
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Delete this chat permanently?',
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop('Cancel');
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
                              fontSize: 11,fontWeight: FontWeight.w500
                          ),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0 ,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop('Delete');
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child:  const Center(child: Text('Delete',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,fontWeight: FontWeight.w500
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
        ),
      ),
    );
  }
}
