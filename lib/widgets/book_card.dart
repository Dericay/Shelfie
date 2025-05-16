import 'package:flutter/material.dart';
import 'package:shelfie/models/books.dart'; // Update path as needed

class BookCard extends StatelessWidget {
  final Book book;
  final IconData buttonIcon;
  final VoidCallback onButtonPressed;
  final VoidCallback? onSetAsReading;
  final bool showSetAsReadingButton; // <-- NEW

  const BookCard({
    super.key,
    required this.book,
    required this.buttonIcon,
    required this.onButtonPressed,
    this.onSetAsReading,
    this.showSetAsReadingButton = false, // <-- default false
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                book.imageUrl != null && book.imageUrl!.isNotEmpty
                    ? Image.network(
                      book.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                    : Container(color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              book.authors.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          IconButton(icon: Icon(buttonIcon), onPressed: onButtonPressed),
          if (showSetAsReadingButton && onSetAsReading != null)
            ElevatedButton(
              child: const Text('Set as Reading'),
              onPressed: onSetAsReading,
            ),
        ],
      ),
    );
  }
}
