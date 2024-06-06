import 'package:bitirme/models/team_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:flutter/material.dart';
import "package:bitirme/alert_message.dart";

class FinanceRegister extends StatefulWidget {
  const FinanceRegister({super.key});

  @override
  State<FinanceRegister> createState() => _FinanceRegisterState();
}

class _FinanceRegisterState extends State<FinanceRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  //String? _selectedRole;

  Icon roleIcon = Icon(
    Icons.contacts,
    color: Color.fromARGB(255, 68, 60, 95),
  );

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.42,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.42,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: surnameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Surname",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Color.fromARGB(255, 68, 60, 95),

                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Color.fromARGB(255, 68, 60, 95),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.42,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                  ),
                ),
                DropdownMenu<String>(
                  leadingIcon: roleIcon,
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color.fromARGB(255, 68, 60, 95),
                  ),
                  selectedTrailingIcon: Icon(
                    Icons.keyboard_arrow_up,
                    color: Color.fromARGB(255, 68, 60, 95),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                        color: Colors.black38, fontWeight: FontWeight.w500),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                  hintText: "Role",
                  width: screenWidth * 0.42,
                  controller: roleController,
                  menuStyle: MenuStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                    alignment: Alignment.bottomLeft,
                    surfaceTintColor:
                        WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onSelected: (_) {
                    setState(() {});
                    switch (roleController.text) {
                      case "Member":
                        roleIcon = Icon(
                          Icons.person_2_outlined,
                          color: Color.fromARGB(255, 68, 60, 95),
                        );
                        break;
                      case "Leader":
                        roleIcon = Icon(
                          Icons.person_4_outlined,
                          color: Color.fromARGB(255, 68, 60, 95),
                        );
                        break;
                      case "Finance":
                        roleIcon = Icon(
                          Icons.person_3_outlined,
                          color: Color.fromARGB(255, 68, 60, 95),
                        );
                        break;
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: "Member",
                      label: "Member",
                      leadingIcon: Icon(
                        Icons.person_2_outlined,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                    DropdownMenuEntry(
                      value: "Leader",
                      label: "Leader",
                      leadingIcon: Icon(
                        Icons.person_4_outlined,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                    DropdownMenuEntry(
                      value: "Finance",
                      label: "Finance",
                      leadingIcon: Icon(
                        Icons.person_3_outlined,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.42,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: jobController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Job",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.business_center_outlined,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.42,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: departmentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Department",
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.business_outlined,
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            TextField(
              keyboardType: TextInputType.text,
              controller: teamNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15)),
                hintText: "Team Name",
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(
                  Icons.groups_outlined,
                  color: Color.fromARGB(255, 68, 60, 95),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            TextField(
              keyboardType: TextInputType.number,
              controller: budgetController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15)),
                hintText: "Budget",
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(
                  Icons.money,
                  color: Color.fromARGB(255, 68, 60, 95),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            registerButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if(await TeamModel(
          teamName: teamNameController.text,
          leaderEmail: emailController.text,
          budget: 0,
        ).createTeam(roleController.text,context)){
          if (await UserModel.register(
            nameController.text,
            surnameController.text,
            emailController.text,
            passwordController.text,
            roleController.text,
            jobController.text,
            departmentController.text,
            teamNameController.text,
            context,
          )) {
            nameController.clear();
            surnameController.clear();
            emailController.clear();
            passwordController.clear();
            roleController.clear();
            jobController.clear();
            departmentController.clear();
            teamNameController.clear();
            budgetController.clear();
          }
        }
      },
      child: Text(
        "Register",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 68, 60, 95),
        foregroundColor: Color.fromARGB(255, 187, 179, 203),
        fixedSize: Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
