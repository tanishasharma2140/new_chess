import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/player_searching_animation.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/view_model/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  final String? roomId;

  const LoadingScreen({super.key, this.roomId});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late GameController gameRoomController;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    gameRoomController = Provider.of<GameController>(context, listen: false);

    // Initialize animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gameRoomController = Provider.of<GameController>(context);

    return Scaffold(
      body: Container(
        width: Sizes.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage( Assets.boardBackground,),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            SizedBox(height: Sizes.screenHeight*0.02,),
            Image.asset(
              Assets.boardChess,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: Sizes.screenHeight*0.07,),
            CircleAvatar(
              radius: 28,
              backgroundColor: ChessColor.white,
              backgroundImage: const AssetImage(Assets.iconsProfile),
            ),
            const  TextConst(
              title: "First Player Found...!!",
              color: ChessColor.white,fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 40),
          const  PlayerSearchingAnimation(),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 28,
              backgroundColor: ChessColor.white,
              backgroundImage: const AssetImage(Assets.iconsProfile),
            ),
            const Text(
              'Waiting for Player 2...',
              style: TextStyle(
                color: ChessColor.white,
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      )
    );
  }
}
