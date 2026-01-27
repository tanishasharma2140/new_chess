import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/custom_textfield.dart';
import 'package:new_chess/res/launcher.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
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
class _PlayWFrdLoadScreenState extends State<PlayWFrdLoadScreen> {
  @override
  Widget build(BuildContext context) {
    final gameCon = Provider.of<GameController>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ChessColor.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: ChessColor.white),
        ),
        backgroundColor: ChessColor.bgColor,
        title: Image(
          image: const AssetImage(Assets.assetsChessLogo),
          height: Sizes.screenHeight * 0.06,
          width: Sizes.screenWidth * 0.4,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Sizes.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsBackChaess),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.1),
          child: Column(
            children: [
              SizedBox(height: Sizes.screenHeight * 0.1),
              GestureDetector(
                onTap: () async {
                  final gameRoomId = await gameCon.createGameRoom(context);
                  gameCon.isReadOnly = true;
                  debugPrint("Game Room Created:");
                },
                child: Container(
                  width: Sizes.screenWidth * 0.8,
                  height: Sizes.screenHeight * 0.06,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.assetsFrdBtn),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: TextConst(
                    title: 'CREATE',
                    color: ChessColor.white,
                    fontWeight: FontWeight.bold,
                    size: Sizes.fontSizeSeven,
                  ),
                ),
              ),
              SizedBox(height: Sizes.screenHeight * 0.03),
              GestureDetector(
                onTap: () {
                  gameCon.isReadOnly = false;
                },
                child: Container(
                  width: Sizes.screenWidth * 0.8,
                  height: Sizes.screenHeight * 0.06,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.assetsFrdBtn),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: TextConst(
                    title: "JOIN",
                    color: ChessColor.white,
                    fontWeight: FontWeight.bold,
                    size: Sizes.fontSizeSeven,
                  ),
                ),
              ),
              SizedBox(height: Sizes.screenHeight * 0.04),
              CustomTextField(
                height: 60.0,
                prefixIcon: Icons.warning_amber,
                suffixIcon: gameCon.showCopyIcon ? Icons.copy : null,
                onSuffixTap: gameCon.showCopyIcon
                    ? () {
                        Clipboard.setData(
                          ClipboardData(text: gameCon.codeController.text),
                        );
                        Utils.show("Code copied to clipboard!", context);
                      }
                    : null,
                controller: gameCon.codeController,
                hintText: "Enter Code",
                filledColor: ChessColor.bgGrey,
                focusedBorderColor: Colors.white.withOpacity(0.7),
                iconColor: Colors.white.withOpacity(0.7),
                readOnly: gameCon.isReadOnly,
              ),
              SizedBox(height: Sizes.screenHeight * 0.01),
              SizedBox(height: Sizes.screenHeight * 0.02),
              TextConst(
                title: "Share this Code",
                color: ChessColor.buttonColor,
                fontWeight: FontWeight.bold,
                size: Sizes.fontSizeSeven,
              ),
              SizedBox(height: Sizes.screenHeight * 0.01),
              TextConst(
                title: "Share this code to start tha match",
                color: ChessColor.white.withOpacity(0.7),
                size: Sizes.fontSizeFive,
              ),
              SizedBox(height: Sizes.screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  debugPrint("Share Code Successfully!!!");
                  String gameRoomId = gameCon.codeController.text;
                  Launcher.shareApk(gameRoomId, context);
                },
                child: Container(
                  height: Sizes.screenHeight * 0.06,
                  width: Sizes.screenWidth * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ChessColor.buttonColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ChessColor.buttonColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  String gameRoomId = gameCon.codeController.text;
                  if (gameRoomId.isNotEmpty) {
                    try {
                      await gameCon.joinGameRoom(gameRoomId, context);
                    } catch (e) {
                      debugPrint("Error joining game room $e");
                    }
                  } else {
                    Utils.show("Please Enter a valid Room Code", context);
                  }
                },
                child: Container(
                  width: Sizes.screenWidth * 0.8,
                  height: Sizes.screenHeight * 0.09,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.assetsNextButton),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: TextConst(
                    title: "NEXT",
                    color: ChessColor.white,
                    fontWeight: FontWeight.bold,
                    size: Sizes.fontSizeSeven,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
