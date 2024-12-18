import 'package:flutter/material.dart';
import 'package:testapp/authentications/PasswordGenerator.dart';
import 'package:testapp/authentications/loginScreen.dart';
import 'package:testapp/features/mainHomepage.dart';

import 'package:testapp/backend_connections/FASTAPI.dart';

final FASTAPIhere FastAPIonthego = FASTAPIhere();

class createOrJoinGroup extends StatefulWidget {
  final String email;

  createOrJoinGroup({required this.email});

  @override
  _CreateOrJoinGroupState createState() => _CreateOrJoinGroupState();
}

class _CreateOrJoinGroupState extends State<createOrJoinGroup> {
  final _groupNameController = TextEditingController();
  final _groupCodeController = TextEditingController();

  bool _isJoiningGroup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Banner Section
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage('assets/authentications/banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Heading
              Text(
                "Create or Join Your First Group",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 15),
              // Group Name Input Field
              if (!_isJoiningGroup)
                Column(
                  children: [
                    _buildTextField(
                      controller: _groupNameController,
                      label: "Group Name",
                      icon: Icons.group,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have a code?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isJoiningGroup = true;
                            });
                          },
                          child: Text(
                            "Join Group",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (_isJoiningGroup) ...[
                Text(
                  "Enter Group Code",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _groupCodeController,
                  label: "Group Code",
                  icon: Icons.vpn_key,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Want to create a new group?",
                      style: TextStyle(fontSize: 16, color: Colors.teal[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isJoiningGroup = false;
                        });
                      },
                      child: Text(
                        "Create Group",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              // Cancel and Done Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => loginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  // Done Button
                  ElevatedButton(
                    onPressed: () async {
                      // Validation Logic for Group Name
                      String groupName = _groupNameController.text.trim();
                      String groupCode = _groupCodeController.text.trim();
                      if (groupCode.isEmpty && groupName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Input field can not be empty",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else if ((groupName.isEmpty || groupName.length < 4) &&
                          groupCode.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Group Name must be at least 4 characters",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else if (groupCode.isNotEmpty) {
                        String grp =
                            await FastAPIonthego.find_group(context, groupCode);
                        if (grp !=  "-1") {
                          FastAPIonthego.group_create(
                              context, widget.email, grp, groupCode);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Joined Group Successfully",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.lightGreen,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  mainHomepage(groupName: grp),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Invalid Group Code",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      } else {
                        String password =
                            generatePassword(); // generating random password
                        FastAPIonthego.all_groups(context, groupName, password);
                        FastAPIonthego.group_create(context, widget.email,
                            _groupNameController.text, password);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Group Password",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17),
                                  // Default style
                                  children: [
                                    TextSpan(
                                        text: "Your Group Password is: \n\n"),
                                    TextSpan(
                                      text: password,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            mainHomepage(groupName: groupName),
                                      ),
                                    );
                                  },
                                  child: Text("OK",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          },
                        );
                        ;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Group Created Successfully",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.lightGreen,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Text Fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[600]),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[700]!),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
