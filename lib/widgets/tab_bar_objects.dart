import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lost_and_found/screens/login_screen.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class TabBarObjects extends StatefulWidget {
  const TabBarObjects({super.key});

  @override
  _TabBarObjectsState createState() => _TabBarObjectsState();
}

class _TabBarObjectsState extends State<TabBarObjects> {
  List<Map<String, String>> misObjetos = [];
  List<Map<String, String>> recoleccionObjetos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchObjetos();
  }

  Future<void> _fetchObjetos() async {
    final email =
        await storage.read(key: "userEmail"); // ← aquí esperamos el valor
    final token = await storage.read(key: 'jwt_token');

    if (email == null) {
      print("No se encontró el userEmail en storage");
      setState(() {
        isLoading = false;
      });
      return;
    }

    final uri = Uri(
      scheme: 'http',
      host: '191.101.14.196',
      port: 8080,
      path: '/v1/lost-objects/users/',
      queryParameters: {
        'userEmail': email,
      },
    );
    print("llamado a $uri");
    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<Map<String, String>> mis = [];
        final List<Map<String, String>> recolectados = [];

        for (var item in data['content']) {
          final objeto = {
            'name': item['name'].toString(),
            'description': item['description'].toString(),
            'qrValue': item['qrValue'].toString(),
          };
          if (item['status'] == true) {
            recolectados.add(objeto);
          } else {
            mis.add(objeto);
          }
        }

        setState(() {
          misObjetos = mis;
          recoleccionObjetos = recolectados;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("llamado a $uri");
        print("Código de respuesta: ${response.statusCode}");
        print("Cuerpo recibido: ${response.body}");
        throw Exception("Error al obtener datos");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5F98E4),
          title: const Text("Objetos", style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Mis Objetos"),
              Tab(text: "Recolección"),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF2F6FC),
        body: TabBarView(
          children: [
            _buildListaObjetos(context, misObjetos),
            _buildListaObjetos(context, recoleccionObjetos),
          ],
        ),
      ),
    );
  }

  Widget _buildListaObjetos(
      BuildContext context, List<Map<String, String>> lista) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (lista.isEmpty) {
      return const Center(child: Text("No hay objetos para mostrar."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final item = lista[index];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            title: Text(
              item['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              item['description'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: const Icon(Icons.qr_code, color: Colors.blue),
            onTap: () {
              _mostrarQR(context, item['qrValue'] ?? '');
            },
          ),
        );
      },
    );
  }

  void _mostrarQR(BuildContext context, String qrValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Código QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrValue,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Escanea este código para más información.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
