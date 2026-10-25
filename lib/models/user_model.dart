import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String rollNo;
  final String department;
  final String semester;
  final String phone;
  final String role; // 'student', 'coordinator', 'admin'
  final String? clubName;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.phone,
    this.role = 'student',
    this.clubName,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
  });

  bool get isCoordinator => role == 'coordinator' || role == 'admin';
  bool get isAdmin => role == 'admin';

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? rollNo,
    String? department,
    String? semester,
    String? phone,
    String? role,
    String? clubName,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      rollNo: rollNo ?? this.rollNo,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      clubName: clubName ?? this.clubName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'department': department,
      'semester': semester,
      'phone': phone,
      'role': role,
      'clubName': clubName,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      rollNo: map['rollNo'] ?? '',
      department: map['department'] ?? 'Computer Science & Engineering',
      semester: map['semester'] ?? '6th Semester',
      phone: map['phone'] ?? '+91 98765 00000',
      role: map['role'] ?? 'student',
      clubName: map['clubName'],
      avatarUrl: map['avatarUrl'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    );
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
