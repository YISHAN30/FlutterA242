import 'package:assignment2/view/taskscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment2/view/loginscreen.dart';
import 'package:assignment2/model/user.dart';
import 'package:assignment2/view/historyscreen.dart';
import 'package:assignment2/view/editprofilescreen.dart';
import 'package:http/http.dart' as http;
import 'package:assignment2/myconfig.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User updatedUser;

  @override
  void initState() {
    super.initState();
    updatedUser = widget.user;
    fetchProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Main Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        ),
drawer: Drawer(
  child: Container(
    color: Colors.grey[100],
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Main', style: TextStyle(color: Colors.blue)),
                tileColor: Colors.blue.shade50,
                selected: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.task, color: Colors.green),
                title: const Text(
                  'Tasks',
                  style: TextStyle(color: Colors.green),
                ),
                hoverColor: Colors.green.shade50,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskScreen(user: updatedUser),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.deepOrange),
                title: const Text(
                  'History',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                hoverColor: Colors.deepOrange.shade50,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(user: widget.user),
                    ),
                  );
                },
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.purple),
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.purple),
                ),
                hoverColor: Colors.purple.shade50,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(user: updatedUser),
                    ),
                  );
                  fetchProfile();
                },
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          hoverColor: Colors.red.shade50,
          onTap: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  ),
                child: const Text('Logout'),
                onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );
      if (shouldLogout == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      ),
      ],
    ),
  ),
),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Worker Details Title Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: Text(
                      "---------- Worker Details ----------",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 18.0),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 450.0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Worker Details Content
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Worker ID: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${updatedUser.userId}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Full Name: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${updatedUser.userName}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Email: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${updatedUser.userEmail}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Phone: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${updatedUser.userPhone}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Address: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${updatedUser.userAddress}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 180),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EditProfileScreen(user: updatedUser),
                              ),
                            );
                            fetchProfile();
                          },

                          icon: const Icon(Icons.edit),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(user: updatedUser),
                  ),
                );
              },
              icon: const Icon(Icons.task_alt),
              label: const Text("View My Task", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText buildInfoText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20, color: Colors.white),
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Future<void> fetchProfile() async {
    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/assignment2/get_profile.php"),
      body: {'user_id': widget.user.userId},
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        setState(() {
          updatedUser = User(
            userId: jsonData['data']['user_id'].toString(),
            userName: jsonData['data']['user_name'].toString(),
            userEmail: jsonData['data']['user_email'].toString(),
            userPhone: jsonData['data']['user_phone'].toString(),
            userAddress: jsonData['data']['user_address'].toString(),
          );
        });
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('remember');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
