import 'package:new_chess/generated/assets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PersonCircleViewModel with ChangeNotifier {
  final List<String> _imagePaths = [
    Assets.assetsPersonLady,
    Assets.assetsPersonMan1,
    Assets.assetsPersonMan3,
    Assets.assetsPersonMan2,
    Assets.assetsPersonMan4,
  ];

  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _rotationAnimationCircle;
  late final List<Animation<double>> _opacityAnimations;
  late final List<Animation<double>> _scaleAnimations;
  late final Animation<double> _centerOpacityAnimation;
  late final Animation<double> _centerScaleAnimation;

  List<String> get imagePaths => _imagePaths;

  Animation<double> get rotationAnimation => _rotationAnimation;
  Animation<double> get rotationAnimationCircle => _rotationAnimationCircle;
  List<Animation<double>> get opacityAnimations => _opacityAnimations;
  List<Animation<double>> get scaleAnimations => _scaleAnimations;
  Animation<double> get centerOpacityAnimation => _centerOpacityAnimation;
  Animation<double> get centerScaleAnimation => _centerScaleAnimation;

  PersonCircleViewModel(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
    _rotationAnimationCircle = Tween<double>(begin: 0, end: -1).animate(_controller);

    _opacityAnimations = List.generate(_imagePaths.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / _imagePaths.length,
            (index + 1) / _imagePaths.length,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _scaleAnimations = List.generate(_imagePaths.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / _imagePaths.length,
            (index + 1) / _imagePaths.length,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _centerOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _centerScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}