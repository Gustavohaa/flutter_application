import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', 
      routes: {
        '/': (context) => LoginScreen(), 
        '/taskList': (context) => TaskListScreen(),
        '/addTask': (context) => AddTaskScreen(), 
      },
    );
  }
}