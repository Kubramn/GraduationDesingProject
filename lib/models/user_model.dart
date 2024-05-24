import "package:bitirme/alert_message.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class UserModel {
  String name;
  String surname;
  String email;
  String password;
  String role;
  String leaderEmail;
  String job;
  String department;
  String teamName;

  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.role,
    required this.leaderEmail,
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
        "leaderEmail": leaderEmail,
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
        leaderEmail: json["leaderEmail"],
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
      leaderEmail: leaderEmail,
      job: job,
      department: department,
      teamName: teamName,
    );
    await newUser.set(user.toJson());
  }

  static Future<String> getNameSurnameByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    final data = userDoc.docs.first.data();
    return "${data['name']} ${data['surname']}";
  }

  static Future<String> findCheckerUserEmailByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    final data = userDoc.docs.first.data();
    if (data["role"] == "Member") {
      return data["leaderEmail"];
    } else if (data["role"] == "Leader") {
      return "finance@gmail.com";
    } else {
      return "";
    }
  }

  static Stream<List<UserModel>> fetchAllUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  static Future<void> updateUser(
    String? email,
    TextEditingController nameController,
    TextEditingController surnameController,
    TextEditingController passwordController,
    TextEditingController roleController,
    TextEditingController leaderEmailController,
    TextEditingController jobController,
    TextEditingController departmentController,
    TextEditingController teamNameController,
  ) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("users").doc(email).get();

      if (snapshot.exists) {
        await FirebaseFirestore.instance.collection("users").doc(email).update({
          "name": nameController.text,
          "surname": surnameController.text,
          "password": passwordController.text,
          "role": roleController.text,
          "leaderEmail": leaderEmailController.text,
          "job": jobController.text,
          "department": departmentController.text,
          "teamName": teamNameController.text,
        });
        nameController.clear();
        surnameController.clear();
        passwordController.clear();
        roleController.clear();
        leaderEmailController.clear();
        jobController.clear();
        departmentController.clear();
        teamNameController.clear();

        print("User data updated successfully!");
      } else {
        print("User not found!");
      }
    } catch (e) {
      print("Error fetching or updating user data: $e");
    }
  }

  static void register(
    TextEditingController nameController,
    TextEditingController surnameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController roleController,
    TextEditingController leaderEmailController,
    TextEditingController jobController,
    TextEditingController departmentController,
    TextEditingController teamNameController,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 68, 60, 95),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); //Navigator.of(context).pop;
      alertMessage(
        "${nameController.text} ${surnameController.text} is registered successfully.",
        Color.fromARGB(255, 0, 255, 0),
        context,
      );
      UserModel(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: roleController.text,
        leaderEmail: leaderEmailController.text,
        job: jobController.text,
        department: departmentController.text,
        teamName: teamNameController.text,
      ).createUser();
      nameController.clear();
      surnameController.clear();
      emailController.clear();
      passwordController.clear();
      roleController.clear();
      leaderEmailController.clear();
      jobController.clear();
      departmentController.clear();
      teamNameController.clear();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      alertMessage(
        "User Registration failed!",
        const Color.fromARGB(255, 255, 0, 0),
        context,
      );
      print("ERROR -> $e");
    }
  }
}
