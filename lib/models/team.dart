import "package:bitirme/models/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Team {
  final CollectionReference teamCollection =
      FirebaseFirestore.instance.collection("team");
  String teamID, teamName;
  String teamLeaderUsername;
  int? budget;

  Team(this.teamID, this.teamName, this.teamLeaderUsername) {
    teamCollection.doc(teamID).set({
      "teamid": teamID,
      "teamname": teamName,
      "teamleader": teamLeaderUsername
    });
  }
}

/*import 'package:bitirme/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}*/