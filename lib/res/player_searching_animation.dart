import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view_model/person_circle_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../generated/assets.dart';


class PlayerSearchingAnimation extends StatefulWidget {
  const PlayerSearchingAnimation({super.key});

  @override
  _PlayerSearchingAnimationState createState() => _PlayerSearchingAnimationState();
}

class _PlayerSearchingAnimationState extends State<PlayerSearchingAnimation> with SingleTickerProviderStateMixin {
  late PersonCircleViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PersonCircleViewModel(this);

  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PersonCircleViewModel>.value(
      value: _viewModel,
      child: const PersonCircleView(),
    );
  }
}

class PersonCircleView extends StatelessWidget {
  const PersonCircleView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PersonCircleViewModel>(context);

    double containerSize = Sizes.screenWidth/2;
    double imageSize = 21.63;
    double radius = (containerSize - imageSize) / 4;
    double centerPosition = (containerSize - imageSize) / 2;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: AnimatedBuilder(
        animation: viewModel.rotationAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: centerPosition,
                top: centerPosition,
                child: Opacity(
                  opacity: viewModel.centerOpacityAnimation.value,
                  child: ScaleTransition(
                    scale: viewModel.centerScaleAnimation,
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage(Assets.assetsPersonMan4)),
                      ),
                    ),
                  ),
                ),
              ),
              // Circular images
              ...List.generate(viewModel.imagePaths.length, (index) {
                double angle = viewModel.rotationAnimation.value + (2 * math.pi * index) / viewModel.imagePaths.length;
                double x = radius * math.cos(angle) + centerPosition;
                double y = radius * math.sin(angle) + centerPosition;
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: viewModel.opacityAnimations[index].value,
                    child: ScaleTransition(
                      scale: viewModel.scaleAnimations[index],
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(viewModel.imagePaths[index])),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Center(
                child: RotationTransition(
                  turns: viewModel.rotationAnimationCircle,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.assetsSearchingCircleImg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}