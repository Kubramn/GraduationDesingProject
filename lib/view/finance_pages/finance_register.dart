import 'package:bitirme/models/user_model.dart';
import 'package:flutter/material.dart';

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
  TextEditingController leaderEmailController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  //String? _selectedRole;

  Icon roleIcon = Icon(Icons.contacts);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 185,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
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
                    width: 185,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: surnameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
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
              SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color.fromARGB(255, 68, 60, 95),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 185,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
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
                    trailingIcon: Icon(Icons.keyboard_arrow_down),
                    selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
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
                    width: 185,
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
                          roleIcon = Icon(Icons.person_2_outlined);
                          break;
                        case "Leader":
                          roleIcon = Icon(Icons.person_4_outlined);
                          break;
                        case "Finance":
                          roleIcon = Icon(Icons.person_3_outlined);
                          break;
                      }
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                          value: "Member",
                          label: "Member",
                          leadingIcon: Icon(Icons.person_2_outlined)),
                      DropdownMenuEntry(
                          value: "Leader",
                          label: "Leader",
                          leadingIcon: Icon(Icons.person_4_outlined)),
                      DropdownMenuEntry(
                          value: "Finance",
                          label: "Finance",
                          leadingIcon: Icon(Icons.person_3_outlined)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.text,
                controller: leaderEmailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Leader Email",
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.person_4_outlined),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 185,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: jobController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Job",
                        hintStyle: TextStyle(color: Colors.black38),
                        prefixIcon: Icon(Icons.business_center_outlined),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 185,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: departmentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Department",
                        hintStyle: TextStyle(color: Colors.black38),
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.text,
                controller: teamNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Team Name",
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: (() => UserModel.register(
                      nameController,
                      surnameController,
                      emailController,
                      passwordController,
                      jobController,
                      departmentController,
                      roleController,
                      leaderEmailController,
                      teamNameController,
                      context,
                    )),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 68, 60, 95),
                  foregroundColor: Color.fromARGB(255, 187, 179, 203),
                  fixedSize: Size(500, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}