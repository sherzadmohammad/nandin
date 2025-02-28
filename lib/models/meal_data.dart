
import 'package:flutter/material.dart';
enum Complexity{
  simple,
  challenging,
  hard
}
enum Affordability{
  affordable,
  pricey,
  luxurious
}
class Meal{
   Meal({
    required this.id,
    required this. categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian
   });
  final String id;
  final List<String>categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  var color=Colors.white;
}

class Post {
  final String? id;
  final String userId;
  final String title;
  final String imageUrl;
  final String? videoUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final String complexity;
  final String affordability;
  final int likeCount;
  final int commentCount;
  final List<String> savedBy;
  final String cuisine;
  final DateTime timestamp;
  final bool isPublic;
  final List<String>? tags; // Will be fetched separately from the tags table

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.imageUrl,
    this.videoUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.likeCount,
    required this.commentCount,
    required this.savedBy,
    required this.cuisine,
    required this.timestamp,
    required this.isPublic,
    this.tags,
  });

  // Create Post from Supabase JSON response
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      duration: json['duration'],
      complexity: json['complexity'],
      affordability: json['affordability'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      savedBy: List<String>.from(json['saved_by'] ?? []),
      cuisine: json['cuisine'],
      timestamp: DateTime.parse(json['timestamp']),
      isPublic: json['is_public'] ?? true,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  // Convert Post to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'ingredients': ingredients,
      'steps': steps,
      'duration': duration,
      'complexity': complexity,
      'affordability': affordability,
      'like_count': likeCount,
      'comment_count': commentCount,
      'saved_by': savedBy,
      'cuisine': cuisine,
      'timestamp': timestamp.toIso8601String(),
      'is_public': isPublic,
      // Note: tags are handled separately through the post_tags table
    };
  }

  // Create a copy of this Post with the given fields replaced with the new values
  Post copyWith({
    String? id,
    String? userId,
    String? title,
    String? imageUrl,
    String? videoUrl,
    List<String>? ingredients,
    List<String>? steps,
    int? duration,
    String? complexity,
    String? affordability,
    int? likeCount,
    int? commentCount,
    List<String>? savedBy,
    String? cuisine,
    DateTime? timestamp,
    bool? isPublic,
    List<String>? tags,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      duration: duration ?? this.duration,
      complexity: complexity ?? this.complexity,
      affordability: affordability ?? this.affordability,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      savedBy: savedBy ?? this.savedBy,
      cuisine: cuisine ?? this.cuisine,
      timestamp: timestamp ?? this.timestamp,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
    );
  }
}