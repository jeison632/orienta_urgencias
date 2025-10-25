import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class PaginaMapa extends StatefulWidget {
  const PaginaMapa({super.key});

  @override
  State<PaginaMapa> createState() => _PaginaMapaState();
}

class _PaginaMapaState extends State<PaginaMapa> {
  final MapController _mapController = MapController();
  LatLng _ubicacionActual = LatLng(4.7110, -74.0721); // 📍 Bogotá por defecto
  List<Marker> _marcadores = [];

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
    _cargarMarcadores();
  }

  // 📍 Obtiene la ubicación actual del usuario
  Future<void> _obtenerUbicacionActual() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activa la ubicación en tu dispositivo')),
      );
      return;
    }

    LocationPermission permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    Position posicion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _ubicacionActual = LatLng(posicion.latitude, posicion.longitude);
    });

    _mapController.move(_ubicacionActual, 14);
  }

  // 🏥 Marcadores de hospitales en Bogotá
  void _cargarMarcadores() {
    final hospitales = [
      {'nombre': 'Hospital Santa Clara', 'posicion': LatLng(4.5985, -74.0865)},
      {
        'nombre': 'Hospital Simón Bolívar',
        'posicion': LatLng(4.7391, -74.0603),
      },
      {'nombre': 'Hospital de Kennedy', 'posicion': LatLng(4.6313, -74.1494)},
      {'nombre': 'Hospital El Tunal', 'posicion': LatLng(4.5561, -74.1272)},
    ];

    setState(() {
      _marcadores =
          hospitales.map((h) {
            return Marker(
              point: h['posicion'] as LatLng,
              width: 80,
              height: 60,
              child: Column(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.red, size: 30),
                  Text(
                    h['nombre'].toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Urgencias (OpenStreetMap)'),
        backgroundColor: const Color.fromARGB(255, 47, 33, 177),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _ubicacionActual,
          initialZoom: 13,
          minZoom: 3,
          maxZoom: 18,
        ),
        children: [
          // 🗺️ Capa base del mapa (OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.uso_adecuado_urgencias',
          ),

          // 📍 Marcadores
          MarkerLayer(markers: _marcadores),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _obtenerUbicacionActual,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
