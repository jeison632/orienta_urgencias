import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaMapa extends StatefulWidget {
  const PaginaMapa({super.key});

  @override
  State<PaginaMapa> createState() => _PaginaMapaState();
}

class _PaginaMapaState extends State<PaginaMapa> {
  final MapController _mapController = MapController();
  LatLng _ubicacionActual = LatLng(4.7110, -74.0721); // 📍 Bogotá por defecto
  List<Marker> _marcadores = [];
  bool _cargandoUbicacion = true;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
    _cargarMarcadores();
  }

  /// 📍 Obtiene la ubicación actual del usuario
  Future<void> _obtenerUbicacionActual() async {
    try {
      bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicioHabilitado) {
        _mostrarMensaje('Por favor activa la ubicación en tu dispositivo.');
        setState(() => _cargandoUbicacion = false);
        return;
      }

      LocationPermission permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        _mostrarMensaje('Permiso de ubicación denegado.');
        setState(() => _cargandoUbicacion = false);
        return;
      }

      Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _ubicacionActual = LatLng(posicion.latitude, posicion.longitude);
        _cargandoUbicacion = false;
      });

      _mapController.move(_ubicacionActual, 15);
    } catch (e) {
      _mostrarMensaje('Error al obtener la ubicación.');
      setState(() => _cargandoUbicacion = false);
    }
  }

  /// 🏥 Carga marcadores de hospitales en Bogotá
  void _cargarMarcadores() {
    final hospitales = [
      {
        'nombre': 'Fundación Cardioinfantil',
        'direccion': 'Calle 163A #13B-60, Bogotá',
        'posicion': LatLng(4.740953, -74.033507),
      },
      {
        'nombre': 'Hospital El Tunal',
        'direccion': 'Cra. 24 #47-60 Sur, Bogotá',
        'posicion': LatLng(3.438789, -76.530558),
      },
      {
        'nombre': 'Clínica del Country',
        'direccion': 'Cra. 7 #73-71, Bogotá',
        'posicion': LatLng(4.668751, -74.056740),
      },

      {
        'nombre': 'Nueva eps kenedy',
        'direccion': 'Cra. 78 trasv 78, Bogotá',
        'posicion': LatLng(4.619919, -74.154260),
      },
      {
        'nombre': 'Hospital Universitario Clínica San Rafael',
        'direccion': 'Carrera 8 #17-45 Sur, Bogotá',
        'posicion': LatLng(4.576655, -74.091325),
      },
      {
        'nombre': 'Hospital Universitario Fundación Santa Fe de Bogotá',
        'direccion': 'Carrera 7 #123-35, Bogotá',
        'posicion': LatLng(4.6952, -74.0330),
      },

      {
        'nombre': 'Hospital Simón Bolívar',
        'direccion': 'Calle 165 #7-06, Bogotá',
        'posicion': LatLng(4.742049, -74.022971),
      },
      {
        'nombre': 'Clínica La Colina',
        'direccion': 'Calle 167 #72-07, Bogotá',
        'posicion': LatLng(4.750068, -74.065441),
      },
      {
        'nombre': 'Clínica Palermo',
        'direccion': 'Calle 45C #22-02, Bogotá',
        'posicion': LatLng(4.6097, -74.0674),
      },
      {
        'nombre': 'Clínica Marly',
        'direccion': 'Calle 53 #38-91, Bogotá',
        'posicion': LatLng(4.5989, -74.1916),
      },
      {
        'nombre': 'Clínica Universidad de La Sabana',
        'direccion': 'Km 7, Vía Chía, Chía',
        'posicion': LatLng(4.8356, -74.0302),
      },
      {
        'nombre': 'Clínica del Occidente',
        'direccion': 'Av. de Las Américas #71C-29, Bogotá',
        'posicion': LatLng(4.6255, -74.1428),
      },
      {
        'nombre': 'Clínica de la Mujer',
        'direccion': 'Calle 119 #7-75, Bogotá',
        'posicion': LatLng(4.7075, -74.0356),
      },
      {
        'nombre': 'Clínica del Prado',
        'direccion': 'Calle 63 #10-39, Bogotá',
        'posicion': LatLng(4.6163, -74.0701),
      },
      {
        'nombre': 'Clínica Shaio',
        'direccion': 'Calle 127 #16-35, Bogotá',
        'posicion': LatLng(4.7320, -74.0300),
      },
      {
        'nombre': 'Clínica Santa María del Lago',
        'direccion': 'Calle 100 #69A-41, Bogotá',
        'posicion': LatLng(4.6782, -74.0602),
      },
      {
        'nombre': 'Clínica Colombia',
        'direccion': 'Calle 70 #7-21, Bogotá',
        'posicion': LatLng(4.6562, -74.0598),
      },
      {
        'nombre': 'Clínica Reina Sofía',
        'direccion': 'Carrera 9 #112-32, Bogotá',
        'posicion': LatLng(4.7015, -74.0369),
      },
      {
        'nombre': 'Hospital Universitario de la Samaritana',
        'direccion': 'Cra. 2 #11-50, Bogotá',
        'posicion': LatLng(4.6098, -74.0826),
      },
      {
        'nombre': 'Clínica Teletón',
        'direccion': 'Calle 162 #7-50, Bogotá',
        'posicion': LatLng(4.7440, -74.0270),
      },
      {
        'nombre': 'Clínica Infantil Colsubsidio',
        'direccion': 'Cra. 19 #129-30, Bogotá',
        'posicion': LatLng(4.7390, -74.0350),
      },
      {
        'nombre': 'Clínica San José',
        'direccion': 'Calle 39 #5-55, Bogotá',
        'posicion': LatLng(4.5985, -74.0842),
      },
      {
        'nombre': 'Clínica Universidad de La Sabana',
        'direccion': 'Km 7, Vía Chía, Chía',
        'posicion': LatLng(4.8356, -74.0302),
      },

      {
        'nombre': 'Clínica Palermo',
        'direccion': 'Calle 45C #22-02, Bogotá',
        'posicion': LatLng(4.6097, -74.0674),
      },
      {
        'nombre': 'Clínica Marly',
        'direccion': 'Calle 53 #38-91, Bogotá',
        'posicion': LatLng(4.5989, -74.1916),
      },

      {
        'nombre': 'Hospital Universitario San Ignacio',
        'direccion': 'Carrera 7 #40-62, Bogotá',
        'posicion': LatLng(4.5986, -74.0706),
      },
      {
        'nombre': 'Hospital Universitario del Tunal',
        'direccion': 'Cra. 24 #47-60 Sur, Bogotá',
        'posicion': LatLng(4.5561, -74.1272),
      },
      {
        'nombre': 'Hospital Universitario Clínica San Rafael',
        'direccion': 'Carrera 8 #17-45 Sur, Bogotá',
        'posicion': LatLng(4.5993, -74.0834),
      },
      {
        'nombre': 'Hospital Universitario Fundación Santa Fe de Bogotá',
        'direccion': 'Carrera 7 #123-35, Bogotá',
        'posicion': LatLng(4.6952, -74.0330),
      },

      {
        'nombre': 'Clínica Shaio',
        'direccion': 'Calle 127 #16-35, Bogotá',
        'posicion': LatLng(4.7320, -74.0300),
      },
      {
        'nombre': 'Clínica Santa María del Lago',
        'direccion': 'Calle 100 #69A-41, Bogotá',
        'posicion': LatLng(4.6782, -74.0602),
      },
      {
        'nombre': 'Clínica Colombia',
        'direccion': 'Calle 70 #7-21, Bogotá',
        'posicion': LatLng(4.6562, -74.0598),
      },
      {
        'nombre': 'Clínica Reina Sofía',
        'direccion': 'Carrera 9 #112-32, Bogotá',
        'posicion': LatLng(4.7015, -74.0369),
      },
      {
        'nombre': 'Clínica del Country',
        'direccion': 'Cra. 7 #73-71, Bogotá',
        'posicion': LatLng(4.6670, -74.0509),
      },
      {
        'nombre': 'Clínica del Prado',
        'direccion': 'Calle 63 #10-39, Bogotá',
        'posicion': LatLng(4.6163, -74.0701),
      },
    ];

    setState(() {
      _marcadores =
          hospitales.map((h) {
            return Marker(
              point: h['posicion'] as LatLng,
              width: 180,
              height: 70,
              child: GestureDetector(
                onTap:
                    () => _mostrarInfoHospital(
                      h['nombre'].toString(),
                      h['direccion'].toString(),
                      h['posicion'] as LatLng,
                    ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      color: Colors.red,
                      size: 35,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        h['nombre'].toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
    });
  }

  /// 🌍 Abre la ubicación del hospital en OpenStreetMap
  Future<void> _abrirEnOpenStreetMap(LatLng posicion) async {
    final url =
        'https://www.openstreetmap.org/?mlat=${posicion.latitude}&mlon=${posicion.longitude}#map=17/${posicion.latitude}/${posicion.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _mostrarMensaje('No se pudo abrir OpenStreetMap.');
    }
  }

  /// 💬 Muestra mensaje temporal (SnackBar)
  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: Colors.redAccent),
    );
  }

  /// 🏥 Muestra tarjeta con información del hospital seleccionado
  void _mostrarInfoHospital(String nombre, String direccion, LatLng posicion) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          esOscuro ? const Color.fromARGB(255, 46, 64, 83) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: esOscuro ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  direccion,
                  style: TextStyle(
                    color: esOscuro ? Colors.grey[300] : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Puedes abrir la ubicación directamente en OpenStreetMap para obtener indicaciones.',
                  style: TextStyle(
                    color: esOscuro ? Colors.grey[200] : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => _abrirEnOpenStreetMap(posicion),
                  icon: const Icon(Icons.map),
                  label: const Text('Abrir en OpenStreetMap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        esOscuro
                            ? const Color.fromARGB(255, 46, 64, 83)
                            : const Color(0xFF00BFA5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    elevation: 6,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Urgencias en Bogotá'),
        backgroundColor:
            esOscuro
                ? const Color.fromARGB(255, 46, 64, 83)
                : const Color(0xFF00BFA5),
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.black45,
      ),
      body:
          _cargandoUbicacion
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text('Obteniendo ubicación actual...'),
                  ],
                ),
              )
              : FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _ubicacionActual,
                  initialZoom: 13,
                  minZoom: 3,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.uso_adecuado_urgencias',
                  ),
                  MarkerLayer(markers: _marcadores),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _ubicacionActual,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _obtenerUbicacionActual,
        backgroundColor:
            esOscuro
                ? const Color.fromARGB(255, 46, 64, 83)
                : const Color(0xFF00BFA5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.my_location),
        label: const Text('Mi ubicación'),
      ),
    );
  }
}
