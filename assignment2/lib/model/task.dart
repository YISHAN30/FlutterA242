class Task {
  String? id;
  String? title;
  String? description;
  String? assignedTo;
  String? dateAssigned;
  String? dueDate;
  String? status;

  Task({
    this.id,
    this.title,
    this.description,
    this.assignedTo,
    this.dateAssigned,
    this.dueDate,
    this.status,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    description = json['description'];
    assignedTo = json['assigned_to'].toString();
    dateAssigned = json['date_assigned'];
    dueDate = json['due_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['assigned_to'] = assignedTo;
    data['date_assigned'] = dateAssigned;
    data['due_date'] = dueDate;
    data['status'] = status;
    return data;
  }
}
