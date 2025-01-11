import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;
  double _currentZoom = 13.0;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(37.334606, -122.009102),
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              onTap: (tapPosition, latLng) {
                setState(() {
                  selectedLocation = latLng;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child: const Icon(Icons.location_pin, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    setState(() {
                      _currentZoom += 1;
                      _mapController.move(_mapController.camera.center, _currentZoom);
                    });
                  },
                  mini: true,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    setState(() {
                      _currentZoom -= 1;
                      _mapController.move(_mapController.camera.center, _currentZoom);
                    });
                  },
                  mini: true,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  child: const Icon(Icons.check),
                  onPressed: () {
                    if (selectedLocation != null) {
                      Navigator.pop(context, selectedLocation);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}