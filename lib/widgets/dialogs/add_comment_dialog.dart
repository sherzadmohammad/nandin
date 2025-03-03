import 'package:flutter/material.dart';

class AddCommentDialog extends StatelessWidget {
  final String postId;
  final String userId;
  final Function(String, String, String) addComment;

  const AddCommentDialog({
    super.key,
    required this.postId,
    required this.userId,
    required this.addComment,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.comment, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          const Text('Add Your Comment'),
        ],
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "Share your thoughts...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Comment cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Your comment will be visible to everyone",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('Post Comment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              try {
                await addComment(
                  postId, 
                  userId, 
                  commentController.text.trim()
                );
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comment added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add comment: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
    );
  }
}