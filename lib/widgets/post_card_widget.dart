// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/utils/time_ago_formatter.dart';
import '../models/meal_data.dart';
import '../models/user_data.dart';
import '../providers/comments_provider.dart';
import '../providers/post_provider.dart';
import '../providers/saved_post_provider.dart';
import '../providers/supabase_instance_provider.dart';
import '../providers/user_provider.dart';
import '../screens/home_pages/edit_post_screen.dart';
import '../screens/home_pages/post_detail_screen.dart';
import '../services/post_service.dart';
import '../utils/toast.dart';
import 'commnt_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCardWidget extends ConsumerStatefulWidget {
  final Post post;
  final UserData user;
  
  const PostCardWidget( {super.key, required this.post, required this.user});

  @override
  ConsumerState<PostCardWidget> createState() => _MealPostCardState();
}

class _MealPostCardState extends ConsumerState<PostCardWidget> {
  bool isLiked = false;
  bool isSaved = false;
  final PostService postService = PostService();
  late final String userId;

@override
void initState() {
  super.initState();
  userId = ref.read(userProvider).asData!.value.id;
  _checkIfLiked();
}


 

  // Check if post is liked
  Future<void> _checkIfLiked() async {
    if (widget.post.id != null) {
      final supabase = ref.read(supabaseProvider);
      
      try {
        final existingLike = await supabase
            .from('likes')
            .select()
            .eq('post_id', widget.post.id!)
            .eq('user_id', userId)
            .maybeSingle();
        
        if (existingLike != null && mounted) {
          setState(() {
            isLiked = true;
          });
        }
      } catch (e) {
        if (mounted) {
          showToast(context: context, message: "Error checking like status: $e");
        }
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // Check if this post belongs to current user
    final currentUser = ref.watch(userProvider).asData!.value;
    final savedPostIds = ref.watch(savedPostsProvider(userId));

    final isSaved = savedPostIds.contains(widget.post.id);
    final isOwner = currentUser.id == widget.post.userId;
    final theme = Theme.of(context);
    // Format date (assuming post has a createdAt field, if not add it)
    final createdAt = timeAgo(context, DateTime.parse(widget.post.createdAt.toString()));
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: widget.post,userId:currentUser.id)
          )
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and post header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: widget.user.userAvatarPath.isNotEmpty
                        ? NetworkImage(widget.user.userAvatarPath)
                        : null,
                    child: widget.user.userAvatarPath.isEmpty
                        ? Icon(Icons.person, color: Colors.grey.shade700)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // User name and post time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name ,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          createdAt!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Post options menu (if owner)
                  if (isOwner)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToEditScreen(context, ref, widget.post);
                        } else if (value == 'delete') {
                          _confirmDelete(context, ref, widget.post.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete', 
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Post title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                widget.post.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Recipe image
            if (widget.post.imageUrl.isNotEmpty)
              Stack(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: Image.network(
                      widget.post.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.image_not_supported, 
                          size: 50, 
                          color: Colors.grey.shade500
                        ),
                      ),
                    ),
                  ),
                  // Complexity and affordability badges
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.post.complexity,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.post.affordability,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.duration} min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            
            // Cuisine type and info row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuisine type
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${AppLocalizations.of(context)!.generalReviews} ${widget.post.cuisine}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(Icons.thumb_up, '${widget.post.likeCount} likes', isLiked ? theme.colorScheme.primary : Colors.grey),
                      _buildStatItem(Icons.comment, '${widget.post.commentCount} comments', Colors.grey),
                      _buildStatItem(Icons.saved_search, '${widget.post.savedCount.toString()} saved', Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tags
            if (widget.post.tags != null && widget.post.tags!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.post.tags!.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 12,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            
            // Divider
            Divider(color: Colors.grey.shade300, height: 1),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    label: 'Like',
                    color: isLiked ? theme.colorScheme.primary : null,
                    onPressed: () async {
                      await postService.toggleLike(widget.post.id!, userId, isComment: false);
                      setState(() {
                        isLiked = !isLiked;
                        // Update like count optimistically
                        if (isLiked) {
                          widget.post.likeCount = (widget.post.likeCount) + 1;
                        } else {
                          widget.post.likeCount = (widget.post.likeCount) ;
                        }
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: 'Comment',
                    onPressed: () {
                      final postId = widget.post.id!;
                      // Trigger fetch manually before showing the sheet
                      ref.read(postProvider.notifier).fetchComments(postId);
                      
                      // Show comments sheet
                      CommentsSheet.show(
                        context,
                        postId,
                        (commentText) async {
                          await ref.read(postProvider.notifier).addComment(
                            postId, 
                            currentUser.id, 
                            commentText
                          );
                        },
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Save',
                    color: isSaved ? theme.colorScheme.primary : null,
                    onPressed: () async {
                      debugPrint('🔍 userId in the post card : $userId');

                      ref.read(savedPostsProvider(userId).notifier).toggleSave(context, widget.post.id!);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onPressed: () {
                      // Implement share functionality
                      showToast(context: context, message: 'Sharing feature coming soon!');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color ?? Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, WidgetRef ref, Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditMealPostScreen(post: post),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(mealPostsProvider.notifier).deletePost(postId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe deleted successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}