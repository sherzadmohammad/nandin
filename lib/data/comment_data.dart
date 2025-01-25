class Comment {
  final String commentId;
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  // Convert a Comment object to a Map
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'username': username,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a Comment object from a Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      userId: map['userId'],
      username: map['username'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
