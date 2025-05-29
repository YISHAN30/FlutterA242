import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/model/work.dart';
import 'package:workertask_app/myconfig.dart';

class SubmitCompletionScreen extends StatefulWidget {
  final Worker worker;
  final Work work;
  const SubmitCompletionScreen({
    super.key,
    required this.worker,
    required this.work,
  });

  @override
  State<SubmitCompletionScreen> createState() => _SubmitCompletionScreenState();
}

class _SubmitCompletionScreenState extends State<SubmitCompletionScreen> {
  final TextEditingController _completionController = TextEditingController();
  bool _isSubmitting = false;

  void _submitCompletion() async {
    if (_completionController.text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    var response = await http.post(
      Uri.parse("${MyConfig.server}submit_work.php"),
      body: {
        'work_id': widget.work.workId,
        'worker_id': widget.worker.workerId,
        'submission_text': _completionController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Submission successful")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Submission failed")));
      }
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Completion"),
        backgroundColor: const Color.fromARGB(255, 160, 236, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Task: ${widget.work.title}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _completionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "What did you complete?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _submitCompletion,
                  child: const Text("Submit"),
                ),
          ],
        ),
      ),
    );
  }
}
