import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/models/meal_data.dart';
import 'package:nanden/services/post_service.dart';

// Provider for the PostService
final postServiceProvider = Provider<PostService>((ref) {
  return PostService();
});

// Provider for meal post state management
class MealPostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostService _postService;

  MealPostsNotifier(this._postService) 
      : super(const AsyncValue.loading());

  // Fetch all meal posts
  Future<void> fetchAllPosts({int limit = 10, int offset = 0}) async {
    try {
      state = const AsyncValue.loading();
      final posts = await _postService.getAllPosts(limit: limit, offset: offset);
      
      if (kDebugMode) {
        print("Successfully fetched ${posts.length} meal posts");
      }
      
      state = AsyncValue.data(posts);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error fetching meal posts: $e");
      }
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Fetch meal posts by tag
  Future<void> fetchPostsByTag(String tagName, {int limit = 10, int offset = 0}) async {
    try {
      state = const AsyncValue.loading();
      final posts = await _postService.getPostsByTag(tagName, limit: limit, offset: offset);
      
      if (kDebugMode) {
        print("Successfully fetched ${posts.length} meal posts with tag: $tagName");
      }
      
      state = AsyncValue.data(posts);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error fetching meal posts by tag: $e");
      }
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Create a new meal post
  Future<Post?> createPost(Post post, List<String> tags) async {
    try {
      final createdPost = await _postService.createPost(post, tags);
      print("successfully created the post$createdPost");
      // Refresh the posts list
      await fetchAllPosts();
      
      if (kDebugMode) {
        print("Successfully created meal post with ID: ${createdPost.id}");
      }
      
      return createdPost;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating meal post: $e");
      }
      return null;
    }
  }

  // Update an existing meal post
  Future<Post?> updatePost(Post post, List<String> tags) async {
    try {
      final updatedPost = await _postService.updatePost(post, tags);
      
      // Refresh the posts list
      await fetchAllPosts();
      
      if (kDebugMode) {
        print("Successfully updated meal post with ID: ${updatedPost.id}");
      }
      
      return updatedPost;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating meal post: $e");
      }
      return null;
    }
  }

  // Delete a meal post
  Future<bool> deletePost(String postId) async {
    try {
      await _postService.deletePost(postId);
      
      // Refresh the posts list
      await fetchAllPosts();
      
      if (kDebugMode) {
        print("Successfully deleted meal post with ID: $postId");
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting meal post: $e");
      }
      return false;
    }
  }

  // A read-only getter for accessing the current meal posts
  List<Post>? get posts => state.asData?.value;
}

// Provider for the MealPostsNotifier
final mealPostsProvider = StateNotifierProvider<MealPostsNotifier, AsyncValue<List<Post>>>((ref) {
  final postService = ref.watch(postServiceProvider);
  return MealPostsNotifier(postService);
});

// Provider for a single meal post by ID
final mealPostByIdProvider = FutureProvider.family.autoDispose<Post?, String>((ref, postId) async {
  final postService = ref.watch(postServiceProvider);
  try {
    return await postService.getPostById(postId);
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching meal post by ID: $e");
    }
    return null;
  }
});