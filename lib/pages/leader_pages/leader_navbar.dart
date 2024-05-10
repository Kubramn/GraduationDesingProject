import 'package:bitirme/pages/leader_pages/leader_dashboard.dart';
import 'package:bitirme/pages/leader_pages/leader_expenses.dart';
import 'package:bitirme/pages/leader_pages/leader_invoice.dart';
import 'package:bitirme/pages/leader_pages/leader_requests.dart';
import 'package:bitirme/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class LeaderNavBar extends StatefulWidget {
  const LeaderNavBar({super.key});

  @override
  State<LeaderNavBar> createState() => _LeaderNavBarState();
}

class _LeaderNavBarState extends State<LeaderNavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;

  void goToPage(index) {
    if (index == 4) {
      FirebaseAuth.instance.signOut();
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
    LeaderDashboard(),
    LeaderExpenses(),
    LeaderInvoice(),
    LeaderRequests(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(180, 255, 255, 255),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                  iconColor: Colors.black,
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  icon: (_currentIndex) == 0
                      ? Icons.pie_chart_rounded
                      : Icons.pie_chart_outline_rounded,
                  text: "Dashboard",
                ),
                GButton(
                  iconColor: Colors.black,
                  iconActiveColor: Colors.white,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  icon: (_currentIndex) == 1
                      ? Icons.attach_money
                      : Icons.attach_money_outlined,
                  text: "Expenses",
                ),
                GButton(
                  iconColor: Colors.black,
                  iconActiveColor: Colors.black,
                  backgroundColor: Colors.amber,
                  textColor: Colors.black,
                  icon: (_currentIndex) == 2
                      ? Icons.receipt_long
                      : Icons.receipt_long_outlined,
                  text: "Invoice",
                ),
                GButton(
                  iconColor: Colors.black,
                  iconActiveColor: Colors.black,
                  backgroundColor: Colors.amber,
                  textColor: Colors.black,
                  icon: (_currentIndex) == 3
                      ? Icons.request_quote
                      : Icons.request_quote_outlined,
                  text: "Requests",
                ),
                GButton(
                  icon: Icons.logout_outlined,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
