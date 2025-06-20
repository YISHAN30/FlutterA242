class Submission {
  String? submissionId;
  String? workId;
  String? workerId;
  String? title; // comes from joined tbl_works
  String? submissionText;
  String? submittedAt;

  Submission({
    this.submissionId,
    this.workId,
    this.workerId,
    this.title,
    this.submissionText,
    this.submittedAt,
  });

  Submission.fromJson(Map<String, dynamic> json) {
    submissionId = json['id'];
    workId = json['work_id'];
    workerId = json['worker_id'];
    title = json['title']; // from JOIN
    submissionText = json['submission_text'];
    submittedAt = json['submitted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = submissionId;
    data['work_id'] = workId;
    data['worker_id'] = workerId;
    data['title'] = title;
    data['submission_text'] = submissionText;
    data['submitted_at'] = submittedAt;
    return data;
  }

  String get formattedDate {
    if (submittedAt == null) return 'No date';
    final dateTime = DateTime.tryParse(submittedAt!);
    return dateTime != null
        ? '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}'
        : submittedAt!;
  }

  String get text => submissionText ?? '';
  String get id => submissionId ?? '';
}
