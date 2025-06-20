class Submission {
  final int id;
  final int workId;
  final int userId;
  final String submissionText;
  final String submittedAt;
  final String workTitle;
  final String workDescription;
  final String? updatedOn;
  final String? dueDate;
  final String? status;

  Submission({
    required this.id,
    required this.workId,
    required this.userId,
    required this.submissionText,
    required this.submittedAt,
    required this.workTitle,
    required this.workDescription,
    this.updatedOn,
    this.dueDate,
    this.status,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as int,
      workId: json['work_id'] as int,
      userId: json['user_id'] as int,
      submissionText: json['submission_text'] as String,
      submittedAt: json['submitted_at'] as String,
      workTitle: json['work_title'] as String,
      workDescription: json['work_description'] as String,
      updatedOn: json['updated_on'] as String?,
      dueDate: json['due_date'] as String?,
      status: json['status'] as String?,
    );
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(submittedAt);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return submittedAt;
    }
  }

  String get formattedUpdatedOn {
    if (updatedOn == null || updatedOn == "NULL") return "";
    try{
      final date = DateTime.parse(updatedOn!);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return updatedOn!;
    }
  }

  String get previewText =>
      submissionText.length > 100
          ? '${submissionText.substring(0, 100)}...'
          : submissionText;
}
