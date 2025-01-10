import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Models/UserState.dart';
import 'package:testapp/backend_connections/FASTAPI.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<Group> groups = [];
  Group? selectedGroup;
  List<dynamic> groupMembers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userState = Provider.of<UserState>(context, listen: false);
      final response = await FASTAPI().getUserData(context, userState.currentUser!.email);
      setState(() {
        groups = (response['groups'] as List)
            .map((group) => Group.fromJson(group))
            .toList();
      });
    } catch (e) {
      print("Error fetching groups: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load groups")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchGroupMembers(String groupCode) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await FASTAPI().getGroupMembers(context, groupCode);
      setState(() {
        groupMembers = response['members'];
      });
    } catch (e) {
      print("Error fetching group members: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> leaveGroup(String groupCode) async {
    try {
      final userState = Provider.of<UserState>(context, listen: false);
      await FASTAPI().leaveGroup(context, userState.currentUser!.email, groupCode);

      // Fetch updated user data from the backend
      final updatedUserData = await FASTAPI().getUserData(context, userState.currentUser!.email);

      // Update the `UserState` with the new user data
      userState.updateUser(User.fromJson(updatedUserData));

      setState(() {
        groups.removeWhere((group) => group.groupCode == groupCode);
        selectedGroup = null;
        groupMembers = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully left the group.")),
      );
    } catch (e) {
      print("Error leaving group: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to leave the group.")),
      );
    }
  }

  Future<void> removeMember(String groupCode, String email) async {
    try {
      await FASTAPI().removeGroupMember(context, groupCode, email);
      setState(() {
        groupMembers.removeWhere((member) => member['email'] == email);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Member removed successfully.")),
      );
    } catch (e) {
      print("Error removing member: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove member.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        backgroundColor: Colors.teal,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      group.groupName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Code: ${group.groupCode}"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                    onTap: () {
                      setState(() {
                        selectedGroup = group;
                      });
                      fetchGroupMembers(group.groupCode);
                    },
                  ),
                );
              },
            ),
          ),
          if (selectedGroup != null)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Group: ${selectedGroup!.groupName}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    SizedBox(height: 8),
                    Text("Code: ${selectedGroup!.groupCode}"),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupMembers.length,
                        itemBuilder: (context, index) {
                          final member = groupMembers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(member['email']),
                              subtitle: Text("Joined: ${member['joined_at']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  removeMember(selectedGroup!.groupCode, member['email']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          leaveGroup(selectedGroup!.groupCode);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Leave Group",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
