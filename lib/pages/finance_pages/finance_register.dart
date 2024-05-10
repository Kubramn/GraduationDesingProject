import 'package:bitirme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController jobController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  //String? _selectedRole;

  Icon roleIcon = Icon(Icons.contacts);

  void register() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); //Navigator.of(context).pop;

      print("------------------REGISTERED------------------");
      UserModel(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: roleController.text,
        job: jobController.text,
        department: departmentController.text,
        teamName: teamNameController.text,
      ).createUser();
      nameController.clear();
      surnameController.clear();
      emailController.clear();
      passwordController.clear();
      roleController.clear();
      jobController.clear();
      departmentController.clear();
      teamNameController.clear();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      print("------------------EEERRROOORRR------------------");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 191, 255),
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        centerTitle: true,
        title: Text("Register a User"),
        titleTextStyle: TextStyle(
            fontSize: 40,
            color: Color.fromARGB(255, 107, 190, 218),
            fontWeight: FontWeight.bold),
        backgroundColor: Color.fromARGB(200, 255, 255, 255),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Registerfh",
                style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 68, 149, 163),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
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
                        prefixIcon: Icon(Icons.person),
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
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 20),
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
                        prefixIcon: Icon(Icons.lock_outline),
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
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      alignment: Alignment.bottomLeft,
                      surfaceTintColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: (() => register()),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 88, 171, 186),
                  foregroundColor: Colors.white,
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
