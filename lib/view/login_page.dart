import 'package:bitirme/alert_message.dart';
import 'package:bitirme/view/finance_pages/finance_navbar.dart';
import 'package:bitirme/view/leader_pages/leader_navbar.dart';
import 'package:bitirme/view/member_pages/member_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.07),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.4,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 52, 52, 52),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color.fromARGB(255, 52, 52, 52),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color.fromARGB(255, 52, 52, 52),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                ElevatedButton(
                  onPressed: (() => login()),
                  child: Text(
                    "Log In",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 52, 52, 52),
                    foregroundColor: Colors.white,
                    fixedSize: Size(screenWidth * 0.9, screenHeight * 0.056),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get("role") == "Member") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MemberNavBar(),
            ),
          );
        } else if (documentSnapshot.get("role") == "Leader") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LeaderNavBar(),
            ),
          );
        } else if (documentSnapshot.get("role") == "Finance") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FinanceNavBar(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void login() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      //Navigator.of(context).pop;
      route();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print("***************************${e.code}***************************");

      if (e.code == "invalid-credential") {
        alertMessage("Wrong password email etc", Colors.red, context);
      } else if (e.code == "invalid-email") {
        alertMessage("Email @ vs typo", Colors.red, context);
      } else if (e.code == "missing-password") {
        alertMessage("missing-password", Colors.red, context);
      } else if (e.code == "too-many-requests") {
        alertMessage("too-many-requests", Colors.red, context);
      }
    }
  }
}
