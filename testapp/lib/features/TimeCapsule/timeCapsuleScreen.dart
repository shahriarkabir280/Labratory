import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import '../../Models/UserState.dart';
import '../gradient_color.dart';
import 'Categories/audio_category.dart';
import 'Categories/image_category.dart';
import 'Categories/video_category.dart';
import 'Categories/stories_category.dart';
// import 'package:audioplayers/audioplayers.dart';

FASTAPI fastapi = FASTAPI();

class timeCapsuleScreen extends StatefulWidget {
  @override
  _TimeCapsuleScreenState createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<timeCapsuleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "Images"; // Default category
  String searchQuery = "";
  bool isSearchBarVisible = false;
  String? currentGroupCode;

  final Map<String, List<Map<String, dynamic>>> categoryData = {
    "Images": [],
    "Videos": [],
    "Voices": [],
    "Stories": [],
  };

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 4, vsync: this);
  //   _tabController.addListener(() {
  //     setState(() {
  //       selectedCategory = ["Images", "Videos", "Voices", "Stories"][_tabController.index];
  //       _searchController.clear();
  //       searchQuery = "";
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedCategory =
            ["Images", "Videos", "Voices", "Stories"][_tabController.index];
        _searchController.clear();
        searchQuery = "";
        if (currentGroupCode != null) {
          if (selectedCategory.toLowerCase() == "stories") {
            fetchMediaFiles(currentGroupCode!, "storie");
          } else
            fetchMediaFiles(currentGroupCode!, selectedCategory.toLowerCase());
        }
      });
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final userState = Provider.of<UserState>(context, listen: true);
  //   currentGroupCode = userState.currentUser?.currentGroup?.groupCode;
  //
  //   if (currentGroupCode != null) {
  //     fetchMediaFiles(currentGroupCode!); // Fetch previously uploaded images
  //   }
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userState = Provider.of<UserState>(context, listen: true);
    currentGroupCode = userState.currentUser?.currentGroup?.groupCode;
    if (currentGroupCode != null) {
      if (selectedCategory.toLowerCase() == "stories") {
        fetchMediaFiles(currentGroupCode!, "storie");
      } else
        fetchMediaFiles(currentGroupCode!, selectedCategory.toLowerCase());
    }
  }

  Future<void> fetchMediaFiles(String groupCode, String media_type) async {
    if (media_type == "voices")
      media_type = "audio";
    else if (media_type != "storie")
      media_type = media_type.substring(0, media_type.length - 1);
    try {
      final mediafiles =
          await fastapi.FetchMediaFiles(context, groupCode, media_type);
      print(media_type);
      setState(() {
        if (media_type == "image")
          categoryData["Images"] = mediafiles;
        else if (media_type == "video")
          categoryData["Videos"] = mediafiles;
        else if (media_type == "storie")
          categoryData["Stories"] = mediafiles;
        else if (media_type == "audio") categoryData["Voices"] = mediafiles;
      });
      print(
          "fetch part e asi categoryData['Images']: ${categoryData["Images"]}");
    } catch (e) {
      print("Error fetching media files: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      try {
        final cloudinaryResponse = await fastapi.UploadMediaFilesToCloudinary(
            context,
            File(pickedFile.path),
            pickedFile.name,
            currentGroupCode!,
            "image");

        if (cloudinaryResponse != null) {
          setState(() {
            categoryData["Images"]!.add({
              "file_name": pickedFile.name,
              "url": cloudinaryResponse["url"],
              // URL returned from Cloudinary
            });
            print(
                "upload part e asi categoryData['Images']: ${categoryData["Images"]}");
          });
        }
//print("upload part er baireeee categoryData['Images']: ${categoryData["Images"]}");
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _pickAudioFromFiles() async {
    // Open file picker for audio files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Only allow audio files
    );

    if (result != null) {
      // Get the picked file
      var pickedFile = result.files.single;

      // Get the path of the selected audio file
      String? filePath = pickedFile.path;

      if (filePath != null) {
        try {
          // Call your upload function (similar to the image upload function)
          final cloudinaryResponse = await fastapi.UploadMediaFilesToCloudinary(
            context,
            File(filePath), // Convert file path to a File object
            pickedFile.name, // The name of the audio file
            currentGroupCode!, // Pass the current group code
            "audio", // Specify the type as "audio"
          );

          if (cloudinaryResponse != null) {
            setState(() {
              // Store only the file name and URL, no need for file_path
              categoryData["Voices"]!.add({
                "file_name": pickedFile.name,
                "url": cloudinaryResponse["url"], // URL returned from Cloudinary
              });

              print("Updated Voices category: ${categoryData["Voices"]}");
            });
          }
        } catch (e) {
          print("Error uploading audio file: $e");
        }
      } else {
        print("Selected file has no path");
      }
    } else {
      // User canceled the file picking
      print("No audio file selected");
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    // Pick video either from the gallery or record a video depending on the source
    final pickedFile = await ImagePicker().pickVideo(source: source);

    // // Check if a video was picked or recorded
    // if (pickedFile != null) {
    //   setState(() {
    //     // Add the picked or recorded video to the categoryData under "Videos"
    //     categoryData["Videos"]!.add({
    //       "file": File(pickedFile.path),
    //       "name": pickedFile.name ?? "Unnamed Video",
    //     });
    //   });
    // } else {
    //   // Handle the case where no video was picked or recorded
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("No video selected or recorded"))
    //   );
    // }

    if (pickedFile != null) {
      try {
        final cloudinaryResponse = await fastapi.UploadMediaFilesToCloudinary(
            context,
            File(pickedFile.path),
            pickedFile.name,
            currentGroupCode!,
            "video");

        if (cloudinaryResponse != null) {
          setState(() {
            categoryData["Videos"]!.add({
              "file_name": pickedFile.name,
              "url": cloudinaryResponse["url"],
              // URL returned from Cloudinary
            });
          });
        }
      } catch (e) {
        print("Error uploading video: $e");
      }
    }
  }

  Future<void> _createTextStory() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create Your Story"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: "Enter the title of your story",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: "Content",
                    hintText: "Write your story here",
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final String title = titleController.text.trim();
                final String content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  _saveTextStory(title, content); // Save the story
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Title and content cannot be empty.")),
                  );
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _saveTextStory(String title, String content) async {
  //   // Example: Adding the story to the categoryData
  //   setState(() {
  //     categoryData["Stories"]!.add({
  //       "title": title,
  //       "content": content,
  //     });
  //   });
  //
  //   // Optional: Save to backend
  //   try {
  //     // final response = await fastapi.uploadStory(
  //     //   title: title,
  //     //   content: content,
  //     //   groupCode: currentGroupCode!,
  //     // );
  //
  //     // if (response) {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     const SnackBar(content: Text("Story created successfully!")),
  //     //   );
  //     // } else {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     const SnackBar(content: Text("Failed to save the story.")),
  //     //   );
  //     // }
  //   } catch (e) {
  //     print("Error saving story: $e");
  //   }
  // }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Capsule'),
        actions: [
          IconButton(
            icon: Icon(isSearchBarVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearchBarVisible = !isSearchBarVisible;
                if (!isSearchBarVisible) {
                  _searchController.clear();
                  searchQuery = "";
                }
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isSearchBarVisible ? 120 : 60),
          child: Column(
            children: [
              if (isSearchBarVisible)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search $selectedCategory...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  color: Colors
                      .transparent, // No indicator since tabs have their own decoration
                ),
                indicatorWeight: 0.0,
                // Removes the default thin indicator line
                labelPadding: EdgeInsets.zero,
                // Ensures tabs fill the width evenly
                tabs: [
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13), // Rounded top left corner
                        topRight:
                            Radius.circular(13), // Rounded top right corner
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: DynamicGradient.createGradient(
                            [
                              Colors.lightBlue.withOpacity(0.5),
                              Colors.indigo.withOpacity(0.4),
                            ],
                            Alignment.topLeft,
                            Alignment.bottomRight,
                          ),
                          boxShadow: _tabController.index == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Images",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _tabController.index == 0 ? 20 : 14,
                            // Larger text for the active tab
                            fontWeight: _tabController.index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: DynamicGradient.createGradient(
                            [
                              Colors.redAccent.withOpacity(0.4),
                              Colors.deepOrangeAccent.withOpacity(0.8),
                            ],
                            Alignment.topLeft,
                            Alignment.bottomRight,
                          ),
                          boxShadow: _tabController.index == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Videos",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _tabController.index == 1 ? 20 : 14,
                            fontWeight: _tabController.index == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: DynamicGradient.createGradient(
                            [
                              Colors.orange.withOpacity(0.6),
                              Colors.orangeAccent.withOpacity(0.5),
                            ],
                            Alignment.topLeft,
                            Alignment.bottomRight,
                          ),
                          boxShadow: _tabController.index == 2
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Voices",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _tabController.index == 2 ? 20 : 14,
                            fontWeight: _tabController.index == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: DynamicGradient.createGradient(
                            [
                              Colors.green.withOpacity(0.4),
                              Colors.lightGreenAccent.withOpacity(0.6),
                            ],
                            Alignment.topLeft,
                            Alignment.bottomRight,
                          ),
                          boxShadow: _tabController.index == 3
                              ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Stories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _tabController.index == 3 ? 20 : 14,
                            fontWeight: _tabController.index == 3
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        elevation: 0,
        // Remove the shadow below the AppBar
        backgroundColor: Colors
            .transparent, // Set AppBar background to transparent if needed
        // bottomOpacity: 0.0
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ImageCategory(
            items: categoryData["Images"]!,
            searchQuery: searchQuery,
            searchController: _searchController,
            onRename: _renameItem,
            onDelete: _deleteItem,
          ),
          VideoCategory(
            items: categoryData["Videos"]!,
            searchQuery: searchQuery,
            searchController: _searchController,
            onRename: _renameItem,
            onDelete: _deleteItem,
          ),
          //   AudioCategory(
          //     items: categoryData["Audio"]!,
          //     searchQuery: searchQuery,
          //     searchController: _searchController,
          //     onRename: _renameItem,
          //     onDelete: _deleteItem,
          //   ),
          AudioCategory(
            items: categoryData["Voices"]!,
            searchQuery: searchQuery,
            searchController: _searchController,
            onRename: _renameItem,
            onDelete: _deleteItem,
          ),
          StoriesCategory(
            items: categoryData["Stories"]!,
            searchQuery: searchQuery,
            searchController: _searchController,
            onEditStory: _EditStory,
            onDeleteStory: _deleteStory,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  StatelessWidget _buildFloatingActionButton() {
    final categoryIcons = {
      "Images": Icons.add_a_photo,
      "Videos": Icons.videocam,
      "Voices": Icons.mic,
      "Stories": Icons.edit,
    };

    if (categoryIcons.containsKey(selectedCategory)) {
      return FloatingActionButton(
        onPressed: () => _showAddOptions(category: selectedCategory),
        child: Icon(categoryIcons[selectedCategory]),
      );
    }
    return Container();
  }

  void _showAddOptions({required String category}) {
    switch (category) {
      case "Images":
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Take a Picture"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Select from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            );
          },
        );
        break;

      case "Videos":
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text("Record a Video"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickVideo(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.video_library),
                  title: const Text("Select from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickVideo(ImageSource.gallery);
                  },
                ),
              ],
            );
          },
        );
        break;
      //
      case "Voices":
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.audiotrack),
                  title: const Text("Select from Files"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickAudioFromFiles();
                  },
                ),
              ],
            );
          },
        );
        break;
      //
      // case "Stories":
      //   showModalBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           ListTile(
      //             leading: const Icon(Icons.camera),
      //             title: const Text("Create a Story"),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _createStory();
      //             },
      //           ),
      //           ListTile(
      //             leading: const Icon(Icons.photo_library),
      //             title: const Text("Select from Gallery"),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _selectStoryFromGallery();
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   break;
      case "Stories":
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text("Create a Story"),
              onTap: () async {
                Navigator.pop(context);
                await _createTextStory(); // Calls the function to create a text story
              },
            );
          },
        );
        break;

      default:
        // Handle other cases or show a default action
        break;
    }
  }

  void _renameItem(String category, int index) {
    final TextEditingController renameController = TextEditingController(
        text: categoryData[category]![index]['file_name']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rename this file"),
          content: TextField(
            controller: renameController, // Pre-fill with the current name
            decoration: const InputDecoration(labelText: "New Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  categoryData[category]![index]['file_name'] =
                      renameController.text;
                });
                  String media_type = category.toLowerCase();
                if (media_type == "voices")
                  media_type = "audio";
                else
                  media_type = media_type.substring(0, media_type.length - 1);
                await fastapi.RenameItems(context, currentGroupCode!, index,
                    renameController.text, media_type);
                Navigator.pop(context); // Close the dialog after renaming
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Image Renamed Successfully"),
                      backgroundColor: Colors.lightGreen),
                );
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String category, int index) {
    showDialog(
      context: context,
      builder: (context) {
        print(index);
        return AlertDialog(
          title: const Text("Delete File"),
          content: const Text("Are you sure you want to delete file?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  categoryData[category]!.removeAt(index); // Delete the item
                });
                String media_type = category.toLowerCase();
                if (media_type == "voices")
                  media_type = "audio";
                else
                  media_type = media_type.substring(0, media_type.length - 1);
                await fastapi.DeleteItems(
                    context, currentGroupCode!, index, media_type);
                Navigator.pop(context); // Close the dialog after deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("File Deleted Successfully"),
                      backgroundColor: Colors.lightGreen),
                );
              },
              child: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.redAccent), // Optional: make the delete button red
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTextStory(String title, String content) async {
    // Example: Adding the story to the categoryData

    try {
      await fastapi.UploadStories(
        context,
        title,
        content,
        currentGroupCode!,
      );

      setState(() {
        categoryData["Stories"]!.add({
          "title": title,
          "content": content,
          // URL returned from Cloudinary
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story Added Successfully')),
      );
    } catch (e) {
      print("Error uploading story: $e");
    }
  }

  void _EditStory(int index) {
    // Initialize controllers with the current title and content
    final titleController =
        TextEditingController(text: categoryData["Stories"]![index]['title']);
    final contentController =
        TextEditingController(text: categoryData["Stories"]![index]['content']);
    ;

    // Show a dialog box for editing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Story'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save the new title and content
                final newTitle = titleController.text.trim();
                final newContent = contentController.text.trim();

                // Ensure both title and content are not empty
                if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                  setState(() {
                    categoryData["Stories"]![index]['title'] = newTitle;
                    categoryData["Stories"]![index]['content'] = newContent;
                  });
                  // Use the onEdit callback to update the specific index
                  fastapi.UpdateStory(
                      context, currentGroupCode!, index, newTitle, newContent);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Story Edited Successfully')),
                  );
                } else {
                  // Show an error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Title and Content cannot be empty')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteStory(int index) {
    showDialog(
      context: context,
      builder: (context) {
        print(index);
        return AlertDialog(
          title: const Text("Delete File"),
          content: const Text("Are you sure you want to delete file?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  categoryData["Stories"]!.removeAt(index); // Delete the item
                });
                await fastapi.DeleteStory(context, currentGroupCode!, index);
                Navigator.pop(context); // Close the dialog after deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Story Deleted Successfully"),
                      backgroundColor: Colors.lightGreen),
                );
              },
              child: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.redAccent), // Optional: make the delete button red
            ),
          ],
        );
      },
    );
  }

// Future<void> _pickAudioFromFiles() async {
//   // Open file picker for audio files
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.audio, // Only allow audio files
//   );
//
//   if (result != null) {
//     // Get the picked file
//     var pickedFile = result.files.single;
//
//     // Get the path of the selected audio file
//     String? filePath = pickedFile.path;
//
//     if (filePath != null) {
//       print("Audio file selected: $filePath");
//
//       // Here you would upload the file to Cloudinary or another storage service
//       // Assuming you have a function for uploading the file to Cloudinary:
//       var cloudinaryResponse = await uploadToCloudinary(filePath);
//
//       if (cloudinaryResponse != null && cloudinaryResponse["url"] != null) {
//         // Successfully uploaded to Cloudinary
//         setState(() {
//           categoryData["Voices"]!.add({
//             "file_name": pickedFile.name, // Using pickedFile.name
//             "url": cloudinaryResponse["url"], // URL returned from Cloudinary
//           });
//         });
//       } else {
//         print("Error uploading to Cloudinary");
//       }
//     } else {
//       print("Selected file has no path");
//     }
//   } else {
//     // User canceled the file picking
//     print("No audio file selected");
//   }
// }
}
