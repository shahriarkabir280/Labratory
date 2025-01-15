import 'package:flutter/material.dart';

class ImageCategory extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String searchQuery;
  final Function(String, int) onRename;
  final Function(String, int) onDelete;
  final TextEditingController searchController;

  ImageCategory({
    required this.items,
    required this.searchQuery,
    required this.onRename,
    required this.onDelete,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = items
        .where((item) =>
        item['file_name'] != null &&
        item['file_name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    print(items);

    return Container(
      color: Colors.lightBlueAccent.withOpacity(0.8),
      child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          final imageUrl = item['url'] ?? ""; // Cloudinary URL of the image
          final fileName = item['file_name'] ?? "Unnamed Image";

          return Padding(
            padding:
            const EdgeInsets.only(bottom: 20.0), // Add space below each ListTile
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  if (imageUrl.isNotEmpty) {
                    // Navigate to full-screen image view
                    _showFullScreenImage(context, imageUrl);
                  } else {
                    // Show a message if the URL is missing
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Image URL is missing"),
                    ));
                  }
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Show a placeholder if the image fails to load
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    )
                        : const Icon(Icons.image, size: 50), // Placeholder for missing URL
                  ),
                ),
              ),
              title: Text(fileName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onRename('Images', index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDelete('Images', index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Full-screen image view
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Interactive image viewer
            Expanded(
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Back button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
