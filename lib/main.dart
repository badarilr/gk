import 'package:flutter/material.dart';
import 'screens/raag_list_screen.dart';

void main() => runApp(const RaagbookApp());

class RaagbookApp extends StatelessWidget {
  const RaagbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raagbook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RaagListScreen(),
    );
  }
}
