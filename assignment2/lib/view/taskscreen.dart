import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment2/model/user.dart';
import 'package:assignment2/model/task.dart';
import 'package:assignment2/myconfig.dart';
import 'package:assignment2/view/editprofilescreen.dart';
import 'package:assignment2/view/historyscreen.dart';
import 'package:assignment2/view/loginscreen.dart';
import 'package:assignment2/view/profilescreen.dart';
import 'package:assignment2/view/submitscreen.dart';

class TaskScreen extends StatefulWidget {
  final User user;
  const TaskScreen({super.key, required this.user});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final url = Uri.parse("${MyConfig.myurl}/assignment2/get_works.php");
    try {
      final response = await http.post(url, body: {'user_id': widget.user.userId});
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            tasks = (jsonData['data'] as List)
                .map((taskJson) => Task.fromJson(taskJson))
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception(jsonData['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _navigateToSubmitScreen(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitScreen(task: task.toJson(), user: widget.user),
      ),
    ).then((value) => loadTasks());
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.task, color: Colors.green),
                title: const Text('Tasks', style: TextStyle(color: Colors.green)),
                hoverColor: Colors.green.shade50,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TaskScreen(user: widget.user)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.deepOrange),
                title: const Text('History', style: TextStyle(color: Colors.deepOrange)),
                hoverColor: Colors.deepOrange.shade50,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen(user: widget.user)),
                  );
                },
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.purple),
                title: const Text('Edit Profile', style: TextStyle(color: Colors.purple)),
                hoverColor: Colors.purple.shade50,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen(user: widget.user)),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            hoverColor: Colors.red.shade50,
            onTap: showLogoutConfirmation,
          ),
        ),
      ],
    ),
  ),
),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen(user: widget.user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(width: 8),
                  Text('View Submission History', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Error loading tasks", style: TextStyle(color: Colors.red)),
            Text(errorMessage!),
            ElevatedButton(onPressed: loadTasks, child: const Text("Retry")),
          ],
        ),
      );
    }

    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks assigned."));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            title: Text(task.title ?? "No Title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: ${task.description ?? 'No description'}", style: const TextStyle(fontSize: 16)),
                Text("Due Date: ${task.dueDate ?? 'No due date'}", style: const TextStyle(fontSize: 16)),
                Text("Status: ${task.status ?? 'Unknown'}", style: const TextStyle(fontSize: 16)),
              ],
            ),
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(16),
            onTap: () => _navigateToSubmitScreen(task),
          ),
        );
      },
    );
  }
}