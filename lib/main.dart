import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const RaagbookApp());

class RaagbookApp extends StatelessWidget {
  const RaagbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gk Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
