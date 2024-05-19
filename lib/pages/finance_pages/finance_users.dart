import 'package:bitirme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinanceUsers extends StatefulWidget {
  const FinanceUsers({super.key});

  @override
  State<FinanceUsers> createState() => _FinanceUsersState();
}

class _FinanceUsersState extends State<FinanceUsers> {
  UserModel? _selectedUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  Icon roleIcon = Icon(Icons.contacts);

  Stream<List<UserModel>> fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> updateUser(String? email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("users").doc(email).get();

      if (snapshot.exists) {
        await FirebaseFirestore.instance.collection("users").doc(email).update({
          "name": nameController.text,
          "surname": surnameController.text,
          "password": passwordController.text,
          "role": roleController.text,
          "job": jobController.text,
          "department": departmentController.text,
          "teamName": teamNameController.text,
        });
        nameController.clear();
        surnameController.clear();
        passwordController.clear();
        roleController.clear();
        jobController.clear();
        departmentController.clear();
        teamNameController.clear();

        print("User data updated successfully!");
      } else {
        print("User not found!");
      }
    } catch (e) {
      print("Error fetching or updating user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              StreamBuilder<List<UserModel>>(
                stream: fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return DropdownMenu<UserModel>(
                      width: screenWidth - 60,
                      leadingIcon: Icon(Icons.person_search),
                      trailingIcon: Icon(Icons.keyboard_arrow_down),
                      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                      ),
                      hintText: "Select a user to edit or delete...",
                      menuStyle: MenuStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        alignment: Alignment.bottomLeft,
                        surfaceTintColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 157, 203, 201)),
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onSelected: (user) {
                        setState(() {
                          _selectedUser = user;
                        });
                        nameController.text = _selectedUser?.name ?? "";
                        surnameController.text = _selectedUser?.surname ?? "";
                        passwordController.text = _selectedUser?.password ?? "";
                        roleController.text = _selectedUser?.role ?? "";
                        jobController.text = _selectedUser?.job ?? "";
                        departmentController.text =
                            _selectedUser?.department ?? "";
                        teamNameController.text = _selectedUser?.teamName ?? "";
                      },
                      dropdownMenuEntries: users.map((UserModel user) {
                        return DropdownMenuEntry<UserModel>(
                          leadingIcon: Icon(Icons.person_outline),
                          label: user.email,
                          value: user,
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("ERROR!"));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
              Divider(
                height: 70,
                color: Color.fromARGB(255, 49, 102, 101),
                thickness: 1.5,
                indent: 5,
                endIndent: 5,
              ),
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
              SizedBox(
                height: 60,
                width: screenWidth - 60,
                child: ElevatedButton(
                  onPressed: (() => updateUser(_selectedUser?.email)),
                  child: Text(
                    "Update User",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 49, 102, 101),
                    foregroundColor: Color.fromARGB(255, 157, 203, 201),
                    //fixedSize: ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 60,
                width: screenWidth - 60,
                child: ElevatedButton(
                  onPressed: (() => {}),
                  child: Text(
                    "Delete User",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 49, 102, 101),
                    foregroundColor: Colors.red,
                    //fixedSize: ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
