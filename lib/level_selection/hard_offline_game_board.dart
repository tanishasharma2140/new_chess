import 'dart:async';
import 'dart:math';
import 'package:new_chess/board/hard_square_board.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/chess_audio.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view/game/components/dead_piece.dart';
import 'package:new_chess/view/game/components/piece.dart';
import 'package:new_chess/view/game/square_board.dart';
import 'package:flutter/material.dart';

class HardOfflineGameBoard extends StatefulWidget {
  final bool isAgainstComputer;

  const HardOfflineGameBoard({super.key, this.isAgainstComputer = false});

  @override
  State<HardOfflineGameBoard> createState() => _HardOfflineGameBoardState();
}

class _HardOfflineGameBoardState extends State<HardOfflineGameBoard> {
  // A 2-dimensional list representing the chessboard
  late List<List<ChessPiece?>> board;
  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> validMoves = [];
  List<ChessPiece> whitePiecesTaken = [];
  List<ChessPiece> blackPiecesTaken = [];
  bool isWhiteTurn = true;
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
  bool isComputerThinking = false;


  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  // INITIALIZE BOARD
  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
    List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: "Assets/board/raja_pawn.png");
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: "Assets/board/raja_white_pawn.png");
    }

    // Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "Assets/board/raja_rook.png");
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "Assets/board/raja_rook.png");
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "Assets/board/raja_white_rook.png");
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "Assets/board/raja_white_rook.png");

    // Place knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "Assets/board/raja_knight.png");
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "Assets/board/raja_knight.png");
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "Assets/board/raja_white_knight.png");
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "Assets/board/raja_white_knight.png");

    // Place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "Assets/board/raja_bishop.png");
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "Assets/board/raja_bishop.png");
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "Assets/board/raja_white_bishop.png");
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "Assets/board/raja_white_bishop.png");

    // Place queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: "Assets/board/raja_queen.png");
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: "Assets/board/raja_white_queen.png");

    // Place kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: "Assets/board/raja_king.png");
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: "Assets/board/raja_white_king.png");

    board = newBoard;
  }

  // USER SELECTED A PIECE
  void pieceSelected(int row, int col) {
    // If it's computer's turn and we're playing against computer, ignore human input
    if (widget.isAgainstComputer && !isWhiteTurn) return;

    setState(() {
      // No piece has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
      // There is a piece already selected, but user can select another one of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece?.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      // If there is a piece selected and user taps on a square that is valid move
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);

        // If playing against computer and it's now computer's turn, make computer move
        if (widget.isAgainstComputer && !isWhiteTurn) {
          makeComputerMoveHard();
        }
        return;
      }

      // If a piece is selected, calculate its valid moves
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  // IMPROVED COMPUTER MOVE WITH AI
  void makeComputerMoveHard() {
    if (isWhiteTurn) return;

    setState(() {
      isComputerThinking = true;
    });

    // Longer thinking time for more "realistic" behavior
    Timer(const Duration(milliseconds: 1500), () {
      const pieceValues = {
        ChessPieceType.pawn: 1,
        ChessPieceType.knight: 3,
        ChessPieceType.bishop: 3,
        ChessPieceType.rook: 5,
        ChessPieceType.queen: 9,
        ChessPieceType.king: 100,
      };

      // This will store all possible moves with their evaluations
      List<Map<String, dynamic>> allPossibleMoves = [];

      // Evaluate all possible moves
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          if (board[row][col] != null && !board[row][col]!.isWhite) {
            List<List<int>> moves =
            calculateRealValidMoves(row, col, board[row][col], true);

            for (var move in moves) {
              int score = 0;
              int toRow = move[0];
              int toCol = move[1];

              // 1. Material evaluation (captures)
              if (board[toRow][toCol] != null) {
                score += pieceValues[board[toRow][toCol]!.type]! * 10;

                // Bonus for capturing with less valuable piece
                if (pieceValues[board[row][col]!.type]! <
                    pieceValues[board[toRow][toCol]!.type]!) {
                  score += 5;
                }
              }

              // 2. Center control
              if ((toRow >= 3 && toRow <= 4) && (toCol >= 3 && toCol <= 4)) {
                score += 3;
              }

              // 3. Piece development
              if ((board[row][col]!.type == ChessPieceType.knight ||
                  board[row][col]!.type == ChessPieceType.bishop) && row < 2) {
                score += 2;
              }

              // 4. Castling bonus
              if (board[row][col]!.type == ChessPieceType.king &&
                  (col - toCol).abs() == 2) {
                score += 10;
              }

              // 5. King safety - penalty for moving king early
              if (board[row][col]!.type == ChessPieceType.king && row == 0) {
                score -= 5;
              }

              // 6. Simulate move to evaluate checks and threats
              ChessPiece? capturedPiece = board[toRow][toCol];
              board[toRow][toCol] = board[row][col];
              board[row][col] = null;

              // Check if this move puts opponent in check
              if (isKingInCheck(true)) {
                score += 15; // Big bonus for checks
              }

              // Evaluate opponent's best response
              int opponentBestResponseScore = evaluateOpponentBestResponse();

              // Subtract opponent's best response from our score
              score -= opponentBestResponseScore ~/ 2;

              // Undo simulation
              board[row][col] = board[toRow][toCol];
              board[toRow][toCol] = capturedPiece;

              // 7. Penalty for hanging pieces
              if (isSquareUnderAttack(toRow, toCol, true)) {
                score -= pieceValues[board[row][col]!.type]! * 5;
              }

              // 8. Pawn structure evaluation
              if (board[row][col]!.type == ChessPieceType.pawn) {
                // Bonus for passed pawns
                if (isPassedPawn(toRow, toCol, false)) {
                  score += 4;
                }
                // Penalty for doubled pawns
                if (hasDoubledPawns(toCol, false)) {
                  score -= 3;
                }
              }

              allPossibleMoves.add({
                'fromRow': row,
                'fromCol': col,
                'toRow': toRow,
                'toCol': toCol,
                'piece': board[row][col]!,
                'score': score,
              });
            }
          }
        }
      }

      if (allPossibleMoves.isEmpty) {
        setState(() {
          isComputerThinking = false;
        });
        return;
      }

      // Sort moves by score (best first)
      allPossibleMoves.sort((a, b) => b['score'].compareTo(a['score']));

      // Unbeatable: Always choose the absolute best move
      Map<String, dynamic> chosenMove = allPossibleMoves[0];

      // Make the move
      selectedPiece = chosenMove['piece'];
      selectedRow = chosenMove['fromRow'];
      selectedCol = chosenMove['fromCol'];
      movePiece(chosenMove['toRow'], chosenMove['toCol']);

      setState(() {
        isComputerThinking = false;
      });
    });
  }

