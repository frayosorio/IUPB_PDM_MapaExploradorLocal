import 'package:flutter/material.dart';
import 'package:mapa_explorador_local/modelos/Lugar.dart';

class DetalleLugarVista extends StatelessWidget {
  final Lugar lugar;
  final Map<String, IconData> iconos;

  const DetalleLugarVista({
    super.key,
    required this.lugar,
    required this.iconos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(
            lugar.nombre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              iconos[lugar.tipo] ?? Icons.place,
              color: Colors.blue,
            ),
            title: Text("Categoría: ${lugar.tipo.toUpperCase()}"),
          ),
          const SizedBox(height: 10),
          Text(lugar.horario),
          const SizedBox(height: 10),
          Text(lugar.telefono),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Aquí se puede poner instrucciones relacionadas con el lugar
                Navigator.pop(context);
              },
              icon: const Icon(Icons.directions),
              label: const Text("IR AHORA"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
