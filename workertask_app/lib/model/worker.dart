class Worker {
  String? workerId;
  String? workerName;
  String? workerEmail;
  String? workerPassword;
  String? workerPhone;
  String? workerAddress;

  Worker({
    this.workerId,
    this.workerName,
    this.workerEmail,
    this.workerPassword,
    this.workerPhone,
    this.workerAddress,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      workerId: json['worker_id']?.toString(),
      workerName: json['worker_name']?.toString(),
      workerEmail: json['worker_email']?.toString(),
      workerPassword: json['worker_password']?.toString(),
      workerPhone: json['worker_phone']?.toString(),
      workerAddress: json['worker_address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['worker_id'] = workerId;
    data['worker_name'] = workerName;
    data['worker_email'] = workerEmail;
    data['worker_password'] = workerPassword;
    data['worker_phone'] = workerPhone;
    data['worker_address'] = workerAddress;
    return data;
  }
}
