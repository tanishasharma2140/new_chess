import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view/auth/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin  {

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _shimmerAnim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ♟ Chess Image
              Image.asset(
                Assets.assetsPawnTwo,
                height: 130,
              ),

              const SizedBox(height: 5),

              _buildShimmerTitle(),

              const SizedBox(height: 25),

              // GOLD BORDER IMAGE
              _buildCard(),

              // const SizedBox(height: 35),

              // const Text(
              //   "New here? Create an account",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: Sizes.screenWidth *0.86,
      height: Sizes.screenHeight*0.3,
      decoration: BoxDecoration(
        color: const Color(0x1A0F0A03), // rgba(15,10,3,0.65) approx
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0B25C), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0B25C).withOpacity(0.08),
            blurRadius: 1,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFFE0B25C).withOpacity(0.06),
            blurRadius: 4,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: const Color(0xFFE0B25C).withOpacity(0.12),
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Dark glass inner fill
            Positioned.fill(
              child: Container(
                color: const Color(0xFF3E1F0C).withOpacity(0.25)
              ),
            ),

            // Inner inset shadow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: RadialGradient(
                    colors: [
                      Colors.transparent,
                    Color(0xFF5A2E10).withOpacity(0.75),
                    ],
                    radius: 1.2,
                  ),
                ),
              ),
            ),

            // Corner ornaments ✦
            ..._corners(),

            // Card content
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Top ornate gold line
                  _ornateLine(),

                  const SizedBox(height: 20),

                  // Phone field
                  _buildPhoneField(),

                  const SizedBox(height: 22),

                  // Login button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> OtpPage(phoneNumber: "9876543210")));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        Image.asset(
                          Assets.assetsBlueButton,
                          height: 55,
                          fit: BoxFit.contain,
                        ),

                        const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom ornate gold line
                  _ornateLine(bottom: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, __) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(_shimmerAnim.value - 1, 0),
          end: Alignment(_shimmerAnim.value + 1, 0),
          colors: const [
            Color(0xFFD4900A),
            Color(0xFFFFE082),
            Color(0xFFf5c26b),
            Color(0xFFFFE082),
            Color(0xFFD4900A),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ).createShader(bounds),
        child: const Text(
          'CHESS LOGIN',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
            color: Colors.white,
            fontFamily: FontFamily.kanitReg,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(2, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Corner ✦ ornaments
  List<Widget> _corners() {
    const style = TextStyle(
      color: Color(0xFFE0B25C),
      fontSize: 18,
      height: 1,
    );
    return [
      Positioned(top: 10, left: 14, child: Text('✦', style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(top: 10, right: 14, child: Text('✦', style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(bottom: 10, left: 14, child: Text('✦', style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(bottom: 10, right: 14, child: Text('✦', style: style.copyWith(color: const Color(0xB3E0B25C)))),
    ];
  }

  // Ornate gradient line (top/bottom dividers)
  Widget _ornateLine({bool bottom = false}) {
    return Container(
      margin: EdgeInsets.only(
        top: bottom ? 20 : 0,
        bottom: bottom ? 0 : 0,
      ),
      width: double.infinity,
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFE0B25C),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // Phone number input field
  Widget _buildPhoneField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0B25C),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [

          // 🇮🇳 Flag (thoda chhota)
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.asset(
              Assets.assetsIndFlag,
              height: 18,   // 👈 height kam
              width: 24,    // 👈 width kam
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 4),  // 👈 spacing kam

          // +91 (thoda compact)
          const Text(
            '+91',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,   // 👈 font thoda kam
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 6), // 👈 spacing kam

          // Divider (thoda chhota)
          Container(
            width: 1,
            height: 18,   // 👈 height kam
            color: const Color(0xFFE0B25C),
          ),

          const SizedBox(width: 6), // 👈 spacing kam

          // 📱 TextField ko zyada jagah
          Expanded(
            flex: 3,   // 👈 ye important hai
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              cursorColor: const Color(0xFFE0B25C),
              decoration: const InputDecoration(
                hintText: 'Enter your mobile number',
                hintStyle: TextStyle(
                  color: Color(0x73FFFFFF),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      )
    );
  }

}