import 'package:flutter/material.dart';
import 'file_menu.dart'; // Import your FileMenu widget

class RecentFilesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Ensures the list takes only the space it needs
      itemCount: 10, // Adjust the item count as necessary
      itemBuilder: (context, index) {
        // File name dynamically created for each item
        String fileName = 'File ${index + 1}';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text(fileName),
            subtitle: Text('Description of the file'),
            trailing: FileMenu(fileName: fileName), // Use FileMenu here
            onTap: () {
              // Handle file tap action (e.g., open file details)
            },
          ),
        );
      },
    );
  }
}