// Helper function to evaluate opponent's best response
  int evaluateOpponentBestResponse() {
    int bestScore = 0;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] != null && board[row][col]!.isWhite) {
          List<List<int>> moves =
          calculateRealValidMoves(row, col, board[row][col], false);

          for (var move in moves) {
            int score = 0;

            // Material evaluation
            // if (board[move[0]][move[1]] != null) {
            //   score += pieceValues[board[move[0]][move[1]]!.type]! * 10;
            // }

            // Update best score
            if (score > bestScore) {
              bestScore = score;
            }
          }
        }
      }
    }

    return bestScore;
  }

// Helper function to check if a square is under attack
  bool isSquareUnderAttack(int row, int col, bool byWhite) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] != null && board[r][c]!.isWhite == byWhite) {
          List<List<int>> moves =
          calculateRealValidMoves(r, c, board[r][c], false);
          if (moves.any((m) => m[0] == row && m[1] == col)) {
            return true;
          }
        }
      }
    }
    return false;
  }

// Helper function to check for passed pawns
  bool isPassedPawn(int row, int col, bool isWhite) {
    int direction = isWhite ? -1 : 1;
    int startCol = max(0, col - 1);
    int endCol = min(7, col + 1);

    for (int r = row + direction; r >= 0 && r < 8; r += direction) {
      for (int c = startCol; c <= endCol; c++) {
        if (board[r][c] != null &&
            board[r][c]!.type == ChessPieceType.pawn &&
            board[r][c]!.isWhite != isWhite) {
          return false;
        }
      }
    }
    return true;
  }

// Helper function to check for doubled pawns
  bool hasDoubledPawns(int col, bool isWhite) {
    int count = 0;
    for (int row = 0; row < 8; row++) {
      if (board[row][col] != null &&
          board[row][col]!.type == ChessPieceType.pawn &&
          board[row][col]!.isWhite == isWhite) {
        count++;
        if (count >= 2) return true;
      }
    }
    return false;
  }

  // Check for stalemate (draw)
  bool isStalemate(bool isWhiteTurn) {
    // If king is not in check but player has no valid moves
    if (!isKingInCheck(isWhiteTurn)) {
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (board[i][j] != null && board[i][j]!.isWhite == isWhiteTurn) {
            if (calculateRealValidMoves(i, j, board[i][j], true).isNotEmpty) {
              return false; // Found at least one valid move
            }
          }
        }
      }
      return true; // No valid moves found
    }
    return false;
  }

