import 'package:flutter/material.dart';
import 'package:mapa_explorador_local/vistas/mapa_vista.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MapaVista(titulo: "Buscando mis sitios..."),
    );
  }
}
