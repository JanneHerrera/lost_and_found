import 'package:flutter/material.dart';
import '../widgets/tab_bar_objects.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      body: const TabBarObjects(),
    );
  }
}
