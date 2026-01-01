import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/core/theme/app_typography.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.isWide ? _buildWideLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Left Side: Visual / Brand
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111418),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA_mRgWyrKHn6R5ytFyG4k-gqblF_CYEX0g8zwFvZRaHJJ5Vh0fJkJeaqHDWXIcDyzE9QA2QpLFhxgLNELoFD8c9b9LabAL4Twsg7k_51RUj5ipm3hTe13Kr_EJiDCO5bTcO_kuvFyy7cTfGINyMFqhQ7Q6dmMSkSRS3tW3Rp5fNJp9-9cidUdG-Mx-p-8txhbngjau9JX-Pt5Of9h4OskDIqBbV0w_JivSysk-_Di4ooeyOxZfvuYCWPqgX7_DUKxuZ3WFnuFI0D4',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.c.primary.withOpacity(0.1),
                    const Color(0xFF101922).withOpacity(0.5),
                    const Color(0xFF101922).withOpacity(0.9),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Icon
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: context.c.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: context.c.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.waves,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Headline
                  Text(
                    'Connect instantly.\nChat seamlessly.',
                    style: AppTypography.displayMedium.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Experience the next generation of communication with Ripple Chat. Secure, fast, and built for connection.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: const Color(0xFF93AEBF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right Side: Login Form
        Expanded(
          child: Container(
            color: context.c.background,
            padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: context.c.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: SafeArea(
        child: Column(
          children: [
            // Mobile Logo
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: context.c.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: SingleChildScrollView(child: _buildLoginForm()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Headline
          Column(
            crossAxisAlignment: context.isWide
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome back to Ripple',
                style: AppTypography.displaySmall.copyWith(
                  color: context.c.textPrimary,
                ),
                textAlign: context.isWide ? TextAlign.start : TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter your details to sign in.',
                style: AppTypography.bodyLarge.copyWith(
                  color: context.c.textSecondary,
                ),
                textAlign: context.isWide ? TextAlign.start : TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Email Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: AppTypography.labelLarge.copyWith(
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: context.c.textSecondary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: AppTypography.labelLarge.copyWith(
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: context.c.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: context.c.textSecondary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Handle forgot password
                context.showSnackBar('Forgot password feature coming soon!');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot password?',
                style: AppTypography.labelLarge.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Login Button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Log In'),
          ),
          const SizedBox(height: 32),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: context.c.border, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Or continue with',
                  style: AppTypography.labelLarge.copyWith(
                    color: context.c.textSecondary,
                  ),
                ),
              ),
              Expanded(child: Divider(color: context.c.border, height: 1)),
            ],
          ),
          const SizedBox(height: 24),

          // Social Login Buttons
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  label: 'Google',
                  icon: _buildGoogleIcon(),
                  onPressed: () {
                    // TODO: Handle Google login
                    context.showSnackBar('Google login coming soon!');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSocialButton(
                  label: 'Apple',
                  icon: _buildAppleIcon(context),
                  onPressed: () {
                    // TODO: Handle Apple login
                    context.showSnackBar('Apple login coming soon!');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sign Up Link
          Center(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodyLarge.copyWith(
                  color: context.c.textSecondary,
                ),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Navigate to sign up
                        context.showSnackBar('Sign up feature coming soon!');
                      },
                      child: Text(
                        'Sign up',
                        style: AppTypography.bodyLarge.copyWith(
                          color: context.c.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: context.c.border),
        backgroundColor: context.c.surface,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: context.c.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: GoogleIconPainter()),
    );
  }

  Widget _buildAppleIcon(BuildContext context) {
    return Icon(Icons.apple, size: 20, color: context.c.textPrimary);
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // TODO: Handle actual login logic
      context.showSnackBar('Login functionality coming soon!');
    }
  }
}

// Custom painter for Google icon
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // This is a simplified Google icon - in production, you'd want to use an SVG
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.4, size.height * 0.4),
      paint,
    );

    paint.color = const Color(0xFFDB4437);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, 0, size.width * 0.4, size.height * 0.4),
      paint,
    );

    paint.color = const Color(0xFFFF0F00);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width * 0.4, size.height * 0.4),
      paint,
    );

    paint.color = const Color(0xFF0F9D58);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.6,
        size.height * 0.6,
        size.width * 0.4,
        size.height * 0.4,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
