import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/helper/helper_methods.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:new_chess/view/game/components/piece.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  final TextEditingController codeController = TextEditingController();
  String gameName = "Chess Game";
  String? _gameRoomId;
  Map<String, dynamic>? _liveGameData;
  Map<String, dynamic>? get liveGameData => _liveGameData;
  int _status = 0;
  int? selectedGameType;
  bool _isLoading = false;
  bool? _isWhite;
  bool _showCopyIcon = false;
  bool _isReadOnly = false;


  final List<ChessBoardModel> chessBoardList = [
    ChessBoardModel(
      title: 'Play Online',
      subtitle: 'Challenge players globally',
      gameType: 1,
      image: Assets.assetsPlayOnline,
    ),
    ChessBoardModel(
      title: 'Play with Computer',
      subtitle: 'Practice with AI',
      gameType: 2,
      image: Assets.assetsPlayWComp,
    ),
    ChessBoardModel(
      title: 'Play with Friends',
      subtitle: 'Local multiplayer mode',
      gameType: 3,
      image: Assets.assetsPlayWFrd,
    ),
    ChessBoardModel(
      title: 'Play Offline',
      subtitle: 'Play without internet',
      gameType: 4,
      image: Assets.assetsPlayWOff,
    ),
  ];
  // Getters
  String? get gameRoomId => _gameRoomId;
  int get status => _status;
  bool get isLoading => _isLoading;
  bool? get isWhite => _isWhite;
  bool get showCopyIcon => _showCopyIcon;
  bool get isReadOnly => _isReadOnly;

  // Setter for isReadOnly
  set isReadOnly(bool value) {
    _isReadOnly = value;
    notifyListeners();
  }







  /// Initialize the game based on the selected type
  Future<void>
  initGame(int gameType, BuildContext context) async {
    selectedGameType = gameType;
    switch (gameType) {
      case 1:
        findOrCreateGameRoom(context);
        break;
      case 2:
        break;
      case 3:
        // Navigator.pushNamed(context, RoutesName.playWFrdLoad);
        break;
      case 4:
        Navigator.pushNamed(context, RoutesName.levelSelection);
        /// direct Play with Computer ke
        // Navigator.pushNamed(context, RoutesName.offlineGameBoard);
        break;
      default:
        Navigator.pushNamed(context, RoutesName.gameBoard);
    }
  }


  // Find or Create a game room
  Future<void> findOrCreateGameRoom(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Step 1: Check for an Available game
      QuerySnapshot availableRooms = await FirebaseFirestore.instance
          .collection('games')
          .where('status', isEqualTo: 0)
          .limit(1)
          .get();

      if (availableRooms.docs.isNotEmpty) {
        // Step 2: Join the first available room (second player)
        var roomData = availableRooms.docs.first.data() as Map<String, dynamic>;
        String roomId = availableRooms.docs.first.id;
        List<dynamic> getAvlPlayerData = roomData["playerData"];
        print(getAvlPlayerData.length);
        final playerData = {'userId': userId, 'isWhite': false};
        _isWhite = false;
        getAvlPlayerData.add(playerData);
        print(getAvlPlayerData.length);
        await FirebaseFirestore.instance
            .collection('games')
            .doc(roomId)
            .update({
          'playerData': getAvlPlayerData,
          'status': 1,
        });

        _gameRoomId = roomId;
        debugPrint("Joined existing game room: $roomId");
      } else {
        // Step 3: Create a new room if no available room is found (first player)
        final playerData = {'userId': userId, 'isWhite': true};
        _isWhite = true;
        DocumentReference newGameRoomRef =
            await FirebaseFirestore.instance.collection('games').add({
          'gameName': gameName,
          'gameType': selectedGameType,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 0,
          'playerData': [playerData],
          'isWhiteTurn': true,
          'turnPlayerId': userId,
          'moves': {
            "row": "null",
            "col": "null",
            "playerId": userId,
            "timestamp": FieldValue.serverTimestamp(),
          },
        });
        _gameRoomId = newGameRoomRef.id;
        _status = 0;
        debugPrint("Created new game room: $_gameRoomId");
      }
      if (selectedGameType == 1) {
        Navigator.pushNamed(context, RoutesName.loading);
      } else {
        print("hello");
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error finding or creating game room: $e");
    } finally {
      if (_gameRoomId != null) {
        listenToGameRoom(_gameRoomId!, context);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createGameRoom(BuildContext context) async {
    try {
      DocumentReference newGameRoomRef =
          await FirebaseFirestore.instance.collection('games').add({
        'gameName': gameName,
        'gameType': selectedGameType,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 0,
        'playerData': [],
        'isWhiteTurn': true,
        'turnPlayerId': "",
        'moves': {
          "row": "null",
          "col": "null",
          "playerId": "",
          "timestamp": FieldValue.serverTimestamp(),
        },
      });
      _showCopyIcon = true;
      _isReadOnly = true;
      codeController.text = newGameRoomRef.id;

      Utils.show("Game room created successfully!", context);
    } catch (e) {
      Utils.show("Failed to create game room: $e", context);
    }
  }

  Future<void> joinGameRoom(String roomId, context) async {
    dynamic playerDatas;
    try {
      DocumentReference roomRef =
          FirebaseFirestore.instance.collection('games').doc(roomId);
      DocumentSnapshot roomSnapshot = await roomRef.get();
      final userId = await UserViewModel().getUser();
      if (roomSnapshot.exists) {
        Map<String, dynamic> roomData =
            roomSnapshot.data() as Map<String, dynamic>;
        List<dynamic> playerDataList = roomData["playerData"];

        if (playerDataList.length < 2) {
          if (playerDataList.isEmpty) {
            playerDatas = {'userId': userId, 'isWhite': true};
            _isWhite = true;
          } else {
            playerDatas = {'userId': userId, 'isWhite': false};
            _isWhite = false;
          }
          playerDataList.add(playerDatas);
          await roomRef.update({
            'playerData': playerDataList,
            'status': playerDataList.length == 2 ? 1 : 0,
            'updatedAt': FieldValue.serverTimestamp(),
            'turnPlayerId': playerDataList.first['userId']
          });

          print("Joined game room: $roomId");
          Navigator.pushNamed(
            context,
            RoutesName.loading,
            arguments: roomId,
          );
        } else {
          throw Exception("Room is already full.");
        }
      } else {
        throw Exception("Room not found.");
      }
    } catch (e) {
      print("Error joining game room: $e");
      rethrow;
    } finally {
      _gameRoomId = roomId;
      if (_gameRoomId != null) {
        listenToGameRoom(_gameRoomId!, context);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isMyTurn = false;
  Future<void> updatePlayerTurnFrom() async {
    isWhiteTurn = !isWhiteTurn;
    print("is White:${(isWhiteTurn)}");
    print("turn updated");
    final nextTurnPlayerId = _liveGameData!['playerData']
        .firstWhere((e) => e["isWhite"] == isWhiteTurn)['userId'];
    await FirebaseFirestore.instance
        .collection('games')
        .doc(_gameRoomId!)
        .update({'isWhiteTurn': isWhiteTurn, 'turnPlayerId': nextTurnPlayerId});
  }

  bool isWhiteTurn = true;
  bool isNavigated = false;
  void listenToGameRoom(String roomId, BuildContext context) {
    print("hhhhhhhh");
    FirebaseFirestore.instance
        .collection('games')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) async {
      debugPrint("Snapshot received: ${snapshot.data()}");
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        _liveGameData = data;
        isWhiteTurn = data['isWhiteTurn'];
        final userId = await UserViewModel().getUser();
        notifyListeners();
        var row = data['moves']?['row'];
        var col = data['moves']?['col'];
        if (liveGameData?["turnPlayerId"].toString() == userId.toString()) {
          isMyTurn = true;
        }
        if (liveGameData?["turnPlayerId"].toString() != userId.toString()) {
          isMyTurn = false;
        }
        if (row != "null" || col != "null") {
          debugPrint("Move detected with row: $row, col: $col");
          pieceSelected(row, col, context);
        }
        if (data['playerData'].length == 2 &&
            data["status"] == 1 &&
            isNavigated == false) {
          String p1name = await getUserName(userId!);
          final oppents = data['playerData']
              .where((e) => e["userId"] != userId)
              .first['userId'];
          String p2name = await getUserName(oppents);
          Navigator.pushNamed(
            context,
            RoutesName.gameBoard,
            arguments: {
              'player1': p1name,
              'player2': p2name,
            },
          );
          isNavigated = true;
          notifyListeners();
        }

        _status = data['status'];
        notifyListeners();
      }
    });
  }

  Future<void> validateFirestoreState() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('games')
        .doc(_gameRoomId)
        .get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      debugPrint("Current game state: $data");
    } else {
      debugPrint("Error: Game room does not exist.");
    }
  }

  Future<void> sendBoardToFirebase(
      List<List<ChessPiece?>> board, String userId) async {
    List<Map<String, dynamic>> boardData = [];

    // Loop through the chessboard to prepare data for firebase
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        ChessPiece? piece = board[row][col];
        if (piece != null) {
          boardData.add({
            'row': row,
            'col': col,
            'type': piece.type.toString().split('.').last,
            'isWhite': piece.isWhite,
            'imagePath': piece.imagePath,
          });
        }
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('games')
          .doc(_gameRoomId)
          .update({
        'board': boardData,
        'playerId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Board sent successfully to Firebase!');
    } catch (e) {
      debugPrint('Error sending board to Firebase: $e');
    }
  }

  Future<void> sendToFirebase(int row, int col, String userId) async {
    await FirebaseFirestore.instance
        .collection('games')
        .doc(_gameRoomId)
        .update({
      'moves': {
        "row": row,
        "col": col,
        "playerId": userId,
        "timestamp": FieldValue.serverTimestamp(),
      },
    });
  }

  Future<void> winnerUpdate(
      String gameRoomId, String currentPlayerId, bool isWhiteTurn) async {
    try {
      await FirebaseFirestore.instance
          .collection('games')
          .doc(gameRoomId)
          .update({
        "winnerData": {
          "winnerId": currentPlayerId,
          "isWhite": isWhiteTurn,
        }
      });
      debugPrint("Winner data updated successfully in games collection!");
    } catch (e) {
      debugPrint("Error updating winner data: $e");
    }
  }

  Future<void> addGameToHistory(BuildContext context, int gameType,
      dynamic winnerData, dynamic loserData) async {
    selectedGameType = gameType;
    final userId = await UserViewModel().getUser();
    try {
      await FirebaseFirestore.instance.collection('game_history').add({
        'userId': userId,
        'gameType': selectedGameType,
        '${winnerData['id'].toString()}': winnerData,
        '${loserData['id'].toString()}': loserData,
        'createdAt': FieldValue.serverTimestamp()
      });
      Utils.show("Game History Created successfully!", context);
    } catch (e) {
      debugPrint("Error: $e");
      Utils.show("Failed to create game room: $e", context);
    }
  }

  Future<String> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        return "${userData['first_name']} ${userData['last_name']}";
      } else {
        return "Player Not Found";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching username: $e");
      }
      return "Unknown Player";
    }
  }

  // A 2-dimensional list representing the chessboard

  // with each position possible containing a chess piece
  late List<List<ChessPiece?>> board;

