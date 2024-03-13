class UserModel {
  String? id;
  String? fname;
  String? lname;
  String? email;
  String? phone;
  String? national;
  String? cnic;

  UserModel({
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.national,
    required this.cnic,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    fname = json['first_name'];
    lname = json['last_name'];
    email = json['email'];
    phone = json['phone_num'];
    national = json['nationality'];
    cnic = json['cnic'];
  }
}
