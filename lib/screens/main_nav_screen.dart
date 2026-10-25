import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../services/notification_service.dart';
import 'home_dashboard_screen.dart';
import 'campus_map_screen.dart';
import 'campus_news_screen.dart';
import 'my_tickets_screen.dart';
import 'organizer_dashboard_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _showNotificationSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<NotificationService>(
          builder: (context, notifs, _) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.85,
              minChildSize: 0.4,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications, color: AppColors.primary),
                              const SizedBox(width: 8),
                              const Text(
                                'Campus Notifications',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (notifs.unreadCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${notifs.unreadCount}',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          TextButton(
                            onPressed: notifs.markAllAsRead,
                            child: const Text('Mark all read'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: notifs.notifications.isEmpty
                            ? const Center(
                                child: Text('No notifications yet'),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: notifs.notifications.length,
                                itemBuilder: (context, index) {
                                  final item = notifs.notifications[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: item.iconColor.withAlpha(30),
                                      child: Icon(item.icon, color: item.iconColor, size: 20),
                                    ),
                                    title: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.body,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: !item.isRead
                                        ? const CircleAvatar(radius: 4, backgroundColor: AppColors.primary)
                                        : null,
                                    onTap: () => notifs.markAsRead(item.id),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final notifService = Provider.of<NotificationService>(context);

    // Navigation Screens list
    final screens = [
      const HomeDashboardScreen(),
      const CampusMapScreen(),
      const CampusNewsScreen(),
      const MyTicketsScreen(),
      auth.isCoordinator ? const OrganizerDashboardScreen() : const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'CampusEventHub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          // Notification Bell with Unread Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotificationSheet(context),
              ),
              if (notifService.unreadCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${notifService.unreadCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // User Profile Avatar with quick jump to Profile
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 4),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: NetworkImage(auth.currentUser?.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 50 : 15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withAlpha(30),
          elevation: 0,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: AppColors.primary),
              label: 'Explore',
            ),
            const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: AppColors.primary),
              label: 'Venues',
            ),
            const NavigationDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper, color: AppColors.primary),
              label: 'Live News',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: eventProvider.registrations.isNotEmpty,
                label: Text('${eventProvider.registrations.length}'),
                child: const Icon(Icons.confirmation_number_outlined),
              ),
              selectedIcon: const Icon(Icons.confirmation_number, color: AppColors.primary),
              label: 'My Passes',
            ),
            NavigationDestination(
              icon: Icon(auth.isCoordinator ? Icons.admin_panel_settings_outlined : Icons.person_outline),
              selectedIcon: Icon(auth.isCoordinator ? Icons.admin_panel_settings : Icons.person, color: AppColors.primary),
              label: auth.isCoordinator ? 'Desk' : 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
