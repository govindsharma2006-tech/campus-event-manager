import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/metric_card.dart';
import '../widgets/category_chip.dart';
import 'event_detail_screen.dart';
import 'event_form_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);

    final categories = ['All', 'Hackathon', 'Tech', 'Cultural', 'Sports', 'Workshop'];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventFormScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Post Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await eventProvider.fetchCampusNews();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              auth.isCoordinator ? 'COORDINATOR CONSOLE' : 'STUDENT DASHBOARD',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hello, ${auth.currentUser?.name.split(' ')[0] ?? 'Student'}! 👋',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What events are you joining this week?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.celebration_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Campus Stats Metric Cards Row
              Row(
                children: [
                  MetricCard(
                    title: 'Active Events',
                    value: '${eventProvider.allEvents.length}',
                    subtitle: 'Campus Live',
                    icon: Icons.event_available,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  MetricCard(
                    title: 'My Passes',
                    value: '${eventProvider.registrations.length}',
                    subtitle: 'Confirmed',
                    icon: Icons.confirmation_number,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 10),
                  MetricCard(
                    title: 'Saved',
                    value: '${eventProvider.bookmarkedIds.length}',
                    subtitle: 'Starred',
                    icon: Icons.bookmark,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                onChanged: (val) => eventProvider.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search events by name, club, or venue...',
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon: eventProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => eventProvider.setSearchQuery(''),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Category Filter Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = eventProvider.selectedCategory.toLowerCase() == cat.toLowerCase();
                    return CategoryChip(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () => eventProvider.setSelectedCategory(cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Events Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events (${eventProvider.filteredEvents.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (eventProvider.selectedCategory != 'All' || eventProvider.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        eventProvider.setSelectedCategory('All');
                        eventProvider.setSearchQuery('');
                      },
                      child: const Text('Reset filter'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Events List or Empty State
              if (eventProvider.filteredEvents.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 54, color: isDark ? Colors.grey : Colors.grey.shade400),
                      const SizedBox(height: 14),
                      const Text(
                        'No matching events found',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try searching for another keyword or change your category filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          eventProvider.setSelectedCategory('All');
                          eventProvider.setSearchQuery('');
                        },
                        child: const Text('View All Events'),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: eventProvider.filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = eventProvider.filteredEvents[index];
                    return EventCard(
                      event: event,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailScreen(eventId: event.id),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
