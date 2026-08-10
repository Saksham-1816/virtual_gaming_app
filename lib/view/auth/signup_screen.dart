import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:virtual_gaming_app/providers/auth/auth_provider.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
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
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 6),

                        _buildCasinoLogo(),

                        const SizedBox(height: 18),

                        _buildSignupCard(authProvider),

                       
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
              colors: [
                Color(0xFF04020E),
                Color(0xFF080318),
                Color(0xFF02020A),
              ],
            ),
          ),
        ),

        Positioned(
          top: 100,
          left: -110,
          child: _glow(240),
        ),

        Positioned(
          top: 300,
          right: -120,
          child: _glow(260),
        ),

        Positioned(
          bottom: 200,
          left: -100,
          child: _glow(230),
        ),

        Positioned(
          top: 210,
          left: 20,
          child: _backgroundDice(
            -0.3,
          ),
        ),

        Positioned(
          top: 270,
          right: 12,
          child: _backgroundDice(
            0.25,
          ),
        ),

        Positioned(
          top: 120,
          right: 30,
          child: Opacity(
            opacity: 0.08,
            child: Icon(
              Icons.casino_rounded,
              size: 90,
              color: const Color(0xFF9C38FF),
            ),
          ),
        ),
      ],
    );
  }

  Widget _glow(double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF741DFF).withOpacity(0.15),
              const Color(0xFF741DFF).withOpacity(0.03),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _backgroundDice(double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Opacity(
        opacity: 0.07,
        child: const Icon(
          Icons.casino_rounded,
          size: 100,
          color: Color(0xFFA63AFF),
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return SizedBox(
      height: 76,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 3),

              Text(
                'Join now and start your winning journey!',
                style: TextStyle(
                  color: Color(0xFFB9B3C9),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCasinoLogo() {
    return SizedBox(
      height: 255,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 315,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              border: Border.all(
                color: const Color(0xFFB53DFF),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9A2EFF)
                      .withOpacity(0.65),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),

          Container(
            width: 292,
            height: 153,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF16082F),
                  Color(0xFF05040D),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFFB72C),
                width: 1.2,
              ),
            ),
          ),
const Positioned(
            top: 86,
            child: Text(
              'VIRTUAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),

          const Positioned(
            top: 108,
            child: Text(
              'CASINO',
              style: TextStyle(
                color: Color(0xFFFFD34D),
                fontSize: 40,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: Color(0xFFFF8C00),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 38,
            bottom: 25,
            child: Transform.rotate(
              angle: -0.25,
              child: const Icon(
                Icons.casino_rounded,
                size: 62,
                color: Color(0xFF7130E8),
                shadows: [
                  Shadow(
                    color: Color(0xFF982DFF),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 38,
            bottom: 25,
            child: Transform.rotate(
              angle: 0.22,
              child: const Icon(
                Icons.casino_rounded,
                size: 62,
                color: Color(0xFFE53A54),
                shadows: [
                  Shadow(
                    color: Color(0xFFFF3155),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSignupCard(
    AuthProvider authProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        28,
        22,
        25,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF070612).withOpacity(0.94),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: const Color(0xFF54217C),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A20FF)
                .withOpacity(0.08),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNameField(),

          const SizedBox(height: 22),

          _buildEmailField(),

          const SizedBox(height: 22),

          _buildPasswordField(),

          const SizedBox(height: 22),

          _buildConfirmPasswordField(),

          if (authProvider.errorMessage != null) ...[
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFF390B19),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF8C263D),
                ),
              ),
              child: Text(
                authProvider.errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFFF6179),
                  fontSize: 13,
                ),
              ),
            ),
          ],

          const SizedBox(height: 25),

          _buildCreateButton(authProvider),

          const SizedBox(height: 25),

          _buildOrDivider(),

          const SizedBox(height: 24),

          _buildLoginText(),
        ],
      ),
    );
  }
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      style: _fieldTextStyle(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
        }

        return null;
      },
      decoration: _inputDecoration(
        hint: 'Name',
        icon: Icons.person_outline_rounded,
      ),
    );
  }

  // ============================================================
  // EMAIL
  // ============================================================

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: _fieldTextStyle(),
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
        hint: 'Email',
        icon: Icons.mail_outline_rounded,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      style: _fieldTextStyle(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }

        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
      decoration: _inputDecoration(
        hint: 'Password',
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
            color: const Color(0xFFC3BDCF),
            size: 26,
          ),
        ),
      ),
    );
  }
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      style: _fieldTextStyle(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }

        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },
      decoration: _inputDecoration(
        hint: 'Confirm Password',
        icon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureConfirmPassword =
                  !_obscureConfirmPassword;
            });
          },
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFFC3BDCF),
            size: 26,
          ),
        ),
      ),
    );
  }

  TextStyle _fieldTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 17,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9690A7),
        fontSize: 17,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFA43BFF),
        size: 27,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF060610),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFF3D3155),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFF9B2FFF),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFFFF3E5E),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFFFF3E5E),
        ),
      ),
    );
  }
  Widget _buildCreateButton(
    AuthProvider authProvider,
  ) {
    return GestureDetector(
      onTap: authProvider.isLoading
          ? null
          : _signup,
      child: Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6419EF),
              Color(0xFFB72CFF),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFC64CFF),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9A20FF)
                  .withOpacity(0.4),
              blurRadius: 22,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: authProvider.isLoading
              ? const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 35),
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
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF30293D),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFFA7A0B5),
              fontSize: 17,
            ),
          ),
        ),

        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF30293D),
          ),
        ),
      ],
    );
  }
  Widget _buildLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            color: Color(0xFFBDB6C8),
            fontSize: 16,
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Color(0xFFA63AFF),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}