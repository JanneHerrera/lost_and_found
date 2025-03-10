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
  List<String> objetos = []; // 🔥 Lista vacía para almacenar los Pokémon
  bool isLoading = true; // 🔥 Estado para saber si la carga sigue en proceso

  @override
  void initState() {
    super.initState();
    _fetchPokemon(); // 🔥 Llamamos a la función al iniciar el widget
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
          objetos = nombresPokemon; // 🔥 Guardamos los nombres obtenidos
          isLoading = false; // 🔥 Marcamos como cargado
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
          bottom: const TabBar(
            tabs: [
              Tab(text: "Mis Objetos"),
              Tab(text: "Recolección"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListaObjetos(context),
            const Icon(Icons.recycling),
          ],
        ),
      ),
    );
  }

  Widget _buildListaObjetos(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // 🔄 Mostramos carga
    }

    return ListView.builder(
      itemCount: objetos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(objetos[index]),
          trailing: const Icon(Icons.qr_code),
          onTap: () {
            _mostrarQR(context, objetos[index]);
          },
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
          content: SizedBox(
            width: 200,
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: "QR de $objeto",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Escanea este código para más información.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
