import 'package:flutter/material.dart';
import 'package:shelfie/widgets/update_progress_dialog.dart';

class BookListCard extends StatelessWidget {
  final String title;
  final List<String> authors;
  final String? imageUrl;
  final Widget? trailing;
  final int pagesRead;
  final int totalPages;
  final void Function(int newPage) onUpdateProgress;

  const BookListCard({
    super.key,
    required this.title,
    required this.authors,
    this.imageUrl,
    this.trailing,
    required this.pagesRead,
    required this.totalPages,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final fixedImageUrl = imageUrl?.replaceFirst('http://', 'https://');
    final progress = totalPages > 0 ? pagesRead / totalPages : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 150,
              child:
                  fixedImageUrl != null
                      ? Image.network(
                        fixedImageUrl,
                        width: 100,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      )
                      : const Icon(Icons.book, size: 50, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFD60A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("${(progress * 100).toStringAsFixed(0)}% read"),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Color(0xFF0C3343),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Rounded corners
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final newPage = await showDialog<int>(
                        context: context,
                        builder:
                            (context) => UpdateProgressDialog(
                              pagesRead: pagesRead,
                              totalPages: totalPages,
                            ),
                      );
                      if (newPage != null) {
                        onUpdateProgress(newPage);
                      }
                    },
                    child: const Text(
                      'Update progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
