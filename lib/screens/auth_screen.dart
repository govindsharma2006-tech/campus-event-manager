import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'main_nav_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsRegister;

  const AuthScreen({super.key, this.initialIsRegister = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;

  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'student@campus.edu');
  final _passwordController = TextEditingController(text: 'campus123');
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedRole = 'student'; // 'student' or 'coordinator'

  // Primary Theme Purple from screenshot
  static const Color _primaryPurple = Color(0xFF5E35B1); // Deep Purple
  static const Color _lightPurpleBg = Color(0xFFF5F3FF); // Lavender light bg

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (_isSignUp) {
      final success = await auth.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        rollNo: _rollController.text.trim().isEmpty ? '23CSB1042' : _rollController.text.trim(),
        department: 'Computer Science & Engineering',
        semester: '6th Semester',
        phone: '+91 98765 43210',
        password: _passwordController.text,
        role: _selectedRole,
      );

      if (!mounted) return;
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
        );
      } else {
        _showError(auth.errorMessage ?? 'Registration failed');
      }
    } else {
      final success = await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
        );
      } else {
        _showError(auth.errorMessage ?? 'Invalid email or password');
      }
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryPurple.withAlpha(20),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Purple Graduation Cap Icon
                      const Icon(
                        Icons.school_rounded,
                        size: 52,
                        color: _primaryPurple,
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        _isSignUp ? 'Create Account' : 'Campus Event Manager',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _primaryPurple,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        _isSignUp
                            ? 'Register to manage and explore campus events'
                            : 'Sign in to manage and register for events',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Demo Quick Login Box (From Screenshot)
                      if (!_isSignUp) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: _lightPurpleBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _primaryPurple.withAlpha(30)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Demo Quick Login:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => _handleQuickDemo(false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.person, size: 14, color: _primaryPurple),
                                              SizedBox(width: 4),
                                              Text(
                                                'Student Demo',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => _handleQuickDemo(true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.admin_panel_settings, size: 14, color: _primaryPurple),
                                              SizedBox(width: 4),
                                              Text(
                                                'Admin Demo',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Sign Up extra fields
                      if (_isSignUp) ...[
                        _buildInputField(
                          controller: _nameController,
                          hintText: 'Full Name',
                          prefixIcon: Icons.person_outline,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _rollController,
                          hintText: 'Roll Number / Student ID',
                          prefixIcon: Icons.badge_outlined,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter Roll No' : null,
                        ),
                        const SizedBox(height: 14),

                        // Role Selector
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Center(child: Text('Student', style: TextStyle(fontSize: 12))),
                                selected: _selectedRole == 'student',
                                selectedColor: _primaryPurple,
                                labelStyle: TextStyle(
                                  color: _selectedRole == 'student' ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                onSelected: (_) => setState(() => _selectedRole = 'student'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Center(child: Text('Coordinator', style: TextStyle(fontSize: 12))),
                                selected: _selectedRole == 'coordinator',
                                selectedColor: _primaryPurple,
                                labelStyle: TextStyle(
                                  color: _selectedRole == 'coordinator' ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                onSelected: (_) => setState(() => _selectedRole = 'coordinator'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Email Field
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please enter your email';
                          if (!v.contains('@')) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign In / Sign Up Purple Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryPurple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  _isSignUp ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSignUp = !_isSignUp;
                                _formKey.currentState?.reset();
                              });
                            },
                            child: Text(
                              _isSignUp ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        prefixIcon: Icon(prefixIcon, size: 20, color: Colors.grey.shade600),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryPurple, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 1.8),
        ),
      ),
    );
  }
}
