import 'dart:convert';
import 'package:assignment2/view/submitscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:assignment2/model/user.dart';
import 'package:assignment2/model/task.dart';
import 'package:assignment2/myconfig.dart';

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
      final response = await http.post(
        url,
        body: {'user_id': widget.user.userId},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            tasks =
                (jsonData['data'] as List)
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
        builder:
            (context) => SubmitScreen(task: task.toJson(), user: widget.user),
      ),
    ).then((value) {
      loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _buildBody(),
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
            Text("Error loading tasks", style: TextStyle(color: Colors.red)),
            Text(errorMessage!),
            ElevatedButton(onPressed: loadTasks, child: Text("Retry")),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            title: Text(
              task.title ?? "No Title",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: ${task.description ?? 'No description'}"),
                Text("Due Date: ${task.dueDate ?? 'No due date'}"),
                Text("Status: ${task.status ?? 'Unknown'}"),
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
