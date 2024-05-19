import 'package:bitirme/pages/expenses_page.dart';
import 'package:bitirme/pages/invoice_page.dart';
import 'package:bitirme/pages/leader_pages/leader_invoice.dart';
import 'package:bitirme/pages/leader_pages/leader_navbar.dart';
import 'package:bitirme/pages/member_pages/member_expenses.dart';
import 'package:bitirme/pages/member_pages/member_invoice.dart';
import 'package:bitirme/pages/member_pages/member_navbar.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/pages/finance_pages/finance_navbar.dart';
import 'package:bitirme/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  InvoicePage.firstCamera = cameras.first;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ExpenseManagementApplication());
}

class ExpenseManagementApplication extends StatelessWidget {
  const ExpenseManagementApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
