import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_widgets.dart';
import '../widgets/premium_components.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Sign In Controllers
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Sign Up Controllers
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  bool _isSignInLoading = false;
  bool _isSignUpLoading = false;
  bool _obscureSignInPassword = true;
  bool _obscureSignUpPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo and Welcome
              FadeInSlideUp(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.work, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to JobBoard',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find your dream job today',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Tab Bar
              FadeInSlideUp(
                delay: const Duration(milliseconds: 200),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Sign In'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tab Content
              SizedBox(
                height: 400,
                child: TabBarView(controller: _tabController, children: [_buildSignInForm(), _buildSignUpForm()]),
              ),

              const SizedBox(height: 24),

              // Social Login
              FadeInSlideUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton('Google', Icons.g_mobiledata, Colors.red, _signInWithGoogle),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSocialButton('LinkedIn', Icons.business, Colors.blue, _signInWithLinkedIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Guest Access
              FadeInSlideUp(
                delay: const Duration(milliseconds: 800),
                child: TextButton(
                  onPressed: _continueAsGuest,
                  child: Text(
                    'Continue as Guest',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildSignInForm() => FadeInSlideUp(
    delay: const Duration(milliseconds: 400),
    child: Form(
      key: _signInFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _signInEmailController,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signInPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureSignInPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureSignInPassword = !_obscureSignInPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureSignInPassword,
            validator: _validatePassword,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: Text('Forgot Password?', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PremiumButton(text: 'Sign In', onPressed: _signIn, isLoading: _isSignInLoading),
          ),
        ],
      ),
    ),
  );

  Widget _buildSignUpForm() => FadeInSlideUp(
    delay: const Duration(milliseconds: 400),
    child: Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _signUpNameController,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            validator: _validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signUpEmailController,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signUpPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureSignUpPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureSignUpPassword = !_obscureSignUpPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureSignUpPassword,
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signUpConfirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureConfirmPassword,
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PremiumButton(text: 'Sign Up', onPressed: _signUp, isLoading: _isSignUpLoading),
          ),
        ],
      ),
    ),
  );

  Widget _buildSocialButton(String text, IconData icon, Color color, VoidCallback onPressed) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, color: color),
    label: Text(text),
    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
  );

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _signUpPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _signIn() async {
    if (!_signInFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSignInLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSignInLoading = false;
    });

    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _signUp() async {
    if (!_signUpFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSignUpLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSignUpLoading = false;
    });

    if (mounted) {
      context.go('/');
    }
  }

  void _signInWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google Sign In - Coming Soon')));
  }

  void _signInWithLinkedIn() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('LinkedIn Sign In - Coming Soon')));
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset - Coming Soon')));
  }

  void _continueAsGuest() {
    context.go('/');
  }
}
