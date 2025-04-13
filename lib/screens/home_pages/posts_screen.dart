
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/post_provider.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/home_pages/edit_post_screen.dart';
import '../../providers/post_with_user_provider.dart';
import '../../widgets/post_card_widget.dart';

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
    final postsWithUserAsync = ref.watch(postsWithUserProvider);
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
      body: postsWithUserAsync.when(
  data: (postsWithUser) {
    if (postsWithUser.isEmpty) {
      return const Center(child: Text('No recipes yet. Create your first recipe!'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        // Invalidate and re-fetch the provider manually
        await ref.refresh(postsWithUserProvider.future);
      },

      child: ListView.builder(
        itemCount: postsWithUser.length,
        itemBuilder: (context, index) {
          final item = postsWithUser[index];
          return PostCardWidget(post: item.post, user: item.user);
        },
      ),
    );
  },
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (e, _) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Error: $e'),
        ElevatedButton(
          onPressed: () => ref.refresh(postsWithUserProvider),
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
