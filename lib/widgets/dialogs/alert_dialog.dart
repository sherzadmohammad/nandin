import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowBottomSheetDialog extends StatelessWidget {
  const ShowBottomSheetDialog({super.key, required this.onRemoveImage});
  final VoidCallback onRemoveImage;
  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(context.mounted) {
      Navigator.pop(context, pickedImage);
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(context.mounted) {
      Navigator.pop(context, pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 35.0, 16.0, 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            style:  ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.black)
            ),
            icon: const Icon(Icons.image_outlined),
            onPressed: () async {
              await _pickImageFromGallery(context);
            },
            label: Text(AppLocalizations.of(context)!.bottomSheet_library
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style:  ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black)
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () async {
              await _pickImageFromCamera(context);
            },
            label:  Text(AppLocalizations.of(context)!.bottomSheet_camera
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style:  ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.redAccent)
            ),
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              onRemoveImage();
              Navigator.of(context).pop();
            },
            label: Text(AppLocalizations.of(context)!.bottomSheet_removePhoto
            ),
          ),
        ],
      ),
    );
  }
}
