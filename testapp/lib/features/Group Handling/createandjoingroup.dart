import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend_connections/FASTAPI.dart';
import '../../Models/UserState.dart';
import '../HomepageHandling/mainHomepage.dart';
import '../../authentications/loginScreen.dart';
import '../../authentications/PasswordGenerator.dart';

class CreateandJoinGroup extends StatefulWidget {
  @override
  _CreateOrJoinGroupState createState() => _CreateOrJoinGroupState();
}

class _CreateOrJoinGroupState extends State<CreateandJoinGroup> {
  final _groupNameController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final FASTAPI fastAPI = FASTAPI();

  bool _isJoiningGroup = false;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);
    final email = userState.currentUser?.email ?? '';

    return SafeArea( // Wrap the entire Scaffold in a SafeArea
      child: Scaffold(
        backgroundColor: Colors.teal[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
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
                Text(
                  "Create or Join Your First Group",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                const SizedBox(height: 15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => mainHomepage()),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String groupName = _groupNameController.text.trim();
                        String groupCode = _groupCodeController.text.trim();

                        if (groupName.isEmpty && groupCode.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Input field cannot be empty",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (groupCode.isNotEmpty) {
                          try {
                            final response = await fastAPI.joinGroup(context, email, groupCode);
                            if (response["success"] == true) {
                              final group = Group.fromJson(response['group']);
                              userState.addGroup(group);
                              userState.setCurrentGroup(group);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => mainHomepage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to join group"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid Group Code"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        } else if (groupName.isNotEmpty) {
                          if (groupName.length < 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Group Name must be at least 4 characters"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          try {
                            String password = generatePassword();
                            final response = await fastAPI.createGroup(context, email, groupName, password);

                            if (response['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Created Group Successfully"),
                                  backgroundColor: Colors.lightGreen,
                                ),
                              );
                              final group = Group.fromJson(response['group']);

                              userState.addGroup(group);
                              userState.setCurrentGroup(group);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Group Password"),
                                    content: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black, fontSize: 17),
                                        children: [
                                          TextSpan(text: "Your Group Password is: \n\n"),
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
                                          Navigator.of(context).pop(); // Close the dialog
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => mainHomepage()),
                                          );
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              throw Exception("Failed to create group");
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to create group: $e"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
