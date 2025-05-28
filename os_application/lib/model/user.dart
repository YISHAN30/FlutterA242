class User {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;

  User({
    this.userId,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhone,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_password'] = userPassword;
    data['user_phone'] = userPhone;
    return data;
  }
}
