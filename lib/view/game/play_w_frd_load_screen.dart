import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/launcher.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:new_chess/view_model/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PlayWFrdLoadScreen extends StatefulWidget {
  const PlayWFrdLoadScreen({super.key});
  @override
  State<PlayWFrdLoadScreen> createState() => _PlayWFrdLoadScreenState();
}

class _PlayWFrdLoadScreenState extends State<PlayWFrdLoadScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 2800),
  )..repeat(reverse: true);
  late final AnimationController _glowCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  late final Animation<double> _floatAnim =
  Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  late final Animation<double> _glowAnim =
  Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

  int _mode = 0; // 0 = Create, 1 = Join
  final _focusNode = FocusNode();

  static const _gold = Color(0xFFFFD700);
  static const _blue = Color(0xFF42A5F5);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gc = Provider.of<GameController>(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Positioned.fill(
            child: Image.asset(Assets.assetsBlueGradientBg, fit: BoxFit.cover),
          ),
          _glowOrb(top: -60, left: -60, color: _gold, size: 200),
          _glowOrb(top: 120, right: -80, color: const Color(0xFF1565C0), size: 180),
          _glowOrb(bottom: 80, left: -40, color: const Color(0xFF1E3A5F), size: 160),
          Column(children: [
            _header(),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    const SizedBox(height: 20),
                    _floatingPiece(),
                    const SizedBox(height: 22),
                    _vsRow(),
                    const SizedBox(height: 24),
                    _modeSelector(gc),
                    const SizedBox(height: 22),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08), end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: _mode == 0 ? _createPanel(gc) : _joinPanel(gc),
                    ),
                    const SizedBox(height: 24),
                    _nextButton(gc),
                    const SizedBox(height: 28),
                  ]),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────────

  Widget _glowOrb({double? top, double? bottom, double? left, double? right,
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
              color.withOpacity(0.18 * _glowAnim.value),
              color.withOpacity(0),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _header() => Container(
    height: Sizes.screenHeight * 0.13,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(Assets.assetsWoodenTile), fit: BoxFit.cover),
    ),
    child: Stack(alignment: Alignment.center, children: [
      Positioned(
        left: 10,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(Assets.assetsGoldBackButton, height: 35),
        ),
      ),
      const Text('PLAY WITH FRIEND', style: TextStyle(
        fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: 2,
        fontFamily: FontFamily.kanitReg, color: Colors.white,
        shadows: [Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(2, 2))],
      )),
    ]),
  );

  Widget _floatingPiece() => AnimatedBuilder(
    animation: _floatAnim,
    builder: (_, __) => Transform.translate(
      offset: Offset(0, _floatAnim.value),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => Stack(alignment: Alignment.center, children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(
                color: _gold.withOpacity(0.35 * _glowAnim.value),
                blurRadius: 40, spreadRadius: 10,
              )],
            ),
          ),
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A6E), Color(0xFF0D1E3A)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              border: Border.all(color: _gold.withOpacity(0.7), width: 2),
            ),
            child: Center(child: Text('♛', style: TextStyle(fontSize: 46, color: ChessColor.white))),
          ),
        ]),
      ),
    ),
  );

  Widget _vsRow() => Row(children: [
    _vsPlayer('♙', 'YOU'),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_gold, Color(0xFFFFA000)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: _gold.withOpacity(0.4), blurRadius: 12)],
      ),
      child: const Text('VS', style: TextStyle(
        color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold,
        fontFamily: FontFamily.kanitReg, letterSpacing: 3,
      )),
    ),
    _vsPlayer('♟', 'FRIEND'),
  ]);

  Widget _vsPlayer(String piece, String label) => Expanded(
    child: Column(children: [
      Text(piece, style: const TextStyle(fontSize: 28, color: Colors.white70)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(
        color: Colors.white.withOpacity(0.5), fontSize: 10,
        fontFamily: FontFamily.kanitReg, letterSpacing: 2,
      )),
    ]),
  );

  Widget _modeSelector(GameController gc) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: Colors.white.withOpacity(0.12)),
    ),
    child: Row(children: [
      _modeTab(0, Icons.add_circle_outline_rounded, 'Create Room', gc),
      _modeTab(1, Icons.login_rounded, 'Join Room', gc),
    ]),
  );

  Widget _modeTab(int idx, IconData icon, String label, GameController gc) {
    final sel = _mode == idx;
    final color = idx == 0 ? _gold : _blue;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _mode = idx;
          gc.isReadOnly = (idx == 0);
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            gradient: sel ? LinearGradient(
              colors: idx == 0
                  ? [_gold, const Color(0xFFFFA000)]
                  : [const Color(0xFF1E88E5), const Color(0xFF0D47A1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ) : null,
            borderRadius: BorderRadius.circular(44),
            boxShadow: sel ? [BoxShadow(
              color: color.withOpacity(0.45), blurRadius: 12, offset: const Offset(0, 3),
            )] : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 16, color: sel ? Colors.white : Colors.white38),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(
              color: sel ? Colors.white : Colors.white38,
              fontSize: 13, fontWeight: FontWeight.bold,
              fontFamily: FontFamily.kanitReg, letterSpacing: 0.5,
            )),
          ]),
        ),
      ),
    );
  }

  Widget _createPanel(GameController gc) => _PanelCard(
    key: const ValueKey('create'),
    accent: _gold, dim: const Color(0xFF2A1F00),
    child: Column(children: [
      _stepRow(['Create Room', 'Share Code', 'Start Game'],
          gc.codeController.text.isNotEmpty ? 1 : 0, _gold),
      const SizedBox(height: 18),
      // Generate button
      GestureDetector(
        onTap: () async {
          await gc.createGameRoom(context);
          gc.isReadOnly = true;
          setState(() {});
        },
        child: _gradBtn(
          gradient: const LinearGradient(colors: [_gold, Color(0xFFFFA000)]),
          glow: _gold,
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('GENERATE ROOM CODE', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold,
              fontSize: 13, letterSpacing: 1.2, fontFamily: FontFamily.kanitReg,
            )),
          ]),
        ),
      ),
      if (gc.codeController.text.isNotEmpty) ...[
        const SizedBox(height: 16),
        // Code display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black38, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _gold.withOpacity(0.5), width: 1.5),
          ),
          child: Row(children: [
            Expanded(child: Text(gc.codeController.text, textAlign: TextAlign.center,
              style: const TextStyle(color: _gold, fontSize: 17, fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg, letterSpacing: 4),
            )),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: gc.codeController.text));
                Utils.show("Copied!", context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.copy_rounded, color: _gold, size: 18),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        // Share button
        GestureDetector(
          onTap: () => Launcher.shareApk(gc.codeController.text, context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.1), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _gold.withOpacity(0.35), width: 1.2),
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.share_rounded, color: _gold, size: 18),
              SizedBox(width: 8),
              Text('Share with Friend', style: TextStyle(
                color: _gold, fontSize: 13, fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg, letterSpacing: 0.8,
              )),
            ]),
          ),
        ),
      ],
    ]),
  );

  Widget _joinPanel(GameController gc) => _PanelCard(
    key: const ValueKey('join'),
    accent: _blue, dim: const Color(0xFF001433),
    child: Column(children: [
      _stepRow(['Get Code', 'Enter Code', 'Join Game'],
          gc.codeController.text.isNotEmpty ? 1 : 0, _blue),
      const SizedBox(height: 18),
      Container(
        decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focusNode.hasFocus ? _blue : _blue.withOpacity(0.3),
            width: _focusNode.hasFocus ? 2 : 1.2,
          ),
          boxShadow: _focusNode.hasFocus
              ? [BoxShadow(color: _blue.withOpacity(0.25), blurRadius: 16)]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: TextField(
          controller: gc.codeController,
          focusNode: _focusNode,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          cursorColor: _blue,
          style: const TextStyle(
            color: Color(0xFF64B5F6), fontSize: 22, fontWeight: FontWeight.bold,
            fontFamily: FontFamily.kanitReg, letterSpacing: 5,
          ),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'ROOM-XXXX',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2),
                fontSize: 16, letterSpacing: 4, fontFamily: FontFamily.kanitReg),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            suffixIcon: gc.codeController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear_rounded, color: _blue, size: 18),
              onPressed: () { gc.codeController.clear(); setState(() {}); },
            )
                : null,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.info_outline_rounded, color: Colors.blue.shade200, size: 14),
        const SizedBox(width: 6),
        const Text('Ask your friend to share their Room Code', style: TextStyle(
          color: Colors.white38, fontSize: 11, fontFamily: FontFamily.kanitReg,
        )),
      ]),
    ]),
  );

  Widget _stepRow(List<String> steps, int active, Color color) => Row(
    children: List.generate(steps.length, (i) {
      final done = i < active;
      final cur = i == active;
      return Expanded(child: Row(children: [
        Expanded(child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 26, height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? color : cur ? color.withOpacity(0.2) : Colors.white.withOpacity(0.06),
              border: Border.all(color: done || cur ? color : Colors.white12, width: 1.5),
            ),
            child: Center(child: done
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : Text('${i + 1}', style: TextStyle(
                color: cur ? color : Colors.white24, fontSize: 11,
                fontWeight: FontWeight.bold, fontFamily: FontFamily.kanitReg))),
          ),
          const SizedBox(height: 4),
          Text(steps[i], textAlign: TextAlign.center, style: TextStyle(
            color: cur ? color : Colors.white24, fontSize: 9,
            fontFamily: FontFamily.kanitReg, letterSpacing: 0.3,
          )),
        ])),
        if (i < steps.length - 1)
          Expanded(child: Container(
            height: 1.5, margin: const EdgeInsets.only(bottom: 16),
            color: i < active ? color.withOpacity(0.6) : Colors.white12,
          )),
      ]));
    }),
  );

  Widget _gradBtn({required LinearGradient gradient, required Color glow, required Widget child}) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: glow.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 5))],
        ),
        child: child,
      );

  Widget _nextButton(GameController gc) => GestureDetector(
    onTap: () async {
      final id = gc.codeController.text.trim();
      if (id.isNotEmpty) {
        await gc.joinGameRoom(id, context);
      } else {
        Utils.show("Please enter a valid Room Code", context);
      }
    },
    child: Stack(alignment: Alignment.center, children: [
      Image.asset(Assets.assetsBlueButton,
          height: Sizes.screenHeight * 0.07, width: Sizes.screenWidth * 0.6, fit: BoxFit.fill),
      const Text('NEXT', style: TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,
        fontFamily: FontFamily.kanitReg, letterSpacing: 1.5,
        shadows: [Shadow(color: Colors.black, blurRadius: 6, offset: Offset(2, 2))],
      )),
    ]),
  );
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({super.key, required this.accent, required this.dim, required this.child});
  final Color accent, dim;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [dim.withOpacity(0.7), Colors.black.withOpacity(0.45)],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: accent.withOpacity(0.3), width: 1.4),
      boxShadow: [
        BoxShadow(color: accent.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 6)),
        const BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    child: child,
  );
}