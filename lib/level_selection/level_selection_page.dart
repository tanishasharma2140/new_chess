import 'dart:ui';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class LevelSelectionPage extends StatefulWidget {
  const LevelSelectionPage({super.key});

  @override
  State<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: Sizes.screenWidth,
            height: Sizes.screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.boardBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: Sizes.screenWidth * 0.85,
                  padding: const EdgeInsets.symmetric(
                      vertical: 40, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'CHOOSE DIFFICULTY',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildLevelButton('EASY', Colors.greenAccent,(){
                        Navigator.pushNamed(context, RoutesName.offlineGameBoard);
                      }),
                      const SizedBox(height: 20),
                      _buildLevelButton('MEDIUM', Colors.orangeAccent,(){
                        Navigator.pushNamed(context, RoutesName.mediumOffline);
                      }),
                      const SizedBox(height: 20),
                      _buildLevelButton('HARD', Colors.redAccent,(){
                        Navigator.pushNamed(context, RoutesName.hardOffline);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(String level, Color color , VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            level,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
