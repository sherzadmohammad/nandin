import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanden/models/comment_data.dart';
import '../services/post_service.dart';

class CommentsNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  final PostService _postService;

  CommentsNotifier(this._postService) : super(const AsyncValue.loading());

  // Fetch comments for a specific post
  Future<void> fetchComments(String postId) async {
    try {
      final commentsData = await _postService.getComments(postId);
      final comments = commentsData.map((data) {
        final user = data['users'];
        return Comment(
          id: data['id']?.toString(),
          authorName: user?['name'] ?? 'Unknown',
          authorAvatar: user?['user_avatar_path'] ?? '',
          content: data['content'] ?? '',
          timeAgo: data['created_at'] ?? '',
        );
      }).toList();

      state = AsyncValue.data(comments);
    } catch (e,trace) {
      state = AsyncValue.error(e,trace);
    }
  }

  // Add comment and update state
  Future<void> addComment(String postId, String userId, String text) async {
    try {
      await _postService.addComment(postId, userId, text);

      // After adding the comment, fetch updated comments list
      await fetchComments(postId); // Automatically updates the UI
    } catch (e,trace) {
      state = AsyncValue.error(e,trace);
    }
  }
}


final postServiceProvider = Provider((ref) {
  return PostService();
});

final postProvider = StateNotifierProvider<CommentsNotifier, AsyncValue<List<Comment>>>((ref) {
  final postService = ref.read(postServiceProvider);
  return CommentsNotifier(postService);
});

