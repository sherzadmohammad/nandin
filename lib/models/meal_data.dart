import 'dart:convert';

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
  final String id;
  final String title;
  final String imageUrl;
  final String? videoUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final String complexity;
  final String affordability;
  final String userId;
  final int likeCount;
  final int commentCount;
  final List<String> savedBy;
  final List<String> tags;
  final String cuisine;
  final DateTime timestamp;
  final bool isPublic;

  Post({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.videoUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.userId,
    required this.likeCount,
    required this.commentCount,
    required this.savedBy,
    required this.tags,
    required this.cuisine,
    required this.timestamp,
    required this.isPublic,
  });

  /// Convert Post object to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'ingredients': jsonEncode(ingredients), // Convert list to JSON string
      'steps': jsonEncode(steps),
      'duration': duration,
      'complexity': complexity,
      'affordability': affordability,
      'user_id': userId,
      'like_count': likeCount,
      'comment_count': commentCount,
      'saved_by': jsonEncode(savedBy), // Convert list to JSON string
      'tags': jsonEncode(tags),
      'cuisine': cuisine,
      'timestamp': timestamp.toIso8601String(),
      'is_public': isPublic,
    };
  }

  /// Convert JSON (from Supabase) to Post object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      ingredients: List<String>.from(jsonDecode(json['ingredients'])),
      steps: List<String>.from(jsonDecode(json['steps'])),
      duration: json['duration'],
      complexity: json['complexity'],
      affordability: json['affordability'],
      userId: json['user_id'],
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
      savedBy: List<String>.from(jsonDecode(json['saved_by'])),
      tags: List<String>.from(jsonDecode(json['tags'])),
      cuisine: json['cuisine'],
      timestamp: DateTime.parse(json['timestamp']),
      isPublic: json['is_public'],
    );
  }
}
