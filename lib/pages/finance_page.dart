import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

void logout() {
  FirebaseAuth.instance.signOut();
}

class _FinancePageState extends State<FinancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 187, 168, 255),
      body: Column(
        children: [ElevatedButton(onPressed: logout, child: Text("Log Out"))],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(135, 79, 46, 150),
        backgroundColor: Color.fromARGB(255, 187, 168, 255),
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          print(index);
        },
        items: [
          Icon(
            Icons.shopping_cart,
            color: Color.fromARGB(255, 187, 168, 255),
          ),
          Icon(
            Icons.home,
            color: Color.fromARGB(255, 187, 168, 255),
          ),
          Icon(
            Icons.home,
            color: Color.fromARGB(255, 187, 168, 255),
          ),
          Icon(
            Icons.home,
            color: Color.fromARGB(255, 187, 168, 255),
          ),
        ],
      ),
    );
  }
}
