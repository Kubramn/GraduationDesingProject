import "package:cloud_firestore/cloud_firestore.dart";

class UserModel {
  String name;
  String surname;
  String email;
  String password;
  String role;
  String job;
  String department;
  String teamName;

  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.role,
    required this.job,
    required this.department,
    required this.teamName,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "role": role,
        "job": job,
        "department": department,
        "teamName": teamName,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        job: json["job"],
        department: json["department"],
        teamName: json["teamName"],
      );

  Future createUser() async {
    final newUser = FirebaseFirestore.instance.collection('users').doc(email);
    final user = UserModel(
      name: name,
      surname: surname,
      email: email,
      password: password,
      role: role,
      job: job,
      department: department,
      teamName: teamName,
    );
    await newUser.set(user.toJson());
  }
}
