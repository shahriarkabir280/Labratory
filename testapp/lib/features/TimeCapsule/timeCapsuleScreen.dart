import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import '../../Models/UserState.dart';
import 'Categories/image_category.dart';
import 'Categories/video_category.dart';


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
        print("hello lad");
        if (currentGroupCode != null) {
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
      fetchMediaFiles(currentGroupCode!, selectedCategory.toLowerCase());
    }
  }

  Future<void> fetchMediaFiles(String groupCode, String media_type) async {
    media_type = media_type.substring(0, media_type.length - 1);
    try {
      final mediafiles =
          await fastapi.FetchMediaFiles(context, groupCode, media_type);
      setState(() {
        if (media_type == "image")
          categoryData["Images"] = mediafiles;
        else if (media_type == "video") categoryData["Videos"] = mediafiles;
      });
      print("fetch part e asi categoryData['Images']: ${categoryData["Images"]}");
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
            print("upload part e asi categoryData['Images']: ${categoryData["Images"]}");
          });
        }
//print("upload part er baireeee categoryData['Images']: ${categoryData["Images"]}");
      } catch (e) {
        print("Error uploading image: $e");
      }
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
          preferredSize: isSearchBarVisible
              ? const Size.fromHeight(150)
              : const Size.fromHeight(50),
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
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.transparent, // Transparent since the tabs will have their own colors
                ),
                indicatorWeight: 0.0, // This removes the thin indicator line
                labelPadding: EdgeInsets.zero, // Ensures tabs fill the width evenly
                tabs: [
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13), // Rounded top left corner
                        topRight: Radius.circular(13), // Rounded top right corner
                      ),
                      child: Container(
                        color: Colors.lightBlueAccent.withOpacity(0.8), // Full background color
                        alignment: Alignment.center,
                        child: const Text(
                          "Images",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13), // Rounded top left corner
                        topRight: Radius.circular(13), // Rounded top right corner
                      ),
                      child: Container(
                        color: Colors.orangeAccent.withOpacity(0.9) ,// Full background color
                        alignment: Alignment.center,
                        child: const Text(
                          "Videos",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13), // Rounded top left corner
                        topRight: Radius.circular(13), // Rounded top right corner
                      ),
                      child: Container(
                        color: Colors.orange, // Full background color
                        alignment: Alignment.center,
                        child: const Text(
                          "Voices",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13), // Rounded top left corner
                        topRight: Radius.circular(13), // Rounded top right corner
                      ),
                      child: Container(
                        color: Colors.purple, // Full background color
                        alignment: Alignment.center,
                        child: const Text(
                          "Stories",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )

              ,
            ],
          ),
        ),
        elevation: 0, // Remove the shadow below the AppBar
        backgroundColor: Colors.transparent,// Set AppBar background to transparent if needed
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
          //   StoryCategory(
          //     items: categoryData["Stories"]!,
          //     searchQuery: searchQuery,
          //     searchController: _searchController,
          //     onRename: _renameItem,
          //     onDelete: _deleteItem,
          //   ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  StatelessWidget _buildFloatingActionButton() {
    final categoryIcons = {
      "Images": Icons.add_a_photo,
      "Videos": Icons.videocam,
      "Audio": Icons.mic,
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
      // case "Audio":
      //   showModalBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           ListTile(
      //             leading: const Icon(Icons.mic),
      //             title: const Text("Record Audio"),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _recordAudio();
      //             },
      //           ),
      //           ListTile(
      //             leading: const Icon(Icons.audiotrack),
      //             title: const Text("Select from Files"),
      //             onTap: () async {
      //               Navigator.pop(context);
      //               await _pickAudioFromFiles();
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   break;
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
                media_type = media_type.substring(0, media_type.length - 1);
                await fastapi.RenameItems(
                    context, currentGroupCode!, index, renameController.text , media_type);
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
                media_type = media_type.substring(0, media_type.length - 1);
                await fastapi.DeleteItems(context, currentGroupCode!, index, media_type);
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
}
