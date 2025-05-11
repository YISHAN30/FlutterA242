import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms_app/myconfig.dart';
import 'package:wtms_app/view/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
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
                      controller: fullNameController,
                      decoration: const InputDecoration(labelText: "Full Name"),
                      keyboardType: TextInputType.text,
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
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
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
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields")),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    http
        .post(
          Uri.parse("${MyConfig.server}register_worker.php"),
          body: {
            "fullName": fullName,
            "email": email,
            "password": password,
            "phone": phone,
            "address": address,
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsondata = json.decode(response.body);
            if (jsondata['status'] == 'success') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Success!")));
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to register")),
              );
            }
          }
        });
  }
}
