import 'package:flutter/material.dart';
import 'screens/Icon_animation.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', 
      routes: {
        '/': (context) => IconAnimation(), 
        '/login': (context) => LoginScreen(),
        '/taskList': (context) => TaskListScreen(),
        '/addTask': (context) => AddTaskScreen(onTaskAdded: (Task) {},), 
      },
    );
  }
}
