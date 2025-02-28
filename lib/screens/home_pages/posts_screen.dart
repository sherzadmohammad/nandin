
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/models/meal_data.dart';
import 'package:nanden/providers/post_provider.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/home_pages/edit_post_screen.dart';


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

class MealPostCard extends ConsumerWidget {
  final Post post;
  
  const MealPostCard({super.key, required this.post});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this post belongs to current user
    final currentUser = ref.watch(userProvider).asData?.value;
    final isOwner = currentUser != null && currentUser.id == post.userId;
    
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
          if (post.imageUrl.isNotEmpty)
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
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
                        label: Text(post.complexity),
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: Text(post.affordability),
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
              post.title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Cuisine: ${post.cuisine} • ${post.duration} min'),
            trailing: isOwner ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _navigateToEditScreen(context, ref, post);
                } else if (value == 'delete') {
                  //_confirmDelete(context, ref, post.id);
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
                _buildInfoItem(Icons.timer, '${post.duration} min'),
                _buildInfoItem(Icons.thumb_up, '${post.likeCount} likes'),
                _buildInfoItem(Icons.comment, '${post.commentCount} comments'),
              ],
            ),
          ),
          
          // Tags
          if (post.tags != null && post.tags!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: post.tags!.map((tag) => Chip(
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
                icon: const Icon(Icons.thumb_up_outlined),
                label: const Text('Like'),
                onPressed: () {
                  // Like functionality
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment_outlined),
                label: const Text('Comment'),
                onPressed: () {
                  // Comment functionality
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Save'),
                onPressed: () {
                  // Save functionality
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

