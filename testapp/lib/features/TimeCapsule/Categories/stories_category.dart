import 'package:flutter/material.dart';
import 'package:testapp/features/TimeCapsule/timeCapsuleScreen.dart';
import '../../gradient_color.dart';

class StoriesCategory extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String searchQuery;
  final Function(int) onEditStory;
  final Function(int) onDeleteStory;
  final TextEditingController searchController;

  StoriesCategory({
    required this.items,
    required this.searchQuery,
    required this.onEditStory,
    required this.onDeleteStory,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = items
        .where((item) =>
    item['title'] != null &&
        item['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: DynamicGradient.createGradient(
          [Colors.lightGreen.withOpacity(0.2), Colors.green.withOpacity(0.4)],
          Alignment.bottomRight,
          Alignment.topLeft,
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          final fileName = item['title'] ?? "Unnamed Text File";
          final fileContentPreview = item['content'] != null
              ? (item['content'].length > 100
              ? "${item['content'].substring(0, 100)}..."
              : item['content'])
              : "No content available";

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3.0,
            child: ListTile(
              title: Text(
                fileName.length > 40
                    ? "${fileName.substring(0, 35)}..."
                    : fileName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                fileContentPreview,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEditStory(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDeleteStory(index),
                  ),
                ],
              ),
              onTap: () => _showFullText(context, fileName, item['content']),
            ),
          );
        },
      ),
    );
  }


  // Full text view dialog
  void _showFullText(BuildContext context, String fileName, String? content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fileName),
        content: SingleChildScrollView(
          child: Text(content ?? "No content available"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
