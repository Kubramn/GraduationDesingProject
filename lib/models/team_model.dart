import 'package:bitirme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future createTeam(String role) async {
    if (role == "Leader") {
      final newTeam = FirebaseFirestore.instance.collection('teams').doc();
      final team = TeamModel(
        id: newTeam.id,
        teamName: teamName,
        leaderEmail: leaderEmail,
        budget: budget,
      );
      await newTeam.set(team.toJson());
    }
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
