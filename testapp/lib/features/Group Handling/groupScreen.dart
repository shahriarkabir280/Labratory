import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import '../../Models/UserState.dart';
import '../../backend_connections/FASTAPI.dart';
import 'createandjoingroup.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<Group> groups = [];
  Group? selectedGroup;
  List<dynamic> groupMembers = [];

  bool isLoading = false;
  bool isMemberLoading = false;
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
      isMemberLoading = true;
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
        isMemberLoading = false;
      });
    }
  }



  Future<void> leaveGroup(String groupCode) async {
    try {
      final userState = Provider.of<UserState>(context, listen: false);
      final currentGroupCode = userState.currentUser?.currentGroup?.groupCode;

      await FASTAPI().leaveGroup(context, userState.currentUser!.email, groupCode);

      // Fetch updated user data from the backend
      final updatedUserData = await FASTAPI().getUserData(context, userState.currentUser!.email);

      // Update the `UserState` with the new user data
      userState.updateUser(User.fromJson(updatedUserData));

      // Check if the group being left is the current group
       if (currentGroupCode == groupCode) {
        if (updatedUserData['groups'].isNotEmpty) {
          // If there are still groups, set the first group as the current group
          final newCurrentGroup = Group.fromJson(updatedUserData['groups'][0]);
          userState.updateCurrentGroup(newCurrentGroup);
        } /*else {
          // If no groups remain, redirect the user to CreateandJoinGroup
          userState.updateCurrentGroup(null); // Clear current group
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You must be a member of at least one group."),
              backgroundColor: Colors.redAccent,
            ),
          );

          return;
        }*/
      }

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
    return SafeArea( // Ensures proper padding for the UI
      child: Scaffold(
        appBar: AppBar(
          title: Text("Groups"),
          backgroundColor: Colors.teal,
          elevation: 1,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : groups.isEmpty // Check if no groups exist
            ? _buildNoGroupsPlaceholder(context) // Show placeholder UI
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
                      subtitle: Row(
                        children: [
                          Expanded(child: Text("Code: ${group.groupCode}")),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.teal),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: group.groupCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Group code copied to clipboard!")),
                              );
                            },
                          ),
                        ],
                      ),
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
                  child: isMemberLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Group: ${selectedGroup!.groupName}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              leaveGroup(selectedGroup!.groupCode);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Leave Group",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
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
                                    removeMember(
                                        selectedGroup!.groupCode, member['email']);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a placeholder UI when no groups are available
  Widget _buildNoGroupsPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 80, color: Colors.teal),
          SizedBox(height: 20),
          Text(
            "You have not created any group.",
            style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateandJoinGroup()),
              );
            },
           // icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              "Create Group",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

