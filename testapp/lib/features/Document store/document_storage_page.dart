import 'package:flutter/material.dart';
import 'package:testapp/features/Document store/category_page.dart';
import 'package:testapp/widgets/grid_view_tile.dart';

class documentStoragePage extends StatefulWidget {
  @override
  _DocumentStoragePageState createState() => _DocumentStoragePageState();
}

class _DocumentStoragePageState extends State<documentStoragePage> {
  // List to hold the categories
  List<String> categories = ['Educational', 'Medical', 'Financial', 'Personal'];

  // Function to add a new category
  void _addCategory(String newCategory) {
    setState(() {
      categories.add(newCategory);
    });
  }

  // Show dialog for creating a new category
  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController _categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Category'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newCategory = _categoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  _addCategory(newCategory);
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Categories", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: categories.map((category) {
                return GridViewTile(category: category);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context); // Show the dialog to create a new category
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
