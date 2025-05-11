class Worker {
  String? id;
  String? fullName;
  String? email;
  String? password;
  String? phone;
  String? address;

  Worker({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.phone,
    this.address,
  });

  Worker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
