import "package:cloud_firestore/cloud_firestore.dart";

class Employee {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  final String name;
  final String surname;
  final String email;
  final String password;
  final String jobname;
  final String companyname;
  final String department;
  final String teamid;

  Employee({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.jobname,
    required this.companyname,
    required this.department,
    required this.teamid,
  }) {
    userCollection.doc(name).set({
      "name": name,
      "surname": surname,
      "email": email,
      "password": password,
      "jobName": jobname,
      "companyName": companyname,
      "department": department,
      "teamID": teamid,
    });
  }

  toJson() {
    return {
      "name": name,
      "surname": surname,
      "email": email,
      "jobName": jobname,
      "companyName": companyname,
      "department": department,
    };
  }
}
