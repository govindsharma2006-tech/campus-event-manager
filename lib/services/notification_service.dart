import 'package:flutter/material.dart';

class CampusNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  CampusNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.icon = Icons.notifications_active,
    this.iconColor = const Color(0xFF4F46E5),
    this.isRead = false,
  });
}

class NotificationService extends ChangeNotifier {
  final List<CampusNotification> _notifications = [
    CampusNotification(
      id: 'notif_1',
      title: 'Welcome to CampusEventHub! 🎓',
      body: 'Explore upcoming campus hackathons, cultural nights, and guest workshops.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      icon: Icons.celebration,
      iconColor: const Color(0xFF10B981),
    ),
    CampusNotification(
      id: 'notif_2',
      title: 'Reminder: Hackathon Registration',
      body: 'Registrations for HackNova 2026 will close in 48 hours. Secure your team pass now!',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.timer,
      iconColor: const Color(0xFFF59E0B),
    ),
  ];

  List<CampusNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String body,
    IconData icon = Icons.notifications_active,
    Color iconColor = const Color(0xFF4F46E5),
  }) {
    final notif = CampusNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      icon: icon,
      iconColor: iconColor,
    );
    _notifications.insert(0, notif);
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
