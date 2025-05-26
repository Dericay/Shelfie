import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/widgets/book_options_dropdown.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final void Function(String)? onOptionSelected;

  const BookCard({super.key, required this.book, this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    final fixedImageUrl = book.imageUrl?.replaceFirst('http://', 'https://');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 150,
              child:
                  fixedImageUrl != null && fixedImageUrl.isNotEmpty
                      ? Image.network(
                        fixedImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      )
                      : const Icon(Icons.book, size: 50, color: Colors.grey),
            ),
          ),

          // Book info section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book.authors.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF6C6C6C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book.publishedDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6C6C6C),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: BookOptionsDropdown(
                      book: book,
                      onOptionSelected: onOptionSelected ?? (_) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
