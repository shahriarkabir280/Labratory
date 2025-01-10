import 'package:flutter/material.dart';
import 'package:testapp/features/Document store/folder_page.dart';
import 'package:testapp/features/Document%20store/recent_files_list.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;

  CategoryPage({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(  // Making the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Folders",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // GridView inside SingleChildScrollView
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(), // Disable internal scroll of GridView
                children: [
                  _buildFolderCard(
                    context,
                    folderName: 'Docs',
                    icon: Icons.description,
                    color: Colors.blue,
                  ),
                  _buildFolderCard(
                    context,
                    folderName: 'Images',
                    icon: Icons.image,
                    color: Colors.orange,
                  ),
                  _buildFolderCard(
                    context,
                    folderName: 'Videos',
                    icon: Icons.video_library,
                    color: Colors.green,
                  ),
                  _buildFolderCard(
                    context,
                    folderName: 'Music',
                    icon: Icons.music_note,
                    color: Colors.purple,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Recent Files", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              RecentFilesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, {required String folderName, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FolderPage(folderName: folderName)),
        );
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 25, color: color),
              SizedBox(height: 8),
              Text(
                folderName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
