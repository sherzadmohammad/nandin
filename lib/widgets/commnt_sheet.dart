// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/utils/time_ago_formatter.dart';
import 'package:nanden/widgets/profile_image_widget.dart';

class Comment {
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int likes;
  final List<Comment> replies;

  Comment({
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.replies = const [],
  });
}

class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;
  final List<Comment> comments;
  final Function(String) onAddComment;

  const CommentsSheet({
    super.key,
    required this.postId,
    required this.comments,
    required this.onAddComment,
  });

  static void show(BuildContext context, String postId, List<Comment> comments, Function(String) onAddComment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        postId: postId,
        comments: comments,
        onAddComment: onAddComment,
      ),
    );
  }

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  var user;
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
                          'Comments (${widget.comments.length})',
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
                child: widget.comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to leave a comment!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: widget.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.comments[index];
                          return CommentItem(comment: comment);
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

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 48 : 16,
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
              CircleAvatar(
                radius: 16,
                backgroundImage: comment.authorAvatar.isNotEmpty
                    ? NetworkImage(comment.authorAvatar)
                    : null,
                child: comment.authorAvatar.isEmpty
                    ? Text(comment.authorName[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Text(timeAgo(context,DateTime.parse(comment.timeAgo) )!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(comment.content),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  comment.likes > 0 ? comment.likes.toString() : 'Like',
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
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 28),
              child: Column(
                children: comment.replies
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