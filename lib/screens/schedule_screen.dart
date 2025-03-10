import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: const Center(
        child: Text(
          'Aquí puedes ver tu horario.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
