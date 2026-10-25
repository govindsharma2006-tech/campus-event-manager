class VenueModel {
  final String id;
  final String name;
  final String building;
  final String floor;
  final int capacity;
  final double latitude;
  final double longitude;
  final String description;
  final List<String> amenities;
  final String imageUrl;

  const VenueModel({
    required this.id,
    required this.name,
    required this.building,
    required this.floor,
    required this.capacity,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.amenities,
    required this.imageUrl,
  });

  static List<VenueModel> get sampleVenues => [
    const VenueModel(
      id: 'v1',
      name: 'Dr. APJ Abdul Kalam Grand Auditorium',
      building: 'Main Academic Block A',
      floor: 'Ground Floor',
      capacity: 1200,
      latitude: 28.5450,
      longitude: 77.1926,
      description: 'Air-conditioned main auditorium with Dolby Atmos sound, twin 4K projection screens, and green room.',
      amenities: ['Dolby Sound', 'Stage Lighting', 'VIP Lounge', 'WiFi 6', 'Wheelchair Accessible'],
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=600',
    ),
    const VenueModel(
      id: 'v2',
      name: 'Turing Advanced Innovation Lab',
      building: 'Technology & Computing Block',
      floor: '3rd Floor, Room 304',
      capacity: 180,
      latitude: 28.5458,
      longitude: 77.1932,
      description: 'High-performance computing lab with 120 dual-monitor workstations, gigabit LAN, and interactive smartboards.',
      amenities: ['Dual Monitors', 'High-Speed LAN', 'Smartboards', 'Server Access', 'Backup Power'],
      imageUrl: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=600',
    ),
    const VenueModel(
      id: 'v3',
      name: 'Open Air Amphitheatre (OAT)',
      building: 'Student Activity Center',
      floor: 'Open Complex',
      capacity: 2500,
      latitude: 28.5442,
      longitude: 77.1915,
      description: 'Sprawling open-air amphitheatre with acoustically treated tiered seating for cultural nights and battle of the bands.',
      amenities: ['Concert Audio Rig', 'Flood Lights', 'Open Sky', 'Food Stalls Nearby'],
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600',
    ),
    const VenueModel(
      id: 'v4',
      name: 'Indoor Sports Arena & Gymnasium',
      building: 'Sports Complex',
      floor: 'Ground & Mezzanine',
      capacity: 800,
      latitude: 28.5435,
      longitude: 77.1945,
      description: 'Wooden floor basketball court, 4 badminton courts, table tennis hall, and digital scoreboards.',
      amenities: ['Wooden Flooring', 'Locker Rooms', 'Medical First Aid', 'Spectator Stands'],
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600',
    ),
    const VenueModel(
      id: 'v5',
      name: 'Aryabhata Conference Hall',
      building: 'Management & R&D Tower',
      floor: '2nd Floor, Room 210',
      capacity: 250,
      latitude: 28.5462,
      longitude: 77.1920,
      description: 'Executive conference hall with push-to-talk delegate microphones, teleconferencing, and acoustic wall panels.',
      amenities: ['Delegate Mics', 'Video Conferencing', 'Central AC', 'Executive Chairs'],
      imageUrl: 'https://images.unsplash.com/photo-1431540015161-0bf868a2d407?w=600',
    ),
  ];
}
