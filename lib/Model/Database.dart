import 'package:bitirme/Model/Team.dart';
import 'package:bitirme/Model/User.dart';

RegisterNewEmployee(String name, String surname,String username,String password,String jobname,String companyname,String department,String teamid){
  User(name, surname, username, password, jobname, companyname, department, teamid);
}
CreateNewTeam(String teamID, String teamName, User teamLeader){
  Team(teamID, teamName, teamLeader);
}