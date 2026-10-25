import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/metric_card.dart';
import 'event_form_screen.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  void _showDeleteConfirmation(BuildContext context, String eventId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "$title"? All associated student registrations will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false).deleteEvent(eventId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event deleted successfully.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventProvider = Provider.of<EventProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final totalEvents = eventProvider.allEvents.length;
    final totalRegistrations = eventProvider.totalRegisteredStudents;
    final totalCapacity = eventProvider.allEvents.fold(0, (sum, e) => sum + e.maxParticipants);
    final fillRate = totalCapacity > 0 ? ((totalRegistrations / totalCapacity) * 100).toInt() : 0;

    // Categories data for bar chart
    final categoryCounts = eventProvider.categoryEventCount;
    final categories = ['Hackathon', 'Tech', 'Cultural', 'Sports', 'Workshop'];

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
          'Create Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coordinator Console Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withAlpha(30),
                    child: const Icon(Icons.shield, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.currentUser?.clubName ?? 'Club Coordinator Desk',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Convenor: ${auth.currentUser?.name ?? 'Dr. Coordinator'}',
                          style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.restore, color: AppColors.warning),
                    tooltip: 'Reset Demo Data',
                    onPressed: () async {
                      await eventProvider.resetToDefaultData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Events and tickets reset to sample state')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Metrics Grid
            Row(
              children: [
                MetricCard(
                  title: 'Events Created',
                  value: '$totalEvents',
                  icon: Icons.event,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                MetricCard(
                  title: 'Total Registrations',
                  value: '$totalRegistrations',
                  subtitle: '$fillRate% filled',
                  icon: Icons.group_add,
                  color: AppColors.success,
                ),
                const SizedBox(width: 10),
                MetricCard(
                  title: 'Venue Capacity',
                  value: '$totalCapacity',
                  icon: Icons.chair,
                  color: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Analytics Chart using fl_chart
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Event Distribution by Category',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Live Analytics', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 160,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 6,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: 2,
                              getTitlesWidget: (val, _) => Text(
                                '${val.toInt()}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, _) {
                                final index = val.toInt();
                                if (index >= 0 && index < categories.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      categories[index].substring(0, 3),
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(categories.length, (i) {
                          final count = categoryCounts[categories[i]] ?? 0;
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: count.toDouble(),
                                gradient: AppColors.primaryGradient,
                                width: 18,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // CRUD Management Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Campus Events (${eventProvider.allEvents.length})',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventFormScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Event'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Event Management List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventProvider.allEvents.length,
              itemBuilder: (context, index) {
                final event = eventProvider.allEvents[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          event.bannerUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.primary.withAlpha(30),
                            child: const Icon(Icons.event, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.time} • ${event.venue}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.registeredCount} / ${event.maxParticipants} Registered',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      // Actions: Edit & Delete
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                        tooltip: 'Edit Event',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EventFormScreen(eventToEdit: event)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        tooltip: 'Delete Event',
                        onPressed: () => _showDeleteConfirmation(context, event.id, event.title),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
