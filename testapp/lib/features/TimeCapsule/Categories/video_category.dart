import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCategory extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String searchQuery;
  final Function(String, int) onRename;
  final Function(String, int) onDelete;
  final TextEditingController searchController;

  VideoCategory({
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
    return Container(
        color: Colors.orangeAccent.withOpacity(0.9),
        child: ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            final videoUrl = item['url'] ?? ""; // Cloudinary URL of the video
            final fileName = item['file_name'] ?? "Unnamed Video";

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              // Space below each ListTile
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    if (videoUrl.isNotEmpty) {
                      // Navigate to full-screen video view
                      _showFullScreenVideo(context, videoUrl);
                    } else {
                      // Show a message if the URL is missing
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Video URL is missing"),
                        ),
                      );
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
                      child: videoUrl.isNotEmpty
                          ? const Icon(
                              Icons.videocam,
                              size: 50,
                              color: Colors.blueAccent,
                            ) // Placeholder icon for videos
                          : const Icon(Icons.broken_image,
                              size: 50), // Placeholder for missing URL
                    ),
                  ),
                ),
                title: Text(fileName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => onRename('Videos', index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDelete('Videos', index),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  // Full-screen video view
  void _showFullScreenVideo(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPage(videoUrl: videoUrl),
      ),
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  FullScreenVideoPage({required this.videoUrl});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Auto-play the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
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

// import 'package:flutter/material.dart';
// import 'dart:io';
//
// class VideoCategory extends StatelessWidget {
//   final List<Map<String, dynamic>> items;
//   final String searchQuery;
//   final TextEditingController searchController;
//   final Function(String, int) onRename;
//   final Function(String, int) onDelete;
//
//   VideoCategory({
//     required this.items,
//     required this.searchQuery,
//     required this.searchController,
//     required this.onRename,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Filter videos based on the search query
//     final filteredItems = items
//         .where((item) =>
//         item['file_name'].toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//
//     return ListView.builder(
//       itemCount: filteredItems.length,
//       itemBuilder: (context, index) {
//         final item = filteredItems[index];
//         return ListTile(
//           leading: Icon(Icons.video_library), // Video thumbnail can be added here
//           title: Text(item['file_name']),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () => onRename('Videos', index),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => onDelete('Videos', index),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
