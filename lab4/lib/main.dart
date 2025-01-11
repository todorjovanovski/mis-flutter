import 'package:flutter/material.dart';
import 'package:lab4/screens/calendar_screen.dart';


void main() {
  runApp(const ExamScheduleApp());
}

class ExamScheduleApp extends StatelessWidget {
  const ExamScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarScreen(),
    );
  }
}