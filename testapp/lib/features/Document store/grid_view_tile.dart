import 'package:flutter/material.dart';
import 'package:testapp/features/Document store/category_page.dart';

class GridViewTile extends StatelessWidget {
  final String category;

  GridViewTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Adds shadow to make it look elevated
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for a softer look
      ),
      margin: EdgeInsets.all(10), // Add some spacing between grid items
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // Makes the tap area have rounded corners as well
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CategoryPage(categoryName: category)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the card
            borderRadius: BorderRadius.circular(12), // Round the corners for the background
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), // Light shadow
                blurRadius: 8, // Blur radius for the shadow
                offset: Offset(0, 4), // Offset for the shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.folder,
                size: 50,
                color: Colors.blueAccent, // Custom icon color
              ),
              SizedBox(height: 10), // Space between icon and text
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Make category name bold
                  color: Colors.black87, // Text color
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
