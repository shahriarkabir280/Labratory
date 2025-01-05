import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';
import 'package:testapp/features/timeCapsuleScreen.dart';
import 'package:testapp/features/eventPlanningPage.dart';
import 'package:testapp/features/Document store/document_storage_page.dart';
import 'package:testapp/features/Expense Tracking/expenseTrackingScreen.dart';
import '../authentications/loginScreen.dart';
import 'Drawer/about.dart';
import 'Drawer/changePassword.dart';
import 'Drawer/editProfile.dart';
import 'Drawer/privacyPolicy.dart';
import 'Drawer/termsAndConditions.dart';

class mainHomepage extends StatefulWidget {
  @override
  _MainHomepageState createState() => _MainHomepageState();
}

class _MainHomepageState extends State<mainHomepage> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;
  int _currentIndex = 0;

  final List<String> _slideshowImages = [
    'assets/slideshowimages/slide1.jpg',
    'assets/slideshowimages/slide2.png',
    'assets/slideshowimages/slide3.jpg',
  ];

  final List<IconData> _gridIcons = [
    Icons.bar_chart,
    Icons.folder,
    Icons.event,
    Icons.picture_in_picture_alt_sharp,
  ];

  final List<String> _headlines = [
    'Expense Tracking',
    'Documents',
    'Plan Events',
    'Memories',
  ];

  final List<String> _descriptions = [
    'Track your family expenses effortlessly.',
    'Store and access important documents.',
    'Keep track of upcoming events.',
    'Save precious family moments.',
  ];

  final List<Color> _colors = [
    Colors.teal[300]!,
    Colors.teal[400]!,
    Colors.teal[500]!,
    Colors.teal[600]!,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slideshowImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: true);
    final groupName = userState.currentUser?.groups.isNotEmpty == true
        ? userState.currentUser!.groups.first.groupName
        : 'No Group';

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, userState),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer(BuildContext context, UserState userState) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildProfileHeader(userState),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildShadowedTile(
                  icon: Icons.home,
                  text: 'Home',
                  onTap: () => Navigator.pop(context),
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.lock_outlined,
                  text: 'Change Password',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  ),
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.dark_mode,
                  text: 'Dark Mode',
                  onTap: () {},
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.check_box,
                  text: 'Terms and Conditions',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()),
                  ),
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.policy,
                  text: 'Privacy Policy',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Privacy()),
                  ),
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.info_outline,
                  text: 'About',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => About()),
                  ),
                  iconColor: Colors.teal,
                ),
                _buildShadowedTile(
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {
                    userState.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => loginScreen()),
                    );
                  },
                  iconColor: Colors.teal,
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserState userState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(color: Colors.teal),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/user_image.png'),
            backgroundColor: Colors.black12,
          ),
          SizedBox(height: 10),
          Text(
            userState.currentUser?.name ?? 'User Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Text(
            'FamNest',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 4),
          Text(
            'Your Family Management App',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSlideshow(),
        const SizedBox(height: 25),
        _buildGrid(),
      ],
    );
  }

  Widget _buildSlideshow() {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slideshowImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(_slideshowImages[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slideshowImages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.teal : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: _gridIcons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _handleGridTap(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: _colors[index],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_gridIcons[index], size: 40, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      _headlines[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _descriptions[index],
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleGridTap(int index) {
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseTrackingScreen()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => documentStoragePage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => eventPlannerPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => timeCapsuleScreen()));
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.pop(context);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create Group'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
      ],
    );
  }


  Widget _buildShadowedTile({
    required IconData icon,
    required String text,
    required Function() onTap,
    required Color iconColor, // Correctly use iconColor parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon, color: iconColor),  // Use iconColor for the icon color
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
