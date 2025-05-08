import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
        orderBy: selectedSort == 'latest' ? 'newest' : 'revalance',
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All','fiction', 'science', 'history', 'art']
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() => selectedCategory = category);
                            fetchBooks(category == 'all' ? '' : category);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          DropdownButton<String>(
            value: selectedSort,
            items: [
              DropdownMenuItem(value: 'latest', child: Text('Latest')),
              DropdownMenuItem(value: 'revelance', child: Text('Most popular'))
            ],
            onChanged: (value) {
              setState(() => selectedSort = value!);
              fetchBooks(selectedCategory);
            },
          ),
          Expanded(
            child: isLoading
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
                      final book = books[index]['volumeInfo'];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: book['imageLinks'] != null
                                  ? Image.network(
                                      book['imageLinks']['thumbnail'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Container(color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                book['title'] ?? 'No title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                book['authors'] != null ? (book['authors'] as List).join(', ') : 'Unknown author',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
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
