class Comment {
  final String? id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int likes;
  final List<Comment> replies;

  Comment({
    this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.replies = const [],
  });

  // fromJson method to create a Comment from the response data
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString(), // Safely convert to String, assuming id is nullable
      authorName: json['users']?['name'] ?? 'Unknown', // Handle nulls and nested data
      authorAvatar: json['users']?['user_avatar_path'] ?? '',
      content: json['content'] ?? '',
      timeAgo: json['created_at'] ?? '',
      likes: json['likes'] ?? 0, // Adjust as per your table structure
      // Assuming replies are not part of the direct comment data; you can handle them as needed
      replies: [], // Modify this if replies come from the database as a separate field
    );
  }
}
