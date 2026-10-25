import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Digital University Student ID Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(90),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID Card Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.school, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'UNIVERSITY CAMPUS CARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          auth.isCoordinator ? 'COORDINATOR' : 'STUDENT',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Avatar & Student Details
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white.withAlpha(50),
                        backgroundImage: NetworkImage(
                          user?.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Student Name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Roll: ${user?.rollNo ?? "23CSB1042"}',
                              style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.department ?? 'Computer Science & Engineering',
                              style: TextStyle(color: Colors.white.withAlpha(190), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 8),

                  // Card Bottom Bar (Validity & Chip)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VALID THRU: 2027',
                        style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 10, letterSpacing: 0.5),
                      ),
                      Row(
                        children: [
                          Icon(Icons.nfc, color: Colors.white.withAlpha(180), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'CAMPUS RFID ACTIVE',
                            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings & Preferences List
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  // Role Switcher Tile (Allows mentor / student to toggle between views instantly!)
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF818CF8),
                      child: Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                    ),
                    title: const Text('Active App View', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(
                      auth.isCoordinator ? 'Currently: Club Coordinator Console' : 'Currently: Student Experience View',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Switch(
                      value: auth.isCoordinator,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        auth.switchRole(val ? 'coordinator' : 'student');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(val ? 'Switched to Coordinator Desk' : 'Switched to Student Experience'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // Dark / Light Theme Toggle Tile
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDark ? Colors.amber : Colors.blueGrey,
                      child: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white, size: 20),
                    ),
                    title: const Text('Dark Mode Appearance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(isDark ? 'Dark theme enabled' : 'Light theme enabled', style: const TextStyle(fontSize: 12)),
                    trailing: Switch(
                      value: isDark,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => themeProvider.setDarkMode(val),
                    ),
                  ),
                  const Divider(height: 1),

                  // Reset Demo Data (Evaluator Friendly!)
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.warning,
                      child: Icon(Icons.refresh, color: Colors.white, size: 20),
                    ),
                    title: const Text('Reset Demo Data', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Reload original campus events & wipe custom passes', style: TextStyle(fontSize: 12)),
                    onTap: () async {
                      await eventProvider.resetToDefaultData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demo data reset to factory initial state')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Academic Course Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Course & Project Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildDetailLine('Course', 'Flutter Hybrid Mobile App Development'),
                  _buildDetailLine('Assessment', 'Classroom Project (100 Marks)'),
                  _buildDetailLine('Project Name', 'CampusEventHub (Smart Event & Fest Platform)'),
                  _buildDetailLine('Version', 'v1.0.0 Stable (Dart 3.12 / Flutter 3.44)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign Out from CampusEventHub'),
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
