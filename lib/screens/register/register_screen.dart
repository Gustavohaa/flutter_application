// register_screen.dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import 'register_background.dart';
import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  final AppDatabase db;
  const RegisterScreen({required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterBackground(
        child: RegisterForm(db: db),
      ),
    );
  }
}
