import 'package:flutter/material.dart';

class AllInOnePage extends StatelessWidget {
  const AllInOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal.shade100,
      //appBar: AppBar(),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 165, width: 220,
                      margin: EdgeInsets.all(15),
                      //padding: EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Match the border radius
                          child: Image.asset(
                            'assets/images/picture2.jpg',
                            fit: BoxFit.cover, // Adjust how the image fits inside
                          ),
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      height: 180, width: 220,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.redAccent[100],
                          borderRadius: BorderRadius.circular(8)
                      ),
                      // child: Center(child: Text('Picture1')),
                      child: Image.asset(
                        'assets/images/picture1.png',
                        //fit: BoxFit.cover, // Adjusts how the image fits inside the container
                      ),
                    ),
                    Container(
                      height: 180, width: 220,
                      margin: EdgeInsets.all(15),
                      // padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Match the border radius
                        child: Image.asset(
                          'assets/images/picture3.png',
                          fit: BoxFit.cover, // Adjust how the image fits inside
                        ),
                      ),
                    ),
                    Container(
                      height: 180, width: 220,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Image.asset(
                        'assets/images/picture4.png',

                        fit: BoxFit.cover, // Adjusts how the image fits inside the container
                      ),
                    ),
                    Container(
                      height: 180, width: 300,
                      margin: EdgeInsets.all(15),
                      // padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          // color: Colors.orangeAccent.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Match the border radius
                        child: Image.asset(
                          'assets/images/picture5.png',
                          fit: BoxFit.cover, // Adjust how the image fits inside
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height : 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width : 145,
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue, // Button's background color
                          foregroundColor: Colors.white,     // Text color
                          shadowColor: Colors.grey,          // Shadow color
                          elevation: 6,                      // Elevation for the button's shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                        child: Text(
                          "Expense \n Tracker",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.05),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      width: 160,
                      height : 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen, // Button's background color
                          foregroundColor: Colors.white,     // Text color
                          shadowColor: Colors.grey,          // Shadow color
                          elevation: 6,                      // Elevation for the button's shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),

                        child: Text(
                          "Document",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: 160,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent, // Button's background color
                          foregroundColor: Colors.white,     // Text color
                          shadowColor: Colors.grey,          // Shadow color
                          elevation: 6,                      // Elevation for the button's shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                        child: Text(
                          "   Fam \nCalender",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: 150,
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent, // Button's background color
                          foregroundColor: Colors.white,     // Text color
                          shadowColor: Colors.grey,          // Shadow color
                          elevation: 6,                      // Elevation for the button's shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                        child: Text(
                          "  Time \nCapsule",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
