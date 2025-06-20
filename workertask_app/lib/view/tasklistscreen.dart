import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/model/work.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/submitcompletionscreen.dart';
import 'package:workertask_app/view/loginscreen.dart';
import 'package:workertask_app/view/profilescreen.dart';
import 'package:workertask_app/view/registerscreen.dart';
import 'package:workertask_app/view/submissionhistoryscreen.dart';

class TaskListScreen extends StatefulWidget {
  final Worker worker;
  const TaskListScreen({super.key, required this.worker});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Work> workList = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final response = await http
          .post(
            Uri.parse("${MyConfig.server}get_works.php"),
            body: {'worker_id': widget.worker.workerId},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            workList =
                (data['data'] as List).map((e) => Work.fromJson(e)).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading tasks: $e')));
    }
  }

  Color _getStatusColor(String? status) {
    return (status?.toLowerCase() == 'complete') ? Colors.green : Colors.red;
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen(worker: widget.worker)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SubmissionHistoryScreen(worker: widget.worker),
        ),
      );
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
                  onTap: () => Navigator.pop(context),
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
            onTap: _logout,
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
        title: const Text("Task List"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadTasks,
                child: ListView.builder(
                  itemCount: workList.length,
                  itemBuilder: (context, index) {
                    final work = workList[index];
                    final isComplete = work.status?.toLowerCase() == 'complete';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Task ID: ${work.workId}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Task Title: ${work.title ?? 'No title'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Description: ${work.description ?? 'No description'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Assigned Date: ${work.dateAssigned ?? 'N/A'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Due Date: ${work.dueDate ?? 'N/A'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(work.status),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    work.status ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (!isComplete)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => SubmitCompletionScreen(
                                                worker: widget.worker,
                                                work: work,
                                              ),
                                        ),
                                      ).then((_) => _loadTasks());
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.blue[900],
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Back'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
