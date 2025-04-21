import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_data.dart';
import '../models/user_data.dart';
import 'post_provider.dart';

class PostWithUser {
  final Post post;
  final UserData user;

  PostWithUser({required this.post, required this.user});
}

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
