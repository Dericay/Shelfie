import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shelfie/models/books.dart';

class MyShelfScreen extends StatelessWidget {
  const MyShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shelf"),
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
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: book.imageUrl.isNotEmpty
                          ? Image.network(
                              book.imageUrl,
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
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await box.delete(book.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Book removed from shelf')),
                        );
                      },
                    ),
TextButton(
  child: const Text('Set as Reading'),
  onPressed: () async {
    var readingBox = Hive.box<Book>('readingBooks');

    // Create a new Book instance with the same values
    final readingBook = Book(
      id: book.id,
      title: book.title,
      author: book.author,
      imageUrl: book.imageUrl,
    );

    // Save to readingBooks
    await readingBox.put(readingBook.id, readingBook);

    // Remove from savedBooks
    await box.delete(book.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book moved to Reading')),
    );
  },
),

                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
