import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workertask_app/model/worker.dart';
import 'package:workertask_app/model/work.dart';
import 'package:workertask_app/myconfig.dart';
import 'package:workertask_app/view/submitcompletionscreen.dart';

class TaskListScreen extends StatefulWidget {
  final Worker worker;
  const TaskListScreen({super.key, required this.worker});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Work> workList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    var response = await http.post(
      Uri.parse("${MyConfig.server}get_works.php"),
      body: {'worker_id': widget.worker.workerId},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        var workData = data['data'] as List;
        setState(() {
          workList = workData.map((e) => Work.fromJson(e)).toList();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task List Screen")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: workList.length,
              itemBuilder: (context, index) {
                Work work = workList[index];
                bool isComplete = (work.status ?? '').toLowerCase() == 'complete';
                return Card(
                  color: isComplete ? Colors.green[100] : Colors.white,
                  child: ListTile(
                    title: Text(work.title ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description: ${work.description}"),
                        Text("Assigned: ${work.dateAssigned}"),
                        Text("Due: ${work.dueDate}"),
                        Text("Status: ${work.status}"),
                      ],
                    ),
                    trailing: isComplete
                        ? null
                        : ElevatedButton(
                            child: const Text("Submit"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubmitCompletionScreen(
                                          worker: widget.worker, work: work),
                                ),
                              ).then((_) => _loadTasks());
                            },
                          ),
                  ),
                );
              },
            ),
    );
  }
}
