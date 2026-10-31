import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../configuracion/configuracion.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapaVista extends StatefulWidget {
  const MapaVista({super.key, required this.titulo});

  final String titulo;

  @override
  State<MapaVista> createState() => _MapaState();
}

class _MapaState extends State<MapaVista> {
  String _categoriaSeleccionada = "cafe";
  final MapController _controladorMapa = MapController();
  LatLng? _posicionActual;
  StreamSubscription<Position>? _secuenciaPosicionamiento;
  bool _mapaListo = false; // Bandera para saber si el mapa ya se renderizó

  Future<void> _buscarLugares() async {}

  @override
  void initState() {
    super.initState();
    _iniciarEscuchaUbicacion();
  }

  Future<void> _iniciarEscuchaUbicacion() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      print("GPS Desactivado");
      return;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        print("Permiso no concedido");
        return;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      print("Permiso no concedido de manera permanente");
      return;
    }

    LocationSettings especificacionesLocalizacion = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _secuenciaPosicionamiento = Geolocator.getPositionStream(
      locationSettings: especificacionesLocalizacion,
    ).listen((Position posicion) {
      final nuevaPosicion = LatLng(posicion.latitude, posicion.longitude);
      setState(() {
        _posicionActual = nuevaPosicion;
        print("Nueva posición: $nuevaPosicion");

        // Solo intentamos mover el mapa si ya sabemos que el widget FlutterMap fue creado
        if (_mapaListo) {
          try {
            _controladorMapa.move(nuevaPosicion, 14);
          } catch (e) {
            print("Error al mover el mapa: $e");
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _secuenciaPosicionamiento?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: [
          DropdownButton(
            value: _categoriaSeleccionada,
            items: MapaConfiguracion.categorias.map((categoria) {
              return DropdownMenuItem<String>(
                value: categoria["id"],
                child: Row(
                  children: [
                    Icon(
                      categoria["icono"],
                      color: MapaConfiguracion.colorOpcion,
                      size: 20,
                    ),
                    const SizedBox(width: 20),
                    Text(categoria["nombre"]),
                  ],
                ),
              );
            }).toList(),
            onChanged: (opcion) {
              setState(() {
                _categoriaSeleccionada = opcion!;
                _buscarLugares();
              });
            },
          ),
        ],
      ),
      body: _posicionActual == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          FlutterMap(
            mapController: _controladorMapa,
            options: MapOptions(
              initialZoom: 14,
              initialCenter: _posicionActual!,
              onMapReady: () {
                // Aquí marcamos que el mapa ya está listo y sincronizado con el controlador
                setState(() {
                  _mapaListo = true;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.curso_moviles.explorador_local",
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 30,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "acercar",
                  onPressed: () {
                    if (_mapaListo) {
                      _controladorMapa.move(
                        _controladorMapa.camera.center,
                        _controladorMapa.camera.zoom + 1,
                      );
                    }
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'alejar',
                  onPressed: () {
                    if (_mapaListo) {
                      _controladorMapa.move(
                        _controladorMapa.camera.center,
                        _controladorMapa.camera.zoom - 1,
                      );
                    }
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}