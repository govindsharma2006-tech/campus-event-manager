import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/venue_model.dart';
import '../providers/event_provider.dart';
import 'event_detail_screen.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final List<VenueModel> _venues = VenueModel.sampleVenues;
  late VenueModel _selectedVenue;

  @override
  void initState() {
    super.initState();
    _selectedVenue = _venues.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventProvider = Provider.of<EventProvider>(context);

    // Filter events happening at the selected venue
    final venueEvents = eventProvider.allEvents.where((e) {
      return e.venue.toLowerCase().contains(_selectedVenue.name.split(' ')[0].toLowerCase()) ||
          _selectedVenue.name.toLowerCase().contains(e.venue.toLowerCase());
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Header & Visual Campus Layout
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
              ),
              child: Stack(
                children: [
                  // Stylized Map Background Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CampusMapPainter(isDark: isDark),
                    ),
                  ),

                  // Pins for Venues
                  ...List.generate(_venues.length, (index) {
                    final venue = _venues[index];
                    final isSelected = venue.id == _selectedVenue.id;

                    // Compute mock positions across the canvas
                    final double topPos = 40.0 + (index * 38.0);
                    final double leftPos = 40.0 + ((index * 55.0) % 220);

                    return Positioned(
                      top: topPos,
                      left: leftPos,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedVenue = venue),
                        child: AnimatedScale(
                          scale: isSelected ? 1.25 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : AppColors.primary,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected ? AppColors.primary.withAlpha(120) : Colors.black.withAlpha(40),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: isSelected ? Colors.white : AppColors.primary,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(160),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  venue.name.split(' ')[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Compass & Live GPS badge
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(180),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(40)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.gps_fixed, size: 13, color: AppColors.accent),
                          SizedBox(width: 4),
                          Text(
                            'Live Campus GPS',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Map Legend overlay
                  Positioned(
                    bottom: 12,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(170),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Tap any pin to view venue details & schedule',
                        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Venues Selector Carousel
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 8),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _venues.length,
                  itemBuilder: (context, index) {
                    final venue = _venues[index];
                    final isSelected = venue.id == _selectedVenue.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(venue.name.split(' ')[0]),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedVenue = venue),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Selected Venue Detailed Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 40 : 10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _selectedVenue.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: AppColors.primary.withAlpha(40),
                              child: const Icon(Icons.apartment, color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedVenue.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_selectedVenue.building} • ${_selectedVenue.floor}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.people_outline, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Capacity: ${_selectedVenue.capacity} seats',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _selectedVenue.description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Amenities Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _selectedVenue.amenities.map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary.withAlpha(40)),
                          ),
                          child: Text(
                            amenity,
                            style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Active Events Happening At This Venue
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled Events at this Venue (${venueEvents.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (venueEvents.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'No public events currently scheduled at this venue.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...venueEvents.map((e) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(e.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: Text('${e.time} • ${e.organizerClub}', style: const TextStyle(fontSize: 12)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: e.id)),
                            );
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to render interactive campus map layout grid, paths, and building blocks
class CampusMapPainter extends CustomPainter {
  final bool isDark;

  CampusMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    final lawnPaint = Paint()
      ..color = isDark ? const Color(0xFF064E3B).withAlpha(40) : const Color(0xFFD1FAE5)
      ..style = PaintingStyle.fill;

    // Draw campus greenery lawns
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(20, 20, 80, 70), const Radius.circular(12)),
      lawnPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(180, 110, 120, 80), const Radius.circular(12)),
      lawnPaint,
    );

    // Draw pathways / main campus roads
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.75, size.height * 0.45), Offset(size.width * 0.75, size.height), roadPaint);

    // Draw subtle grid
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double j = 0; j < size.height; j += 30) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
