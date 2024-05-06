import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeaderProfile extends StatelessWidget {
  const LeaderProfile({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 600,
              ),
              ElevatedButton(
                onPressed: (() => logout()),
                child: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 0, 0),
                  foregroundColor: Colors.white,
                  fixedSize: Size(500, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
