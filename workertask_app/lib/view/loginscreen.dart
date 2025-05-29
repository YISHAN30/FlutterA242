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

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
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
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                      ),
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
                              if (isChecked) {
                                if (email.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please fill in all the fields",
                                      ),
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        151,
                                        151,
                                        151,
                                      ),
                                    ),
                                  );
                                  isChecked = false;
                                  return;
                                }
                              }
                              storeCredentials(email, password, isChecked);
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          loginWorker();
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Register a new account?"),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: const Text("Forgot Password?"),
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
          backgroundColor: Color.fromARGB(255, 151, 151, 151),
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${worker.workerName}"),
              backgroundColor: const Color.fromARGB(255, 151, 151, 151),
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
              backgroundColor: Color.fromARGB(255, 151, 151, 151),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Server error: ${response.statusCode}"),
            backgroundColor: const Color.fromARGB(255, 151, 151, 151),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network error: $e"),
          backgroundColor: const Color.fromARGB(255, 151, 151, 151),
        ),
      );
      print("Exception during login: $e");
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
          backgroundColor: Color.fromARGB(255, 151, 151, 151),
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
          backgroundColor: Color.fromARGB(255, 151, 151, 151),
        ),
      );
    }
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('pass');
    bool? isChecked = prefs.getBool('remember');
    if (email != null && password != null && isChecked != null) {
      emailController.text = email;
      passwordController.text = password;
      setState(() {
        this.isChecked = isChecked ?? false;
      });
    } else {
      emailController.clear();
      passwordController.clear();
      isChecked = false;
      setState(() {});
    }
  }
}
