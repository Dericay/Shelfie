import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shelfie/models/books.dart';
import 'package:shelfie/services/google_book_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shelfie/widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List books = [];
  String selectedCategory = 'All';
  bool isLoading = false;
  String selectedSort = 'latest';
  String _getLabel(String? option) {
    switch (option) {
      case 'read':
        return 'Read';
      case 'set_as_reading':
        return 'Reading';
      case 'save_for_later':
        return 'Saved for Later';
      default:
        return 'Want to read';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks(selectedCategory);
  }

  DateTime _parseDate(String? dateString) {
    try {
      return DateTime.parse(dateString ?? '');
    } catch (_) {
      return DateTime(1900);
    }
  }

  Future<void> fetchBooks(String query) async {
    setState(() => isLoading = true);
    try {
      final fetchedBooks = await GoogleBookApi.fetchBooks(
        query,
        orderBy: selectedSort == 'latest' ? 'newest' : 'null',
      );
      fetchedBooks.sort((a, b) {
        final dateA = _parseDate(a.publishedDate);
        final dateB = _parseDate(b.publishedDate);
        return selectedSort == 'latest'
            ? dateB.compareTo(dateA)
            : dateA.compareTo(dateB);
      });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Discover books',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: fetchBooks,
              decoration: InputDecoration(
                hintText: 'Search books, authors...',
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.grey[300]),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  [
                    'All',
                    'Fiction',
                    'Drama',
                    'Science',
                    'Philosophy',
                    'History',
                    'Travel',
                  ].map((category) {
                    final bool isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        color:
                            isSelected
                                ? const Color(0xFF0C3343)
                                : Colors.grey[200],
                        elevation: isSelected ? 6 : 0,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            setState(() => selectedCategory = category);
                            fetchBooks(category == '' ? '' : category);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              style: TextStyle(color: Colors.grey),
              value: selectedSort,
              items: [
                DropdownMenuItem(value: 'latest', child: Text('Newest')),
                DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
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
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: BookCard(
                            book: book,
                            onOptionSelected: (option) async {
                              final box = Hive.box<Book>('books');

                              if (!book.isInBox) {
                                await box.put(book.id, book);
                              }
                              final hiveBook = box.get(book.id)!;

                              hiveBook.readingStatus = option;
                              await hiveBook.save();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Book marked as ${_getLabel(option)}',
                                  ),
                                ),
                              );
                            },
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
