import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:assignment2/myconfig.dart';
import 'package:assignment2/model/user.dart';

class SubmitScreen extends StatefulWidget {
  final dynamic task; // Pass the task map from TaskScreen
  final User user;

  const SubmitScreen({Key? key, required this.task, required this.user})
    : super(key: key);

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final TextEditingController _submissionController = TextEditingController();
  bool _isSubmitting = false;

  void _submitWork() async {
    if (_submissionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your work description.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse("${MyConfig.myurl}/assignment2/submit_work.php"),
            body: {
              "work_id": widget.task['id'].toString(),
              "user_id": widget.user.userId.toString(),
              "submission_text": _submissionController.text,
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Submission successful.")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonData['message'] ?? "Submission failed."),
            ),
          );
        }
      } else {
        throw Exception("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Submit Work Completion",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.task['title'], style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text("What did you complete?"),
            const SizedBox(height: 8),
            TextField(
              controller: _submissionController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe your work here...",
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Submit"),
                    onPressed: _submitWork,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
