import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../modelos/Lugar.dart';

class MapaServicio {
  final String _urlBase = "https://overpass-api.de/api/interpreter";

  Future<List<Lugar>> buscarLugares({
    required LatLng posicion,
    required String categoria,
  }) async {
    final consulta =
        "[out:json][timeout:30];node['amenity'='$categoria'](around:1500,${posicion.latitude},${posicion.longitude});out;";
    final url = Uri.parse("$_urlBase?data=${Uri.encodeComponent(consulta)}");
    print(url);
    try {
      final respuesta = await http
          .get(url, headers: {"User-Agent": "ExploradorLocalIUPB"})
          .timeout(const Duration(seconds: 60));

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);
        final lugares = datos["elements"] as List;
        return lugares.map((json) => Lugar.fromJson(json)).toList();
      } else {
        throw 'Error del servidor: ${respuesta.statusCode}';
      }
    } catch (e) {
      throw 'Error de conexión: $e';
    }
  }
}
