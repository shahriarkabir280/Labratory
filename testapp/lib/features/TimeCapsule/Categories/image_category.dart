import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart'; // Add this import for downloading functionality

import '../../gradient_color.dart';

class ImageCategory extends StatefulWidget  {
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
  _ImageCategoryState createState() => _ImageCategoryState();
}

class _ImageCategoryState extends State<ImageCategory> {
  bool isSelectMode = false;
  List<int> selectedIndices = [];
  List<String> downloadedFiles = []; // This will hold the file paths

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = widget.items
        .where((item) =>
    item['file_name'] != null &&
        item['file_name']
            .toLowerCase()
            .contains(widget.searchQuery.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: DynamicGradient.createGradient(
          [Colors.lightBlueAccent.withOpacity(0.2), Colors.indigoAccent.withOpacity(0.4)],
          Alignment.bottomRight,
          Alignment.topLeft,
        ),
      ),
      child: Stack(
        children: [
          // GridView for images
          GridView.builder(
            padding: const EdgeInsets.symmetric (horizontal: 8.0, vertical: 16.0), // Add padding to prevent overflow
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two images in one row
              crossAxisSpacing: 0.0, // Space between columns
              childAspectRatio: 0.75, // Adjust ratio to give items enough vertical space
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index)  {
              final item = filteredItems[index];
              final imageUrl = item['url'] ?? ""; // Cloudinary URL of the image
              final fileName = item['file_name'] ?? "Unnamed Image";

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (imageUrl.isNotEmpty) {
                          _showFullScreenImage(context, imageUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Image URL is missing")),
                          );
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                          )
                              : const Icon(Icons.image, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      fileName.length > 40 ? "${fileName.substring(0, 35)}..." : fileName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!isSelectMode)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit, size: 25),
                                onPressed: () => widget.onRename('Images', index),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete, size: 25),
                                onPressed: () => widget.onDelete('Images', index),
                              ),
                            ],
                          ),
                         // const SizedBox(height: 5), // Adjust height for spacing
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.download, size: 25),
                                onPressed: () => _downloadImage(imageUrl, fileName),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.share, size: 25),
                                onPressed: () => _shareImage(imageUrl),
                              ),
                            ],
                          ),
                        ],
                      ),


                    if (isSelectMode)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Checkbox(
                          value: selectedIndices.contains(index),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedIndices.add(index);
                              } else {
                                selectedIndices.remove(index);
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
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

  // Share image functionality
  void _shareImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      Share.share(imageUrl, subject: "Check out this image!"); // Share the image URL
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image URL is missing")),
      );
    }
  }

  // Download image functionality
  void _downloadImage(String imageUrl, String fileName) async {
    if (imageUrl.isNotEmpty) {
      print(imageUrl);
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: imageUrl,
          savedDir: '/storage/emulated/0/Download', // Example save path
          fileName: fileName,
          showNotification: true, // Show download progress
          openFileFromNotification: true, // Open file after download
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Download started")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Download failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image URL is missing")),
      );
    }
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
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
