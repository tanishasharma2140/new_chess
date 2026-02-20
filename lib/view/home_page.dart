import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shimmerAnim =
        Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildShimmerTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, __) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(_shimmerAnim.value - 1, 0),
          end: Alignment(_shimmerAnim.value + 1, 0),
          colors: const [
            Color(0xFFB0BEC5),  // soft grey
            Colors.white,       // bright shine
            Color(0xFFECEFF1),  // light white
            Colors.white,       // shine
            Color(0xFFB0BEC5),  // soft grey
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ).createShader(bounds),
        child: const Text(
          "CHOOSE YOUR MODE",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: FontFamily.kanitReg,
            color: Colors.white,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsBlueGradientBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [

          _topWoodenHeader(),

          const SizedBox(height: 40),

          Image.asset(
            Assets.assetsPawnTwo,
            height: 130,
          ),

          const SizedBox(height: 5),

          /// 🔥 Golden Animated Title
          _buildShimmerTitle(),

          const SizedBox(height: 40),

          _playVsComputerButton(),
          _twoPlayersButton(),
          _puzzlesButton(),
        ],
      ),
    );
  }

  Widget _topWoodenHeader() {
    return SizedBox(
      height: Sizes.screenHeight * 0.15,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [

          Positioned.fill(
            child: Image.asset(
              Assets.assetsWoodenTile,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            left: 20,
            top: 10,
            bottom: 0,
            child: Center(
              child: Image.asset(
                // Assets.assetsGoldenCircle,
                Assets.assetsGoldCircleProfile,
                height: Sizes.screenHeight * 0.11,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(
            right: 20,
            top: 10,
            bottom: 0,
            child: Center(
              child: Image.asset(
                Assets.assetsRedSettingStrip,
                height: Sizes.screenHeight * 0.11,
                fit: BoxFit.contain,
              ),
            ),
          ),

        ],
      ),
    );
  }  Widget _playVsComputerButton() {
    return _imageButton(
      text: "PLAY VS COMPUTER",
      imagePath: Assets.assetsGreenButton,
      onTap: () {},
    );
  }

  Widget _twoPlayersButton() {
    return _imageButton(
      text: "PLAY ONLINE",
      imagePath: Assets.assetsBlueButton,
      onTap: () {},
    );
  }

  Widget _puzzlesButton() {
    return _imageButton(
      text: "PLAY WITH FRIEND",
      imagePath: Assets.assetsBlueButton,
      onTap: () {},
    );
  }

  Widget _imageButton({
    required String text,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 65,
              fit: BoxFit.contain,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}