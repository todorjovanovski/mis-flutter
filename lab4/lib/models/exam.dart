class Exam {
  final int? id;
  final String title;
  final DateTime dateTime;
  final double locationLat;
  final double locationLng;

  Exam({
    this.id,
    required this.title,
    required this.dateTime,
    required this.locationLat,
    required this.locationLng,
  });

  // Convert Exam to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date_time': dateTime.toIso8601String(),
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }

  // Convert Map to Exam
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['date_time']),
      locationLat: map['location_lat'],
      locationLng: map['location_lng'],
    );
  }
}
