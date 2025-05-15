import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/services/google_book_api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List books = [];
  String selectedCategory = 'fiction';
  bool isLoading = false;
  String selectedSort = 'latest';

  @override
  void initState() {
    super.initState();
    fetchBooks(selectedCategory);
  }

  Future<void> fetchBooks(String query) async {
    setState(() => isLoading = true);
    try {
      final fetchedBooks = await GoogleBookApi.fetchBooks(
        query,
        orderBy: selectedSort == 'latest' ? 'newest' : 'relevance',
      );

      setState(() => books = fetchedBooks);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() => books = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: fetchBooks,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  ['All', 'Fiction', 'Science', 'History']
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setState(() => selectedCategory = category);
                              fetchBooks(category == 'all' ? '' : category);
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              style: TextStyle(color: Colors.grey),
              value: selectedSort,
              items: [
                DropdownMenuItem(value: 'latest', child: Text('Latest')),
                DropdownMenuItem(value: 'title', child: Text('Most popular')),
              ],

              onChanged: (value) {
                setState(() => selectedSort = value!);
                fetchBooks(selectedCategory);
              },
            ),
          ),

          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index] as Book;

                        final bookTitle = book.title;
                        final authorsList = book.authors;
                        final authorsText = authorsList.join(', ');
                        final imageUrl = book.imageUrl ?? '';

                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child:
                                    imageUrl.isNotEmpty
                                        ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 100,
                                                  ),
                                        )
                                        : const Icon(
                                          Icons.book,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  bookTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  authorsText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.bookmark_border),
                                onPressed: () async {
                                  var box = Hive.box<Book>('savedBooks');
                                  await box.put(book.id, book);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Saved for later!')),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
