import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'screens/icon_animation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppDatabase db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjectX',
      debugShowCheckedModeBanner: false,
      home: IconAnimation(db: db),
    );
  }
}
