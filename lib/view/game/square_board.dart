// import 'package:new_chess/res/app_colors.dart';
// import 'package:new_chess/view/game/components/piece.dart';
// import 'package:flutter/material.dart';
//
// class SquareBoard extends StatelessWidget {
//   final bool isWhite;
//   final ChessPiece? piece;
//   final bool isSelected;
//   final bool isValidMove;
//   final void Function()? onTap;
//   const SquareBoard({
//     super.key,
//     required this.isWhite,
//     required this.piece,
//     required this.isSelected,
//     required this.onTap,
//     required this.isValidMove,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Gradient gradient;
//
//     if (isSelected) {
//       gradient = const LinearGradient(
//         colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // Green tones
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       );
//     } else if (isValidMove) {
//       gradient = const LinearGradient(
//         colors: [Color(0xFF81C784), Color(0xFF388E3C)], // Lighter green
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       );
//     } else {
//       gradient = isWhite
//           ? const LinearGradient(
//         colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       )
//           : const LinearGradient(
//         colors: [Color(0xFF546E7A), Color(0xFF263238)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       );
//     }
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(isValidMove ? 8 : 0),
//         decoration: BoxDecoration(
//           gradient: gradient,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               offset: const Offset(2, 4),
//               blurRadius: 6,
//               spreadRadius: 1,
//             ),
//           ],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: piece != null
//             ? Center(
//           child: Image.asset(
//             piece!.imagePath,
//             // color: piece!.isWhite ? Colors.white : Colors.black,
//           ),
//         )
//             : null,
//       ),
//     );
//   }
// }

import 'package:new_chess/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/view/game/components/piece.dart';

class SquareBoard extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const SquareBoard({
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
          ? Assets.boardWoodSquare
          : Assets.boardWhiteWood;
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
