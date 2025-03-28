import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class TabBarObjects extends StatefulWidget {
  const TabBarObjects({super.key});

  @override
  _TabBarObjectsState createState() => _TabBarObjectsState();
}

class _TabBarObjectsState extends State<TabBarObjects> {
  List<String> objetos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemon();
  }

  Future<void> _fetchPokemon() async {
    const url = "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<String> nombresPokemon =
            (data['results'] as List).map((p) => p['name'].toString()).toList();

        setState(() {
          objetos = nombresPokemon;
          isLoading = false;
        });
      } else {
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
            _buildListaObjetos(context),
            const Center(
              child: Icon(Icons.recycling, size: 100, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaObjetos(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: objetos.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            title: Text(
              objetos[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.qr_code, color: Colors.blue),
            onTap: () {
              _mostrarQR(context, objetos[index]);
            },
          ),
        );
      },
    );
  }

  void _mostrarQR(BuildContext context, String objeto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Código QR de $objeto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200, // Tamaño fijo para el ancho del QR
                height: 200, // Tamaño fijo para la altura del QR
                child: QrImageView(
                  data: "QR de $objeto",
                  version: QrVersions.auto,
                  size: 200.0, // Tamaño del QR
                ),
              ),
              const SizedBox(height: 10), // Espaciado entre el QR y el texto
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
