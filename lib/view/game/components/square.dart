import 'package:new_chess/view/game/components/piece.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  final bool? isWhitePlayer;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
    this.isWhitePlayer,
  });

  @override
  Widget build(BuildContext context) {
    Gradient gradient;

    if (isSelected) {
      gradient = const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // Green tones
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isValidMove) {
      gradient = const LinearGradient(
        colors: [Color(0xFF81C784), Color(0xFF388E3C)], // Lighter green
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      gradient = isWhite
          ? const LinearGradient(
        colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )
          : const LinearGradient(
        colors: [Color(0xFF546E7A), Color(0xFF263238)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: isWhitePlayer != null && isWhitePlayer! ? 0 : pi,
        child: Container(
          margin: EdgeInsets.all(isValidMove ? 8 : 0),
          decoration: BoxDecoration(
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(2, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: piece != null
              ? Center(
            child: Image.asset(
              piece!.imagePath,
              // color: piece!.isWhite ? Colors.white : Colors.black,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
