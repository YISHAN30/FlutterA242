import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Account"),
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
              onTap: () => Navigator.pop(context),
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
            const Divider(),
            const ListTile(leading: Icon(Icons.info), title: Text("More Info")),
            const ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Contact Us"),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Full Name"),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: "Phone"),
                      keyboardType: TextInputType.phone,
                    ),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: "Address"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerWorkerDialog,
                        child: const Text("Register"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerWorkerDialog() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      showSnackBar("Please fill in all the fields");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showSnackBar("Please enter a valid email");
      return;
    }

    if (password.length < 6) {
      showSnackBar("Password must be at least 6 characters");
      return;
    }

    if (password != confirmPassword) {
      showSnackBar("Passwords do not match");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Register this account?"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                registerWorker();
              },
            ),
          ],
        );
      },
    );
  }

  void registerWorker() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    http
        .post(
          Uri.parse("${MyConfig.server}register_worker.php"),
          body: {
            "worker_name": name,
            "worker_email": email,
            "worker_password": password,
            "worker_phone": phone,
            "worker_address": address,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsondata = json.decode(response.body);
            if (jsondata['status'] == 'success') {
              showSnackBar("Registration successful!", isError: false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              showSnackBar("Failed to register");
            }
          } else {
            showSnackBar("Server error: ${response.statusCode}");
          }
        })
        .catchError((error) {
          showSnackBar("Network error: $error");
        });
  }

  void showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
