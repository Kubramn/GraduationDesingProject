import 'package:bitirme/pages/member_pages/member_expenses.dart';
import 'package:bitirme/pages/member_pages/member_invoice.dart';
import 'package:bitirme/pages/member_pages/member_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MemberNavBar extends StatefulWidget {
  const MemberNavBar({super.key});

  @override
  State<MemberNavBar> createState() => _MemberNavBarState();
}

class _MemberNavBarState extends State<MemberNavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;

  void goToPage(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List _screens = [
    MemberExpenses(),
    MemberInvoice(),
    MemberProfile(),
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
                    ? Icons.attach_money
                    : Icons.attach_money_outlined,
                text: "Expenses",
              ),
              GButton(
                icon: (_currentIndex) == 1
                    ? Icons.receipt_long
                    : Icons.receipt_long_outlined,
                text: "Invoice",
              ),
              GButton(
                icon:
                    (_currentIndex) == 2 ? Icons.person : Icons.person_outline,
                text: user?.displayName ?? "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
