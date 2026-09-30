import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  // Coordenadas aproximadas de Este (Braga)
  static const LatLng _centroEste = LatLng(41.5454, -8.3960);
  static const LatLng _centroBraga = LatLng(41.5454, -8.4265);

  Future<void> _abrirGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Este,+Braga,+Portugal',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Braga'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Abrir no Google Maps',
            onPressed: _abrirGoogleMaps,
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.red.shade50,
            child: const Text(
              'Mapa centrado em Este (São Mamede / São Pedro), Braga.\n'
              'Nota: Os dados não incluem coordenadas GPS por morada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _centroEste,
                initialZoom: 14,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.codigos_postais_braga',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _centroEste,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: _centroBraga,
                      width: 30,
                      height: 30,
                      child: const Icon(
                        Icons.location_city,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Legend
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                const Text('Este'),
                const SizedBox(width: 20),
                const Icon(Icons.location_city, color: Colors.blue, size: 20),
                const SizedBox(width: 4),
                const Text('Centro de Braga'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
