

import 'package:hive/hive.dart';

part 'books.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

    @HiveField(2)
  String author;

    @HiveField(3)
  String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });


}