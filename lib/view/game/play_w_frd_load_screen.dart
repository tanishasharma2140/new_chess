import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
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

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ChessColor.bgColor,
        body: Container(
          width: Sizes.screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.boardBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [

              Stack(
                children: [
                  SizedBox(
                    height: Sizes.screenHeight * 0.12,
                    width: double.infinity,
                    child: Image.asset(
                      Assets.iconsHeader,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: Sizes.screenHeight * 0.05,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        Assets.iconsBackbutton,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// MAIN CONTENT
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.12),
                  child: Column(
                    children: [

                      GestureDetector(
                        onTap: () async {
                          final gameRoomId = await gameCon.createGameRoom(context);
                          gameCon.isReadOnly = true;
                        },
                        child: Image.asset(
                          Assets.iconsWhitetheeDButton,
                          height: Sizes.screenHeight * 0.11,
                          width: Sizes.screenWidth * 0.76,
                          fit: BoxFit.fill,
                        ),
                      ),

                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: () {
                          gameCon.isReadOnly = false;
                        },
                        child: Image.asset(
                          Assets.iconsJoinBtn,
                          height: Sizes.screenHeight * 0.11,
                          width: Sizes.screenWidth * 0.76,
                          fit: BoxFit.fill,
                        ),
                      ),

                      const SizedBox(height: 26),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: TextField(
                          controller: gameCon.codeController,
                          readOnly: gameCon.isReadOnly,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Code",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            suffixIcon: gameCon.showCopyIcon
                                ? IconButton(
                              icon: Icon(
                                Icons.copy,
                                color: Colors.white.withOpacity(0.85),
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: gameCon.codeController.text),
                                );
                                Utils.show("Copied!", context);
                              },
                            )
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// UPDATED SHARE TEXT
                      Text(
                        "Share this Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.fontSizeSeven,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.75),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4),

                      TextConst(
                        title: "Share this code to start the match",
                        color: Colors.white70,
                        size: Sizes.fontSizeFive,
                      ),

                      const SizedBox(height: 18),

                      /// UPDATED SHARE BUTTON
                      GestureDetector(
                        onTap: () {
                          String gameRoomId = gameCon.codeController.text;
                          Launcher.shareApk(gameRoomId, context);
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () async {
                          String roomId = gameCon.codeController.text;
                          if (roomId.isNotEmpty) {
                            await gameCon.joinGameRoom(roomId, context);
                          } else {
                            Utils.show("Please enter a valid Room Code", context);
                          }
                        },
                        child: Image.asset(
                          Assets.iconsNextBtn,
                          height: Sizes.screenHeight * 0.09,
                          width: Sizes.screenWidth * 0.76,
                          fit: BoxFit.fill,
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
