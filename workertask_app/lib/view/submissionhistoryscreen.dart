import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/submission.dart';
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/loginscreen.dart';
import 'package:workertask_app/view/registerscreen.dart';
import 'package:workertask_app/view/tasklistscreen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final Worker worker;
  const SubmissionHistoryScreen({super.key, required this.worker});

  @override
  State<SubmissionHistoryScreen> createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  int _currentIndex = 1;
  bool _isLoading = true;
  List<Submission> _submissions = [];
  Submission? _selectedSubmission;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.server}get_submissions.php"),
        body: {'worker_id': widget.worker.workerId},
      );
      final body = response.body.trim();
      if (response.statusCode == 200 && body.isNotEmpty) {
        final jsonData = json.decode(body);
        if (jsonData['status'] == 'success') {
          setState(() {
            _submissions =
                (jsonData['data'] as List)
                    .map((data) => Submission.fromJson(data))
                    .toList();
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _confirmUpdateDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Update"),
            content: const Text(
              "Are you sure you want to update this submission?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.pop(context);
                  _updateSubmission();
                },
              ),
            ],
          ),
    );
  }

  Future<void> _updateSubmission() async {
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.server}edit_submissions.php"),
        body: {
          'submission_id': _selectedSubmission!.id,
          'updated_text': _textController.text,
        },
      );

      if (response.statusCode == 200) {
        await _fetchSubmissions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Submission updated successfully."),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _currentIndex = 1;
          _selectedSubmission = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TaskListScreen(worker: widget.worker),
        ),
      );
    } else if (index == 2 && _selectedSubmission == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select a submission to edit."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
        if (_selectedSubmission != null && index == 2) {
          _textController.text = _selectedSubmission!.text;
        }
      });
    }
  }

  void _logout() {
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.worker.workerEmail ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  Icons.app_registration,
                  "Register Account",
                  const RegisterScreen(),
                ),
                _buildDrawerItem(Icons.login, "Login", const LoginScreen()),
                _buildDrawerItem(
                  Icons.task,
                  "View Task",
                  TaskListScreen(worker: widget.worker),
                ),
                _buildDrawerItem(
                  Icons.history,
                  "Submission History",
                  SubmissionHistoryScreen(worker: widget.worker),
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
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap:
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 2 ? "Edit Submission" : "Submission History",
          style: const TextStyle(),
        ),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: _buildDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : IndexedStack(
                index: _currentIndex,
                children: [
                  _buildSubmissionHistory(),
                  _buildSubmissionHistory(),
                  _buildEditSubmission(),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        selectedItemColor: Colors.blue[900],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
        ],
      ),
    );
  }

  Widget _buildSubmissionHistory() {
    return _submissions.isEmpty
        ? const Center(child: Text("No submissions found."))
        : ListView.builder(
          itemCount: _submissions.length,
          itemBuilder: (context, index) {
            final submission = _submissions[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color:
                  _selectedSubmission == submission
                      ? Colors.blue.shade100
                      : Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                onTap: () => setState(() => _selectedSubmission = submission),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Task ID: ${submission.workId}"),
                    Text("Title: ${submission.title ?? 'No Title'}"),
                    Text("Submitted At: ${submission.formattedDate}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
  }

  Widget _buildEditSubmission() {
    if (_selectedSubmission == null) {
      return const Center(child: Text("No submission selected."));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Task ID: ${_selectedSubmission!.workId}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            "Title: ${_selectedSubmission!.title ?? 'No Title'}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            "Submitted At: ${_selectedSubmission!.formattedDate}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Edit your submission',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _confirmUpdateDialog,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
