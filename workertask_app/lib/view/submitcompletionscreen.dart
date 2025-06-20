import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/model/work.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/loginscreen.dart';
import 'package:workertask_app/view/registerscreen.dart';
import 'package:workertask_app/view/tasklistscreen.dart';
import 'package:workertask_app/view/submissionhistoryscreen.dart';

class SubmitCompletionScreen extends StatefulWidget {
  final Worker worker;
  final Work work;

  const SubmitCompletionScreen({
    super.key,
    required this.worker,
    required this.work,
  });

  @override
  State<SubmitCompletionScreen> createState() => _SubmitCompletionScreenState();
}

class _SubmitCompletionScreenState extends State<SubmitCompletionScreen> {
  final TextEditingController _completionController = TextEditingController();
  bool _isSubmitting = false;

  void _confirmSubmitDialog() {
    if (_completionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your work details"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Confirm Submission"),
            content: const Text(
              "Are you sure you want to submit your completed work?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _submitCompletion();
                },
                child: const Text("Submit"),
              ),
            ],
          ),
    );
  }

  void _submitCompletion() async {
    setState(() {
      _isSubmitting = true;
    });

    var response = await http.post(
      Uri.parse("${MyConfig.server}submit_work.php"),
      body: {
        'work_id': widget.work.workId,
        'worker_id': widget.worker.workerId,
        'submission_text': _completionController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Submission successful"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Submission failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Server error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Logout Confirmation"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 160, 236, 255),
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('images/Logo.png'),
                  radius: 40,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.worker.workerName ?? 'User',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.worker.workerEmail ?? '',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text("Register Account"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.task),
                  title: const Text("View Task"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskListScreen(worker: widget.worker),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Submission History"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                SubmissionHistoryScreen(worker: widget.worker),
                      ),
                    );
                  },
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text("More Info"),
                ),
                const ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text("Contact Us"),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text("Submit Completion"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _confirmLogout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Task ID: ${widget.work.workId}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Task: ${widget.work.title}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Description: ${widget.work.description}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Assigned Date: ${widget.work.dateAssigned}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Due Date: ${widget.work.dueDate}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),
            const Text(
              "What did you complete?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: TextField(
                controller: _completionController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe your completed work...",
                ),
              ),
            ),
            const SizedBox(height: 25),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _confirmSubmitDialog,
                    icon: const Icon(Icons.send),
                    label: const Text("Submit"),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
