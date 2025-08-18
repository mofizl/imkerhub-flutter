import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(ImkerHubApp());
}

class ImkerHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImkerHub',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8F0),
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}