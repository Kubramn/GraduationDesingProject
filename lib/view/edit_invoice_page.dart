import 'dart:io';
import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/leader_pages/leader_navbar.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:bitirme/view/member_pages/member_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../controller/ocr_controller.dart';

class EditInvoicePage extends StatefulWidget {
  final String imagePath;
  const EditInvoicePage({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditInvoicePage> createState() => _EditInvoicePageState();
}

class _EditInvoicePageState extends State<EditInvoicePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Icon categoryIcon = Icon(
    Icons.category_outlined,
    color: Color.fromARGB(255, 49, 102, 101),
  );

  @override
  void initState() {
    super.initState();
    readTextFromImage(widget.imagePath, dateController, priceController);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          highlightColor: Color.fromARGB(50, 49, 102, 101),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: RawScrollbar(
        radius: const Radius.circular(100),
        thumbColor: Color.fromARGB(255, 157, 203, 201),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth),
                  child: Image.file(
                    File(widget.imagePath),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                invoiceInfoTextField(
                  titleController,
                  LocaleData.dialogTitle.getString(context),
                  Icons.title,
                ),
                SizedBox(height: screenHeight * 0.02),
                invoiceInfoTextField(
                  descriptionController,
                  LocaleData.dialogDescription.getString(context),
                  Icons.description_outlined,
                ),
                SizedBox(height: screenHeight * 0.02),
                categoryDropdownMenu(),
                SizedBox(height: screenHeight * 0.02),
                invoiceInfoTextField(
                  dateController,
                  LocaleData.dialogDate.getString(context),
                  Icons.date_range,
                ),
                SizedBox(height: screenHeight * 0.02),
                invoiceInfoTextField(
                  priceController,
                  LocaleData.dialogPrice.getString(context),
                  Icons.price_change_outlined,
                ),
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  onPressed: () async {
                    addExpense();
                    String role = await UserModel.getRoleByEmail(
                        LoginPage.currentUserEmail ?? "");

                    switch (role) {
                      case "Member":
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemberNavBar(),
                          ),
                        );
                        break;

                      case "Leader":
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LeaderNavBar(),
                          ),
                        );
                        break;
                    }
                  },
                  child: Text(
                    LocaleData.addExpenseButton.getString(context),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 157, 203, 201),
                    foregroundColor: Color.fromARGB(255, 49, 102, 101),
                    fixedSize: Size(500, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryDropdownMenu() {
    return DropdownMenu<String>(
      controller: categoryController,
      leadingIcon: categoryIcon,
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
        hintStyle:
            TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      hintText: LocaleData.dialogCategory.getString(context),
      width: 394,

      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        alignment: Alignment.bottomLeft,
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onSelected: (_) {
        setState(() {});
        switch (categoryController.text) {
          case "Travel and Transportation":
            categoryIcon = Icon(
              Icons.emoji_transportation,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Meals and Entertainment":
            categoryIcon = Icon(
              Icons.fastfood_outlined,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Office Supplies and Equipment":
            categoryIcon = Icon(
              Icons.meeting_room_outlined,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Other Expenses":
            categoryIcon = Icon(
              Icons.attach_money,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
        }
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: "Travel and Transportation",
          label: "Travel and Transportation",
          leadingIcon: Icon(
            Icons.emoji_transportation,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Meals and Entertainment",
          label: "Meals and Entertainment",
          leadingIcon: Icon(
            Icons.fastfood_outlined,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Office Supplies and Equipment",
          label: "Office Supplies and Equipment",
          leadingIcon: Icon(
            Icons.meeting_room_outlined,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Other Expenses",
          label: "Other Expenses",
          leadingIcon: Icon(
            Icons.attach_money,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
      ],
    );
  }

  Widget invoiceInfoTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black38),
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 49, 102, 101),
        ),
      ),
    );
  }

  Future<void> addExpense() async {
    String checkerUserEmail = await UserModel.decideCheckerUserEmailByTeam(
      LoginPage.currentUserEmail ?? "",
    );
    String status = await UserModel.decideStatusByRole(
      LoginPage.currentUserEmail ?? "",
    );

    ExpenseModel(
            title: titleController.text,
            status: status,
            price: priceController.text,
            date: dateController.text,
            description: descriptionController.text,
            userEmail: LoginPage.currentUserEmail ?? "",
            checkerUserEmail: checkerUserEmail,
            category: categoryController.text,
            image: widget.imagePath)
        .createExpense();
  }
}

