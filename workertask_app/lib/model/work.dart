class Work {
  String? workId;
  String? title;
  String? description;
  String? assignedTo;
  String? dateAssigned;
  String? dueDate;
  String? status;

  Work({
    this.workId,
    this.title,
    this.description,
    this.assignedTo,
    this.dateAssigned,
    this.dueDate,
    this.status,
  });

  Work.fromJson(Map<String, dynamic> json) {
    workId = json['id'];
    title = json['title'];
    description = json['description'];
    assignedTo = json['assigned_to'];
    dateAssigned = json['date_assigned'];
    dueDate = json['due_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = workId;
    data['title'] = title;
    data['description'] = description;
    data['assigned_to'] = assignedTo;
    data['date_assigned'] = dateAssigned;
    data['due_date'] = dueDate;
    data['status'] = status;
    return data;
  }
}
