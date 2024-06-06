import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/team_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';

class FinanceUsers extends StatefulWidget {
  const FinanceUsers({super.key});

  @override
  State<FinanceUsers> createState() => _FinanceUsersState();
}

class _FinanceUsersState extends State<FinanceUsers> {
  UserModel? _selectedUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: RawScrollbar(
        radius: const Radius.circular(100),
        thumbColor: Color.fromARGB(255, 157, 203, 201),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.08),
                StreamBuilder<List<UserModel>>(
                  stream: UserModel.fetchAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final users = snapshot.data!;
                      return DropdownMenu<UserModel>(
                        controller: emailController,
                        width: screenWidth * 0.86,
                        leadingIcon: Icon(
                          Icons.person_search,
                          color: Color.fromARGB(255, 49, 102, 101),
                        ),
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromARGB(255, 49, 102, 101),
                        ),
                        selectedTrailingIcon: Icon(
                          Icons.keyboard_arrow_up,
                          color: Color.fromARGB(255, 49, 102, 101),
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                        hintText: LocaleData.dropdownUser.getString(context),
                        menuStyle: MenuStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
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
                          passwordController.text =
                              _selectedUser?.password ?? "";
                          roleController.text = _selectedUser?.role ?? "";
                          jobController.text = _selectedUser?.job ?? "";
                          departmentController.text =
                              _selectedUser?.department ?? "";
                          teamNameController.text =
                              _selectedUser?.teamName ?? "";
                        },
                        dropdownMenuEntries: users.map((UserModel user) {
                          return DropdownMenuEntry<UserModel>(
                            leadingIcon: Icon(
                              Icons.person_outline,
                              color: Color.fromARGB(255, 49, 102, 101),
                            ),
                            label: user.email,
                            value: user,
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          LocaleData.error.getString(context),
                        ),
                      );
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
                  height: screenHeight * 0.07,
                  color: Color.fromARGB(255, 49, 102, 101),
                  thickness: 1.5,
                  indent: 5,
                  endIndent: 5,
                ),
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
                          hintText: LocaleData.name.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 49, 102, 101),
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
                          hintText: LocaleData.surname.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color.fromARGB(255, 49, 102, 101),
                          ),
                        ),
                      ),
                    ),
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
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                          hintText: LocaleData.password.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color.fromARGB(255, 49, 102, 101),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.42,
                      child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: roleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                          hintText: LocaleData.role.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.contacts_outlined,
                            color: Color.fromARGB(255, 49, 102, 101),
                          ),
                        ),
                      ),
                    ),
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
                          hintText: LocaleData.job.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.business_center_outlined,
                            color: Color.fromARGB(255, 49, 102, 101),
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
                          hintText: LocaleData.department.getString(context),
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.business_outlined,
                            color: Color.fromARGB(255, 49, 102, 101),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: roleController.text == "Finance" ? false : true,
                  child: SizedBox(height: screenHeight * 0.04),
                ),
                Visibility(
                  visible: roleController.text == "Finance" ? false : true,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: teamNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      hintText: LocaleData.teamName.getString(context),
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.groups_outlined,
                        color: Color.fromARGB(255, 49, 102, 101),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                updateUserButton(screenWidth),
                SizedBox(height: screenHeight * 0.03),
                deleteUserButton(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetAllFields() {
    setState(() {
      emailController.clear();
      nameController.clear();
      surnameController.clear();
      passwordController.clear();
      roleController.clear();
      jobController.clear();
      departmentController.clear();
      teamNameController.clear();
    });
  }

  Widget updateUserButton(double screenWidth) {
    return ElevatedButton(
      onPressed: () async {
        if (await UserModel.updateUser(
          _selectedUser?.email,
          nameController.text,
          surnameController.text,
          passwordController.text,
          roleController.text,
          jobController.text,
          departmentController.text,
          teamNameController.text,
        )) {
          if (roleController.text == "Leader") {
            TeamModel.updateTeamName(
              _selectedUser!.teamName,
              teamNameController.text,
            );

            UserModel.updateTeamNamesOfUsers(
              _selectedUser!.teamName,
              teamNameController.text,
            );
          }
          resetAllFields();
        }
      },
      child: Text(
        LocaleData.updateUserButton.getString(context),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 49, 102, 101),
        foregroundColor: Color.fromARGB(255, 157, 203, 201),
        fixedSize: Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget deleteUserButton(double screenWidth) {
    return ElevatedButton(
      onPressed: () async {
        if (await UserModel.deleteUser(_selectedUser?.email)) {
          resetAllFields();
        }
      },
      child: Text(
        LocaleData.deleteUserButton.getString(context),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 49, 102, 101),
        foregroundColor: Colors.red,
        fixedSize: Size(double.maxFinite, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
