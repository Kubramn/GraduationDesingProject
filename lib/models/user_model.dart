import "package:cloud_firestore/cloud_firestore.dart";

class UserModel {
  String id;
  String name;
  String surname;
  String email;
  String password;
  String role;
  String job;
  String company;
  String department;
  String teamID;

  UserModel({
    this.id = "",
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.role,
    required this.job,
    required this.company,
    required this.department,
    required this.teamID,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "role": role,
        "job": job,
        "company": company,
        "department": department,
        "teamID": teamID,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        job: json["job"],
        company: json["company"],
        department: json["department"],
        teamID: json["teamID"],
      );

  Future createUser(
    String name,
    String surname,
    String email,
    String password,
    String role,
    String job,
    String company,
    String department,
    String teamID,
  ) async {
    final newUser = FirebaseFirestore.instance.collection('users').doc();
    final user = UserModel(
      id: newUser.id,
      name: name,
      surname: surname,
      email: email,
      password: password,
      role: role,
      job: job,
      company: company,
      department: department,
      teamID: teamID,
    );
    await newUser.set(user.toJson());
  }
}
