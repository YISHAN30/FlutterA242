import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/loginscreen.dart';
import 'package:workertask_app/view/registerscreen.dart';
import 'package:workertask_app/view/tasklistscreen.dart';
import 'package:workertask_app/view/submissionhistoryscreen.dart';

class ProfileScreen extends StatefulWidget {
  final Worker worker;
  const ProfileScreen({super.key, required this.worker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.worker.workerEmail ?? '';
    _phoneController.text = widget.worker.workerPhone ?? '';
    _addressController.text = widget.worker.workerAddress ?? '';
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

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .post(
            Uri.parse("${MyConfig.server}update_profile.php"),
            body: {
              'worker_id': widget.worker.workerId,
              'worker_name': widget.worker.workerName,
              'worker_email': _emailController.text,
              'worker_phone': _phoneController.text,
              'worker_address': _addressController.text,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _currentIndex = 0; // switch to Profile tab after success
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update failed"),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _confirmUpdateDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Confirm Update"),
            content: const Text(
              "Are you sure you want to update your profile?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _updateProfile();
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
    );
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TaskListScreen(worker: widget.worker),
        ),
      );
    } else {
      setState(() => _currentIndex = index);
    }
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 160, 236, 255),
            ),
            margin: EdgeInsets.zero, // <– removes extra top/bottom space
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ), // tighter padding
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
        title: const Text("Profile"),
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
                  _buildProfileView(),
                  _buildEditProfile(),
                  Container(),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue[900],
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'View Task'),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  widget.worker.workerName?.substring(0, 1) ??
                                      'U',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.worker.workerName ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 25),
                              _infoRow("ID", widget.worker.workerId ?? ''),
                              const Divider(),
                              _infoRow(
                                "Email",
                                widget.worker.workerEmail ?? '',
                              ),
                              const Divider(),
                              _infoRow(
                                "Phone",
                                widget.worker.workerPhone ?? '',
                              ),
                              const Divider(),
                              _infoRow(
                                "Address",
                                widget.worker.workerAddress ?? '',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditProfile() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _infoRow("ID", widget.worker.workerId ?? ''),
                    const Divider(),
                    _infoRow("Name", widget.worker.workerName ?? ''),
                    const Divider(),
                    _editableField("Email", _emailController),
                    const Divider(),
                    _editableField("Phone", _phoneController),
                    const Divider(),
                    _editableField("Address", _addressController, maxLines: 3),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _confirmUpdateDialog,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _editableField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
