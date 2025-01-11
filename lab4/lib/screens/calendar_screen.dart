import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lab4/models/exam.dart';
import 'package:lab4/screens/add_exam_screen.dart';
import 'package:lab4/screens/map_navigation_screen.dart';
import 'package:lab4/services/database_service.dart';
import 'package:lab4/widgets/exam_tile_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Exam> _exams = [];
  CalendarFormat _format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final exams = await DatabaseService().fetchExams();
    setState(() {
      _exams = exams;
    });
  }

  Future<void> _deleteExam(int id) async {
    await DatabaseService().deleteExam(id);
    _loadExams();
  }
  List<Exam> _getExamsForSelectedDay(DateTime selectedDay) {
    return _exams.where((exam) {
      final examDate = DateTime(exam.dateTime.year, exam.dateTime.month, exam.dateTime.day);
      final selectedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      return examDate.isAtSameMomentAs(selectedDate);
    }).toList();
  }

  void _showExamsDialog(DateTime selectedDay) {
  final examsForSelectedDay = _getExamsForSelectedDay(selectedDay);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Scheduled exams"),
        content: examsForSelectedDay.isEmpty
            ? const Text("No exams for this day.")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: examsForSelectedDay.map((exam) {
                  return ExamTile(
                    exam: exam,
                    onDelete: () => _deleteExam(exam.id!),
                    onNavigate: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapNavigationScreen(
                            eventLocation: LatLng(exam.locationLat, exam.locationLng),
                          ),
                        ),
                      );
                    },
                    getLocation: _getLocationFromCoordinates,
                  );
                }).toList(),
              ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}


  Future<List<Placemark>> _getLocationFromCoordinates(double lat, double lng) async {
    try {
      return await placemarkFromCoordinates(lat, lng);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExamScreen(onSave: _loadExams)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _format,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showExamsDialog(selectedDay);

            },
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _exams.length,
              itemBuilder: (context, index) {
                final exam = _exams[index];
                return ExamTile(
                  exam: exam,
                  onDelete: () => _deleteExam(exam.id!),
                  onNavigate: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapNavigationScreen(
                          eventLocation: LatLng(exam.locationLat, exam.locationLng),
                        ),
                      ),
                    );
                  },
                  getLocation: _getLocationFromCoordinates,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
