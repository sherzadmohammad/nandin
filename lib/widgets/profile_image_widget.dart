import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? file;
  final double size;
  final double borderRadius;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.file,
    this.size = 65.0, // Default size
    this.borderRadius = 30.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius), // Makes it circular

        child:imageUrl != null? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.white,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/blank-profile-picture.png',
            fit: BoxFit.cover,
          ),
        )
        :Image.file(
          file!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/blank-profile-picture.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