// The currently selected piece on the chess board,
// If no piece is selected,this is null.
  ChessPiece? selectedPiece;

  // The row index of the selected piece.
  // Default value -1 indicated no piece is currently selected;
  int selectedRow = -1;

  // The col index of the selected piece
  // Default value -1 indicated no piece is currently selected;
  int selectedCol = -1;

  // A list of valid moves for the currently selected piece
// each move is represented as a list with 2 element : row and col

  // A list of white pieces that have been taken by the black player

  List<ChessPiece> whitePiecesTaken = [];

  // A list of black pieces that have been taken by the white player

  List<ChessPiece> blackPiecesTaken = [];
  List<List<int>> validMoves = [];
  // A boolean to indicate whose turn it is
  // bool isWhiteTurn = true;

  // initial position of kings (keep track of this to make it easier later to see if king is in check)
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;


  // INITIALIZE BOARD
  void initializeBoard() {
    List<List<ChessPiece?>> newBoard =
    List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: "Assets/pawn.png");
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: "Assets/white_pawn.png");
    }

    // Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "Assets/rook.png");
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "Assets/rook.png");
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "Assets/white_rook.png");
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "Assets/white_rook.png");

    // Place knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "Assets/knight_l.png");
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "Assets/knight_r.png");
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "Assets/white_l_knight.png");
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "Assets/white_r_knight.png");

    // Place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "Assets/bishop.png");
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "Assets/bishop.png");
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "Assets/white_bishop.png");
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "Assets/white_bishop.png");

    // Place queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: "Assets/queen.png");
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: "Assets/white_queen.png");

    // Place kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: "Assets/king.png");
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: "Assets/white_king.png");

    board = newBoard;
    notifyListeners();
  }

