import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/post_service.dart';
import 'comments_provider.dart';
import 'post_with_user_provider.dart';

class SavedPostsNotifier extends StateNotifier<Set<String>> {
  final PostService _postService;
  final String userId;

  SavedPostsNotifier(this._postService, this.userId) : super({}) {
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    final savedPostIds = await _postService.getSavedPostIds(userId);
    state = savedPostIds.toSet();
  }

  bool isSaved(String postId) => state.contains(postId);

  Future<void> toggleSave(BuildContext context, String postId) async {
    await _postService.toggleSavePost(context,postId, userId);
    if (state.contains(postId)) {
      state = {...state}..remove(postId);
    } else {
      state = {...state}..add(postId);
    }
  }
}
final savedPostsProvider = StateNotifierProvider.family<SavedPostsNotifier, Set<String>, String>((ref, userId) {
  final postService = ref.watch(postServiceProvider);
  return SavedPostsNotifier(postService, userId);
});

final savedPostsWithUserProvider = Provider.family<List<PostWithUser>, String>((ref, userId) {
  final savedIds = ref.watch(savedPostsProvider(userId));
  final allPosts = ref.watch(postsWithUserProvider).maybeWhen(
    data: (posts) => posts,
    orElse: () => <PostWithUser>[],
  );

  return allPosts.where((post) => savedIds.contains(post.post.id)).toList();
});


