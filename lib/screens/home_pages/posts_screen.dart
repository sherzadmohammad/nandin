
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/models/meal_data.dart';
import 'package:nanden/providers/post_provider.dart';
import 'package:nanden/providers/supabase_instance_provider.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/home_pages/edit_post_screen.dart';
import 'package:nanden/services/post_service.dart';
import 'package:nanden/utils/toast.dart';
import 'package:nanden/widgets/commnt_sheet.dart';
import 'package:nanden/widgets/dialogs/add_comment_dialog.dart';

class MealPostsScreen extends ConsumerStatefulWidget {
  const MealPostsScreen({super.key});

  @override
  ConsumerState<MealPostsScreen> createState() => _MealPostsScreenState();
}

class _MealPostsScreenState extends ConsumerState<MealPostsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch meal posts when the screen loads
    Future.microtask(() => ref.read(mealPostsProvider.notifier).fetchAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    // Watch the meal posts state
    final postsAsync = ref.watch(mealPostsProvider);
    // Watch the user state
    final userAsync = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Feed'),
        actions: [
          // Show username in app bar if available
          userAsync.when(
            data: (userData) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(userData.name)),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No recipes yet. Create your first recipe!'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(mealPostsProvider.notifier).fetchAllPosts(),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return MealPostCard(post: post);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.read(mealPostsProvider.notifier).fetchAllPosts(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipeDialog(context),
        tooltip: 'Add New Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context) {
    // Check if user is logged in first
    final user = ref.read(userProvider).asData?.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to create a recipe')),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEditMealPostScreen()),
    );
  }
}

class MealPostCard extends ConsumerStatefulWidget {
  final Post post;
  
  const MealPostCard({super.key, required this.post});

  @override
  ConsumerState<MealPostCard> createState() => _MealPostCardState();
}

class _MealPostCardState extends ConsumerState<MealPostCard> {
 bool isLiked = false;
bool isSaved = false;
final PostService postService = PostService();
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
  if (widget.post.id != null) {
    final supabase = ref.read(supabaseProvider);
    
    try {
      final existingLike = await supabase
          .from('likes')
          .select()
          .eq('post_id', widget.post.id!)
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
    // Check if this post belongs to current user
    final currentUser = ref.watch(userProvider).asData!.value;
    final isOwner = currentUser.id == widget.post.userId;
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image
          if (widget.post.imageUrl.isNotEmpty)
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                  ),
                ),
                // Complexity and affordability chips
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Chip(
                        label: Text(widget.post.complexity),
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: Text(widget.post.affordability),
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          
          // Recipe header with title
          ListTile(
            title: Text(
              widget.post.title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Cuisine: ${widget.post.cuisine} • ${widget.post.duration} min'),
            trailing: isOwner ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _navigateToEditScreen(context, ref, widget.post);
                } else if (value == 'delete') {
                  _confirmDelete(context, ref, widget.post.id!);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ) : null,
          ),
          
          // Quick info row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildInfoItem(Icons.timer, '${widget.post.duration} min'),
                _buildInfoItem(Icons.thumb_up, '${widget.post.likeCount + (isLiked ? 1 : 0)} likes'),
                _buildInfoItem(Icons.comment, '${widget.post.commentCount} comments'),
              ],
            ),
          ),
          
          // Tags
          if (widget.post.tags != null && widget.post.tags!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.post.tags!.map((tag) => Chip(
                  label: Text(tag),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            ),
          
          // Action buttons
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: isLiked ? Colors.blue : null),
                label: Text('Like'),
                onPressed: () async {
                  await postService.toggleLikePost(widget.post.id!, userId);
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment_outlined),
                label: Text('${widget.post.commentCount} Comments'),
                onPressed: () async {
                  final postId = widget.post.id!;

                  try {
                    final commentData = await postService.getComments(postId);

                    final comments = commentData.map((data) {
                      return Comment(
                        authorName: data['users']['username'],
                        authorAvatar: data['users']['avatar_url'],
                        content: data['content'],
                        timeAgo: data['created_at'],
                      );
                    }).toList();
                    if(context.mounted){
                      CommentsSheet.show(
                        context,
                        postId,
                        comments,
                        (commentText) async {
                          await postService.addComment(postId, currentUser.id, commentText);
                          
                          // Fetch updated comments
                          final updatedCommentData = await postService.getComments(postId);

                          final updatedComments = updatedCommentData.map((data) {
                            return Comment(
                              authorName: data['users']['user'],
                              authorAvatar: data['users']['profile_photo_path'],
                              content: data['comment'],
                              timeAgo: data['created_at'],
                            );
                          }).toList();

                          // Reopen the comments sheet with the updated comments
                          if(context.mounted){
                            Navigator.pop(context); // Close the current sheet
                            CommentsSheet.show(context, postId, updatedComments, (newText) async {
                              await postService.addComment(postId, currentUser.id, newText);
                            });
                          }
                        }
                      );
                    }
                  } catch (e) {
                    if(kDebugMode){
                     print('Error fetching comments: $e');
                    }
                  }
                },

              ),
              TextButton.icon(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? Colors.orange : null),
                label: const Text('Save'),
                onPressed: () async {
                  await postService.toggleSavePost(widget.post.id!, userId);
                  setState(() {
                    isSaved = !isSaved;
                  });
                },
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
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

