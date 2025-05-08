import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBookApi {
  static Future<List<dynamic>> fetchBooks(String query, {String orderBy = 'revelance'}) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Failed to load books');
    }
  }
}
