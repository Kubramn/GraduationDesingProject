import 'package:bitirme/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registration Page'),
        ),
        body: RegisterPage(),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _username, _password;

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration successful'),
          content: Text('Name: $_name\nEmail: $_username'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
            onSaved: (value) => _name = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) => !value!.isEmpty ? 'Please enter your username' : null,
            onSaved: (value) => _username = value,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
            onSaved: (value) => _password = value,
          ),
          TextButton(
            child: Text('Register'),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
