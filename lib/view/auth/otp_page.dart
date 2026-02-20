import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view/home_page.dart';
import 'package:new_chess/view/main_navigation_page.dart';



class OtpPage extends StatefulWidget {
  /// The phone number shown in subtitle (e.g. "9876543210")
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  static const int _otpLength = 4;
  static const int _resendSeconds = 30;

  // One controller + focusNode per box
  final List<TextEditingController> _controllers =
  List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_otpLength, (_) => FocusNode());

  // Resend timer
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  // Animations
  late final AnimationController _entryCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _shakeCtrl;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _shimmerAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _shakeAnim;

  // Track which boxes are filled
  final List<bool> _filled = List.generate(_otpLength, (_) => false);
  bool _isVerifying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Entry
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fadeAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    // Gold shimmer on title
    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _shimmerAnim = Tween<double>(begin: -2, end: 2)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // Floating chess piece
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -7, end: 7)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    // Shake on error
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    _entryCtrl.dispose();
    _shimmerCtrl.dispose();
    _floatCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── Input handling ─────────────────────────────────────────
  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      setState(() => _filled[index] = true);
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _tryVerify();
      }
    } else {
      setState(() => _filled[index] = false);
    }
  }

  void _onKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() => _filled[index - 1] = false);
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _tryVerify() async {
    if (_otp.length < _otpLength) return;
    setState(() {
      _isVerifying = true;
      _hasError = false;
    });
    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    // Demo: "123456" succeeds, anything else fails
    if (_otp == '1234') {
      setState(() => _isVerifying = false);
      // TODO: Navigate to home
      Navigator.push(context, CupertinoPageRoute(builder: (context)=> MainNavigationPage()));
    } else {
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });
      _shakeCtrl.forward(from: 0);
      // Clear fields after a moment
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      for (int i = 0; i < _otpLength; i++) {
        _controllers[i].clear();
        _filled[i] = false;
      }
      setState(() => _hasError = false);
      _focusNodes[0].requestFocus();
    }
  }

  // ── Build ───────────────────────────────────────────────────
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildChessIcon(),
                        const SizedBox(height: 6),
                        _buildShimmerTitle(),
                        const SizedBox(height: 6),
                        _buildSubtitle(),
                        const SizedBox(height: 28),
                        _buildOtpCard(),
                        const SizedBox(height: 24),
                        _buildResendRow(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ),
    );
  }

  // ── Chess Icon ──────────────────────────────────────────────
  Widget _buildChessIcon() {
    return Image.asset(
      Assets.assetsPawnTwo,
      height: 110,
    );
  }

  // ── Shimmer Title ───────────────────────────────────────────
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
          'OTP VERIFICATION',
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

  // ── Subtitle ────────────────────────────────────────────────
  Widget _buildSubtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: Colors.white.withOpacity(0.60),
          fontSize: 13.5,
          fontFamily: FontFamily.kanitReg,
          letterSpacing: 0.4,
        ),
        children: [
          const TextSpan(text: 'Code sent to  '),
          TextSpan(
            text: '+91 ${widget.phoneNumber}',
            style: const TextStyle(
              color: Color(0xFFf5c26b),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── OTP Card ────────────────────────────────────────────────
  Widget _buildOtpCard() {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) {
        final shake = _hasError
            ? (8 * (0.5 - (_shakeAnim.value - 0.5).abs()) * 2 *
            ((_shakeAnim.value * 6).round() % 2 == 0 ? 1 : -1))
            : 0.0;
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: Container(
        width: Sizes.screenWidth * 0.88,
        decoration: BoxDecoration(
          color: const Color(0x1A0F0A03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hasError
                ? const Color(0xFFFF4444)
                : const Color(0xFFE0B25C),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (_hasError
                  ? const Color(0xFFFF4444)
                  : const Color(0xFFE0B25C))
                  .withOpacity(0.10),
              blurRadius: 1,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: (_hasError
                  ? const Color(0xFFFF4444)
                  : const Color(0xFFE0B25C))
                  .withOpacity(0.08),
              blurRadius: 20,
            ),
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.55),
            //   blurRadius: 40,
            //   offset: const Offset(0, 16),
            // ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Dark warm fill
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF3E1F0C).withOpacity(0.25),
                ),
              ),
              // Radial vignette
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF5A2E10).withOpacity(0.65),
                      ],
                      radius: 1.2,
                    ),
                  ),
                ),
              ),
              // Corner ornaments
              ..._corners(),

              // Content
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ornateLine(),
                    const SizedBox(height: 22),

                    // Instruction text
                    Text(
                      'Enter the 4-digit code',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 13,
                        letterSpacing: 1.2,
                        fontFamily: FontFamily.kanitReg,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // OTP boxes
                    _buildOtpBoxRow(),

                    const SizedBox(height: 8),

                    // Error message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _hasError
                          ? Padding(
                        key: const ValueKey('err'),
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Color(0xFFFF6B6B), size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'Invalid OTP. Please try again.',
                              style: TextStyle(
                                color:
                                const Color(0xFFFF6B6B).withOpacity(0.9),
                                fontSize: 12.5,
                                fontFamily: FontFamily.kanitReg,
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(key: ValueKey('no_err'), height: 6),
                    ),

                    const SizedBox(height: 16),

                    // Verify button
                    _buildVerifyButton(),

                    _ornateLine(bottom: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 6 OTP input boxes ───────────────────────────────────────
  Widget _buildOtpBoxRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_otpLength, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _OtpBox(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            isFilled: _filled[i],
            hasError: _hasError,
            onChanged: (v) => _onChanged(v, i),
            onKey: (e) => _onKeyEvent(e, i),
          ),
        );
      }),
    );
  }

  // ── Verify Button ───────────────────────────────────────────
  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: _isVerifying ? null : _tryVerify,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            Assets.assetsBlueButton,
            height: 55,
            fit: BoxFit.contain,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isVerifying
                ? const SizedBox(
              key: ValueKey('loader'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : const Text(
              key: ValueKey('label'),
              'VERIFY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Resend row ──────────────────────────────────────────────
  Widget _buildResendRow() {
    final canResend = _secondsLeft == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.50),
            fontSize: 13.5,
            fontFamily: FontFamily.kanitReg,
          ),
        ),
        GestureDetector(
          onTap: canResend ? _startTimer : null,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: canResend
                  ? const Color(0xFFf5c26b)
                  : Colors.white.withOpacity(0.35),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.kanitReg,
              decoration: canResend ? TextDecoration.underline : TextDecoration.none,
              decorationColor: const Color(0xFFf5c26b),
            ),
            child: canResend
                ? const Text('Resend OTP')
                : Text('Resend in ${_secondsLeft}s'),
          ),
        ),
      ],
    );
  }

  // ── Shared helpers (match LoginPage style) ──────────────────
  List<Widget> _corners() {
    const style = TextStyle(
      color: Color(0xFFE0B25C),
      fontSize: 18,
      height: 1,
    );
    return [
      Positioned(
          top: 10,
          left: 14,
          child: Text('✦',
              style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(
          top: 10,
          right: 14,
          child: Text('✦',
              style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(
          bottom: 10,
          left: 14,
          child: Text('✦',
              style: style.copyWith(color: const Color(0xB3E0B25C)))),
      Positioned(
          bottom: 10,
          right: 14,
          child: Text('✦',
              style: style.copyWith(color: const Color(0xB3E0B25C)))),
    ];
  }

  Widget _ornateLine({bool bottom = false}) {
    return Container(
      margin: EdgeInsets.only(top: bottom ? 20 : 0),
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
}

// ══════════════════════════════════════════════════════════════
//  SINGLE OTP BOX  (extracted widget for clean code)
// ══════════════════════════════════════════════════════════════
class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFilled;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKey;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isFilled,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> with SingleTickerProviderStateMixin {
  late AnimationController _popCtrl;
  late Animation<double> _popAnim;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _popAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
        CurvedAnimation(parent: _popCtrl, curve: Curves.easeOut));

    widget.focusNode.addListener(() {
      if (mounted) setState(() => _hasFocus = widget.focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(_OtpBox old) {
    super.didUpdateWidget(old);
    // Pop animation when digit is filled
    if (!old.isFilled && widget.isFilled) {
      _popCtrl.forward(from: 0).then((_) => _popCtrl.reverse());
    }
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = widget.hasError
        ? const Color(0xFFFF4444)
        : _hasFocus
        ? const Color(0xFFFFE082)
        : widget.isFilled
        ? const Color(0xFFE0B25C)
        : const Color(0xFFE0B25C).withOpacity(0.40);

    final Color bgColor = widget.hasError
        ? const Color(0xFFFF4444).withOpacity(0.10)
        : _hasFocus
        ? const Color(0xFFFFE082).withOpacity(0.08)
        : Colors.black.withOpacity(0.35);

    return ScaleTransition(
      scale: _popAnim,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: widget.onKey,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 42,
          height: 52,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.8),
            boxShadow: _hasFocus
                ? [
              BoxShadow(
                color: const Color(0xFFFFE082).withOpacity(0.18),
                blurRadius: 12,
                spreadRadius: 1,
              )
            ]
                : widget.isFilled
                ? [
              BoxShadow(
                color: const Color(0xFFE0B25C).withOpacity(0.12),
                blurRadius: 8,
              )
            ]
                : [],
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                color: widget.hasError
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFFFFE082),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg,
              ),
              cursorColor: const Color(0xFFf5c26b),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                isCollapsed: true,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ),
    );
  }
}