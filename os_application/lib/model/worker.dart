class Worker {
  String? workerId;
  String? workerName;
  String? workerEmail;
  String? workerPassword;
  String? workerPhone;

  Worker({
    this.workerId,
    this.workerName,
    this.workerEmail,
    this.workerPassword,
    this.workerPhone,
  });

  Worker.fromJson(Map<String, dynamic> json) {
    workerId = json['worker_id'].toString();
    workerName = json['worker_name'];
    workerEmail = json['worker_email'];
    workerPassword = json['worker_password'];
    workerPhone = json['worker_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['worker_id'] = workerId;
    data['worker_name'] = workerName;
    data['worker_email'] = workerEmail;
    data['worker_password'] = workerPassword;
    data['worker_phone'] = workerPhone;
    return data;
  }
}
