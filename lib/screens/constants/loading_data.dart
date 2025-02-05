import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingData extends StatelessWidget {
  const LoadingData({super.key});

  Widget container(double width, double height) => Shimmer.fromColors(
        baseColor: const Color(0xFFEEF4F7),
        highlightColor: Colors.white.withValues(alpha: (0.2*255).toDouble()),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4F7),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: container(120, 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: 6, // Simulate 6 loading items
          itemBuilder: (context, index) => Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Simulating image placeholder
                  container(double.infinity, 120),
                  const SizedBox(height: 8),
                  // Simulating text placeholders
                  container(150, 12),
                  const SizedBox(height: 8),
                  container(180, 12),
                  const SizedBox(height: 8),
                  container(100, 12),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: container(24, 24), // Placeholder icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: container(24, 24), // Placeholder icon
            label: '',
          ),
        ],
      ),
    );
  }
}
