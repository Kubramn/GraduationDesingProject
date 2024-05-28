import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/finance_pages/finance_navbar.dart';
import 'package:bitirme/view/leader_pages/leader_navbar.dart';
import 'package:bitirme/view/member_pages/member_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String? currentUserEmail;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70),
              Image(image: AssetImage("images/login_image.png")),
              SizedBox(height: 80),
              Text(
                LocaleData.loginTitle.getString(context),
                style: TextStyle(
                    fontSize: 45,
                    color: Color.fromARGB(255, 35, 97, 49),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: Color.fromARGB(255, 255, 195, 34),
                    cursorColor: Color.fromARGB(255, 255, 195, 34),
                    selectionHandleColor: Color.fromARGB(255, 255, 195, 34),
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)),
                    hintText: LocaleData.email.getString(context),
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color.fromARGB(255, 35, 97, 49),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: Color.fromARGB(255, 255, 195, 34),
                    cursorColor: Color.fromARGB(255, 255, 195, 34),
                    selectionHandleColor: Color.fromARGB(255, 255, 195, 34),
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)),
                    hintText: LocaleData.password.getString(context),
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color.fromARGB(255, 35, 97, 49),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              ElevatedButton(
                onPressed: () async {
                  String? email = await UserModel.login(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                  if (email != null) {
                    LoginPage.currentUserEmail = email;
                    route();
                  }
                },
                child: Text(
                  LocaleData.loginButton.getString(context),
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 145, 183, 92),
                  foregroundColor: Color.fromARGB(255, 35, 97, 49),
                  fixedSize: Size(screenWidth * 0.9, screenHeight * 0.056),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _changeLocale(_currentLocale);
                    },
                    icon: changeLanguageIcon(_currentLocale),
                  ),
                  SizedBox(width: 3),
                  IconButton(
                    highlightColor: Color.fromARGB(100, 145, 183, 92),
                    onPressed: () {
                      showCallDialog();
                    },
                    icon: Icon(
                      Icons.support_agent,
                      color: Color.fromARGB(255, 35, 97, 49),
                      size: 40,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCallDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            "Support",
            style: TextStyle(
              color: Color.fromARGB(255, 52, 52, 52),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 350,
            height: 80,
            child: Text(
              "Please call us if you have any questions or problems.",
              style: TextStyle(
                color: Color.fromARGB(255, 52, 52, 52),
                fontSize: 25,
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Color.fromARGB(255, 145, 183, 92),
              ),
              onPressed: () async {
                FlutterPhoneDirectCaller.callNumber("+905079166060");
                Navigator.pop(context);
              },
              child: Text(
                "Call",
                style: TextStyle(
                  color: Color.fromARGB(255, 35, 97, 49),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Color.fromARGB(255, 145, 183, 92),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Color.fromARGB(255, 35, 97, 49),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _changeLocale(String currentLocale) {
    if (currentLocale == "tr") {
      _flutterLocalization.translate("en");
      setState(() {
        _currentLocale = "en";
      });
    } else {
      _flutterLocalization.translate("tr");
      setState(() {
        _currentLocale = "tr";
      });
    }
  }

  Image changeLanguageIcon(String currentLocale) {
    if (currentLocale == "tr") {
      return Image.asset(
        'images/gb.png',
        width: 45,
      );
    } else {
      return Image.asset(
        'images/tr.png',
        width: 45,
      );
    }
  }

  void route() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(LoginPage.currentUserEmail)
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
}
