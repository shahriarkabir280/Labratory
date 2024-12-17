import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FolderPage extends StatefulWidget {
  final String folderName;

  FolderPage({required this.folderName});

  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<String> folders = []; // List of folder names
  List<File> files = []; // List of picked files

  // Function to add a new folder
  void _addFolder() async {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Folder'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter folder name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  folders.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: Text('Create'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Function to pick files
  void _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        files.addAll(result.files.map((file) => File(file.path!)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.create_new_folder),
            onPressed: _addFolder,
          ),
        ],
      ),
      body: ListView(
        children: [
          // Section for folders
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Folders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          folders.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.folder, color: Colors.amber),
                title: Text(folders[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FolderPage(folderName: folders[index]),
                    ),
                  );
                },
              );
            },
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No folders available.',
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // Section for files
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Files',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          files.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                title: Text(files[index].path.split('/').last),
                subtitle: Text(
                  'File size: ${files[index].lengthSync()} bytes',
                ),
              );
            },
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No files added yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFile,
        child: Icon(Icons.add),
        tooltip: 'Add Files',
      ),
    );
  }
}
