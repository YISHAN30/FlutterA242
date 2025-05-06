import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['results'][0];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Failed to load user. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : userData == null
              ? Center(child: Text("No user data available"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        userData!['picture']['large'],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "${userData!['name']['first']} ${userData!['name']['last']}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Email: ${userData!['email']}"),
                    Text("Phone: ${userData!['phone']}"),
                    Text("Cell: ${userData!['cell']}"),
                    SizedBox(height: 8),
                    Text(
                      "Address: ${userData!['location']['street']['number']} ${userData!['location']['street']['name']}, ${userData!['location']['city']}, ${userData!['location']['state']}, ${userData!['location']['country']}",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text("Age: ${userData!['dob']['age']}"),
                    Text("Nationality: ${userData!['nat']}"),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchUser,
                      child: Text("Refresh User"),
                    ),
                  ],
                ),
              ),
    );
  }
}
