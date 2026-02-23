import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class LevelSelectionPage extends StatefulWidget {
  const LevelSelectionPage({super.key});

  @override
  State<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _glowAnim =
  Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

  int? _pressed;

  final _levels = const [
    _Level('EASY',   '♟', 'Beginner Friendly',  1, Color(0xFF00C853), Color(0xFF69F0AE), RoutesName.offlineGameBoard),
    _Level('MEDIUM', '♞', 'Tactical Challenge',  2, Color(0xFFFF8F00), Color(0xFFFFCA28), RoutesName.mediumOffline),
    _Level('HARD',   '♛', 'Master Level',        3, Color(0xFFB71C1C), Color(0xFFFF5252), RoutesName.hardOffline),
  ];

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // ── Blue gradient background (same as LeaderBoard) ──
        Positioned.fill(
          child: Image.asset(Assets.assetsBlueGradientBg, fit: BoxFit.fill),
        ),

        // ── Back button top-left ──
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ),

        // ── Centered wooden panel ──
        Center(
          child: _buildWoodenPanel(),
        ),
      ]),
    );
  }

  Widget _buildWoodenPanel() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Container(
        width: Sizes.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Gold border glow (like the image)
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.7 + 0.3 * _glowAnim.value),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.3 * _glowAnim.value),
              blurRadius: 24, spreadRadius: 4,
            ),
            const BoxShadow(
              color: Colors.black54, blurRadius: 20, offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(children: [
            // Wooden texture background image
            Positioned.fill(
              child: Image.asset(
                Assets.assetsWoodenTile,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay for readability
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Text(
                    'Difficulty Level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.kanitReg,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(2, 2)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    'Choose your battle mode',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                      fontFamily: FontFamily.kanitReg,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Wooden divider line (like in image)
                  _woodenDivider(),

                  const SizedBox(height: 22),

                  // Level buttons
                  ...List.generate(_levels.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _levelButton(_levels[i], i),
                  )),

                  const SizedBox(height: 8),

                  // Bottom stats bar (like in image)
                  _bottomStatsBar(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _woodenDivider() {
    return Row(children: [
      Expanded(child: Container(
        height: 1.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            const Color(0xFFFFD700).withOpacity(0.5),
            Colors.transparent,
          ]),
        ),
      )),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: const Text('⚔️', style: TextStyle(fontSize: 16)),
      ),
      Expanded(child: Container(
        height: 1.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            const Color(0xFFFFD700).withOpacity(0.5),
            Colors.transparent,
          ]),
        ),
      )),
    ]);
  }

  Widget _levelButton(_Level lvl, int i) {
    final isPressed = _pressed == i;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = i),
      onTapUp: (_) {
        setState(() => _pressed = null);
        Navigator.pushNamed(context, lvl.route);
      },
      onTapCancel: () => setState(() => _pressed = null),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          transform: Matrix4.identity()..scale(isPressed ? 0.96 : 1.0),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lvl.color1.withOpacity(isPressed ? 0.55 : 0.28),
                lvl.color2.withOpacity(isPressed ? 0.3 : 0.12),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: lvl.color1.withOpacity(isPressed ? 1.0 : 0.55 * _glowAnim.value),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: lvl.color1.withOpacity(isPressed ? 0.5 : 0.2 * _glowAnim.value),
                blurRadius: 14, offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(children: [
            // Piece circle
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [lvl.color1, lvl.color2],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(
                  color: lvl.color1.withOpacity(0.5 * _glowAnim.value),
                  blurRadius: 10,
                )],
              ),
              child: Center(child: Text(lvl.piece,
                  style: const TextStyle(fontSize: 20, color: Colors.white))),
            ),

            const SizedBox(width: 14),

            // Label + subtitle
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lvl.label, style: TextStyle(
                  color: lvl.color1, fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg, letterSpacing: 1.5,
                )),
                Text(lvl.subtitle, style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11, fontFamily: FontFamily.kanitReg,
                )),
              ],
            )),

            // Stars
            Row(children: List.generate(3, (s) => Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(Icons.star_rounded, size: 14,
                  color: s < lvl.stars
                      ? lvl.color1
                      : Colors.white.withOpacity(0.15)),
            ))),

            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                color: lvl.color1.withOpacity(0.7), size: 14),
          ]),
        ),
      ),
    );
  }

  // Bottom stats bar (like in the reference image)
  Widget _bottomStatsBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('Games Won', '0', const Color(0xFF00C853)),
          _statDivider(),
          _stat('Drawn', '0', Colors.white54),
          _statDivider(),
          _stat('Lost', '0', const Color(0xFFFF5252)),
          _statDivider(),
          _stat('Win Rate', '0%', const Color(0xFFFFD700)),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(
        color: color, fontSize: 16, fontWeight: FontWeight.bold,
        fontFamily: FontFamily.kanitReg,
      )),
      Text(label, style: const TextStyle(
        color: Colors.white38, fontSize: 9,
        fontFamily: FontFamily.kanitReg, letterSpacing: 0.5,
      )),
    ]);
  }

  Widget _statDivider() => Container(
    width: 1, height: 28,
    color: Colors.white.withOpacity(0.12),
  );
}

class _Level {
  final String label, piece, subtitle, route;
  final int stars;
  final Color color1, color2;
  const _Level(this.label, this.piece, this.subtitle, this.stars,
      this.color1, this.color2, this.route);
}
