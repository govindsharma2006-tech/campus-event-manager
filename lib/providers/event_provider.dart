import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../models/news_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class EventProvider extends ChangeNotifier {
  final StorageService _storage;
  final ApiService _apiService;
  final NotificationService _notificationService;

  List<EventModel> _events = [];
  List<RegistrationModel> _registrations = [];
  List<String> _bookmarkedIds = [];
  List<NewsModel> _campusNews = [];

  bool _isNewsLoading = false;
  String? _newsError;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  EventProvider(this._storage, this._apiService, this._notificationService) {
    _initializeData();
  }

  // --- Getters ---
  List<EventModel> get allEvents => List.unmodifiable(_events);
  List<RegistrationModel> get registrations => List.unmodifiable(_registrations);
  List<String> get bookmarkedIds => List.unmodifiable(_bookmarkedIds);
  List<NewsModel> get campusNews => List.unmodifiable(_campusNews);
  bool get isNewsLoading => _isNewsLoading;
  String? get newsError => _newsError;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Filtered Events according to search query and category
  List<EventModel> get filteredEvents {
    return _events.where((event) {
      final matchesCategory = _selectedCategory == 'All' || event.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.venue.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.organizerClub.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<EventModel> get featuredEvents {
    return _events.where((e) => e.isFeatured).toList();
  }

  List<EventModel> get bookmarkedEvents {
    return _events.where((e) => _bookmarkedIds.contains(e.id)).toList();
  }

  // --- Initializer ---
  void _initializeData() {
    _loadEvents();
    _registrations = _storage.getRegistrations();
    _bookmarkedIds = _storage.getBookmarks();
    fetchCampusNews();
  }

  void _loadEvents() {
    final customEvents = _storage.getStoredEvents();
    if (customEvents.isNotEmpty) {
      _events = customEvents;
    } else {
      _events = _getInitialSeedEvents();
      _storage.saveEvents(_events);
    }
    notifyListeners();
  }

  // --- Search & Category Filters ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // --- CRUD: CREATE ---
  Future<void> createEvent(EventModel event) async {
    _events.insert(0, event);
    await _storage.saveEvents(_events);
    
    _notificationService.addNotification(
      title: 'New Campus Event Published! 🎉',
      body: '"${event.title}" has been scheduled at ${event.venue}. Check it out now!',
      icon: Icons.add_circle,
      iconColor: const Color(0xFF10B981),
    );

    notifyListeners();
  }

  // --- CRUD: READ ---
  EventModel? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- CRUD: UPDATE ---
  Future<void> updateEvent(EventModel updatedEvent) async {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      await _storage.saveEvents(_events);

      _notificationService.addNotification(
        title: 'Event Schedule Updated 📢',
        body: 'Details for "${updatedEvent.title}" have been updated by organizers.',
        icon: Icons.edit_calendar,
        iconColor: const Color(0xFF06B6D4),
      );

      notifyListeners();
    }
  }

  // --- CRUD: DELETE ---
  Future<void> deleteEvent(String eventId) async {
    final event = getEventById(eventId);
    _events.removeWhere((e) => e.id == eventId);
    _bookmarkedIds.remove(eventId);
    _registrations.removeWhere((r) => r.eventId == eventId);

    await _storage.saveEvents(_events);
    await _storage.saveBookmarks(_bookmarkedIds);
    await _storage.saveRegistrations(_registrations);

    if (event != null) {
      _notificationService.addNotification(
        title: 'Event Cancelled',
        body: '"${event.title}" has been removed from the campus schedule.',
        icon: Icons.cancel,
        iconColor: const Color(0xFFEF4444),
      );
    }

    notifyListeners();
  }

  // --- Event Registration & Ticketing ---
  Future<RegistrationModel?> registerForEvent({
    required EventModel event,
    required String studentName,
    required String studentRollNo,
    required String studentEmail,
    required String studentPhone,
    required String department,
    String? teamName,
    int teamSize = 1,
  }) async {
    if (event.isFull) return null;

    final ticketId = 'TKT-${DateTime.now().year}-${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final qrData = 'CAMPUS-PASS:$ticketId|${event.id}|$studentRollNo|${event.title}';

    final registration = RegistrationModel(
      ticketId: ticketId,
      eventId: event.id,
      eventTitle: event.title,
      eventDate: '${event.date.day}/${event.date.month}/${event.date.year}',
      eventTime: event.time,
      eventVenue: event.venue,
      category: event.category,
      studentName: studentName,
      studentRollNo: studentRollNo,
      studentEmail: studentEmail,
      studentPhone: studentPhone,
      department: department,
      teamName: teamName,
      teamSize: teamSize,
      registeredAt: DateTime.now(),
      qrData: qrData,
      status: 'Confirmed',
    );

    // Increment registered count
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index].registeredCount += teamSize;
      await _storage.saveEvents(_events);
    }

    _registrations.insert(0, registration);
    await _storage.saveRegistrations(_registrations);

    // Trigger Notification
    _notificationService.addNotification(
      title: 'Registration Confirmed! 🎟️',
      body: 'You are registered for "${event.title}". Digital pass generated: $ticketId',
      icon: Icons.confirmation_number,
      iconColor: const Color(0xFF4F46E5),
    );

    notifyListeners();
    return registration;
  }

  Future<void> cancelRegistration(String ticketId) async {
    final regIndex = _registrations.indexWhere((r) => r.ticketId == ticketId);
    if (regIndex != -1) {
      final reg = _registrations[regIndex];
      // Decrement event registered count
      final eventIndex = _events.indexWhere((e) => e.id == reg.eventId);
      if (eventIndex != -1) {
        _events[eventIndex].registeredCount = (_events[eventIndex].registeredCount - reg.teamSize).clamp(0, 9999);
        await _storage.saveEvents(_events);
      }

      _registrations.removeAt(regIndex);
      await _storage.saveRegistrations(_registrations);

      _notificationService.addNotification(
        title: 'Registration Cancelled',
        body: 'Your ticket ($ticketId) for "${reg.eventTitle}" has been cancelled.',
        icon: Icons.cancel,
        iconColor: const Color(0xFFEF4444),
      );

      notifyListeners();
    }
  }

  bool isRegistered(String eventId) {
    return _registrations.any((r) => r.eventId == eventId);
  }

  RegistrationModel? getRegistrationByEventId(String eventId) {
    try {
      return _registrations.firstWhere((r) => r.eventId == eventId);
    } catch (_) {
      return null;
    }
  }

  // --- Bookmarks ---
  void toggleBookmark(String eventId) async {
    if (_bookmarkedIds.contains(eventId)) {
      _bookmarkedIds.remove(eventId);
    } else {
      _bookmarkedIds.add(eventId);
    }
    await _storage.saveBookmarks(_bookmarkedIds);
    notifyListeners();
  }

  bool isBookmarked(String eventId) => _bookmarkedIds.contains(eventId);

  // --- REST API Integration for Live News ---
  Future<void> fetchCampusNews() async {
    _isNewsLoading = true;
    _newsError = null;
    notifyListeners();

    try {
      final news = await _apiService.fetchCampusNews();
      _campusNews = news;
      _isNewsLoading = false;
      notifyListeners();
    } catch (e) {
      _newsError = 'Failed to fetch live updates: ${e.toString()}';
      _isNewsLoading = false;
      notifyListeners();
    }
  }

  // --- Coordinator / Admin Analytics ---
  int get totalRegisteredStudents {
    return _registrations.fold(0, (sum, r) => sum + r.teamSize);
  }

  Map<String, int> get categoryEventCount {
    final map = <String, int>{};
    for (var e in _events) {
      map[e.category] = (map[e.category] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get categoryRegistrationCount {
    final map = <String, int>{};
    for (var r in _registrations) {
      map[r.category] = (map[r.category] ?? 0) + r.teamSize;
    }
    return map;
  }

  // Reset demo data to factory defaults
  Future<void> resetToDefaultData() async {
    _events = _getInitialSeedEvents();
    _registrations.clear();
    _bookmarkedIds.clear();
    await _storage.saveEvents(_events);
    await _storage.saveRegistrations(_registrations);
    await _storage.saveBookmarks(_bookmarkedIds);
    notifyListeners();
  }

  // --- Seed Data with High Visual Quality ---
  static List<EventModel> _getInitialSeedEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: 'evt_1',
        title: 'HackNova 2026: National Level 36h AI Hackathon',
        description: 'India\'s largest collegiate hackathon focused on Generative AI, Autonomous Systems, and Green Tech. Build innovative solutions, pitch before VC judges, and win exciting internships and cash prizes of ₹2,50,000.',
        category: 'Hackathon',
        date: now.add(const Duration(days: 4)),
        time: '09:00 AM',
        venue: 'Turing Advanced Innovation Lab',
        organizerClub: 'ACM & Google Developer Groups (GDG)',
        bannerUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
        maxParticipants: 180,
        registeredCount: 142,
        fee: 0.0,
        isFeatured: true,
        tags: ['AI/ML', 'Hackathon', 'Cash Prize', '36 Hours'],
        rules: [
          'Teams of 2 to 4 members are permitted.',
          'All code must be authored during the 36-hour hackathon window.',
          'Use of open-source frameworks and public APIs is welcomed.',
          'Judging criteria: Innovation (30%), Practicality (30%), Technical Depth (40%).'
        ],
        coordinatorPhone: '+91 98765 11223',
        coordinatorEmail: 'hacknova@campus.edu',
      ),
      EventModel(
        id: 'evt_2',
        title: 'Vibrance 2026: Annual Cultural Gala & Battle of Bands',
        description: 'The premier annual cultural extravaganza featuring high-voltage rock band battles, street plays, choreography showdowns, and celebrity musical guest performance.',
        category: 'Cultural',
        date: now.add(const Duration(days: 8)),
        time: '05:30 PM',
        venue: 'Open Air Amphitheatre (OAT)',
        organizerClub: 'Cultural Affairs Society',
        bannerUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
        maxParticipants: 2500,
        registeredCount: 1890,
        fee: 150.0,
        isFeatured: true,
        tags: ['Music', 'Dance', 'Drama', 'Celebrity Night'],
        rules: [
          'Entry only with digital QR pass generated via the app.',
          'Strict prohibition of any hazardous materials.',
          'Gates close promptly at 06:15 PM.'
        ],
        coordinatorPhone: '+91 98111 33445',
        coordinatorEmail: 'cultural@campus.edu',
      ),
      EventModel(
        id: 'evt_3',
        title: 'Hands-on Flutter 3.4 & Clean Architecture Workshop',
        description: 'Master enterprise-grade Flutter development. Learn State Management with Provider, REST API caching, SQLite local storage, and responsive UI design directly from industry Flutter architects.',
        category: 'Workshop',
        date: now.add(const Duration(days: 2)),
        time: '11:00 AM',
        venue: 'Aryabhata Conference Hall',
        organizerClub: 'Mobile Development Club',
        bannerUrl: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800',
        maxParticipants: 120,
        registeredCount: 88,
        fee: 0.0,
        isFeatured: false,
        tags: ['Flutter', 'Dart', 'Mobile Dev', 'Hands-on'],
        rules: [
          'Bring your laptop with Flutter SDK installed.',
          'Certificate of completion awarded to active attendees.'
        ],
        coordinatorPhone: '+91 99223 44556',
        coordinatorEmail: 'flutter.club@campus.edu',
      ),
      EventModel(
        id: 'evt_4',
        title: 'Inter-Collegiate Slam Dunk & Futsal Tournament',
        description: 'High-octane university athletics tournament! Witness 16 varsity teams battle for the Chancellor Trophy in Basketball and Futsal over 3 days.',
        category: 'Sports',
        date: now.add(const Duration(days: 6)),
        time: '08:30 AM',
        venue: 'Indoor Sports Arena & Gymnasium',
        organizerClub: 'Sports & Athletics Committee',
        bannerUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
        maxParticipants: 500,
        registeredCount: 310,
        fee: 0.0,
        isFeatured: false,
        tags: ['Basketball', 'Futsal', 'Championship', 'Trophy'],
        rules: [
          'Standard FIBA and FIFA indoor rules apply.',
          'Team jerseys and safety gear are mandatory.'
        ],
        coordinatorPhone: '+91 98777 88990',
        coordinatorEmail: 'sports@campus.edu',
      ),
      EventModel(
        id: 'evt_5',
        title: 'RoboWars 2026: 15kg & 30kg Combat Robotics League',
        description: 'Sparks fly and metal crushes! Custom combat bots duel in an enclosed bulletproof arena with spinning blades, pneumatic flippers, and drum spinners.',
        category: 'Tech',
        date: now.add(const Duration(days: 12)),
        time: '02:00 PM',
        venue: 'Dr. APJ Abdul Kalam Grand Auditorium',
        organizerClub: 'Robotics & Automation Society',
        bannerUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800',
        maxParticipants: 1000,
        registeredCount: 640,
        fee: 200.0,
        isFeatured: true,
        tags: ['Robotics', 'Combat', 'Engineering', 'Excitement'],
        rules: [
          'Bot weight limits: 15.0kg and 30.0kg categories.',
          'Fail-safe radio link is compulsory.',
          'Safety check clearance required before arena bout.'
        ],
        coordinatorPhone: '+91 98888 12121',
        coordinatorEmail: 'robowars@campus.edu',
      ),
    ];
  }
}
