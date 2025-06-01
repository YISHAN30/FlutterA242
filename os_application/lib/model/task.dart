class Task {
  int taskid;
  String taskName;
  bool isChecked;

  Task({required this.taskid, required this.taskName, this.isChecked = false});
}

List<Task> taskList = [
  Task(taskid: 1, taskName: "Clean bathroom thoroughly"),
  Task(taskid: 2, taskName: "Vacuum and mop floors"),
  Task(taskid: 3, taskName: "Dust all surfaces"),
  Task(taskid: 4, taskName: "Change bed linens"),
  Task(taskid: 5, taskName: "Empty trash bins"),
  Task(taskid: 6, taskName: "Clean kitchen countertops"),
  Task(taskid: 7, taskName: "Wipe windows and mirrors"),
  Task(taskid: 8, taskName: "Sanitize door handles and switches"),
  Task(taskid: 9, taskName: "Restock toiletries and supplies"),
  Task(taskid: 10, taskName: "Check appliances for cleanliness"),
];
