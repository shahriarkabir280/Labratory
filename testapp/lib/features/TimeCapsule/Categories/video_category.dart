
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart'; // Retained import for downloading functionality
import 'package:share_plus/share_plus.dart'; // Import the share_plus package

import '../../gradient_color.dart';

class VideoCategory extends StatefulWidget {
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
  _VideoCategoryState createState() => _VideoCategoryState();
}

class _VideoCategoryState extends State<VideoCategory> {
  bool isSelectMode = false;
  List<int> selectedIndices = [];

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
          [
            Colors.orangeAccent.withOpacity(0.3),
            Colors.redAccent.withOpacity(0.4)
          ],
          Alignment.bottomRight,
          Alignment.topLeft,
        ),
      ),
      child: Stack(
        children: [
          // GridView for videos
          GridView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.0,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              final videoUrl = item['url'] ?? ""; // URL of the video
              final fileName = item['file_name'] ?? "Unnamed Video";

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (videoUrl.isNotEmpty) {
                          _showFullScreenVideo(context, videoUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Video URL is missing")),
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
                          child: videoUrl.isNotEmpty
                              ? Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/TimeCapsuleIcons/videoIcon.jpg',
                                    // Replace with the actual image URL or asset
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      fileName.length > 40
                          ? "${fileName.substring(0, 35)}..."
                          : fileName,
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
                              onPressed: () =>
                                  _downloadVideo(videoUrl, fileName),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.share, size: 25),
                              onPressed: () => _shareVideo(videoUrl),
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

  // Full-screen video view
  void _showFullScreenVideo(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPage(videoUrl: videoUrl),
      ),
    );
  }

  // Download video functionality
  void _downloadVideo(String videoUrl, String fileName) async {
    if (videoUrl.isNotEmpty) {
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: videoUrl,
          savedDir: '/storage/emulated/0/Download',
          // Example save path
          fileName: fileName,
          showNotification: true,
          // Show download progress
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
        const SnackBar(content: Text("Video URL is missing")),
      );
    }
  }

  // Share video functionality
  void _shareVideo(String videoUrl) {
    if (videoUrl.isNotEmpty) {
      Share.share(videoUrl,
          subject: "Check out this video!"); // Share the video URL
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video URL is missing")),
      );
    }
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
    _controller = VideoPlayerController.network(widget.videoUrl)
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
