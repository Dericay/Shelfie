import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/widgets/book_card.dart';

class MyShelfScreen extends StatelessWidget {
  const MyShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'My books',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Book>('savedBooks').listenable(),
        builder: (context, Box<Book> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No books saved.'));
          }

          final savedBooks = box.values.toList();
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: savedBooks.length,
            itemBuilder: (context, index) {
              final book = savedBooks[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: BookCard(
                      book: book,
                      buttonIcon: Icons.delete,
                      onButtonPressed: () async {
                        await box.delete(book.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book removed from shelf'),
                          ),
                        );
                      },
                      onSetAsReading: () async {
                        final readingBook = Book(
                          id: book.id,
                          title: book.title,
                          authors: List<String>.from(book.authors),
                          imageUrl: book.imageUrl,
                          totalPages: book.totalPages,
                          pagesRead: book.pagesRead,
                          publishedDate: book.publishedDate,
                        );
                        await Hive.box<Book>(
                          'readingBooks',
                        ).put(book.id, readingBook);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Set "${book.title}" as reading'),
                          ),
                        );
                      },
                      showSetAsReadingButton: true, // <-- ONLY in MyShelfScreen
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
