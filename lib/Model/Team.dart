import "package:bitirme/Model/User.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Team{
  final CollectionReference teamCollection = FirebaseFirestore.instance.collection("team");
  String teamID,teamName;
  String teamLeaderUsername ;
  int? budget;

  Team(this.teamID, this.teamName, this.teamLeaderUsername){
    teamCollection.doc(teamID).set({
      "teamid":teamID,
      "teamname":teamName,
      "teamleader":teamLeader.username
    });
  }
}