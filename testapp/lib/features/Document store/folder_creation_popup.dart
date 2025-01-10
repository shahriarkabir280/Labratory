import 'package:flutter/material.dart';

class FolderCreationPopup extends StatefulWidget {
  final Function(String) onFolderCreated; // Callback to pass folder name back

  FolderCreationPopup({required this.onFolderCreated});

  @override
  _FolderCreationPopupState createState() => _FolderCreationPopupState();
}

class _FolderCreationPopupState extends State<FolderCreationPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Folder'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter folder name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String folderName = _controller.text.trim();
            if (folderName.isNotEmpty) {
              widget.onFolderCreated(folderName); // Pass folder name back
              Navigator.pop(context); // Close the dialog
            }
          },
          child: Text('Create'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
