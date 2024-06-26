import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/view/finance_pages/finance_dashboard.dart';
import 'package:bitirme/view/finance_pages/finance_register.dart';
import 'package:bitirme/view/finance_pages/finance_requests.dart';
import 'package:bitirme/view/finance_pages/finance_users.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceNavBar extends StatefulWidget {
  const FinanceNavBar({super.key});

  @override
  State<FinanceNavBar> createState() => _FinanceNavBarState();
}

class _FinanceNavBarState extends State<FinanceNavBar> {
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
          right: screenWidth * 0.04,
          left: screenWidth * 0.04,
          bottom: 25,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.037,
              vertical: 17,
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
                vertical: 15,
              ),
              //duration: Duration(milliseconds: 800),
              tabs: [
                GButton(
                  iconColor: Color.fromARGB(255, 96, 71, 36),
                  iconActiveColor: Color.fromARGB(255, 96, 71, 36),
                  backgroundColor: Color.fromARGB(255, 227, 185, 117),
                  textColor: Color.fromARGB(255, 96, 71, 36),
                  icon: (_currentIndex) == 0
                      ? Icons.pie_chart_rounded
                      : Icons.pie_chart_outline_rounded,
                  text: LocaleData.navbarDashboard.getString(context),
                ),
                GButton(
                  iconColor: Color.fromARGB(255, 76, 89, 23),
                  iconActiveColor: Color.fromARGB(255, 76, 89, 23),
                  backgroundColor: Color.fromARGB(255, 191, 203, 155),
                  textColor: Color.fromARGB(255, 76, 89, 23),
                  icon: (_currentIndex) == 1
                      ? Icons.request_quote
                      : Icons.request_quote_outlined,
                  text: LocaleData.navbarRequests.getString(context),
                ),
                GButton(
                  iconColor: Color.fromARGB(255, 49, 102, 101),
                  iconActiveColor: Color.fromARGB(255, 49, 102, 101),
                  backgroundColor: Color.fromARGB(255, 157, 203, 201),
                  textColor: Color.fromARGB(255, 49, 102, 101),
                  icon: (_currentIndex) == 2
                      ? Icons.people_alt
                      : Icons.people_alt_outlined,
                  text: LocaleData.navbarUsers.getString(context),
                ),
                GButton(
                  iconColor: Color.fromARGB(255, 68, 60, 95),
                  iconActiveColor: Color.fromARGB(255, 68, 60, 95),
                  backgroundColor: Color.fromARGB(255, 187, 179, 203),
                  textColor: Color.fromARGB(255, 68, 60, 95),
                  icon: (_currentIndex) == 3
                      ? Icons.person_add
                      : Icons.person_add_outlined,
                  text: LocaleData.navbarRegister.getString(context),
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
    if (index == 4) {
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
    FinanceDashboard(),
    FinanceRequests(),
    FinanceUsers(),
    FinanceRegister(),
  ];
}
