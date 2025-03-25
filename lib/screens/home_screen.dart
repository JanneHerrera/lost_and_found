import 'package:flutter/material.dart';
import '../widgets/tab_bar_objects.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5F98E4),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      body: const TabBarObjects(),
    );
  }
}
