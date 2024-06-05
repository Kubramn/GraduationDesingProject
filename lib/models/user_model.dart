import "package:bitirme/alert_message.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

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

  static Future<String> getNameSurnameByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final data = userDoc.docs.first.data();
    return "${data['name']} ${data['surname']}";
  }

  static Future<String> getRoleByEmail(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final data = userDoc.docs.first.data();
    return "${data['role']}";
  }

  static Future<String> decideCheckerUserEmailByTeam(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    final data = userDoc.docs.first.data();
    final teamDoc = await FirebaseFirestore.instance
        .collection("teams")
        .where("teamName", isEqualTo: data["teamName"])
        .get();
    final teamData = teamDoc.docs.first.data();
    if (data["role"] == "Member") {
      return teamData["leaderEmail"];
    } else {
      return "No Leader";
    }
  }

  static Future<String> decideStatusByRole(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    final data = userDoc.docs.first.data();
    if (data["role"] == "Member") {
      return "waiting";
    } else if (data["role"] == "Leader") {
      return "acceptedByLeader";
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

  static Stream<List<UserModel>> fetchAllLeaders() {
    return FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "Leader")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  static Future<bool> updateUser(
    String? email,
    String name,
    String surname,
    String password,
    String role,
    String job,
    String department,
    String teamName,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(email).update({
        "name": name,
        "surname": surname,
        "password": password,
        "role": role,
        "job": job,
        "department": department,
        "teamName": teamName,
      });
      print("User data updated successfully!");
      return true;
    } catch (e) {
      print("Error fetching or updating user data: $e");
      return false;
    }
  }

  static Future<void> updateTeamNamesOfUsers(
    String oldTeamName,
    String newTeamName,
  ) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("teamName", isEqualTo: oldTeamName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .update({
            "teamName": newTeamName,
          });
        }
        print('Team names updated successfully');
      } else {
        print('No users found with the team name $oldTeamName');
      }
    } catch (e) {
      print('Failed to update team names: $e');
    }
  }

  static Future<bool> deleteUser(
    String? email,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(email).delete();
      print("User data deleted successfully!");
      return true;
    } catch (e) {
      print("Error fetching or deleting user data: $e");
      return false;
    }
  }

  static Future<bool> register(
    String name,
    String surname,
    String email,
    String password,
    String role,
    String job,
    String department,
    String teamName,
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
      Navigator.pop(context); //Navigator.of(context).pop;
      alertMessage(
        "${name} ${surname} is registered successfully.",
        Color.fromARGB(255, 0, 255, 0),
        context,
      );
      UserModel(
        name: name,
        surname: surname,
        email: email,
        password: password,
        role: role,
        job: job,
        department: department,
        teamName: teamName,
      ).createUser();
      return true;
    } catch (e) {
      Navigator.pop(context);
      alertMessage(
        "User Registration failed!",
        const Color.fromARGB(255, 255, 0, 0),
        context,
      );
      print("ERROR -> $e");
      return false;
    }
  }

  static Future<String?> login(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .get();

      if (userDoc.data()!=null) {
        if(userDoc.data()?["password"]==password){
          Navigator.pop(context);
          return email;
        }else{
          Navigator.pop(context);
          alertMessage("Password is wrong", Colors.red, context);
          return null;
        }

      } else {
        Navigator.pop(context);
        alertMessage("There is no User with that email.", Colors.red, context);
        return null;
      }
    } catch (e) {
      Navigator.pop(context);
      alertMessage("Connection Error! \nYou may try to check your internet connection.", Colors.red, context);

/*       if (e.code == "invalid-credential") {
        alertMessage("Wrong password email etc", Colors.red, context);
      } else if (e.code == "invalid-email") {
        alertMessage("Email @ vs typo", Colors.red, context);
      } else if (e.code == "missing-password") {
        alertMessage("missing-password", Colors.red, context);
      } else if (e.code == "too-many-requests") {
        alertMessage("too-many-requests", Colors.red, context);
      }
 */
      return null;
    }
  }
}
