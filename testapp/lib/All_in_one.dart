import 'package:flutter/material.dart';

class AllInOnePage extends StatefulWidget {
  const AllInOnePage({super.key});

  @override
  State<AllInOnePage> createState() => _AllInOnePageState();
}

class _AllInOnePageState extends State<AllInOnePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal[50],
      appBar: AppBar(backgroundColor: Colors.lightGreenAccent,toolbarHeight: 30),
      drawer: Drawer(
        child: ListView(
          children: [
            // DrawerButton(),
            Container(
              height: 150,
                width: 200,
                color: Colors.grey,
                child: DrawerHeader(child: Text('Profile',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),))),
            // DrawerButtonIcon()
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView for horizontal scrolling
            Column(
              children: [
                Container(
                  color: Colors.lightGreenAccent,
                  height : 300,
                  width : 500,
                  child: Column(
                    children: [
                      SizedBox(height: 6),
                      SizedBox(
                        height: 255, // Height for the PageView
                        width: 328,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            _buildImageContainer('assets/images/picture2.jpg', Colors.orange.shade200),
                            _buildImageContainer('assets/images/picture3.png', Colors.lightGreenAccent),
                            _buildImageContainer('assets/images/picture1.png', Colors.redAccent[100]!),
                            _buildImageContainer('assets/images/picture4.png', Colors.lightGreenAccent),
                            _buildImageContainer('assets/images/picture5.png', Colors.lightGreenAccent),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Dot Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5, // Number of dots
                              (index) => _buildDot(index == _currentPage),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height : 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width : 150,
                    height: 120,
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
                    height : 85,
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3),

              ],
            ),
            const SizedBox(height: 25),
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
                    height: 120,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imagePath, Color color) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          //fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildButton(String text, Color color, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shadowColor: Colors.grey,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
