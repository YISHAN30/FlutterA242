import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/profilescreen.dart';
import 'package:workertask_app/view/loginscreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(254, 255, 170, 1),
              const Color.fromARGB(255, 251, 190, 115),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/Logo.png', width: 180, height: 180),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: const Text(
                  "Welcome to Worker Task Completion System",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : ElevatedButton(
                    onPressed: _handleLoginNavigation,
                    child: const Text("Enter"),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLoginNavigation() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('remember')) ?? false;

    if (rem && email.isNotEmpty && password.isNotEmpty) {
      http
          .post(
            Uri.parse("${MyConfig.server}login_worker.php"),
            body: {"worker_email": email, "worker_password": password},
          )
          .then((response) {
            if (response.statusCode == 200) {
              var jsondata = json.decode(response.body);
              if (jsondata['status'] == 'success') {
                var workerdata = jsondata['data'];
                Worker worker = Worker.fromJson(workerdata[0]);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(worker: worker),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          })
          .catchError((error) {
            print("Login error: $error");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
