import 'package:bitirme/models/team.dart';
import 'package:bitirme/models/user.dart';

registerNewEmployee(
  String name,
  String surname,
  String email,
  String password,
  String jobname,
  String companyname,
  String department,
  String teamid,
) {
  Employee(
    name: name,
    surname: surname,
    email: email,
    password: password,
    jobname: jobname,
    companyname: companyname,
    department: department,
    teamid: teamid,
  );
}

createNewTeam(
  String teamID,
  String teamName,
  String teamLeader,
) {
  Team(
    teamID,
    teamName,
    teamLeader,
  );
}
