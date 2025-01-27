import 'package:flutter/material.dart';
import 'comment_data.dart';
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

class NewMeal {
  NewMeal({
    required this.id,
    required this.categories,
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
    required this.isVegetarian,
    required this.userId,
    required this.username,
    this.likes = const [],
    this.comments = const [],
    this.tags = const [],
    this.cuisine = '',
    required this.timestamp,
  });

  final String id;
  final List<String> categories;
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

  // New fields for user accounts and social interactions
  final String userId; // ID of the user who created the meal
  final String username; // Name of the user who created the meal
  final List<String> likes; // List of user IDs who liked the meal
  final List<Comment> comments; // List of comments on the meal

  // New fields for search filters
  final List<String> tags; // Tags for filtering (e.g., ["quick-meal", "vegetarian"]),
  final String cuisine; // Type of cuisine (e.g., "Italian", "Mexican"),

  // Timestamp for when the meal was posted,
  final DateTime timestamp;

  // Optional: Add a color property for UI customization
  var color = Colors.white;

  // Convert a Meal object to a Map (for Firebase/Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categories': categories,
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'duration': duration,
      'complexity': complexity.toString(),
      'affordability': affordability.toString(),
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'userId': userId,
      'username': username,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'tags': tags,
      'cuisine': cuisine,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a Meal object from a Map (from Firebase/Supabase)
  factory NewMeal.fromMap(Map<String, dynamic> map) {
    return NewMeal(
      id: map['id'],
      categories: List<String>.from(map['categories']),
      title: map['title'],
      imageUrl: map['imageUrl'],
      ingredients: List<String>.from(map['ingredients']),
      steps: List<String>.from(map['steps']),
      duration: map['duration'],
      complexity: Complexity.values.firstWhere(
            (e) => e.toString() == map['complexity'],
      ),
      affordability: Affordability.values.firstWhere(
            (e) => e.toString() == map['affordability'],
      ),
      isGlutenFree: map['isGlutenFree'],
      isLactoseFree: map['isLactoseFree'],
      isVegan: map['isVegan'],
      isVegetarian: map['isVegetarian'],
      userId: map['userId'],
      username: map['username'],
      likes: List<String>.from(map['likes']),
      comments: List<Comment>.from(
        map['comments'].map((comment) => Comment.fromMap(comment)),
      ),
      tags: List<String>.from(map['tags']),
      cuisine: map['cuisine'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}