import 'package:bitirme/view/expenses_page.dart';
import 'package:bitirme/view/invoice_page.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberNavBar extends StatefulWidget {
  const MemberNavBar({super.key});

  @override
  State<MemberNavBar> createState() => _MemberNavBarState();
}

class _MemberNavBarState extends State<MemberNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: screenWidth * 0.13,
          left: screenWidth * 0.13,
          bottom: screenWidth * 0.06,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.037,
              vertical: screenHeight * 0.017,
            ),
            child: GNav(
              tabBorderRadius: 22,
              selectedIndex: _currentIndex,
              onTabChange: (index) => goToPage(index),
              iconSize: 24,
              backgroundColor: Colors.transparent,
              haptic: true,
              gap: 8,
              //textStyle: TextStyle(fontSize: 15, color: Colors.white),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.015,
              ),
              //duration: Duration(milliseconds: 800),
              tabs: [
                GButton(
                  iconColor: Color.fromARGB(255, 76, 89, 23),
                  iconActiveColor: Color.fromARGB(255, 76, 89, 23),
                  backgroundColor: Color.fromARGB(255, 191, 203, 155),
                  textColor: Color.fromARGB(255, 76, 89, 23),
                  icon: (_currentIndex) == 0
                      ? Icons.attach_money
                      : Icons.attach_money_outlined,
                  text: "Expenses",
                ),
                GButton(
                  iconColor: Color.fromARGB(255, 49, 102, 101),
                  iconActiveColor: Color.fromARGB(255, 49, 102, 101),
                  backgroundColor: Color.fromARGB(255, 157, 203, 201),
                  textColor: Color.fromARGB(255, 49, 102, 101),
                  icon: (_currentIndex) == 1
                      ? Icons.receipt_long
                      : Icons.receipt_long_outlined,
                  text: "Invoice",
                ),
                GButton(
                  icon: Icons.logout_outlined,
                  iconColor: Color.fromARGB(255, 139, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToPage(index) async {
    if (index == 2) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("email");
      await prefs.remove("password");
      LoginPage.currentUserEmail = null;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  final List _screens = const [
    ExpensesPage(),
    InvoicePage(),
  ];
}
