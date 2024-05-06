import 'package:bitirme/pages/leader_pages/leader_dashboard.dart';
import 'package:bitirme/pages/leader_pages/leader_expenses.dart';
import 'package:bitirme/pages/leader_pages/leader_invoice.dart';
import 'package:bitirme/pages/leader_pages/leader_profile.dart';
import 'package:bitirme/pages/leader_pages/leader_requests.dart';
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
    setState(() {
      _currentIndex = index;
    });
  }

  List _screens = [
    LeaderDashboard(),
    LeaderExpenses(),
    LeaderInvoice(),
    LeaderRequests(),
    LeaderProfile(),
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
                    ? Icons.attach_money
                    : Icons.attach_money_outlined,
                text: "Expenses",
              ),
              GButton(
                icon: (_currentIndex) == 2
                    ? Icons.receipt_long
                    : Icons.receipt_long_outlined,
                text: "Invoice",
              ),
              GButton(
                icon: (_currentIndex) == 3
                    ? Icons.request_quote
                    : Icons.request_quote_outlined,
                text: "Requests",
              ),
              GButton(
                icon:
                    (_currentIndex) == 4 ? Icons.person : Icons.person_outline,
                text: user?.displayName ?? "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
