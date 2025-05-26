import 'package:hive/hive.dart';

part 'books.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<String> authors;

  @HiveField(3)
  String? imageUrl;

  @HiveField(4)
  int pagesRead;

  @HiveField(5)
  int totalPages;

  @HiveField(6)
  String publishedDate;

  @HiveField(7)
  String? readingStatus;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.imageUrl,
    this.pagesRead = 0,
    required this.totalPages,
    required this.publishedDate,
    this.readingStatus,
  });

  factory Book.fromGoogleApi(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Untitled',
      authors:
          (volumeInfo['authors'] as List<dynamic>?)
              ?.map((a) => a.toString())
              .toList() ??
          ['Unknown Author'],
      imageUrl: volumeInfo['imageLinks']?['thumbnail'],
      totalPages: volumeInfo['pageCount'] ?? 0,
      publishedDate: volumeInfo['publishedDate'],
    );
  }
}
