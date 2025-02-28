import 'package:flutter/foundation.dart';
import 'package:nanden/models/meal_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  final SupabaseClient _supabase;
  PostService() : _supabase = Supabase.instance.client;
  // Create a new post with tags
  Future<Post> createPost(Post post, List<String> tagNames) async {
    // Start a transaction
    try {
      // 1. Insert the post
      final postResponse = await _supabase.from('posts').insert(post.toJson()).select().single();
      if(postResponse.isEmpty){
        if(kDebugMode){
          print("Failed to select the inserted post");
        }
      }
      final createdPost = Post.fromJson(postResponse);
      if (createdPost.id == null) {
        throw Exception("Error: Created post ID is null!");
      }
      // 2. Process tags
      await _handleTags(createdPost.id!, tagNames);

      // 3. Fetch the complete post with tags
      return await getPostById(createdPost.id!);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
  // Get post by ID with its tags
  Future<Post> getPostById(String postId) async {
    try {
      // 1. Get the post
      final response = await _supabase
          .from('posts')
          .select()
          .eq('id', postId)
          .single();
      // 2. Get the tags for this post
      final tags = await _getTagsForPost(postId);
      // 3. Create the post with tags
      final post = Post.fromJson(response);
      return post.copyWith(tags: tags);
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }
  // Get all posts with their tags
  Future<List<Post>> getAllPosts({int limit = 10, int offset = 0}) async {
    try {
      // 1. Get posts
      final response = await _supabase
          .from('posts')
          .select()
          .eq('is_public', true)
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      // 2. Create post objects
      final posts = response.map((json) => Post.fromJson(json)).toList();
      // 3. Get tags for each post
      for (var i = 0; i < posts.length; i++) {
        final tags = await _getTagsForPost(posts[i].id!);
        posts[i] = posts[i].copyWith(tags: tags);
      }
      return posts;
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }
  // Update post with tags
  Future<Post> updatePost(Post post, List<String> tagNames) async {
    try {
      // 1. Update the post
      await _supabase
          .from('posts')
          .update(post.toJson())
          .eq('id', post.id!);
      // 2. Handle tags (this will delete existing tags and add new ones)
      await _handleTags(post.id!, tagNames);
      // 3. Return the updated post
      return await getPostById(post.id!);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }
  // Delete post and all associated data
  Future<void> deletePost(String postId) async {
    try {
      // Just delete the post - cascade will handle the rest
      await _supabase.from('posts').delete().eq('id', postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
  // Get posts by tag
  Future<List<Post>> getPostsByTag(String tagName, {int limit = 10, int offset = 0}) async {
    try {
      // Get posts by tag using a join
      final response = await _supabase
          .from('post_tags')
          .select('post_id')
          .eq('tag_id', await _getTagIdByName(tagName))
          .range(offset, offset + limit - 1);
      final postIds = response.map((item) => item['post_id'] as String).toList();
      // Return empty list if no posts found
      if (postIds.isEmpty) return [];
      // Get all the posts
      final postsResponse = await _supabase
          .from('posts')
          .select()
          .inFilter('id', postIds)
          .order('timestamp', ascending: false);
      // Create post objects
      final posts = postsResponse.map((json) => Post.fromJson(json)).toList();
      // Get tags for each post
      for (var i = 0; i < posts.length; i++) {
        final tags = await _getTagsForPost(posts[i].id!);
        posts[i] = posts[i].copyWith(tags: tags);
      }
      return posts;
    } catch (e) {
      throw Exception('Failed to get posts by tag: $e');
    }
  }
  
  // Private helper methods
  // Get all tags for a post
  Future<List<String>> _getTagsForPost(String postId) async {
    // Get tag IDs for the post
    final postTagsResponse = await _supabase
        .from('post_tags')
        .select('tag_id')
        .eq('post_id', postId);

    final tagIds = postTagsResponse.map<String>((item) => item['tag_id'] as String).toList();

    // If there are no tags, return an empty list
    if (tagIds.isEmpty) return [];

    // Get tag names using the retrieved tag IDs
    final tagsResponse = await _supabase
        .from('tags')
        .select('name')
        .inFilter('id', tagIds);

    return tagsResponse.map<String>((tag) => tag['name'] as String).toList();
}

  // Get or create tag by name
  Future<String> _getOrCreateTag(String tagName) async {
    // Normalize tag name
    final normalizedTag = tagName.trim().toLowerCase();
    // Try to get existing tag
    final existing = await _supabase
        .from('tags')
        .select()
        .eq('name', normalizedTag)
        .maybeSingle();
    if (existing != null) {
      return existing['id'];
    }
    // Create new tag
    final created = await _supabase
        .from('tags')
        .insert({'name': normalizedTag})
        .select()
        .single();
    return created['id'];
  }
  // Get tag ID by name
  Future<String> _getTagIdByName(String tagName) async {
    final response = await _supabase
        .from('tags')
        .select('id')
        .eq('name', tagName.trim().toLowerCase())
        .single();
    return response['id'];
  }
  // Handle tags for a post (delete existing and add new)
  Future<void> _handleTags(String postId, List<String> tagNames) async {
    // 1. Delete existing tags
    await _supabase
        .from('post_tags')
        .delete()
        .eq('post_id', postId);
    // 2. Add new tags
    for (var tagName in tagNames) {
      final tagId = await _getOrCreateTag(tagName);
      await _supabase.from('post_tags').insert({
        'post_id': postId,
        'tag_id': tagId
      });
    }
  }
}