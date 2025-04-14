// login_screen.dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import 'login_background.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final AppDatabase db;
  const LoginScreen({required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBackground(
        child: LoginForm(db: db),
      ),
    );
  }
}
