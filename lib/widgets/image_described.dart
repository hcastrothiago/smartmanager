import 'package:flutter/material.dart';

class ImageDescribed extends StatelessWidget {
  final String imagePath;
  final String description;
  final double spacing;
  final double imageHeight;

  const ImageDescribed({
    super.key,
    required this.description,
    required this.imagePath,
    this.spacing = 6,
    this.imageHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: spacing),

        Image.asset(imagePath, height: imageHeight, fit: BoxFit.contain),
      ],
    );
  }
}
