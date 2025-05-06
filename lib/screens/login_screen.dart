import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main_screen.dart';
import '../styles/app_styles.dart';

const storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    String email = _usernameController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Por favor ingresa usuario y contraseña');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://191.101.14.196:8080/v1/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          await storage.write(key: 'jwt_token', value: token);
          await storage.write(key: 'userEmail', value: email);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          _showError('Respuesta inválida del servidor');
        }
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        _showError('Usuario o contraseña incorrectos');
      } else {
        _showError('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppStyles.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/login_image.png', height: 150),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration:
                      AppStyles.inputDecoration('Usuario', Icons.person),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:
                      AppStyles.inputDecoration('Contraseña', Icons.lock),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: AppStyles.buttonStyle,
                        child: const Text('Iniciar Sesión'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
