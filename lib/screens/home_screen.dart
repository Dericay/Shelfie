import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Book>('readingBooks').listenable(),
        builder: (context, Box<Book> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Reading no books'));
          }
          final readingBooks = box.values.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: readingBooks.length,
            itemBuilder: (context, index) {
              final book = readingBooks[index];
              print('Book: ${book.title}, totalPages: ${book.totalPages}');
              print('Hive key: ${book.key}');

              return BookCard(
                title: book.title,
                authors: book.authors,
                imageUrl:
                    book.imageUrl?.isNotEmpty == true ? book.imageUrl : null,
                pagesRead: book.pagesRead,
                totalPages: book.totalPages,
                onUpdateProgress: (newPage) {
                  setState(() {
                    book.pagesRead = newPage;
                    book.save();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
