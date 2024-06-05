import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/finance_pages/finance_navbar.dart';
import 'package:bitirme/view/leader_pages/leader_navbar.dart';
import 'package:bitirme/view/member_pages/member_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String? currentUserEmail;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  Image _currentLocaleFlag = Image.asset(
    'images/tr.png',
    width: 45,
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _setCurrentLocale();
    _checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: screenWidth * 0.06,
          left: screenWidth * 0.06,
          right: screenWidth * 0.06,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    Image(
                      image: AssetImage("images/login_image.png"),
                      width: double.maxFinite,
                    ),
                    SizedBox(height: screenHeight * 0.04),
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
                          selectionHandleColor:
                              Color.fromARGB(255, 255, 195, 34),
                        ),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: TextStyle(height: 1.5),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
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
                          selectionHandleColor:
                              Color.fromARGB(255, 255, 195, 34),
                        ),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(height: 1.5),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
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
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("email", emailController.text);
                          await prefs.setString(
                              "password", passwordController.text);
                          LoginPage.currentUserEmail = email;
                          route(email);
                        }
                      },
                      child: Text(
                        LocaleData.loginButton.getString(context),
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 145, 183, 92),
                        foregroundColor: Color.fromARGB(255, 35, 97, 49),
                        fixedSize: Size(double.maxFinite, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    _changeLocale(_currentLocale);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("currentLocale", _currentLocale);
                  },
                  icon: _currentLocaleFlag,
                ),
                SizedBox(width: 3),
                IconButton(
                  highlightColor: Color.fromARGB(100, 145, 183, 92),
                  onPressed: () {
                    showSupportDialog();
                  },
                  icon: Icon(
                    Icons.support_agent,
                    color: Color.fromARGB(255, 35, 97, 49),
                    size: 40,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            LocaleData.dialogSupportTitle.getString(context),
            style: TextStyle(
              color: Color.fromARGB(255, 35, 97, 49),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            //height: 100,
            child: AutoSizeText(
              maxLines: 4,
              maxFontSize: 25,
              minFontSize: 25,
              overflow: TextOverflow.ellipsis,
              LocaleData.dialogSupportContent.getString(context),
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
                LocaleData.dialogCallButton.getString(context),
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
                LocaleData.dialogCloseButton.getString(context),
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

  void _checkUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("email");
    final String? password = prefs.getString("password");

    if (email != null && password != null) {
      setState(() {
        LoginPage.currentUserEmail = email;
      });
      route(email);
    }
  }

  void _changeLocale(String currentLocale) {
    if (currentLocale == "tr") {
      _flutterLocalization.translate("en");
      setState(() {
        _currentLocale = "en";
        _currentLocaleFlag = Image.asset(
          'images/tr.png',
          width: 45,
        );
      });
    } else {
      _flutterLocalization.translate("tr");
      setState(() {
        _currentLocale = "tr";
        _currentLocaleFlag = Image.asset(
          'images/gb.png',
          width: 45,
        );
      });
    }
  }

  void _setCurrentLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentLocale = prefs.getString("currentLocale");
    if (currentLocale == "tr") {
      setState(() {
        _currentLocale = "tr";
        _currentLocaleFlag = Image.asset(
          'images/gb.png',
          width: 45,
        );
      });
    } else {
      setState(() {
        _currentLocale = "en";
        _currentLocaleFlag = Image.asset(
          'images/tr.png',
          width: 45,
        );
      });
    }
  }

  void route(String email) async {
    String role = await UserModel.getRoleByEmail(email);

    if (role == "Member") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MemberNavBar(),
        ),
      );
    } else if (role == "Leader") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderNavBar(),
        ),
      );
    } else if (role == "Finance") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinanceNavBar(),
        ),
      );
    }
    ;
  }
}
