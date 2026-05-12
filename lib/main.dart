import 'package:flutter/material.dart';
import 'package:yanyana_p/features/auth/login_page.dart';

void main() {
  runApp(const YanYanaApp());
}

class YanYanaApp extends StatelessWidget {
  const YanYanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YanYana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF97316),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}