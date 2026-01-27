import 'package:new_chess/helper/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view/game/components/dead_piece.dart';
import 'package:new_chess/view/game/components/square.dart';
import 'package:new_chess/view_model/services/game_service.dart';

class GameBoard extends StatefulWidget {
  // final GameController? gameCon;
  const GameBoard({super.key, });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool isLoading = true;
  late FlutterTts flutterTts;
  String lastSpokenText = "";

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    configureTTS();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final gameCon = Provider.of<GameController>(context, listen: false);
      gameCon.initializeBoard();
      setState(() {
        isLoading = false;
      });
    });
  }


  void configureTTS() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.3);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(0.8);
      debugPrint("TTS configured successfully.");
    } catch (e) {
      debugPrint("Error configuring TTS: $e");
    }
  }
   void speak(String text) async {
    try {
      if (text.isNotEmpty && text != lastSpokenText) {
        lastSpokenText = text;
        debugPrint("Speaking: $text");
        await flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("Error speaking text: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final gameCon = Provider.of<GameController>(context);

    if (!gameCon.isMyTurn && lastSpokenText != "It's opponent's turn") {
      Future.microtask(() => speak("It's opponent's turn"));
    } else if (gameCon.isMyTurn && lastSpokenText != "It's your turn") {
      Future.microtask(() => speak("It's your turn"));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: ChessColor.bgGrey,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(Assets.assetsBackChaess, fit: BoxFit.cover),
                ),
                // Optional overlay
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(Assets.assetsFemaleProfile),
                              backgroundColor: Colors.transparent,
                            ),
                            Text(
                              '${arguments['player2']}',
                              style: const TextStyle(
                                color: ChessColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: Sizes.screenWidth * 0.02),
                            Text(
                              !gameCon.isMyTurn ? "It's opponent's Turn 👈" : "",
                              style: const TextStyle(
                                color: ChessColor.buttonColor,
                                fontFamily: FontFamily.robotoBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // WHITE PIECE TAKEN
                      Expanded(
                        child: GridView.builder(
                          itemCount: gameCon.whitePiecesTaken.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8),
                          itemBuilder: (context, index) => DeadPiece(
                            imagePath: gameCon.whitePiecesTaken[index].imagePath,
                            isWhite: true,
                          ),
                        ),
                      ),
                      // GAME STATUS
                      Text(gameCon.checkStatus ? "CHECK!" : ""),
                      // CHESS BOARD
                      Expanded(
                        flex: 3,
                        child: Transform.rotate(
                          angle: gameCon.isWhite! ? 0 : 3.15,
                          child: GridView.builder(
                            itemCount: 8 * 8,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 8),
                            itemBuilder: (context, index) {
                              int row = index ~/ 8;
                              int col = index % 8;
                              bool isSelected = gameCon.selectedRow == row &&
                                  gameCon.selectedCol == col;
                              bool isValidMove = gameCon.validMoves.any(
                                  (position) =>
                                      position[0] == row && position[1] == col);
                              return Square(
                                isWhitePlayer: gameCon.isWhite,
                                isWhite: isWhite(index),
                                piece: gameCon.board[row][col],
                                isSelected: isSelected,
                                isValidMove: isValidMove,
                                onTap: () {
                                  gameCon.setBoardCase(row, col, context);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // BLACK PIECE TAKEN
                      Expanded(
                        child: GridView.builder(
                          itemCount: gameCon.blackPiecesTaken.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8),
                          itemBuilder: (context, index) => DeadPiece(
                            imagePath: gameCon.blackPiecesTaken[index].imagePath,
                            isWhite: false,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Sizes.screenHeight * 0.01,
                          horizontal: Sizes.screenWidth * 0.05,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(Assets.assetsMaleProfile),
                                backgroundColor: Colors.transparent,
                              ),
                              Text(
                                '${arguments['player1']}',
                                style: const TextStyle(
                                  color: ChessColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: Sizes.screenWidth * 0.01),
                              Text(
                                gameCon.isMyTurn ? "It's Your Turn 👈" : "",
                                style: const TextStyle(
                                  color: ChessColor.buttonColor,
                                  fontFamily: FontFamily.robotoBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      ),
    );
  }
}
