import 'package:flutter/material.dart';
import 'create_join_group.dart';

// Create Group Activity
class CreateGroupActivity extends StatelessWidget{
  const CreateGroupActivity({super.key});
  @override
  Widget build(BuildContext context){
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.teal[50]),
      body: Container(
        color: Colors.teal[50],
        child: Center( // Ensures the content is centered horizontally and vertically
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns children at the top
            crossAxisAlignment: CrossAxisAlignment.center, // Centers children horizontally
            children: [
              //SizedBox(height: screenHeight * 0.01), // Adds space at the top
              Container(
                child: Image.asset(
                  'assets/images/Create_or_join_group.png',
                  height: 270,
                  width: 270,
                  //fit: BoxFit.cover, // Adjusts how the image fits inside the container
                ),
              ),
              Text(
                'Create Your First Group',
                style: TextStyle(color: Colors.purple ,fontSize: 29, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.035),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adds padding around the TextField
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Group Name",
                    hintStyle: TextStyle(
                      fontSize: 20,  // Adjust this value to increase or decrease the font size
                      color: Colors.black54,  // Optional: Customize hint text color
                    ),
                    border: OutlineInputBorder(),// Adds a border to the TextField
                    prefixIcon: Icon(
                      Icons.group,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // Button's background color
                  foregroundColor: Colors.white,     // Text color
                  shadowColor: Colors.grey,          // Shadow color
                  elevation: 6,                      // Elevation for the button's shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(height: screenHeight * 0.09),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateJoinActivity()));
              //   },
              //   style: ElevatedButton.styleFrom(     // Text color
              //     shadowColor: Colors.grey,          // Shadow color
              //     elevation: 3,                      // Elevation for the button's shadow
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(0), // Rounded corners
              //     ),
              //   ),
              //   child: Text(
              //     "Back",
              //     style: TextStyle(
              //       fontSize: 17,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}