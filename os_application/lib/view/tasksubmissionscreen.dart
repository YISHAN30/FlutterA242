import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_application/myconfig.dart';
import 'package:os_application/model/user.dart';
import 'package:os_application/view/checkoutscreen.dart';
import 'package:http/http.dart' as http;

class TaskSubmissionScreen extends StatefulWidget {
  final User user;

  const TaskSubmissionScreen({super.key, required this.user});

  @override
  State<TaskSubmissionScreen> createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends State<TaskSubmissionScreen> {
  List<bool> taskCompleted = [false, false, false];
  List<String> tasks = [
    'Sweep the floor',
    'Mop the floor',
    'Dust furniture and fixtures',
    'Clean windows and mirrors',
    'Change bed linens',
    'Vacuum carpets and rugs',
    'Clean bathroom (toilet, sink, shower)',
    'Empty trash bins',
    'Wipe kitchen counters and appliances',
    'Restock toiletries and supplies',
  ];

  void _submitTasks() async {
    List<String> completedTasks = [];
    for (int i = 0; i < taskCompleted.length; i++) {
      if (taskCompleted[i]) completedTasks.add(tasks[i]);
    }

    if (completedTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete at least one task before submitting"),
        ),
      );
      return;
    }

    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd').format(now);

    var response = await http.post(
      Uri.parse(
        "${MyConfig.server}/os_application/php/tasksubmission_user.php",
      ),
      body: {
        "userid": widget.user.userId,
        "name": widget.user.userName,
        "date": date,
        "tasks": completedTasks.join(', '),
      },
    );

    if (response.statusCode == 200 && response.body == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task submitted successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => CheckoutScreen(user: widget.user),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task submission failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Submission")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("User ID: ${widget.user.userId}"),
            Text("Name: ${widget.user.userName}"),
            const SizedBox(height: 20),
            const Text("Complete your tasks:"),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(tasks[index]),
                    value: taskCompleted[index],
                    onChanged: (value) {
                      setState(() {
                        taskCompleted[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitTasks,
              child: const Text("Submit Tasks"),
            ),
          ],
        ),
      ),
    );
  }
}
