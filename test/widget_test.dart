import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_event_hub/models/event_model.dart';
import 'package:campus_event_hub/models/registration_model.dart';
import 'package:campus_event_hub/services/storage_service.dart';
import 'package:campus_event_hub/providers/auth_provider.dart';
import 'package:campus_event_hub/screens/auth_screen.dart';

void main() {
  group('CampusEventHub Model Tests', () {
    test('EventModel initializes and parses properly', () {
      final now = DateTime.now();
      final event = EventModel(
        id: 'test_1',
        title: 'TechNova Hackathon',
        description: 'Flagship 36h hackathon',
        category: 'Hackathon',
        date: now,
        time: '10:00 AM',
        venue: 'Turing Lab',
        organizerClub: 'ACM Student Chapter',
        bannerUrl: 'https://example.com/banner.jpg',
        maxParticipants: 100,
        registeredCount: 45,
        fee: 0.0,
        coordinatorPhone: '+91 98765 43210',
        coordinatorEmail: 'events@campus.edu',
      );

      expect(event.title, 'TechNova Hackathon');
      expect(event.isFull, false);
      expect(event.availableSeats, 55);

      final map = event.toMap();
      final reconstructed = EventModel.fromMap(map);
      expect(reconstructed.id, 'test_1');
      expect(reconstructed.maxParticipants, 100);
      expect(reconstructed.registeredCount, 45);
    });

    test('RegistrationModel serialization and QR pass data', () {
      final reg = RegistrationModel(
        ticketId: 'TKT-2026-ABCD1234',
        eventId: 'test_1',
        eventTitle: 'TechNova Hackathon',
        eventDate: '28/10/2026',
        eventTime: '10:00 AM',
        eventVenue: 'Turing Lab',
        category: 'Hackathon',
        studentName: 'Rohan Sharma',
        studentRollNo: '23CSB1042',
        studentEmail: 'rohan@campus.edu',
        studentPhone: '+91 98765 43210',
        department: 'Computer Science',
        registeredAt: DateTime.now(),
        qrData: 'CAMPUS-PASS:TKT-2026-ABCD1234|test_1|23CSB1042',
      );

      expect(reg.ticketId, 'TKT-2026-ABCD1234');
      expect(reg.status, 'Confirmed');

      final jsonStr = reg.toJson();
      final decoded = RegistrationModel.fromJson(jsonStr);
      expect(decoded.ticketId, reg.ticketId);
      expect(decoded.studentRollNo, '23CSB1042');
    });

    testWidgets('AuthScreen renders clean login card and toggles to Sign Up', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = StorageService(prefs);
      final authProvider = AuthProvider(storage);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: authProvider,
            child: const AuthScreen(),
          ),
        ),
      );

      expect(find.text('Campus Event Manager'), findsOneWidget);
      expect(find.text('Sign in to manage and register for events'), findsOneWidget);
      expect(find.text('Student Demo'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget); // Button
      expect(find.text('Sign Up'), findsOneWidget); // Toggle link

      // Tap Sign Up toggle
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
    });
  });
}
