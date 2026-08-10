import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:virtual_gaming_app/providers/auth/auth_provider.dart';
import 'package:virtual_gaming_app/view/home/home_screen.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF03030D),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              _buildBackground(),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCasinoLogo(),

                        const SizedBox(height: 6),

                        const Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Login to continue your winning journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFC1BBCF),
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildPurpleDivider(),

                        const SizedBox(height: 20),

                        _buildLoginCard(authProvider),

                        const SizedBox(height: 22),

                        _buildSignupCard(),

                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF04020E), Color(0xFF080318), Color(0xFF02020A)],
            ),
          ),
        ),

        Positioned(top: 100, left: -100, child: _purpleGlow(230)),

        Positioned(top: 260, right: -120, child: _purpleGlow(260)),

        Positioned(bottom: 180, left: -100, child: _purpleGlow(230)),

        Positioned(
          top: 190,
          left: 20,
          child: _backgroundCasinoIcon(Icons.casino_rounded, -0.35),
        ),

        Positioned(
          top: 285,
          right: 12,
          child: _backgroundCasinoIcon(Icons.casino_rounded, 0.3),
        ),

        Positioned(
          top: 90,
          right: 30,
          child: _backgroundCasinoIcon(Icons.circle, 0.2),
        ),
      ],
    );
  }

  Widget _purpleGlow(double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF6D16FF).withOpacity(0.16),
              const Color(0xFF6D16FF).withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _backgroundCasinoIcon(IconData icon, double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Opacity(
        opacity: 0.07,
        child: Icon(icon, size: 100, color: const Color(0xFF9A35FF)),
      ),
    );
  }

  Widget _buildCasinoLogo() {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer neon plate.
          Container(
            width: 300,
            height: 165,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              border: Border.all(color: const Color(0xFFB63CFF), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C2DFF).withOpacity(0.65),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),

          // Inner plate.
          Container(
            width: 292,
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              gradient: const LinearGradient(
                colors: [Color(0xFF15072D), Color(0xFF05040D)],
              ),
              border: Border.all(color: const Color(0xFFFFB72C), width: 1.2),
            ),
          ),

          // Virtual.
          const Positioned(
            top: 82,
            child: Text(
              'VIRTUAL',
              style: TextStyle(
                color: Color(0xFFF9F5FF),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),

          // Casino.
          const Positioned(
            top: 103,
            child: Text(
              'CASINO',
              style: TextStyle(
                color: Color(0xFFFFD34D),
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                shadows: [Shadow(color: Color(0xFFFF8C00), blurRadius: 15)],
              ),
            ),
          ),

          // Spade.

          // Left purple dice.
          Positioned(
            left: 38,
            bottom: 26,
            child: Transform.rotate(
              angle: -0.25,
              child: const Icon(
                Icons.casino_rounded,
                size: 62,
                color: Color(0xFF7130E8),
                shadows: [Shadow(color: Color(0xFF982DFF), blurRadius: 18)],
              ),
            ),
          ),

          // Right red dice.
          Positioned(
            right: 38,
            bottom: 25,
            child: Transform.rotate(
              angle: 0.22,
              child: const Icon(
                Icons.casino_rounded,
                size: 62,
                color: Color(0xFFE53A54),
                shadows: [Shadow(color: Color(0xFFFF3155), blurRadius: 18)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurpleDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0xFFB235FF)],
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.diamond, size: 11, color: Color(0xFFD34BFF)),
        ),

        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB235FF), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLoginCard(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF070612).withOpacity(0.94),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFF6A25A4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A20FF).withOpacity(0.08),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildEmailField(),

          const SizedBox(height: 30),

          const Text(
            'Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildPasswordField(),

          const SizedBox(height: 12),

          if (authProvider.errorMessage != null) ...[
            const SizedBox(height: 5),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFF390B19),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF8C263D)),
              ),
              child: Text(
                authProvider.errorMessage!,
                style: const TextStyle(color: Color(0xFFFF6179), fontSize: 13),
              ),
            ),
          ],

          const SizedBox(height: 12),

          _buildLoginButton(authProvider),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white, fontSize: 17),
      cursorColor: const Color(0xFFA632FF),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }

        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }

        return null;
      },
      decoration: _inputDecoration(
        hint: 'Enter your email',
        icon: Icons.mail_outline_rounded,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white, fontSize: 17),
      cursorColor: const Color(0xFFA632FF),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        return null;
      },
      decoration: _inputDecoration(
        hint: 'Enter your password',
        icon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFFC1BBD0),
            size: 26,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9690A7), fontSize: 17),
      prefixIcon: Icon(icon, color: const Color(0xFFA43BFF), size: 27),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF060610),
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFF3D3155), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFF9B2FFF), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFFF3E5E)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFFF3E5E)),
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return GestureDetector(
      onTap: authProvider.isLoading ? null : _login,
      child: Container(
        width: double.infinity,
        height: 67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6318EF), Color(0xFFB72CFF)],
          ),
          border: Border.all(color: const Color(0xFFC64CFF)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9A20FF).withOpacity(0.4),
              blurRadius: 22,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: authProvider.isLoading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 55),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 31,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSignupCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          color: const Color(0xFF080711),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF4C196F)),
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF16072C),
                border: Border.all(color: const Color(0xFFD43DFF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC029FF).withOpacity(0.4),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFFE65AFF),
                size: 38,
              ),
            ),

            const SizedBox(width: 20),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Create a new account',
                    style: TextStyle(color: Color(0xFFB8B1C5), fontSize: 16),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFA93CFF),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
