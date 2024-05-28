import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("tr", LocaleData.tr),
  MapLocale("en", LocaleData.en),
];

mixin LocaleData {
  static const String email = "email";
  static const String password = "password";
  static const String loginTitle = "loginTitle";
  static const String loginButton = "loginButton";

  static const Map<String, dynamic> tr = {
    "email": "E-posta",
    "password": "Şifre",
    "loginTitle": "Giriş",
    "loginButton": "Giriş Yap",
  };

  static const Map<String, dynamic> en = {
    "email": "Email",
    "password": "Password",
    "loginTitle": "Login",
    "loginButton": "Log In",
  };
}
