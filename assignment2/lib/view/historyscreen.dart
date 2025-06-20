import 'package:assignment2/view/editprofilescreen.dart';
import 'package:assignment2/view/loginscreen.dart';
import 'package:assignment2/view/profilescreen.dart';
import 'package:assignment2/view/taskscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:assignment2/model/user.dart';
import 'package:assignment2/model/submission.dart';
import 'package:assignment2/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  final User user;
  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Submission> submissions = [];
  bool isLoading = true;
  String? errorMessage;
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    final url = Uri.parse("${MyConfig.myurl}/assignment2/get_submissions.php");

    try {
      final response = await http.post(
        url,
        body: {'worker_id': widget.user.userId},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            submissions =
                (jsonData['data'] as List)
                    .map((json) => Submission.fromJson(json))
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

  Future<void> _editSubmission(Submission submission) async {
    TextEditingController controller = TextEditingController(
      text: submission.submissionText,
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Submission'),
            content: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Submission',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _submitUpdatedText(submission.id, controller.text);
    }
  }

  Future<void> _submitUpdatedText(int submissionId, String updatedText) async {
    final url = Uri.parse("${MyConfig.myurl}/assignment2/edit_submission.php");

    try {
      final response = await http.post(
        url,
        body: {
          'submission_id': submissionId.toString(),
          'updated_text': updatedText,
        },
      );

      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission updated successfully!")),
        );
        _loadSubmissions(); // Reload updated data
      } else {
        throw Exception(jsonData['message'] ?? 'Update failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildSubmissionCard(Submission submission, int index) {
    final isExpanded = _expandedStates[index] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => setState(() => _expandedStates[index] = !isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.workTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Text(
                  'Task Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(submission.workDescription),
                const SizedBox(height: 12),
                const Text(
                  'Your Submission:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(submission.submissionText),
                if (submission.dueDate != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Original Due Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(submission.dueDate!),
                  const SizedBox(height: 12),
                  Text(
                    'Submitted on: ${submission.formattedDate}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (submission.updatedOn != null &&
                      submission.updatedOn != "NULL") ...[
                    const SizedBox(height: 12),
                    Text(
                      'Updated On: ${submission.formattedUpdatedOn}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => _editSubmission(submission),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(submission.previewText),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submission History",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSubmissions,
          ),
        ],
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
                      title: const Text(
                        'Main',
                        style: TextStyle(color: Colors.blue),
                      ),
                      tileColor: Colors.blue.shade50,
                      selected: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProfileScreen(user: widget.user),
                          ),
                        );
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
                            builder: (context) => TaskScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: Colors.deepOrange,
                      ),
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
                            builder:
                                (context) => HistoryScreen(user: widget.user),
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
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EditProfileScreen(user: widget.user),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  hoverColor: Colors.red.shade50,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return _buildErrorView();
    if (submissions.isEmpty) return _buildEmptyView();

    return RefreshIndicator(
      onRefresh: _loadSubmissions,
      child: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          return _buildSubmissionCard(submissions[index], index);
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(errorMessage ?? 'Unknown error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSubmissions,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No submissions found', style: TextStyle(fontSize: 18)),
          TextButton(onPressed: _loadSubmissions, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
