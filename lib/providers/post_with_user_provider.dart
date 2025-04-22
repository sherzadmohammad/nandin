

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/meal_data.dart';
import '../models/user_data.dart';
import 'comments_provider.dart';

class PostWithUser {
  final Post post;
  final UserData user;

  PostWithUser({required this.post, required this.user});
}
final searchTagProvider = StateProvider<String>((ref) => '');

final searchPostsWithUserProvider = FutureProvider.autoDispose<List<PostWithUser>>((ref) async {
  
  final keyword = ref.watch(searchTagProvider);
  if (keyword.isEmpty) return [];

  final postService = ref.watch(postServiceProvider);
  final supabase = Supabase.instance.client;

  try {
    // Step 1: Find tag IDs
    final tagResponse = await supabase
        .from('tags')
        .select('id')
        .ilike('name', '%$keyword%');

    final tagIds = (tagResponse as List).map((e) => e['id'] as String).toList();
    if (tagIds.isEmpty) return [];

    // Step 2: Get post IDs
    final postTagsResponse = await supabase
        .from('post_tags')
        .select('post_id')
        .inFilter('tag_id', tagIds);

    final postIds = (postTagsResponse as List).map((e) => e['post_id'] as String).toSet().toList();
    if (postIds.isEmpty) return [];

    // Step 3: Fetch posts
    final posts = await postService.getPostsByIds(postIds);

    // Step 4: Attach user info
    final Map<String, UserData> userCache = {};
    final List<PostWithUser> result = [];

    for (final post in posts) {
      final userId = post.userId;
      UserData? user;

      if (userCache.containsKey(userId)) {
        user = userCache[userId];
      } else {
        user = await postService.getUserById(userId);
        if (user != null) userCache[userId] = user;
      }

      if (user != null) {
        result.add(PostWithUser(post: post, user: user));
      }
    }

    return result;
  } catch (e, stackTrace) {
    print('Error in searchPostsWithUserProvider: $e');
    print(stackTrace);
    throw Exception('Failed to search posts by tag.');
  }
});



final postsWithUserProvider = FutureProvider.autoDispose<List<PostWithUser>>((ref) async {
  final postService = ref.watch(postServiceProvider);
  final List<Post> posts = await postService.getAllPosts();

  // Cache to avoid refetching the same user
  final Map<String, UserData> userCache = {};
  final List<PostWithUser> result = [];

  for (final post in posts) {
    final String userId = post.userId;

    UserData? user;

    if (userCache.containsKey(userId)) {
      user = userCache[userId];
    } else {
      user = await postService.getUserById(userId); // 👈 userId is String here
      if (user != null) {
        userCache[userId] = user;
      }
    }

    if (user != null) {
      result.add(PostWithUser(post: post, user: user));
    }
  }

  return result;
});