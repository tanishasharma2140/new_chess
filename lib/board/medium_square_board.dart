import 'package:new_chess/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/view/game/components/piece.dart';

class MediumSquareBoard extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const MediumSquareBoard({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context) {
    String backgroundImage;

    // Set image paths based on square state
    if (isSelected) {
      backgroundImage = Assets.boardGreenSquare;
    } else if (isValidMove) {
      backgroundImage = Assets.boardGreenSquare;
    } else {
      backgroundImage = isWhite
          ? Assets.boardPinkSquare
          : Assets.boardGreySquare;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: piece != null
            ? Center(
          child: Image.asset(
            piece!.imagePath,
            height: 50,
            width: 50,
          ),
        )
            : null,
      ),
    );
  }
}
