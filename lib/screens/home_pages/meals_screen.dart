import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/widgets/post_card_widget.dart';

import '../../providers/saved_post_provider.dart';


class SavedPostsScreen extends ConsumerWidget {
  final String userId;

  const SavedPostsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPosts = ref.watch(savedPostsWithUserProvider(userId));

    if (savedPosts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved Posts')),
        body: const Center(child: Text("No saved posts yet")),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Posts')),
      body: ListView.builder(
        itemCount: savedPosts.length,
        itemBuilder: (context, index) {
          final postWithUser = savedPosts[index];
          return PostCardWidget(post: postWithUser.post, user: postWithUser.user);
        },
      ),
    );
  }
}
