import 'package:flutter/material.dart';
import '../widgets/tab_bar_objects.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FC),
        appBar: AppBar(
          title: const Text('Objetos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mis Objetos'),
              Tab(text: 'Objetos Recogidos'),
            ],
          ),
        ),
        body: TabBarObjects(),
      ),
    );
  }
}
