import 'package:flutter/material.dart';

class BookOptionsDropdown extends StatefulWidget {
  final dynamic book;

  const BookOptionsDropdown({
    super.key,
    required this.book,
    required void Function(String p1) onOptionSelected,
  });

  @override
  State<BookOptionsDropdown> createState() => _BookOptionsDropdownState();
}

class _BookOptionsDropdownState extends State<BookOptionsDropdown> {
  late String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.book.readingStatus;
  }

  void onOptionSelected(String newStatus) {
    setState(() {
      selectedOption = newStatus;
      widget.book.readingStatus = newStatus;
      widget.book.save();
    });
  }

  String getLabel(String? option) {
    switch (option) {
      case "read":
        return "Read";
      case "set_as_reading":
        return "Reading";
      case "save_for_later":
        return "Saved";
      default:
        return "Want to read";
    }
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: selectedOption == "read" ? Color(0xFFFFC300) : null,
              ),
              title: const Text("Read"),
              trailing:
                  selectedOption == "read"
                      ? const Icon(Icons.check, color: Color(0xFFFFC300))
                      : null,
              onTap: () {
                Navigator.pop(context);
                onOptionSelected("read");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.menu_book,
                color:
                    selectedOption == "set_as_reading"
                        ? const Color(0xFFFFC300)
                        : null,
              ),
              title: const Text("Set as Reading"),
              trailing:
                  selectedOption == "set_as_reading"
                      ? const Icon(Icons.check, color: Color(0xFFFFC300))
                      : null,
              onTap: () {
                Navigator.pop(context);
                onOptionSelected("set_as_reading");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmark_border,
                color:
                    selectedOption == "save_for_later"
                        ? Color(0xFFFFC300)
                        : null,
              ),
              title: const Text("Save for Later"),
              trailing:
                  selectedOption == "save_for_later"
                      ? const Icon(Icons.check, color: Color(0xFFFFC300))
                      : null,
              onTap: () {
                Navigator.pop(context);
                onOptionSelected("save_for_later");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C3343),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showOptionsSheet(context),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                getLabel(selectedOption),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
              height: 24,
              width: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
