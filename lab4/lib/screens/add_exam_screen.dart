// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lab4/models/exam.dart';
import 'package:lab4/screens/location_picker_screen.dart';
import 'package:lab4/services/database_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; 

class AddExamScreen extends StatefulWidget {
  final Function onSave;

  const AddExamScreen({super.key, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;
  LatLng? _selectedLocation;
  String? _areaName;

  String _formattedDateTime() {
    if (_selectedDateTime == null) return 'No Date & Time Selected';
    return '${_selectedDateTime!.toLocal().toString().split(' ')[0]} ${_selectedDateTime!.toLocal().toString().split(' ')[1].substring(0, 5)}';
  }

  String _formattedLocation() {
    if (_selectedLocation == null) return 'No Location Selected';
    return 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}';
  }

  Future<void> _getAreaName(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _areaName = placemarks.first.locality ?? 'Unknown Area';
        });
      }
    } catch (e) {
      setState(() {
        _areaName = 'Error fetching area';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Exam Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: const Text('Select Date and Time'),
            ),
            if (_selectedDateTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selected: ${_formattedDateTime()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final location = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPickerScreen(),
                  ),
                );
                if (location != null) {
                  setState(() {
                    _selectedLocation = location;
                    _areaName = null;
                  });
                  await _getAreaName(location);
                }
              },
              child: const Text('Select Location'),
            ),
            if (_selectedLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected: ${_formattedLocation()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (_areaName != null)
                      Text(
                        'Area: $_areaName',
                        style: const TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _selectedDateTime != null &&
                    _selectedLocation != null) {
                  await DatabaseService().insertExam(
                    Exam(
                      title: _titleController.text,
                      dateTime: _selectedDateTime!,
                      locationLat: _selectedLocation!.latitude,
                      locationLng: _selectedLocation!.longitude
                    )
                  );
                  widget.onSave();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
