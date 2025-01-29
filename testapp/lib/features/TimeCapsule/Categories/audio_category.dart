import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart'; // Add this import for download functionality
import 'package:share_plus/share_plus.dart'; // Add this import for sharing functionality

import 'AudioPlayerPage.dart';

class AudioCategory extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String searchQuery;
  final Function(String, int) onRename;
  final Function(String, int) onDelete;
  final TextEditingController searchController;

  AudioCategory({
    required this.items,
    required this.searchQuery,
    required this.onRename,
    required this.onDelete,
    required this.searchController,
  });

  @override
  _AudioCategoryState createState() => _AudioCategoryState();
}

class _AudioCategoryState extends State<AudioCategory> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  double _currentPosition = 0.0;
  double _totalDuration = 1.0;
  bool isSelectMode = false;
  List<int> selectedIndices = [];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    // Listen to position updates
    audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inSeconds.toDouble();
      });
    });

    // Listen to duration updates
    audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = (duration?.inSeconds.toDouble() ?? 1.0);
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Method to handle downloading audio
  void _downloadAudio(String url, String fileName) async {
    if (url.isNotEmpty) {
      try {
        // Fetch the external storage directory
        final directory = await getExternalStorageDirectory();
        final savedDir = directory?.path ?? '/storage/emulated/0/Download';

        // Ensure the directory exists
        final savedDirFile = Directory(savedDir);
        if (!savedDirFile.existsSync()) {
          savedDirFile.createSync(recursive: true);
        }

        final taskId = await FlutterDownloader.enqueue(
          url: url,
          savedDir: savedDir,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true,
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
        const SnackBar(content: Text("Audio URL is missing")),
      );
    }
  }

  // Method to share the selected audio files
  void _shareSelectedAudio() {
    if (selectedIndices.isNotEmpty) {
      final selectedUrls = selectedIndices
          .map((index) => widget.items[index]['url'])
          .whereType<String>()
          .toList();

      if (selectedUrls.isNotEmpty) {
        // Share the selected URLs directly
        Share.share(
          selectedUrls.join("\n"), // Share the URLs of the selected audios
          subject: "Check out these audios!", // Optional message
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No audio file available to share")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No audio selected to share")),
      );
    }
  }

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

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orangeAccent.withOpacity(0.3),
                      Colors.deepOrangeAccent.withOpacity(0.6),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final fileName = item['file_name'] ?? "Unnamed Audio";
                    final fileUrl = item['url']; // Assuming the URL is stored in "url"

                    // Truncate the file name if it's longer than 40 characters and append "..."
                    String displayFileName = fileName.length > 40
                        ? fileName.substring(0, 40) + "..."
                        : fileName;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading: isSelectMode
                            ? Checkbox(
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
                        )
                            : Container(
                          width: 65,
                          height: 65,
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
                          child: Image.asset(
                            'assets/TimeCapsuleIcons/audioIcon.jpg', // Replace with the actual URL
                            width: 50, // Set the width to match the icon size
                            height: 50, // Set the height to match the icon size
                          ),
                        ),
                        title: Text(
                          displayFileName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          if (!isSelectMode) {
                            if (fileUrl != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioPlayerPage(
                                    filePath: fileUrl, // Use the URL for playback
                                    fileName: fileName,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Audio file URL not found")),
                              );
                            }
                          } else {
                            // Handle checkbox selection in select mode
                            setState(() {
                              if (selectedIndices.contains(index)) {
                                selectedIndices.remove(index);
                              } else {
                                selectedIndices.add(index);
                              }
                            });
                          }
                        },
                        trailing: isSelectMode
                            ? null
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  widget.onRename('Voices', index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  widget.onDelete('Voices', index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.download), // Add download button
                              onPressed: () =>
                                  _downloadAudio(fileUrl, fileName), // Trigger download
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        // Floating Action Button for selecting multiple audios to share
        Positioned(
          bottom: 120,
          right: 18,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (isSelectMode) {
                  selectedIndices.clear();
                }
                isSelectMode = !isSelectMode;
              });
            },
            backgroundColor: isSelectMode ? Colors.red : Colors.blue,
            child: Icon(isSelectMode ? Icons.close : Icons.share),
          ),
        ),
        // Floating Action Button for sharing selected audios
        if (isSelectMode)
          Positioned(
            bottom: 200,
            right: 18,
            child: FloatingActionButton(
              onPressed: _shareSelectedAudio,
              backgroundColor: Colors.green,
              child: const Icon(Icons.send),
             ),
          ),
      ],
    );
  }
}