// Check for insufficient material (draw)
  bool isInsufficientMaterial() {
    int whitePieces = 0;
    int blackPieces = 0;
    bool whiteHasNonKing = false;
    bool blackHasNonKing = false;
    bool whiteHasBishopOrKnight = false;
    bool blackHasBishopOrKnight = false;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] != null) {
          if (board[i][j]!.isWhite) {
            whitePieces++;
            if (board[i][j]!.type != ChessPieceType.king) {
              whiteHasNonKing = true;
              if (board[i][j]!.type == ChessPieceType.bishop ||
                  board[i][j]!.type == ChessPieceType.knight) {
                whiteHasBishopOrKnight = true;
              }
            }
          } else {
            blackPieces++;
            if (board[i][j]!.type != ChessPieceType.king) {
              blackHasNonKing = true;
              if (board[i][j]!.type == ChessPieceType.bishop ||
                  board[i][j]!.type == ChessPieceType.knight) {
                blackHasBishopOrKnight = true;
              }
            }
          }
        }
      }
    }

    // King vs King
    if (whitePieces == 1 && blackPieces == 1) return true;

    // King + bishop/knight vs King
    if ((whitePieces == 2 && whiteHasBishopOrKnight && blackPieces == 1) ||
        (blackPieces == 2 && blackHasBishopOrKnight && whitePieces == 1)) {
      return true;
    }

    return false;
  }

