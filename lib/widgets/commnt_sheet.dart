// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/supabase_instance_provider.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/services/post_service.dart';
import 'package:nanden/utils/time_ago_formatter.dart';
import 'package:nanden/utils/toast.dart';
import 'package:nanden/widgets/profile_image_widget.dart';
import '../models/comment_data.dart';
import '../providers/comments_provider.dart';


class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;
  final Future<void> Function(String) onAddComment;

  const CommentsSheet({
    super.key,
    required this.postId,
    required this.onAddComment,
  });

  static void show(
    BuildContext context,
    String postId,
    Future<void> Function(String) onAddComment,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        postId: postId,
        onAddComment: onAddComment,
      ),
    );
  }

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}


class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  var  user;
  bool _isLoading = false;
  @override
  void initState() {
    user=ref.read(userProvider.notifier).currentUser;
    super.initState();
  }
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
  if (_commentController.text.trim().isEmpty) return;

  setState(() {
    _isLoading = true;
  });

  try {
    await widget.onAddComment(_commentController.text);

    // Clear the input field only after the comment is added
    _commentController.clear();
    if (mounted) {
      setState(() {});  // This will trigger a rebuild
    }
  } catch (e) {
    if(kDebugMode){
      print('Failed to add comment: $e');
    }
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postProvider);

    return DraggableScrollableSheet(
    initialChildSize: 0.75,
    minChildSize: 0.5,
    maxChildSize: 0.95,
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${commentsAsync.asData?.value.length ?? 0})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Comments list
            Expanded(
              child: commentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
                data: (comments) {
                  if (comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No comments yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                          const SizedBox(height: 8),
                          Text('Be the first to leave a comment!', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentItem(comment: comment);
                    },
                  );
                },
              ),
            ),

            // Comment input
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ProfileImageWidget(
                    imageUrl: user.userAvatarPath,
                    size: 30.0,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    color: Theme.of(context).primaryColor,
                    onPressed: _isLoading ? null : _submitComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  }
}

class CommentItem extends ConsumerStatefulWidget {
  final Comment comment;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
  });

  @override
  ConsumerState<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  bool isLiked = false;



  String userId = "user_id";
  @override
void initState() {
  super.initState(); // Call super.initState() first
  
  // Get the user ID
  userId = ref.read(userProvider).asData!.value.id;
  
  // Call the function to check if the post is liked
  _checkIfLiked();
}

// Separate async function to check if post is liked
Future<void> _checkIfLiked() async {
  if (widget.comment.id != null) {
    final supabase = ref.read(supabaseProvider);
    
    try {
      final existingLike = await supabase
          .from('likes')
          .select()
          .eq('post_id', widget.comment.id!)
          .eq('user_id', userId)
          .maybeSingle();
      
      // Update state if the post is liked
      if (existingLike != null) {
        setState(() {
          isLiked = true;
        });
      }
    } catch (e) {
      // Handle any potential errors
      if(mounted){
      showToast(context: context, message: "Error checking like status: $e");
      }
    }
  } else {
    showToast(context: context, message: "Post ID is null");
  }
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isReply ? 48 : 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageWidget(
                imageUrl: widget.comment.authorAvatar,
                size: 30.0,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.comment.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Text(timeAgo(context,DateTime.parse(widget.comment.timeAgo))!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(widget.comment.content),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final postService= PostService();
                            await postService.toggleLike(widget.comment.id!, userId,isComment: true);
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                  color: isLiked ? Colors.blue : null,size: 15.0,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.comment.likes > 0 ? widget.comment.likes.toString() : 'Like',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Render replies if any
          if (widget.comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 28),
              child: Column(
                children: widget.comment.replies
                    .map((reply) => CommentItem(
                          comment: reply,
                          isReply: true,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}