import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const BookCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final fixedImageUrl = imageUrl?.replaceFirst('http://', 'https://');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading:
            fixedImageUrl != null
                ? Image.network(
                  fixedImageUrl,
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(Icons.broken_image),
                )
                : Icon(Icons.book, size: 50, color: Colors.grey),
        title: Text(title),
      ),
    );
  }
}
