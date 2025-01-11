import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lab4/models/exam.dart';

class ExamTile extends StatelessWidget {
  final Exam exam;
  final VoidCallback onDelete;
  final VoidCallback onNavigate;
  final Future<List<Placemark>> Function(double lat, double lng) getLocation;

  const ExamTile({
    super.key,
    required this.exam,
    required this.onDelete,
    required this.onNavigate,
    required this.getLocation,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MMM-yy').format(exam.dateTime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.blue.shade300,
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(exam.title),
        subtitle: FutureBuilder<List<Placemark>>(
          future: getLocation(exam.locationLat, exam.locationLng),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading location...');
            } else if (snapshot.hasError) {
              return const Text('Failed to load location');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final placemark = snapshot.data![0];
              final locality = placemark.locality ?? 'Unknown location';
              return Text('$formattedDate $locality');
            } else {
              return const Text('Unknown location');
            }
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.navigation, color: Colors.blue),
              onPressed: onNavigate,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
