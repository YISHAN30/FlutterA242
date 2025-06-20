import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/registerscreen.dart';
import 'package:workertask_app/view/profilescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  String username = "User";

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 160, 236, 255),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "User",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Not yet logged in",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Task List"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please login first to view tasks."),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Submission History"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Please login first to view submission history.",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            const Divider(),
            const ListTile(leading: Icon(Icons.info), title: Text("More Info")),
            const ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Contact Us"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset('images/Logo.png', width: 150, height: 150),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Remember Me"),
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                              String email = emailController.text;
                              String password = passwordController.text;
                              if (isChecked &&
                                  (email.isEmpty || password.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill in all the fields",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                isChecked = false;
                                return;
                              }
                              storeCredentials(email, password, isChecked);
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: loginWorker,
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text("Register a new account?"),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // implement forgot password logic if available
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Forgot password feature not implemented.",
                              ),
                            ),
                          );
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginWorker() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all the fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse("${MyConfig.server}login_worker.php"),
            body: {"worker_email": email, "worker_password": password},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"] == "success") {
          var workerdata = jsondata["data"];
          Worker worker = Worker.fromJson(workerdata[0]);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", worker.workerName ?? "User");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${worker.workerName}"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(worker: worker),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed. Check your credentials."),
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
          content: Text("Network error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> storeCredentials(
    String email,
    String password,
    bool isChecked,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('remember', isChecked);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pref Stored Success!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await prefs.remove('email');
      await prefs.remove('pass');
      await prefs.remove('remember');
      emailController.clear();
      passwordController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pref Removed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('email') ?? "";
    passwordController.text = prefs.getString('pass') ?? "";
    username = prefs.getString("name") ?? "User";
    setState(() {
      isChecked = prefs.getBool('remember') ?? false;
    });
  }
}
