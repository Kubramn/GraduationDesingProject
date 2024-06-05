import 'package:bitirme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TeamModel {
  String teamName;
  String leaderEmail;
  double budget;

  TeamModel({
    required this.teamName,
    required this.leaderEmail,
    required this.budget,
  });

  Map<String, dynamic> toJson() => {
        "teamName": teamName,
        "leaderEmail": leaderEmail,
        "budget": budget,
      };

  static TeamModel fromJson(Map<String, dynamic> json) => TeamModel(
        teamName: json["teamName"],
        leaderEmail: json["leaderEmail"],
        budget: json["budget"],
      );

  Future createTeam(String role) async {
    if (role == "Leader") {
      final newTeam =
          FirebaseFirestore.instance.collection('teams').doc(teamName);
      final team = TeamModel(
        teamName: teamName,
        leaderEmail: leaderEmail,
        budget: budget,
      );
      await newTeam.set(team.toJson());
    }
  }

  static Future<double> getTeamBudget(Stream<List<UserModel>> list) async {
    String teamName= (await list.first).first.teamName;
    DocumentSnapshot ds =await FirebaseFirestore.instance.collection("teams").doc(teamName).get();
    Map<String, dynamic> doc = ds.data() as Map<String, dynamic>;
    return doc["budget"];
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
}
