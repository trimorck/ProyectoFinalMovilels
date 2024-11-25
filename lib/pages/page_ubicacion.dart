import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageUbicacion extends StatefulWidget {
  @override
  _PageUbicacionState createState() => _PageUbicacionState();
}

class _PageUbicacionState extends State<PageUbicacion> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Añadir el marcador con un ícono predeterminado
    _markers.add(
      Marker(
        markerId: MarkerId('cafe'),
        position: LatLng(-33.4489, -70.6693), // Coordenadas del café
        infoWindow: InfoWindow(
          title: 'Cup o\' Cat',  // Nombre del café
          snippet: 'El mejor café de la ciudad',  // Descripción opcional
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación del Café'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF523a34),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-33.4489, -70.6693), // Coordenadas de ejemplo (Santiago, Chile)
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
