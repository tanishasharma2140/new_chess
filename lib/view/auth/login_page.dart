import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/game_bottom_nav.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/view/auth/register.dart';
import 'package:new_chess/view/dashboard_page.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool showOtp = false;

  late AnimationController _animationController;
  late AnimationController _breathingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // Initial entry animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Continuous breathing animation
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.boardBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Logo with breathing effect
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _animationController,
                        _breathingController,
                      ]),
                      builder: (context, child) {
                        // Use breathing only after initial animation completes
                        final breathingScale = _animationController.isCompleted
                            ? _breathingAnimation.value
                            : 1.0;

                        return Transform.scale(
                          scale: _scaleAnimation.value * breathingScale,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        Assets.boardChess,
                        height: 180,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Switch between Login and OTP
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showOtp ? _otpUi() : _loginUi(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGIN UI =================

  Widget _loginUi() {
    return Column(
      key: const ValueKey('login'),
      mainAxisSize: MainAxisSize.min,
      children: [
         TextConst(
           title:
          "Login",
           size: 32,
           color: Colors.white,
           fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 30),

        _inputContainer(
          child: TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: _inputDecoration(
              hint: "Enter mobile number",
              icon: Icons.phone_android,
            ),
          ),
        ),

        const SizedBox(height: 20),

        _primaryButton(
          text: "Get OTP",
          onTap: () {
            if (_mobileController.text.length == 10) {
              setState(() => showOtp = true);
            }
          },
        ),

        const SizedBox(height: 25),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Register(mobileNumber: _mobileController.text),
              ),
            );
          },
          child:  TextConst(
            title:
            "Create Account",
            color: Colors.white,
            size: 16,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ],
    );
  }


  Widget _otpUi() {
    return Column(
      key: const ValueKey('otp'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const TextConst(
          title: "Verify OTP",
          size: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 12),

        TextConst(
          title:
          "+91 ${_mobileController.text}",
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),

        const SizedBox(height: 35),

        Pinput(
          controller: _otpController,
          length: 4,
          defaultPinTheme: PinTheme(
            width: 50,
            height: 56,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white38),
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 50,
            height: 50,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.white.withOpacity(0.15),
            ),
          ),
        ),

        const SizedBox(height: 30),

        _primaryButton(
          text: "Verify",
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context)=> MainRoot()));
          },
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => showOtp = false);
              },
              child: TextConst(
                title:
                "Change Number",
                color: Colors.white.withOpacity(0.9),
                size: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "•",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 15,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                // Resend OTP
              },
              child: TextConst(
                title:
                "Resend OTP",
                color: Colors.white.withOpacity(0.9),
                size: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= Reusable Widgets =================

  Widget _inputContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
        color: Colors.white.withOpacity(0.15),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      counterText: "",
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      icon: Icon(icon, color: Colors.white),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: TextConst(
          title:
          text,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          size: 17,
        ),
      ),
    );
  }
}