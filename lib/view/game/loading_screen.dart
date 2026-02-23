import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/player_searching_animation.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view_model/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  final String? roomId;
  const LoadingScreen({super.key, this.roomId});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final AnimationController _dotsCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1200),
  )..repeat();

  late final Animation<double> _glowAnim =
  Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

  late final Animation<double> _pulseAnim =
  Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  static const _gold = Color(0xFFFFD700);
  static const _blue = Color(0xFF1E88E5);

  @override
  void dispose() {
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GameController>(context);
    return Scaffold(
      body: Stack(children: [
        // ✅ Original board background (chess teal wala)
        Positioned.fill(
          child: Image.asset(Assets.assetsBlueGradientBg, fit: BoxFit.cover),
        ),

        // Soft glow orbs (subtle, no giant ring)
        _orb(top: -40, left: -40, color: _gold, size: 160),
        _orb(bottom: 40, right: -40, color: _blue, size: 150),

        // Main content
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Logo
              Image.asset(Assets.assetsChessClashLogo,
                  width: 130, height: 130, fit: BoxFit.contain),

              const SizedBox(height: 4),

              // Title
              const Text('FINDING OPPONENT', style: TextStyle(
                color: _gold, fontSize: 11, letterSpacing: 4,
                fontWeight: FontWeight.bold, fontFamily: FontFamily.kanitReg,
              )),

              const Spacer(),

              // Duel Arena
              _duelArena(),

              const Spacer(),

              // Divider
              _swordDivider(),

              const Spacer(),

              // Player searching animation (original)
              const PlayerSearchingAnimation(),

              const SizedBox(height: 18),

              // Status
              _statusRow(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ]),
    );
  }

  // ── GLOW ORB (subtle) ────────────────────────────────────────────────────────
  Widget _orb({double? top, double? bottom, double? left, double? right,
    required Color color, required double size}) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Positioned(
        top: top, bottom: bottom, left: left, right: right,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              color.withOpacity(0.15 * _glowAnim.value),
              color.withOpacity(0),
            ]),
          ),
        ),
      ),
    );
  }

  // ── DUEL ARENA ───────────────────────────────────────────────────────────────
  Widget _duelArena() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _playerCard(piece: '♔', label: 'YOU', color: _gold, isFound: true),
          _centerVsBadge(),
          _playerCard(piece: '♚', label: 'OPPONENT', color: _blue, isFound: false),
        ],
      ),
    );
  }

  Widget _playerCard({
    required String piece,
    required String label,
    required Color color,
    required bool isFound,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Transform.scale(
        scale: isFound ? 1.0 : _pulseAnim.value,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Avatar
          Container(
            width: 78, height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.06)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              border: Border.all(color: color.withOpacity(0.8), width: 2.2),
              boxShadow: [BoxShadow(
                color: color.withOpacity(0.4 * _glowAnim.value),
                blurRadius: 18, spreadRadius: 2,
              )],
            ),
            child: isFound
                ? ClipOval(child: Image.asset(Assets.iconsProfile, fit: BoxFit.cover))
                : Center(child: Text('?', style: TextStyle(
                color: color.withOpacity(0.65), fontSize: 32,
                fontWeight: FontWeight.bold, fontFamily: FontFamily.kanitReg))),
          ),

          const SizedBox(height: 8),

          Text(piece, style: TextStyle(fontSize: 28, color: color)),
          const SizedBox(height: 3),

          Text(label, style: TextStyle(
            color: color, fontSize: 10, letterSpacing: 2,
            fontWeight: FontWeight.bold, fontFamily: FontFamily.kanitReg,
          )),

          const SizedBox(height: 6),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isFound
                  ? Colors.green.withOpacity(0.18)
                  : Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFound
                    ? Colors.greenAccent.withOpacity(0.55)
                    : Colors.orange.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFound ? Colors.greenAccent : Colors.orange,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                isFound ? 'READY' : 'SEARCHING',
                style: TextStyle(
                  color: isFound ? Colors.greenAccent : Colors.orange,
                  fontSize: 8, letterSpacing: 1.2,
                  fontWeight: FontWeight.bold, fontFamily: FontFamily.kanitReg,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _centerVsBadge() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Container(
        width: 54, height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(
            color: _gold.withOpacity(0.55 * _glowAnim.value),
            blurRadius: 22, spreadRadius: 3,
          )],
        ),
        child: const Center(child: Text('VS', style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
          fontFamily: FontFamily.kanitReg, letterSpacing: 1,
        ))),
      ),
    );
  }

  // ── SWORD DIVIDER ────────────────────────────────────────────────────────────
  Widget _swordDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, __) => Container(
            height: 1,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [
              Colors.transparent,
              _gold.withOpacity(0.45 * _glowAnim.value),
            ])),
          ),
        )),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: const Text('⚔️  DUEL ARENA', style: TextStyle(
            color: Colors.white60, fontSize: 10,
            letterSpacing: 2, fontFamily: FontFamily.kanitReg,
          )),
        ),
        Expanded(child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, __) => Container(
            height: 1,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [
              _blue.withOpacity(0.45 * _glowAnim.value),
              Colors.transparent,
            ])),
          ),
        )),
      ]),
    );
  }

  // ── STATUS ROW ───────────────────────────────────────────────────────────────
  Widget _statusRow() {
    return Column(children: [
      AnimatedBuilder(
        animation: _dotsCtrl,
        builder: (_, __) {
          final dots = (_dotsCtrl.value * 4).floor() % 4;
          return Text(
            'Searching for opponent${'.' * dots}',
            style: const TextStyle(
              color: Colors.white60, fontSize: 13,
              fontFamily: FontFamily.kanitReg,
              fontStyle: FontStyle.italic, letterSpacing: 0.5,
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      Container(
        width: Sizes.screenWidth * 0.55,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedBuilder(
          animation: _dotsCtrl,
          builder: (_, __) {
            final progress = (_dotsCtrl.value + 0.5) % 1.0;
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFF1E88E5)]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}