import 'package:bitirme/pages/finance_pages/finance_navbar.dart';
import 'package:bitirme/pages/leader_pages/leader_navbar.dart';
import 'package:bitirme/pages/member_pages/member_navbar.dart';
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

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
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
            color: Color.fromARGB(255, 255, 255, 255),
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

      if (e.code == 'invalid-credential') {
        alertMessage();
      } else if (e.code == '') {
        print('');
      }
    }
  }

  void alertMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Wrong password or email!"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 208, 229, 233),
                Color.fromARGB(255, 135, 215, 230)
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 68, 149, 163),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
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
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
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
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: (() => login()),
                  child: Text(
                    "Log In",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 88, 171, 186),
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
      ),
    );
  }
}
