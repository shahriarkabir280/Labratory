import 'package:flutter/material.dart';

class FileMenu extends StatelessWidget {
  final String fileName; // Assuming the file name is passed into the widget

  FileMenu({required this.fileName});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle file/folder actions (rename, delete, etc.)
        if (value == 'Rename') {
          _showRenameDialog(context);
        } else if (value == 'Delete') {
          _showDeleteConfirmationDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'Rename', child: Text('Rename')),
        PopupMenuItem(value: 'Delete', child: Text('Delete')),
      ],
    );
  }

  // Show dialog for renaming the file
  void _showRenameDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: fileName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename File'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter new file name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform renaming logic (e.g., update file name in database)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File renamed to ${_controller.text}')));
              },
              child: Text('Rename'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog for deleting the file
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete File'),
          content: Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform delete logic (e.g., remove file from database)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File deleted')));
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
