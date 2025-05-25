import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shelfie/models/books.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final IconData? buttonIcon;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onSetAsReading;
  final bool showSetAsReadingButton;

  const BookCard({
    super.key,
    required this.book,
    this.buttonIcon,
    this.onButtonPressed,
    this.onSetAsReading,
    this.showSetAsReadingButton = false, 
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
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              book.authors.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF6C6C6C)),
            ),
          ),
        ],
      ),
    );
  }
}