// USER SELECTED A PIECE
  void pieceSelected(int row, int col, context) {
    print("row: $row || col: $col");
    // no piece has been selected yet, this is the first selection
    if (selectedPiece == null && board[row][col] != null) {
      // changes first isWhiteTurn Tha False
      print('zz${board[row][col]!.isWhite}');
      print('zz$isWhiteTurn');
      if (board[row][col]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][col];
        print("selected: ${selectedPiece!.isWhite}");
        selectedRow = row;
        selectedCol = col;
      }
    }
    // There is a piece already selected , but user can selected another one of their pieces

    else if (board[row][col] != null &&
        board[row][col]!.isWhite == selectedPiece!.isWhite) {
      selectedPiece = board[row][col];
      selectedRow = row;
      selectedCol = col;
    }
    // if there is a piece selected and user taps on a square that is valid move,
    else if (selectedPiece != null &&
        validMoves.any((element) => element[0] == row && element[1] == col)) {
      movePiece(row, col, context);
    }

    // if a piece is selected , calculate it's valid moves
    validMoves =
        calculateRealValidMoves(selectedRow, selectedCol, selectedPiece, true);
    notifyListeners();
  }

  // CALCULATE RAW VALID MOVES
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    if (piece == null) {
      return [];
    }
    //different directions based on their color
    int direction = piece.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        //pawns can move forward if the square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        //pawns can move 2 squares forward if they are their initial position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        // pawns can kill diagonally
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
        // horizontal and vertical direction
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
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
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        // all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], // down 2 right 1
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
        // diagonal direction
        var directions = [
          [-1, -1], // up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1], // down right
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
              break; //block
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        // all eight directions : left,right,up,down,and 4 diagonals

        var directions = [
          [-1, 0], //up
          [1, 0], // down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], // down left
          [1, 1], // down right
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
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        // all eight directions
        var directions = [
          [-1, 0], //up
          [1, 0], // down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], // down left
          [1, 1], // down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        notifyListeners();
        break;
      default:
        notifyListeners();
    }
    return candidateMoves;
  }

// CALCULATE REAL VALID MOVES
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    // after generating all candidates moves, filter out any that would result in a check
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        //this will simulate the future move to see if it's safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    notifyListeners();
    return realValidMoves;
  }

