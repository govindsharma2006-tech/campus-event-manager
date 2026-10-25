import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/event_model.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/qr_ticket_dialog.dart';
import 'event_form_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  void _openRegistrationSheet(BuildContext context, EventModel event) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final rollCtrl = TextEditingController(text: user?.rollNo ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final deptCtrl = TextEditingController(text: user?.department ?? 'Computer Science & Engineering');
    final teamNameCtrl = TextEditingController();
    int teamSize = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Event Registration Form',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Event: ${event.title}',
                        style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                      const Divider(height: 24),

                      CustomTextField(
                        controller: nameCtrl,
                        label: 'Student Full Name',
                        prefixIcon: Icons.person_outline,
                        validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: rollCtrl,
                              label: 'Roll Number',
                              prefixIcon: Icons.badge_outlined,
                              validator: (v) => v == null || v.isEmpty ? 'Roll No required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: phoneCtrl,
                              label: 'Phone',
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.length < 10 ? 'Valid phone required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: emailCtrl,
                        label: 'University Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v != null && v.contains('@') ? null : 'Valid email required',
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: deptCtrl,
                        label: 'Department / Branch',
                        prefixIcon: Icons.account_balance_outlined,
                      ),
                      const SizedBox(height: 14),

                      // Team details if hackathon/cultural
                      if (event.category.toLowerCase() == 'hackathon' || event.category.toLowerCase() == 'sports') ...[
                        CustomTextField(
                          controller: teamNameCtrl,
                          label: 'Team Name (Optional)',
                          hint: 'e.g. CodeWarriors',
                          prefixIcon: Icons.group_outlined,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Team Size (1-4 members):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            DropdownButton<int>(
                              value: teamSize,
                              items: [1, 2, 3, 4].map((size) {
                                return DropdownMenuItem(value: size, child: Text('$size Member${size > 1 ? 's' : ''}'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => teamSize = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      CustomButton(
                        text: 'Confirm & Generate Pass',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final eventProv = Provider.of<EventProvider>(context, listen: false);

                          final reg = await eventProv.registerForEvent(
                            event: event,
                            studentName: nameCtrl.text.trim(),
                            studentRollNo: rollCtrl.text.trim(),
                            studentEmail: emailCtrl.text.trim(),
                            studentPhone: phoneCtrl.text.trim(),
                            department: deptCtrl.text.trim(),
                            teamName: teamNameCtrl.text.trim().isEmpty ? null : teamNameCtrl.text.trim(),
                            teamSize: teamSize,
                          );

                          if (!context.mounted) return;
                          Navigator.pop(context); // Close sheet

                          if (reg != null) {
                            showDialog(
                              context: context,
                              builder: (_) => QrTicketDialog(registration: reg),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventProvider = Provider.of<EventProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final event = eventProvider.getEventById(widget.eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Event not found or removed')),
      );
    }

    final isBookmarked = eventProvider.isBookmarked(event.id);
    final isRegistered = eventProvider.isRegistered(event.id);
    final existingTicket = isRegistered ? eventProvider.getRegistrationByEventId(event.id) : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image AppBar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black.withAlpha(140),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black.withAlpha(140),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.warning : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => eventProvider.toggleBookmark(event.id),
              ),
              if (auth.isCoordinator)
                IconButton(
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black.withAlpha(140),
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventFormScreen(eventToEdit: event)),
                    );
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(90),
                          Colors.transparent,
                          Colors.black.withAlpha(170),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(160),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.fee == 0 ? 'FREE ENTRY' : 'FEE: ₹${event.fee.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Event Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Organizer Club
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Organized by ${event.organizerClub}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Info Card (Date, Time, Venue)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.calendar_month,
                          'Date',
                          DateFormat('EEEE, MMMM dd, yyyy').format(event.date),
                          AppColors.primary,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          Icons.access_time,
                          'Timing',
                          event.time,
                          AppColors.secondary,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          Icons.location_on,
                          'Campus Venue',
                          event.venue,
                          AppColors.warning,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          Icons.people_alt,
                          'Registrations',
                          '${event.registeredCount} / ${event.maxParticipants} students registered (${event.availableSeats} seats left)',
                          AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Event
                  const Text(
                    'About Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rules & Guidelines
                  if (event.rules.isNotEmpty) ...[
                    const Text(
                      'Rules & Guidelines',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...event.rules.map(
                      (rule) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Expanded(
                              child: Text(
                                rule,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Coordinator Contact Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary.withAlpha(40)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.support_agent, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Event Coordinator Desk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(
                                '${event.coordinatorEmail} • ${event.coordinatorPhone}',
                                style: const TextStyle(fontSize: 12, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for sticky action bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: isRegistered
            ? Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'View Digital Pass',
                      icon: Icons.qr_code,
                      onPressed: () {
                        if (existingTicket != null) {
                          showDialog(
                            context: context,
                            builder: (_) => QrTicketDialog(registration: existingTicket),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    tooltip: 'Cancel Registration',
                    onPressed: () {
                      if (existingTicket != null) {
                        eventProvider.cancelRegistration(existingTicket.ticketId);
                      }
                    },
                  ),
                ],
              )
            : CustomButton(
                text: event.isFull ? 'Seats Full' : 'Register Now',
                icon: Icons.app_registration,
                onPressed: event.isFull ? null : () => _openRegistrationSheet(context, event),
              ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
