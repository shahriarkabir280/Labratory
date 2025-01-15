import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/features/TimeCapsule/timeCapsuleScreen.dart';
import 'package:testapp/features/EventPlanning/eventPlanningPage.dart';
import 'package:testapp/features/Document%20store/document_storage_page.dart';
import 'package:testapp/features/Expense%20Tracking/expenseTrackingScreen.dart';
import '../../authentications/loginScreen.dart';
import '../Drawer/about.dart';
import '../Drawer/changePassword.dart';
import '../Drawer/privacyPolicy.dart';
import '../Drawer/termsAndConditions.dart';
import 'package:testapp/features/Drawer/editProfile.dart';

import '../Group Handling/createandjoingroup.dart';
import '../Group Handling/groupScreen.dart';

class mainHomepage extends StatefulWidget {
  @override
  _MainHomepageState createState() => _MainHomepageState();
}


class _MainHomepageState extends State<mainHomepage> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

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
    Colors.orangeAccent,
    Colors.lightBlueAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
  ];

  bool isCreateGroupActive = false;
  bool isGroupsActive = false;

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
    final groups = userState.currentUser?.groups ?? [];
    final currentGroup = userState.currentUser?.currentGroup;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: DropdownButton<Group>(
          value: groups.contains(currentGroup) ? currentGroup : null,
          onChanged: (Group? newGroup) {
            if (newGroup != null) {
              userState.updateCurrentGroup(newGroup);
            }
          },
          hint: Text(
            "Select Group",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          dropdownColor: Colors.white,


          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          underline: SizedBox(), // Removes the default underline
          items: groups.map<DropdownMenuItem<Group>>((Group group) {
            return DropdownMenuItem<Group>(
              value: group,
              child: Row(
                children: [
                  Icon(
                    Icons.group, // Add a group icon to enhance the look
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    group.groupName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,

                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        backgroundColor: Colors.teal,




      ),




      drawer: _buildDrawer(context, userState),
      backgroundColor: Colors.grey[100],
      body: _buildBody(),
      floatingActionButton: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isCreateGroupActive = !isCreateGroupActive;
                  isGroupsActive = false;
                });
                // Navigate to Create Group screen
                Navigator.push(context, MaterialPageRoute(builder: (context) =>CreateandJoinGroup()));
              },
              icon: Icon(
                Icons.group_add,
                color: isCreateGroupActive ? Colors.teal : Colors.black,
              ),
              tooltip: 'Create Group',
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  isGroupsActive = !isGroupsActive;
                  isCreateGroupActive = false;
                });
                // Navigate to Groups screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroupsScreen()));
              },
              icon: Icon(
                Icons.groups,
                color: isGroupsActive ? Colors.teal : Colors.black,
              ),
              tooltip: 'Groups',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );


  }

  Widget _buildDrawer(BuildContext context, UserState userState) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildProfileHeader(userState,context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildShadowedTile(
                  icon: Icons.group,
                  text: 'Groups',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupsScreen()));
                  },
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

  Widget _buildProfileHeader(UserState userState, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40.0),
          decoration: BoxDecoration(color: Colors.teal),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: userState.currentUser?.profilePictureUrl != null
                    ? NetworkImage(userState.currentUser!.profilePictureUrl!)
                    : AssetImage('assets/default_profile_picture.png') as ImageProvider,
                backgroundColor: Colors.black12,
              ),
              SizedBox(height: 10),
              Text(
                userState.currentUser?.name ?? 'User Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 30, // Adjust this value to move the pen icon below the profile image
          right: 70,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to the editProfile.dart screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
        ),

      ],
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
    final List<Color> iconColors = [
      Colors.deepOrange,
      Colors.blue,
      Colors.pink,
      Colors.green,
    ];

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
                color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _gridIcons[index],
                      size: 48,
                      color: iconColors[index],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _headlines[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _descriptions[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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








  Widget _buildShadowedTile({
    required IconData icon,
    required String text,
    required Function() onTap,
    required Color iconColor,
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
              Icon(icon, color: iconColor),
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
