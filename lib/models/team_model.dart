import 'package:bitirme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../alert_message.dart';

class TeamModel {
  String id;
  String teamName;
  String leaderEmail;
  double budget;

  TeamModel({
    this.id = "",
    required this.teamName,
    required this.leaderEmail,
    required this.budget,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "teamName": teamName,
        "leaderEmail": leaderEmail,
        "budget": budget,
      };

  static TeamModel fromJson(Map<String, dynamic> json) => TeamModel(
        id: json["id"],
        teamName: json["teamName"],
        leaderEmail: json["leaderEmail"],
        budget: json["budget"],
      );

  static Future<num> getTeamBudget(String? email) async {
    String teamName= (await UserModel.fetchLeaderInfo(email).first).first.teamName;
    QuerySnapshot qs =await FirebaseFirestore.instance.collection("teams").where("teamName",isEqualTo: teamName).get();
    QueryDocumentSnapshot doc = qs.docs.first;
    return doc.get("budget");
  }

  Future<bool> createTeam(String role,BuildContext context) async {
    List<String> teamList = await getTeamList();
    if (role == "Leader") {
      if (!teamList.contains(teamName)) {
        final newTeam = FirebaseFirestore.instance.collection('teams').doc();
        final team = TeamModel(
          id: newTeam.id,
          teamName: teamName,
          leaderEmail: leaderEmail,
          budget: budget,
        );
        await newTeam.set(team.toJson());
      } else {
        alertMessage(
          "There is a team with this name",
          Color.fromARGB(255, 0, 255, 0),
          context,
        );
        return false;
      }
    } else if (role == "Member") {
      if (!teamList.contains(teamName)) {
        alertMessage(
          "There is no team with this name",
          Color.fromARGB(255, 0, 255, 0),
          context,
        );
        return false;
      }
    }
    return true;
  }

  static Future<List<String>> getTeamList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('teams').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    return documents.map((doc) => doc['teamName'] as String).toList();
  }

  static Future<String> decideLeaderEmailByTeamName(
      String role, String teamName) async {
    final teamDoc = await FirebaseFirestore.instance
        .collection("teams")
        .where("teamName", isEqualTo: teamName)
        .get();

    final data = teamDoc.docs.first.data();
    if (role == "Member") {
      return data["leaderEmail"];
    } else {
      return "No Leader";
    }
  }

  static Future<void> updateTeamName(
    String oldTeamName,
    String newTeamName,
  ) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("teams")
          .where("teamName", isEqualTo: oldTeamName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('teams').doc(docId).update({
          "teamName": newTeamName,
        });
        print('Team name updated successfully');
      } else {
        print('No team found with the name $oldTeamName');
      }
    } catch (e) {
      print('Failed to update team name: $e');
    }
  }
}
