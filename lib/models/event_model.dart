import 'dart:convert';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'Tech', 'Cultural', 'Sports', 'Workshop', 'Hackathon'
  final DateTime date;
  final String time;
  final String venue;
  final String organizerClub;
  final String bannerUrl;
  final int maxParticipants;
  int registeredCount;
  final double fee; // 0 for free
  final bool isFeatured;
  final List<String> tags;
  final List<String> rules;
  final String coordinatorPhone;
  final String coordinatorEmail;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.venue,
    required this.organizerClub,
    required this.bannerUrl,
    required this.maxParticipants,
    this.registeredCount = 0,
    this.fee = 0.0,
    this.isFeatured = false,
    this.tags = const [],
    this.rules = const [],
    required this.coordinatorPhone,
    required this.coordinatorEmail,
  });

  bool get isFull => registeredCount >= maxParticipants;
  int get availableSeats => (maxParticipants - registeredCount).clamp(0, maxParticipants);

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    String? time,
    String? venue,
    String? organizerClub,
    String? bannerUrl,
    int? maxParticipants,
    int? registeredCount,
    double? fee,
    bool? isFeatured,
    List<String>? tags,
    List<String>? rules,
    String? coordinatorPhone,
    String? coordinatorEmail,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      organizerClub: organizerClub ?? this.organizerClub,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      registeredCount: registeredCount ?? this.registeredCount,
      fee: fee ?? this.fee,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      rules: rules ?? this.rules,
      coordinatorPhone: coordinatorPhone ?? this.coordinatorPhone,
      coordinatorEmail: coordinatorEmail ?? this.coordinatorEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'time': time,
      'venue': venue,
      'organizerClub': organizerClub,
      'bannerUrl': bannerUrl,
      'maxParticipants': maxParticipants,
      'registeredCount': registeredCount,
      'fee': fee,
      'isFeatured': isFeatured,
      'tags': tags,
      'rules': rules,
      'coordinatorPhone': coordinatorPhone,
      'coordinatorEmail': coordinatorEmail,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      time: map['time'] ?? '10:00 AM',
      venue: map['venue'] ?? 'Campus Auditorium',
      organizerClub: map['organizerClub'] ?? 'Student Council',
      bannerUrl: map['bannerUrl'] ?? 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      maxParticipants: map['maxParticipants']?.toInt() ?? 100,
      registeredCount: map['registeredCount']?.toInt() ?? 0,
      fee: (map['fee'] is num) ? (map['fee'] as num).toDouble() : 0.0,
      isFeatured: map['isFeatured'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      rules: List<String>.from(map['rules'] ?? []),
      coordinatorPhone: map['coordinatorPhone'] ?? '+91 98765 43210',
      coordinatorEmail: map['coordinatorEmail'] ?? 'events@campus.edu',
    );
  }

  String toJson() => json.encode(toMap());
  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));
}
