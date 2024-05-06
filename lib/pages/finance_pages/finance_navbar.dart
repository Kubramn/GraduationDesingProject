import 'package:bitirme/pages/finance_pages/finance_dashboard.dart';
import 'package:bitirme/pages/finance_pages/finance_profile.dart';
import 'package:bitirme/pages/finance_pages/finance_register.dart';
import 'package:bitirme/pages/finance_pages/finance_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class FinanceNavBar extends StatefulWidget {
  const FinanceNavBar({super.key});

  @override
  State<FinanceNavBar> createState() => _FinanceNavBarState();
}

class _FinanceNavBarState extends State<FinanceNavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;

  void goToPage(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List _screens = [
    FinanceDashboard(),
    FinanceRequests(),
    FinanceRegister(),
    FinanceProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) => goToPage(index),
            iconSize: 24,
            backgroundColor: Colors.black,
            haptic: true,
            gap: 8,
            color: Colors.white,
            activeColor: Colors.black,
            //textStyle: TextStyle(fontSize: 15, color: Colors.white),
            tabBackgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            //duration: Duration(milliseconds: 800),
            tabs: [
              GButton(
                icon: (_currentIndex) == 0
                    ? Icons.pie_chart_rounded
                    : Icons.pie_chart_outline_rounded,
                text: "Dashboard",
              ),
              GButton(
                icon: (_currentIndex) == 1
                    ? Icons.request_quote
                    : Icons.request_quote_outlined,
                text: "Requests",
              ),
              GButton(
                icon: (_currentIndex) == 2
                    ? Icons.person_add
                    : Icons.person_add_outlined,
                text: "Register",
              ),
              GButton(
                icon:
                    (_currentIndex) == 3 ? Icons.person : Icons.person_outline,
                text: user?.displayName ?? "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