// MOVE PIECE

  Future<void> movePiece(int newRow, int newCol, context) async {
// if the new spot has an enemy piece

    // isWhiteTurn = !isWhiteTurn;

    if (board[newRow][newCol] != null) {
      // add the capture piece to the appropriate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }
    //check if the piece being moved in a king
    if (selectedPiece!.type == ChessPieceType.king) {
      // update the appropriate king pos
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

// move the piece and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // see if any kings are under attack
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    // clear selection
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves = [];

    // check if it's Checkmate
    if (isCheckMate(!isWhiteTurn)) {
      final userId = await UserViewModel().getUser();
      String winnerName = isWhiteTurn ? "White" : "Black";
      final winnerId = _liveGameData!['playerData']
          .firstWhere((e) => e['isWhite'] == isWhiteTurn)['userId'];
      final looserId = _liveGameData!['playerData']
          .firstWhere((e) => e['isWhite'] != isWhiteTurn)['userId'];
      final winnerData = {
        'id': winnerId,
        'name':await getUserName(winnerId),
        'status': 'Win'
      };
      final looserData = {
        'id': looserId,
        'name':await getUserName(looserId),
        'status': 'Loss'
      };
      if (winnerId == userId) {
        print("desh ka bhavisya khstre me hai!!!!");
        winnerUpdate(gameRoomId!, winnerId, isWhiteTurn);
        addGameToHistory(context, selectedGameType!,winnerData, looserData);
      } else {}
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          title: const Text(
            textAlign: TextAlign.center,
            "CHECK MATE!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ChessColor.blue, ChessColor.buttonColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                    image: AssetImage(Assets.assetsCheckmate),
                    height: 100), // Adjust height here
                const SizedBox(height: 8),
                const Image(
                  image: AssetImage("Assets/winner.gif"),
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  "$winnerName Wins!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (selectedGameType == 1) {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesName.dashboard,
                  );
                } else {
                  resetGame();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ChessColor.blue, ChessColor.buttonColor],
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
    }

    // change turns
    updatePlayerTurnFrom();
  }

  //IS KING IN CHECK?
  bool isKingInCheck(bool isWhiteKing) {
// Get the position of the king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    // check if any enemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // Skip empty squares and piece of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        // check if the king's position is in this piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    notifyListeners();
    return false;
  }

// SIMULATE A FUTURE MOVE TO SEE IF IT'S SAFE (DOESN'T PUT YOUR OWN KING UNDER ATTACK!)
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    // save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //if the piece is the king ,save it's current position and update to the new

    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      // update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    //simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //check if our own king is under attack
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restore board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    // if the piece was the king , restore it original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    notifyListeners();
    // if king is in check = true,means it's not a safe move.safe move = false
    return !kingInCheck;
  }

  // IS IT CHECK MATE
  bool isCheckMate(bool isWhiteKing) {
    // if the king is not in check, then it's  not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    //if there is at least one legal move for any of the player's piece, then it's not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // skip empty squares and pieces of the other color
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        // if this piece has any valid moves , then it's not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }
    notifyListeners();
    // if none of the above conditions are met, then there are no legal moves left to make
    //it's check mate!
    return true;
  }

  // RESET TO NEW GAME
  void resetGame() {
    initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    validMoves = [];
    notifyListeners();
  }

  // Future<void> setBoardCase(int row, int col, BuildContext context) async {
  //   final userId = await UserViewModel().getUser();
  //   debugPrint("Turn Player ID: ${liveGameData?["turnPlayerId"]}");
  //   debugPrint("User ID: $userId");
  //
  //   if (_selectedGameType == 1) {
  //     if (liveGameData?["turnPlayerId"].toString() == userId.toString()) {
  //       debugPrint("Valid move initiated");
  //
  //       await sendToFirebase(row, col, userId!);
  //       await sendBoardToFirebase(liveGameData!["board"], userId);
  //       debugPrint('Move and board updated successfully.');
  //     } else {
  //       debugPrint('Not your turn!');
  //     }
  //   } else {
  //     debugPrint('Game type not supported.');
  //   }
  //   notifyListeners();
  // }
  Future<void> setBoardCase(int row, int col, BuildContext context) async {
    final userId = await UserViewModel().getUser();
    debugPrint("Turn Player ID: ${liveGameData?["turnPlayerId"]}");
    debugPrint("User ID: $userId");

    if (selectedGameType == 1) {
      // For game type 1 (Online game with Firebase)
      if (liveGameData?["turnPlayerId"].toString() == userId.toString()) {
        debugPrint("Valid move initiated");
        await sendToFirebase(row, col, userId!);
        await sendBoardToFirebase(liveGameData!["board"], userId);
        debugPrint('Move and board updated successfully.');
      } else {
        debugPrint('Not your turn!');
      }
    } else if(selectedGameType == 2){
      if (isWhiteTurn) { // Only allow player to move when it's their turn
        debugPrint("Player move against computer");
        // Directly make the move without Firebase
        pieceSelected(row, col, context);
        await movePiece(row, col, context);
      } else {
        debugPrint('Not your turn! Computer is thinking...');
      }
    }

    else if (selectedGameType == 3) {
      // For game type 3 (Play with Friend)
      if (liveGameData?["turnPlayerId"].toString() == userId.toString()) {
        debugPrint("Valid move initiated");
        await sendToFirebase(row, col, userId!);
        await sendBoardToFirebase(liveGameData!["board"], userId);
        debugPrint('Move and board updated successfully.');
      } else {
        debugPrint('Not your turn!');
      }
    } else {
      // For other game types
      debugPrint('Game type not supported.');
    }
    notifyListeners();
  }
}


class ChessBoardModel {
  final String title;
  final String subtitle;
  final int gameType;
  final String image;

  ChessBoardModel({
    required this.title,
    required this.subtitle,
    required this.gameType,
    required this.image,
  });
}
