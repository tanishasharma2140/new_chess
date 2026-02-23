import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/view_model/services/game_service.dart';
import 'package:provider/provider.dart';

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

           SizedBox(height: 40),

          Image.asset(
            Assets.assetsPawnTwo,
            height: 130,
          ),

           SizedBox(height: 5),

          _buildShimmerTitle(),

           SizedBox(height: 40),

          _playVsComputerButton(),
          _twoPlayersButton(),
          _puzzlesButton(),
        ],
      ),
    );
  }

  Widget _topWoodenHeader() {
    return Container(
      height: Sizes.screenHeight * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsWoodenTile),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// 👤 Profile Golden Circle
                GestureDetector(
                  onTap: () => showProfilePopup(context),
                  child: Image.asset(
                    Assets.assetsGoldCircleProfile,
                    height: Sizes.screenHeight * 0.11,
                    fit: BoxFit.contain,
                  ),
                ),

                /// ⚙️ Red Setting Strip
                Image.asset(
                  Assets.assetsRedSettingStrip,
                  height: Sizes.screenHeight * 0.1,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _playVsComputerButton() {
    return _imageButton(
      text: "PLAY VS COMPUTER",
      imagePath: Assets.assetsGreenBtn,
      onTap: () {
        final gameCon = Provider.of<GameController>(context, listen: false);
        gameCon.initGame(4, context);   // 👈 gameType 4
      },
    );
  }

  Widget _twoPlayersButton() {
    return _imageButton(
      text: "PLAY ONLINE",
      imagePath: Assets.assetsBlueButton,
      onTap: () {
        final gameCon = Provider.of<GameController>(context, listen: false);
        gameCon.initGame(1, context);   // 👈 gameType 1
      },
    );
  }

  Widget _puzzlesButton() {
    return _imageButton(
      text: "PLAY WITH FRIEND",
      imagePath: Assets.assetsBlueButton,
      onTap: () {
        final gameCon = Provider.of<GameController>(context, listen: false);
        gameCon.initGame(3, context);   // 👈 gameType 3
      },
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
            Padding(
              padding:  EdgeInsets.only(top: 5,left: 5,right: 5),
              child: Image.asset(
                imagePath,
                // height: 65,
                fit: BoxFit.contain,
              ),
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




void showProfilePopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => const _ProfilePopup(),
  );
}

class _ProfilePopup extends StatelessWidget {
  const _ProfilePopup();

  static const Map<String, dynamic> _user = {
    'name': 'You',
    'username': '@chess_legend',
    'rating': 1845,
    'rank': 10,
    'winStreak': 5,
    'coins': 4250,
    'level': 14,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsWoodenPopup),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08), // 🔥 light glass effect
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.3), // subtle gold border
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '♟  PROFILE',
                          style: TextStyle(
                            color: Color(0xFFFFE0A0), // soft gold text
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 2,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(
                          //     color: const Color(0xFFFFD700),
                          //     width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700)
                                  .withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            Assets.assetsGoldCircleProfile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _user['name'],
                    style: const TextStyle(
                      color: Color(0xFFFFE0A0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.kanitReg,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _user['username'],
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: FontFamily.kanitReg,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: '⭐',
                          label: 'Rating',
                          value: '${_user['rating']}',
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statCard(
                          icon: '🏅',
                          label: 'Rank',
                          value: '#${_user['rank']}',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statCard(
                          icon: '🪙',
                          label: 'Coins',
                          value: '${_user['coins']}',
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── WIN STREAK ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥',
                            style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextConst(
                              title:
                              '${_user['winStreak']} Win Streak',
                              color: Color(0xFFFFE0A0),
                              fontWeight: FontWeight.bold,
                              size: 14,
                              fontFamily: FontFamily.kanitReg,
                            ),
                             TextConst(
                               title:
                              "You're on fire! 🔥",
                               color: Colors.white38,
                               size: 11,
                               fontFamily: FontFamily.kanitReg,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
        ],
      ),
    );
  }
}