import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Optionally set initial tag filter
    Future.microtask(() {
      _searchController.text = '';
      ref.read(searchTagProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce to avoid spamming the provider
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchTagProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsWithUserAsync = ref.watch(searchPostsWithUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Posts'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by tag...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: postsWithUserAsync.when(
        data: (postsWithUser) {
          if (postsWithUser.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(searchPostsWithUserProvider);
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
                onPressed: () => ref.invalidate(searchPostsWithUserProvider),
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
