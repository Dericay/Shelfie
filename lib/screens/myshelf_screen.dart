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
        valueListenable: Hive.box<Book>('books').listenable(),
        builder: (context, Box<Book> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No books saved.'));
          }
          final savedBooks =
              box.values
                  .where(
                    (b) =>
                        b.readingStatus != null &&
                        (b.readingStatus == "read" ||
                            b.readingStatus == "save_for_later"),
                  )
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: savedBooks.length,
            itemBuilder: (context, index) {
              final book = savedBooks[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BookCard(book: book),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Status: ${book.readingStatus}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
