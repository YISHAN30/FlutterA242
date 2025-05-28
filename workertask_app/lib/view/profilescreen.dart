import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workertask_app/model/worker.dart';
import 'loginscreen.dart';
import 'tasklistscreen.dart'; // <-- import task list screen

class ProfileScreen extends StatelessWidget {
  final Worker worker;

  const ProfileScreen({super.key, required this.worker});

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _viewTasks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskListScreen(worker: worker)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${worker.workerId}"),
            const SizedBox(height: 5),
            Text("Name: ${worker.workerName}"),
            const SizedBox(height: 5),
            Text("Email: ${worker.workerEmail}"),
            const SizedBox(height: 5),
            Text("Phone: ${worker.workerPhone}"),
            const SizedBox(height: 5),
            Text("Address: ${worker.workerAddress}"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _viewTasks(context),
                child: const Text("View Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
