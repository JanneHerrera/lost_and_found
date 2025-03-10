import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Colors.indigo;
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);

  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
    );
  }

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
  );
}
