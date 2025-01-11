// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapNavigationScreen extends StatefulWidget {
  final LatLng eventLocation;

  const MapNavigationScreen({super.key, required this.eventLocation});

  @override
  // ignore: library_private_types_in_public_api
  _MapNavigationScreenState createState() => _MapNavigationScreenState();
}

class _MapNavigationScreenState extends State<MapNavigationScreen> {
  LatLng? _currentLocation;
  List<LatLng> _routePoints = [];
  double _currentZoom = 13.0;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

    Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current position
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null) return;

    final start = '${_currentLocation!.longitude},${_currentLocation!.latitude}';
    final end = '${widget.eventLocation.longitude},${widget.eventLocation.latitude}';
    final url = 'https://router.project-osrm.org/route/v1/driving/$start;$end?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0]['geometry']['coordinates'] as List;
        setState(() {
          _routePoints = route
              .map((point) => LatLng(point[1] as double, point[0] as double))
              .toList();
        });
      } else {
        print('Failed to fetch route: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Event'),
      ),
      body: _currentLocation == null
        ? const Center(child: CircularProgressIndicator())
        : Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation!,
                initialZoom: _currentZoom,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      child: const Icon(Icons.my_location, color: Colors.blue),
                    ),
                    Marker(
                      point: widget.eventLocation,
                      child: const Icon(Icons.location_pin, color: Colors.red),
                    ),
                  ],
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
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
                    heroTag: 'recenter',
                    onPressed: () {
                      if (_currentLocation != null) {
                        _mapController.move(_currentLocation!, _currentZoom);
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}