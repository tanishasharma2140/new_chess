import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/text_const.dart';

class Register extends StatefulWidget {
  final String mobileNumber;
  const Register({super.key, required this.mobileNumber});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  late AnimationController _entryController;
  late AnimationController _breathingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // Set mobile number from widget
    _mobileController.text = widget.mobileNumber;

    // Initial entry animation
    _entryController = AnimationController(
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
    ]).animate(_entryController);

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
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

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _breathingController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
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
                        _entryController,
                        _breathingController,
                      ]),
                      builder: (context, child) {
                        final breathingScale = _entryController.isCompleted
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

                    // Register UI
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         TextConst(
                           title:
                          "Create Account",
                           size: 32,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 30),

                        // Name Input
                        _inputContainer(
                          child: TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: _inputDecoration(
                              hint: "Enter your name",
                              icon: Icons.person_outline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Mobile Number Input (Read Only)
                        _inputContainer(
                          child: TextField(
                            controller: _mobileController,
                            readOnly: true,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            decoration: _inputDecoration(
                              hint: "Mobile number",
                              icon: Icons.phone_android,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _primaryButton(
                          text: "Register",
                          onTap: () {
                            if (_nameController.text.isNotEmpty) {
                              // Handle registration
                            }
                          },
                        ),

                        const SizedBox(height: 25),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:  TextConst(
                            title:
                            "Already have an account? Login",
                            color: Colors.white,
                            size: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
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
        )],

      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    ),
    );
  }
}