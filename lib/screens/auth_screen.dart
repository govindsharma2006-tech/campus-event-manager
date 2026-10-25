import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'main_nav_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsRegister;

  const AuthScreen({super.key, this.initialIsRegister = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login Controllers
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController(text: 'student@campus.edu');
  final _loginPasswordController = TextEditingController(text: 'campus123');
  bool _loginObscure = true;

  // Register Controllers
  final _regFormKey = GlobalKey<FormState>();
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regRollController = TextEditingController();
  final _regDeptController = TextEditingController(text: 'Computer Science & Engineering');
  final _regPhoneController = TextEditingController();
  final _regPasswordController = TextEditingController();
  bool _regObscure = true;
  String _selectedRole = 'student';
  final _clubNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIsRegister ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regRollController.dispose();
    _regDeptController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();
    _clubNameController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(
      email: _loginEmailController.text.trim(),
      password: _loginPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleRegister() async {
    if (!_regFormKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: _regNameController.text.trim(),
      email: _regEmailController.text.trim(),
      rollNo: _regRollController.text.trim(),
      department: _regDeptController.text.trim(),
      semester: '6th Semester',
      phone: _regPhoneController.text.trim(),
      password: _regPasswordController.text,
      role: _selectedRole,
      clubName: _selectedRole == 'coordinator' ? _clubNameController.text.trim() : null,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account registered successfully! Welcome to CampusEventHub.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleQuickDemo(bool isCoordinator) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (isCoordinator) {
      await auth.demoLoginAsCoordinator();
    } else {
      await auth.demoLoginAsStudent();
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Brand Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CampusEventHub',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'University Student & Event Portal',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Demo Login Banner for Evaluators / Viva Examiners
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bolt, color: AppColors.primary, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Quick Demo Review Access',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _handleQuickDemo(false),
                              icon: const Icon(Icons.person, size: 16),
                              label: const Text('Student View', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleQuickDemo(true),
                              icon: const Icon(Icons.admin_panel_settings, size: 16),
                              label: const Text('Coordinator', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tab Selector
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    tabs: const [
                      Tab(text: 'Sign In'),
                      Tab(text: 'Register'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tab Content
                SizedBox(
                  height: 480,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // --- LOGIN TAB ---
                      Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: _loginEmailController,
                              label: 'University Email',
                              hint: 'e.g. name@campus.edu',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Email is required';
                                if (!val.contains('@')) return 'Enter a valid email address';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _loginPasswordController,
                              label: 'Password',
                              hint: 'Enter your password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _loginObscure,
                              suffixIcon: IconButton(
                                icon: Icon(_loginObscure ? Icons.visibility_off : Icons.visibility, size: 20),
                                onPressed: () => setState(() => _loginObscure = !_loginObscure),
                              ),
                              validator: (val) {
                                if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            CustomButton(
                              text: 'Sign In',
                              isLoading: auth.isLoading,
                              onPressed: _handleLogin,
                            ),
                          ],
                        ),
                      ),

                      // --- REGISTER TAB ---
                      SingleChildScrollView(
                        child: Form(
                          key: _regFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Role Selection
                              Text(
                                'Register As',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ChoiceChip(
                                      label: const Center(child: Text('Student')),
                                      selected: _selectedRole == 'student',
                                      onSelected: (val) => setState(() => _selectedRole = 'student'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ChoiceChip(
                                      label: const Center(child: Text('Club Coordinator')),
                                      selected: _selectedRole == 'coordinator',
                                      onSelected: (val) => setState(() => _selectedRole = 'coordinator'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _regNameController,
                                label: 'Full Name',
                                hint: 'e.g. Rohan Gupta',
                                prefixIcon: Icons.person_outline,
                                validator: (val) => val == null || val.isEmpty ? 'Name is required' : null,
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _regEmailController,
                                label: 'College Email',
                                hint: 'e.g. rohan@campus.edu',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) => val != null && val.contains('@') ? null : 'Valid email required',
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _regRollController,
                                label: _selectedRole == 'coordinator' ? 'Faculty / Staff ID' : 'Student Roll Number',
                                hint: _selectedRole == 'coordinator' ? 'e.g. FAC-CS-088' : 'e.g. 23CSB1042',
                                prefixIcon: Icons.badge_outlined,
                                validator: (val) => val == null || val.isEmpty ? 'ID is required' : null,
                              ),
                              const SizedBox(height: 12),
                              if (_selectedRole == 'coordinator') ...[
                                CustomTextField(
                                  controller: _clubNameController,
                                  label: 'Club / Committee Name',
                                  hint: 'e.g. TechNova & AI Club',
                                  prefixIcon: Icons.groups_outlined,
                                  validator: (val) => val == null || val.isEmpty ? 'Club name is required' : null,
                                ),
                                const SizedBox(height: 12),
                              ],
                              CustomTextField(
                                controller: _regPhoneController,
                                label: 'Phone Number',
                                hint: '+91 98765 43210',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (val) => val == null || val.length < 10 ? 'Valid 10-digit phone required' : null,
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _regPasswordController,
                                label: 'Create Password',
                                hint: 'Minimum 6 characters',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _regObscure,
                                suffixIcon: IconButton(
                                  icon: Icon(_regObscure ? Icons.visibility_off : Icons.visibility, size: 20),
                                  onPressed: () => setState(() => _regObscure = !_regObscure),
                                ),
                                validator: (val) => val != null && val.length >= 6 ? null : 'Minimum 6 chars',
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: 'Create Account',
                                isLoading: auth.isLoading,
                                onPressed: _handleRegister,
                              ),
                              const SizedBox(height: 24),
                            ],
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
      ),
    );
  }
}
