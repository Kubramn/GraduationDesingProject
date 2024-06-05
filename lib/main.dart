import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/view/invoice_page.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final cameras = await availableCameras();
  InvoicePage.firstCamera = const CameraDescription(
    name: "name",
    lensDirection: CameraLensDirection.back,
    sensorOrientation: 10,
  );

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

class ExpenseManagementApplication extends StatefulWidget {
  const ExpenseManagementApplication({super.key});

  @override
  State<ExpenseManagementApplication> createState() =>
      _ExpenseManagementApplicationState();
}

class _ExpenseManagementApplicationState
    extends State<ExpenseManagementApplication> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: const LoginPage(),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: locales, initLanguageCode: "en");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
