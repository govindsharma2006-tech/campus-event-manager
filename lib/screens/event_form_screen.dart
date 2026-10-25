import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_colors.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class EventFormScreen extends StatefulWidget {
  final EventModel? eventToEdit;

  const EventFormScreen({super.key, this.eventToEdit});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _organizerCtrl;
  late TextEditingController _bannerCtrl;
  late TextEditingController _maxSeatsCtrl;
  late TextEditingController _feeCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _rulesCtrl;

  late String _selectedCategory;
  late String _selectedVenue;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isFeatured = false;

  final List<String> _categories = ['Hackathon', 'Tech', 'Cultural', 'Sports', 'Workshop'];
  final List<String> _venues = [
    'Dr. APJ Abdul Kalam Grand Auditorium',
    'Turing Advanced Innovation Lab',
    'Open Air Amphitheatre (OAT)',
    'Indoor Sports Arena & Gymnasium',
    'Aryabhata Conference Hall',
  ];

  // Image Presets for quick selection
  final List<String> _bannerPresets = [
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
    'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800',
    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
    'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.eventToEdit;

    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _organizerCtrl = TextEditingController(text: e?.organizerClub ?? 'Tech & Innovation Club');
    _bannerCtrl = TextEditingController(text: e?.bannerUrl ?? _bannerPresets.first);
    _maxSeatsCtrl = TextEditingController(text: e != null ? '${e.maxParticipants}' : '150');
    _feeCtrl = TextEditingController(text: e != null ? '${e.fee.toInt()}' : '0');
    _phoneCtrl = TextEditingController(text: e?.coordinatorPhone ?? '+91 98765 43210');
    _emailCtrl = TextEditingController(text: e?.coordinatorEmail ?? 'events@campus.edu');
    _rulesCtrl = TextEditingController(text: e?.rules.join('\n') ?? 'Valid student ID is mandatory.\nReport 15 minutes before schedule.');

    _selectedCategory = e?.category ?? _categories.first;
    _selectedVenue = e?.venue ?? _venues.first;
    _selectedDate = e?.date ?? DateTime.now().add(const Duration(days: 5));
    _selectedTime = TimeOfDay.now();
    _isFeatured = e?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _organizerCtrl.dispose();
    _bannerCtrl.dispose();
    _maxSeatsCtrl.dispose();
    _feeCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _rulesCtrl.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final formattedTime = _selectedTime.format(context);
    final rulesList = _rulesCtrl.text
        .split('\n')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();

    if (widget.eventToEdit == null) {
      // Create new event
      final newEvent = EventModel(
        id: 'evt_${const Uuid().v4().substring(0, 8)}',
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _selectedCategory,
        date: _selectedDate,
        time: formattedTime,
        venue: _selectedVenue,
        organizerClub: _organizerCtrl.text.trim(),
        bannerUrl: _bannerCtrl.text.trim(),
        maxParticipants: int.tryParse(_maxSeatsCtrl.text.trim()) ?? 100,
        registeredCount: 0,
        fee: double.tryParse(_feeCtrl.text.trim()) ?? 0.0,
        isFeatured: _isFeatured,
        tags: [_selectedCategory, 'Campus 2026'],
        rules: rulesList,
        coordinatorPhone: _phoneCtrl.text.trim(),
        coordinatorEmail: _emailCtrl.text.trim(),
      );

      await eventProvider.createEvent(newEvent);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campus Event created successfully! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      // Update existing event
      final updated = widget.eventToEdit!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _selectedCategory,
        date: _selectedDate,
        time: formattedTime,
        venue: _selectedVenue,
        organizerClub: _organizerCtrl.text.trim(),
        bannerUrl: _bannerCtrl.text.trim(),
        maxParticipants: int.tryParse(_maxSeatsCtrl.text.trim()) ?? widget.eventToEdit!.maxParticipants,
        fee: double.tryParse(_feeCtrl.text.trim()) ?? widget.eventToEdit!.fee,
        isFeatured: _isFeatured,
        rules: rulesList,
        coordinatorPhone: _phoneCtrl.text.trim(),
        coordinatorEmail: _emailCtrl.text.trim(),
      );

      await eventProvider.updateEvent(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event details updated successfully! ✏️'),
          backgroundColor: AppColors.primary,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.eventToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Campus Event' : 'Create New Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              CustomTextField(
                controller: _titleCtrl,
                label: 'Event Title *',
                hint: 'e.g. CodeStorm 2026: Annual Algorithmic Contest',
                prefixIcon: Icons.title,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Event title is required';
                  if (val.trim().length < 5) return 'Title must be at least 5 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selector
              Text('Category *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Venue Selector
              Text('Campus Venue *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVenue,
                    isExpanded: true,
                    items: _venues.map((v) {
                      return DropdownMenuItem(value: v, child: Text(v, maxLines: 1, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedVenue = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date & Time Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Date *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Time *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _pickTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Text(_selectedTime.format(context), style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Organizer Club
              CustomTextField(
                controller: _organizerCtrl,
                label: 'Organizing Club / Society *',
                prefixIcon: Icons.groups,
                validator: (val) => val == null || val.isEmpty ? 'Organizer club is required' : null,
              ),
              const SizedBox(height: 16),

              // Poster Banner Selector
              Text('Poster Banner Image *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bannerPresets.length,
                  itemBuilder: (context, index) {
                    final url = _bannerPresets[index];
                    final isSelected = _bannerCtrl.text == url;
                    return GestureDetector(
                      onTap: () => setState(() => _bannerCtrl.text = url),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(url, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _bannerCtrl,
                label: 'Or Custom Image URL',
                prefixIcon: Icons.link,
              ),
              const SizedBox(height: 16),

              // Max Seats & Fee Row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _maxSeatsCtrl,
                      label: 'Capacity (Seats) *',
                      prefixIcon: Icons.chair_alt,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || int.tryParse(val) == null || int.parse(val) <= 0) {
                          return 'Enter valid capacity';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _feeCtrl,
                      label: 'Entry Fee (₹ 0 for Free)',
                      prefixIcon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descCtrl,
                label: 'Event Description *',
                hint: 'Provide an overview of the event, itinerary, and agenda...',
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
                validator: (val) => val == null || val.length < 10 ? 'Description must be at least 10 characters' : null,
              ),
              const SizedBox(height: 16),

              // Rules
              CustomTextField(
                controller: _rulesCtrl,
                label: 'Event Rules (One per line)',
                maxLines: 3,
                prefixIcon: Icons.rule,
              ),
              const SizedBox(height: 16),

              // Coordinator Contacts
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneCtrl,
                      label: 'Coordinator Phone',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _emailCtrl,
                      label: 'Coordinator Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Featured Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Feature on Campus Spotlight', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text('Highlight on home banner carousel', style: TextStyle(fontSize: 12)),
                value: _isFeatured,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _isFeatured = val),
              ),
              const SizedBox(height: 24),

              // Save Action Button
              CustomButton(
                text: isEditing ? 'Update Campus Event' : 'Publish Campus Event',
                icon: isEditing ? Icons.save : Icons.publish,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
