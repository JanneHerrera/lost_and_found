import 'dart:async';
import 'package:flutter/material.dart';

class TabBarObjects extends StatefulWidget {
  @override
  _TabBarObjectsState createState() => _TabBarObjectsState();
}

class _TabBarObjectsState extends State<TabBarObjects> {
  List<Map<String, String>> misObjetos = [];
  List<Map<String, String>> recoleccionObjetos = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchObjetos(); // Primera carga
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchObjetos(); // Se repite cada minuto
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar al salir del widget
    super.dispose();
  }

  Future<void> _fetchObjetos() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulación de la lógica para obtener los datos
      final nuevosMisObjetos = [
        {'nombre': 'Mochila', 'categoria': 'Escolar'},
        {'nombre': 'Suéter azul', 'categoria': 'Ropa'}
      ];
      final nuevosRecoleccionObjetos = [
        {'nombre': 'Termo', 'categoria': 'Accesorio'}
      ];

      // Aquí podrías comparar si hay cambios antes de hacer setState
      final sonIguales = _listasIguales(misObjetos, nuevosMisObjetos) &&
          _listasIguales(recoleccionObjetos, nuevosRecoleccionObjetos);

      if (!sonIguales) {
        setState(() {
          misObjetos = nuevosMisObjetos;
          recoleccionObjetos = nuevosRecoleccionObjetos;
        });
      }
    } catch (e) {
      print('Error al obtener los objetos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Comparación simple de listas de mapas
  bool _listasIguales(
      List<Map<String, String>> a, List<Map<String, String>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].toString() != b[i].toString()) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const TabBar(
          tabs: [
            Tab(text: 'Mis Objetos'),
            Tab(text: 'Objetos Recogidos'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              _buildLista(misObjetos),
              _buildLista(recoleccionObjetos),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLista(List<Map<String, String>> objetos) {
    if (objetos.isEmpty) {
      return const Center(child: Text('No hay objetos para mostrar'));
    }

    return ListView.builder(
      itemCount: objetos.length,
      itemBuilder: (context, index) {
        final objeto = objetos[index];
        return ListTile(
          title: Text(objeto['nombre'] ?? ''),
          subtitle: Text(objeto['categoria'] ?? ''),
        );
      },
    );
  }
}
