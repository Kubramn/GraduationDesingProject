import 'package:bitirme/pages/auth_page.dart';
import 'package:bitirme/pages/leader_pages/leader_invoice.dart';
import 'package:bitirme/pages/leader_pages/leader_navbar.dart';
import 'package:bitirme/pages/member_pages/member_navbar.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/pages/finance_pages/finance_navbar.dart';
import 'package:bitirme/pages/login_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  LeaderInvoice.firstCamera = CameraDescription(
      name: "name",
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 100);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ExpenseManagementApplication());
}

class ExpenseManagementApplication extends StatelessWidget {
  const ExpenseManagementApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemberNavBar(),
      theme: ThemeData(highlightColor: Colors.amber),
    );
  }
}
