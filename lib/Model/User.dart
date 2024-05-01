import "package:cloud_firestore/cloud_firestore.dart";

class User{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("user");
  String? name,surname,username,password,jobname,companyname,department,teamid;

  User(this.name, this.surname, this.username, this.password, this.jobname, this.companyname, this.department, this.teamid){
    userCollection.doc(name).set({
      "name":name,
      "surname":surname,
      "email":username,
      "password":password,
      "jobName":jobname,
      "companyName":companyname,
      "department":department,
      "teamID":teamid,
    });
  }
}