import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shelfie/models/books.dart';

class GoogleBookApi {
  static Future<List<Book>> fetchBooks(
    String query, {
    String orderBy = 'relevance',
  }) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map((item) => Book.fromGoogleApi(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
