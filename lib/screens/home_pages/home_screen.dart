import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/providers/user_provider.dart';
import 'package:nanden/screens/home_pages/edit_post_screen.dart';
import '../../providers/post_with_user_provider.dart';
import '../../widgets/post_card_widget.dart';

class AllPostsScreen extends ConsumerWidget {
  const AllPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsWithUserAsync = ref.watch(postsWithUserProvider); // Unfiltered provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
        centerTitle: true,
      ),
      body: postsWithUserAsync.when(
        data: (postsWithUser) {
          if (postsWithUser.isEmpty) {
            return const Center(child: Text('No public posts available.'));
          }
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(postsWithUserProvider);
              },
              child: ListView.builder(
                itemCount: postsWithUser.length,
                itemBuilder: (context, index) {
                  final item = postsWithUser[index];
                  return PostCardWidget(post: item.post, user: item.user);
                },
              ),
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
                onPressed: () => ref.invalidate(postsWithUserProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipeDialog(context, ref),
        tooltip: 'Add New Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context, WidgetRef ref) {
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
