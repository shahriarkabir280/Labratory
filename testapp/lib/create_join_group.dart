import 'package:flutter/material.dart';
import 'create_group.dart';
import 'join_group.dart';

// Create Join Group Activity
class CreateJoinActivity extends StatelessWidget{
  const CreateJoinActivity({super.key}); // constructor
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Scaffold (occupies the whole device screen)
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.teal[50]),
        body: Container(
          color: Colors.teal[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start, // Aligns children at the top
                children: [
                  //SizedBox(height: screenHeight * 0.01), // Adds space at the top
                  Container(
                    child: Image.asset(
                      'assets/images/Create_or_join_group.png',
                      height: 290,
                      width: 290,
                      //fit: BoxFit.cover, // Adjusts how the image fits inside the container
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01), // Adds space between the image and the text
                  Text('Create or Join Group', style: TextStyle(color: Colors.deepPurple, fontSize: 32, fontWeight: FontWeight.bold,),),
                  SizedBox(height: screenHeight * 0.07),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroupActivity()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Button's background color
                      foregroundColor: Colors.white,     // Text color
                      shadowColor: Colors.grey,          // Shadow color
                      elevation: 8,                      // Elevation for the button's shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14), // Rounded corners
                      ),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>JoinGroupActivity()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Button's background color
                      foregroundColor: Colors.white,     // Text color
                      shadowColor: Colors.grey,          // Shadow color
                      elevation: 8,                      // Elevation for the button's shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14), // Rounded corners
                      ),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text(
                      "Join",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}