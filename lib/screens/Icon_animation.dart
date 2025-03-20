import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class IconAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/icon.png',
              width: 120,
              height: 120,
            ),
            SizedBox(height: 20), 
            CircularProgressIndicator( 
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
