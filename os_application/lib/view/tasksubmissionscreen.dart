import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:os_application/myconfig.dart';
import 'package:os_application/model/worker.dart';
import 'package:os_application/view/checkoutscreen.dart';
import 'package:os_application/model/task.dart'; // Assuming task.dart is inside model/

class TaskSubmissionScreen extends StatefulWidget {
  final Worker worker;

  const TaskSubmissionScreen({super.key, required this.worker});

  @override
  State<TaskSubmissionScreen> createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends State<TaskSubmissionScreen> {
  late List<Task> taskListCopy;

  @override
  void initState() {
    super.initState();
    taskListCopy =
        taskList
            .map((task) => Task(taskid: task.taskid, taskName: task.taskName))
            .toList();
  }

  void _submitTasks() async {
    List<String> completedTasks =
        taskListCopy
            .where((task) => task.isChecked)
            .map((task) => task.taskName)
            .toList();

    if (completedTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check at least one task before submitting."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd').format(now);

    var response = await http.post(
      Uri.parse("${MyConfig.server}/tasksubmission_worker.php"),
      body: {
        "worker_id": widget.worker.workerId,
        "worker_name": widget.worker.workerName,
        "submission_date": date,
        "tasks_completed": completedTasks.join(', '), // fixed key here
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Success"),
                  content: Text(
                    jsonResponse['message'] ?? "Tasks submitted successfully.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => CheckoutScreen(worker: widget.worker),
                          ),
                        );
                      },
                      child: const Text("Ok"),
                    ),
                  ],
                ),
          );
          return;
        }
      } catch (e) {
        // JSON decode failed
        print("Error parsing response JSON: $e");
      }
    }

    // If here, submission failed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task submission failed."),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("Task Submission Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Worker ID: ${widget.worker.workerId}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Worker Name: ${widget.worker.workerName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Date: $today",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select completed tasks:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: taskListCopy.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(taskListCopy[index].taskName),
                    value: taskListCopy[index].isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        taskListCopy[index].isChecked = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _submitTasks,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Submit Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
