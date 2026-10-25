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

class _AuthScreenState extends State<AuthScreen> {
  int _activeTab = 0; // 0 = Sign In, 1 = Sign Up

  // Sign In Controllers
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController(text: 'student@campus.edu');
  final _loginPasswordController = TextEditingController(text: 'campus123');
  bool _loginObscure = true;

  // Sign Up Controllers
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
    _activeTab = widget.initialIsRegister ? 1 : 0;
  }

  @override
  void dispose() {
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
          content: Text(auth.errorMessage ?? 'Login failed. Please verify credentials.'),
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
          content: Text('Account created successfully! Welcome to CampusEventHub.'),
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
          content: Text(auth.errorMessage ?? 'Registration failed. Try again.'),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // University App Logo & Title Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'CampusEventHub',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Smart Campus Event Lifecycle & Fest Platform',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Quick Review Access Box for Mentors & Evaluators
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withAlpha(60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bolt, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Evaluator / Quick Demo Login',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap below to instantly log in without manual typing:',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _handleQuickDemo(false),
                            icon: const Icon(Icons.person, size: 15),
                            label: const Text('Student View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _handleQuickDemo(true),
                            icon: const Icon(Icons.admin_panel_settings, size: 15),
                            label: const Text('Coordinator', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Segmented Tabs: Log In vs Sign Up
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeTab = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            gradient: _activeTab == 0 ? AppColors.primaryGradient : null,
                            color: _activeTab == 0 ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _activeTab == 0
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(70),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _activeTab == 0
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeTab = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            gradient: _activeTab == 1 ? AppColors.primaryGradient : null,
                            color: _activeTab == 1 ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _activeTab == 1
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(70),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _activeTab == 1
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Display based on active tab
              if (_activeTab == 0) _buildSignInForm(auth, isDark) else _buildSignUpForm(auth, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- SIGN IN FORM ---
  Widget _buildSignInForm(AuthProvider auth, bool isDark) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _loginEmailController,
            label: 'University Email Address *',
            hint: 'e.g. student@campus.edu',
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
            label: 'Password *',
            hint: 'Enter your account password',
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
          const SizedBox(height: 10),

          // Forgot Password Row
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo Password is: campus123 or use Quick Demo Login above')),
                );
              },
              child: const Text('Forgot Password?', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(height: 16),

          CustomButton(
            text: 'Sign In to CampusEventHub',
            icon: Icons.login,
            isLoading: auth.isLoading,
            onPressed: _handleLogin,
          ),
          const SizedBox(height: 18),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account yet? ",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 1),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- SIGN UP FORM ---
  Widget _buildSignUpForm(AuthProvider auth, bool isDark) {
    return Form(
      key: _regFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Selection Radio Chips
          Text(
            'Account Type *',
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
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _selectedRole == 'student' ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: _selectedRole == 'student' ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) => setState(() => _selectedRole = 'student'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Club Coordinator')),
                  selected: _selectedRole == 'coordinator',
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _selectedRole == 'coordinator' ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: _selectedRole == 'coordinator' ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) => setState(() => _selectedRole = 'coordinator'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _regNameController,
            label: 'Full Name *',
            hint: 'e.g. Rohan Gupta',
            prefixIcon: Icons.person_outline,
            validator: (val) => val == null || val.trim().isEmpty ? 'Full name is required' : null,
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _regEmailController,
            label: 'University / College Email *',
            hint: 'e.g. rohan@campus.edu',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!val.contains('@')) return 'Enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _regRollController,
            label: _selectedRole == 'coordinator' ? 'Faculty / Staff ID *' : 'Student Roll Number *',
            hint: _selectedRole == 'coordinator' ? 'e.g. FAC-CS-088' : 'e.g. 23CSB1042',
            prefixIcon: Icons.badge_outlined,
            validator: (val) => val == null || val.trim().isEmpty ? 'Identification ID is required' : null,
          ),
          const SizedBox(height: 14),

          if (_selectedRole == 'coordinator') ...[
            CustomTextField(
              controller: _clubNameController,
              label: 'Club / Society / Committee Name *',
              hint: 'e.g. TechNova & AI Club',
              prefixIcon: Icons.groups_outlined,
              validator: (val) => val == null || val.trim().isEmpty ? 'Club name is required' : null,
            ),
            const SizedBox(height: 14),
          ],

          CustomTextField(
            controller: _regDeptController,
            label: 'Department / Branch *',
            hint: 'e.g. Computer Science & Engineering',
            prefixIcon: Icons.account_balance_outlined,
            validator: (val) => val == null || val.trim().isEmpty ? 'Department is required' : null,
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _regPhoneController,
            label: 'Phone Number *',
            hint: '+91 98765 43210',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Phone number is required';
              if (val.trim().length < 10) return 'Enter a valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _regPasswordController,
            label: 'Create Password *',
            hint: 'Minimum 6 characters',
            prefixIcon: Icons.lock_outline,
            obscureText: _regObscure,
            suffixIcon: IconButton(
              icon: Icon(_regObscure ? Icons.visibility_off : Icons.visibility, size: 20),
              onPressed: () => setState(() => _regObscure = !_regObscure),
            ),
            validator: (val) {
              if (val == null || val.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 22),

          CustomButton(
            text: 'Create Account & Continue',
            icon: Icons.person_add_alt_1,
            isLoading: auth.isLoading,
            onPressed: _handleRegister,
          ),
          const SizedBox(height: 18),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already registered? ',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 0),
                  child: const Text(
                    'Sign In here',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
