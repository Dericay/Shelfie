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
                        borderRadius: BorderRadius.circular(10),
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
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
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
                        final book = books[index];
                        return BookCard(
                          book: book,
                          buttonIcon: Icons.bookmark_border,
                          onButtonPressed: () async {
                            var box = Hive.box<Book>('savedBooks');
                            await box.put(book.id, book);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved for later!')),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
