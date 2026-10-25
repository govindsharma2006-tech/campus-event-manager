import 'dart:convert';

class RegistrationModel {
  final String ticketId;
  final String eventId;
  final String eventTitle;
  final String eventDate;
  final String eventTime;
  final String eventVenue;
  final String category;
  final String studentName;
  final String studentRollNo;
  final String studentEmail;
  final String studentPhone;
  final String department;
  final String? teamName;
  final int teamSize;
  final DateTime registeredAt;
  final String qrData;
  final String status; // 'Confirmed', 'Checked-In', 'Cancelled'

  RegistrationModel({
    required this.ticketId,
    required this.eventId,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventVenue,
    required this.category,
    required this.studentName,
    required this.studentRollNo,
    required this.studentEmail,
    required this.studentPhone,
    required this.department,
    this.teamName,
    this.teamSize = 1,
    required this.registeredAt,
    required this.qrData,
    this.status = 'Confirmed',
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'eventVenue': eventVenue,
      'category': category,
      'studentName': studentName,
      'studentRollNo': studentRollNo,
      'studentEmail': studentEmail,
      'studentPhone': studentPhone,
      'department': department,
      'teamName': teamName,
      'teamSize': teamSize,
      'registeredAt': registeredAt.toIso8601String(),
      'qrData': qrData,
      'status': status,
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      ticketId: map['ticketId'] ?? '',
      eventId: map['eventId'] ?? '',
      eventTitle: map['eventTitle'] ?? '',
      eventDate: map['eventDate'] ?? '',
      eventTime: map['eventTime'] ?? '',
      eventVenue: map['eventVenue'] ?? '',
      category: map['category'] ?? 'Tech',
      studentName: map['studentName'] ?? '',
      studentRollNo: map['studentRollNo'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      studentPhone: map['studentPhone'] ?? '',
      department: map['department'] ?? 'Computer Science',
      teamName: map['teamName'],
      teamSize: map['teamSize']?.toInt() ?? 1,
      registeredAt: DateTime.tryParse(map['registeredAt'] ?? '') ?? DateTime.now(),
      qrData: map['qrData'] ?? '',
      status: map['status'] ?? 'Confirmed',
    );
  }

  String toJson() => json.encode(toMap());
  factory RegistrationModel.fromJson(String source) => RegistrationModel.fromMap(json.decode(source));
}
