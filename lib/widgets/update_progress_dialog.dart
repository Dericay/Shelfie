import 'package:flutter/material.dart';

class UpdateProgressDialog extends StatefulWidget {
  final int pagesRead;
  final int totalPages;

  const UpdateProgressDialog({
    super.key,
    required this.pagesRead,
    required this.totalPages,
  });

  @override
  State<UpdateProgressDialog> createState() => _UpdateProgressDialogState();
}

class _UpdateProgressDialogState extends State<UpdateProgressDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.pagesRead.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Progress"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Page number (of ${widget.totalPages})",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final enteredPage = int.tryParse(_controller.text);
            if (enteredPage != null && enteredPage <= widget.totalPages) {
              Navigator.pop(context, enteredPage);
            } else {}
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