// Check for 50-move rule (draw)
// You'll need to add a move counter to your state
  int moveCounter = 0;

  bool is50MoveRule() {
    return moveCounter >= 50;
  }

  // CALCULATE RAW VALID MOVES
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    // Different directions based on their color
    int direction = piece.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
      // Pawns can move forward if the square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // Pawns can move 2 squares forward from their initial position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        // Pawns can capture diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;

      case ChessPieceType.rook:
      // Horizontal and vertical directions
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // capture
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.knight:
      // All eight possible L shapes
        var knightMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // capture
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;

      case ChessPieceType.bishop:
      // Diagonal directions
        var directions = [
          [-1, -1], // up-left
          [-1, 1], // up-right
          [1, -1], // down-left
          [1, 1], // down-right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.queen:
      // All eight directions
        var directions = [
          [-1, 0], [1, 0], [0, -1], [0, 1], // straight
          [-1, -1], [-1, 1], [1, -1], [1, 1], // diagonal
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // capture
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.king:
      // All eight directions (one square)
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];

        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // capture
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }

        // Castling
        if (!piece.hasMoved) {
          // Kingside castling
          if (board[row][5] == null &&
              board[row][6] == null &&
              board[row][7] != null &&
              !board[row][7]!.hasMoved) {
            candidateMoves.add([row, 6]); // kingside castle
          }
          // Queenside castling
          if (board[row][3] == null &&
              board[row][2] == null &&
              board[row][1] == null &&
              board[row][0] != null &&
              !board[row][0]!.hasMoved) {
            candidateMoves.add([row, 2]); // queenside castle
          }
        }
        break;
    }
    return candidateMoves;
  }

  // CALCULATE REAL VALID MOVES (with check simulation)
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        if (simulatedMoveIsSafe(piece!, row, col, move[0], move[1])) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  // MOVE PIECE
  void movePiece(int newRow, int newCol) {
    ChessAudio.playMove();
    moveCounter++;

    // Handle castling
    if (selectedPiece!.type == ChessPieceType.king &&
        (selectedCol - newCol).abs() == 2) {
      // Kingside castling
      if (newCol > selectedCol) {
        // Move rook
        board[newRow][5] = board[newRow][7];
        board[newRow][7] = null;
      }
      // Queenside castling
      else {
        // Move rook
        board[newRow][3] = board[newRow][0];
        board[newRow][0] = null;
      }
    }

    // Handle capture
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      ChessAudio.capture();
      moveCounter = 0; // Reset on capture
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    // Update king position if moved
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    // Mark piece as moved
    selectedPiece!.hasMoved = true;

    // Execute move
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Check for check
    checkStatus = isKingInCheck(!isWhiteTurn);

    // Clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // Check for game results
    if (isCheckMate(!isWhiteTurn)) {
      showGameOverDialog(isWhiteTurn ? "White" : "Black", "Checkmate");
    }
    else if (isStalemate(!isWhiteTurn)) {
      showGameOverDialog("", "Stalemate (Draw)");
    }
    else if (isInsufficientMaterial()) {
      showGameOverDialog("", "Draw (Insufficient Material)");
    }
    else if (is50MoveRule()) {
      showGameOverDialog("", "Draw (50-move Rule)");
    }

    // Change turns
    isWhiteTurn = !isWhiteTurn;
  }

  // SHOW GAME OVER DIALOG
  void showGameOverDialog(String winner, String reason) {
    // Play appropriate sound
    if (reason == "Checkmate") {
      ChessAudio.checkMate();
    } else {
      ChessAudio.staleMate();
    }

    // Determine the winner text
    String winnerText;
    if (winner.isNotEmpty) {
      if (widget.isAgainstComputer) {
        // If playing against computer, show "You Win" or "Computer Wins"
        winnerText = winner == "White"
            ? (isWhiteTurn ? "Computer Wins!" : "You Win!")
            : (isWhiteTurn ? "You Win!" : "Computer Wins!");
      } else {
        // If local multiplayer, show the color that won
        winnerText = "$winner Wins!";
      }
    } else {
      // Draw case
      winnerText = "Game Ended in a Draw!";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          reason.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage(
                reason == "Checkmate"
                    ? Assets.assetsCheckmate
                    : Assets.boardPersons
            )),
            const SizedBox(height: 12),
            Text(
              winnerText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reason == "Checkmate")
              const Text(
                "🎉🎉",
                style: TextStyle(fontSize: 24),
              ),
            const SizedBox(height: 12),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: resetGame,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Play Again",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }  // IS KING IN CHECK?
  bool isKingInCheck(bool isWhiteKing) {
    List<int> kingPosition =
    isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
        calculateRealValidMoves(i, j, board[i][j], false);

        if (pieceValidMoves.any((move) =>
        move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  // SIMULATE MOVE FOR SAFETY CHECK
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    List<int>? originalKingPosition;

    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
      piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    // Simulate move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    // Restore board
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    return !kingInCheck;
  }

  // CHECK FOR CHECKMATE
  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) return false;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        if (calculateRealValidMoves(i, j, board[i][j], true).isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  // RESET GAME
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    moveCounter = 0;
    setState(() {});
  }

  // HELPER METHODS
  bool isInBoard(int row, int col) =>
      row >= 0 && row < 8 && col >= 0 && col < 8;
  bool isWhiteSquare(int index) => (index ~/ 8 + index % 8) % 2 == 0;
  bool _dialogShown = false;

  void showCheckDialog(BuildContext context) {
    ChessAudio.playCheck();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 100,
            width: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/board/square_bg.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 28),
                SizedBox(height: 8),
                Text(
                  "CHECK!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        _dialogShown = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkStatus && !_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCheckDialog(context);
        _dialogShown = true;
      });
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.boardBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: playerInfo("With AI", "", !isWhiteTurn,isAI: true),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: whitePiecesTaken.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8),
                      itemBuilder: (context, index) => DeadPiece(
                        imagePath: whitePiecesTaken[index].imagePath,
                        isWhite: true,
                      ),
                    ),
                  ),
                  // Chess board
                  Expanded(
                    flex: 4,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.boardPurpleBackBoard,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 14,
                            left: Sizes.screenWidth * 0.01,
                            right: Sizes.screenWidth * 0.005,
                          ),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: 8 * 8,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                            ),
                            itemBuilder: (context, index) {
                              int row = index ~/ 8;
                              int col = index % 8;
                              bool isSelected =
                                  selectedRow == row && selectedCol == col;
                              bool isValidMove = validMoves.any(
                                      (move) => move[0] == row && move[1] == col);
                              return HardSquareBoard(
                                isWhite: isWhiteSquare(index),
                                piece: board[row][col],
                                isSelected: isSelected,
                                isValidMove: isValidMove,
                                onTap: () => pieceSelected(row, col),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      itemCount: blackPiecesTaken.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8),
                      itemBuilder: (context, index) => DeadPiece(
                        imagePath: blackPiecesTaken[index].imagePath,
                        isWhite: false,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: playerInfo("You", "", isWhiteTurn,isAI: false),
                    ),
                  ),

                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerInfo(String name, String flagPath, bool isActive,{required bool isAI}) {
    return Container(
      height: Sizes.screenHeight * 0.09,
      width: Sizes.screenWidth * 0.5,
      padding: EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.024),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isActive
                ? "Assets/board/square_bg.png"
                : "Assets/board/square_without.png",
          ),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile Image
          Container(
            width: 55,
            height: 55,
            child: Image.asset(
               isAI
                ?Assets.boardAiBackground
                :  Assets.boardPersons,

            ),
          ),

          // Name Box
          Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            height: Sizes.screenHeight * 0.028,
            width: Sizes.screenWidth * 0.25,
            decoration: const BoxDecoration(
              color: Color(0xff043532),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border(
                top: BorderSide(color: Colors.white, width: 0.5),
                bottom: BorderSide(color: Colors.white, width: 0.5),
                right: BorderSide(color: Colors.white, width: 0.5),
              ),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
