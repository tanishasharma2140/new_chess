import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class ChessAudio {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static bool _isMusicPlaying = false;

  // Sound effects
  // static Future<void> playMove() async {
  //   try {
  //     await _sfxPlayer.setAsset('sounds/move.mp3');
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Move sound error: $e");
  //   }
  // }

  // static Future<void> playCapture() async {
  //   try {
  //     await _sfxPlayer.setAsset('sounds/capture.mp3');
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Capture sound error: $e");
  //   }
  // }

  // static Future<void> playCheck() async {
  //   try {
  //     await _sfxPlayer.setAsset('Assets/sounds/Check.mp3'); // all lowercase
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Check sound error: $e");
  //   }
  // }



  static Future<void> playCheck() async {
    try {
      print("hffhyf");
      await _sfxPlayer.setAsset('Assets/sounds/Check.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      debugPrint("Check sound error: $e");
    }
  }

  static Future<void> playMove() async {
    try {
      print("hffhyf");
      await _sfxPlayer.setAsset('Assets/sounds/chess_moves.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      debugPrint("Move sound error: $e");
    }
  }

  static Future<void> staleMate() async {
    try {
      print("hffhyf");
      await _sfxPlayer.setAsset('Assets/sounds/stalemate.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      debugPrint("Move sound error: $e");
    }
  }


  static Future<void> checkMate() async {
    try {
      print("hffhyf");
      await _sfxPlayer.setAsset('Assets/sounds/checkmate_voice.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      debugPrint("CheckMate sound error: $e");
    }
  }

  static Future<void> capture() async {
    try {
      print("hffhyf");
      await _sfxPlayer.setAsset('Assets/sounds/capture.mp3');
      await _sfxPlayer.play();
    } catch (e) {
      debugPrint("Capture sound error: $e");
    }
  }


  // static Future<void> playCheckmate() async {
  //   try {
  //     await _sfxPlayer.setAsset('Assets/sounds/checkmate_sound.mp3');
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Checkmate sound error: $e");
  //   }
  // }

  // static Future<void> playGameEnd() async {
  //   try {
  //     await _sfxPlayer.setAsset('Assets/sounds/game_end.mp3');
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Game end sound error: $e");
  //   }
  // }

  // static Future<void> playWinSound() async {
  //   try {
  //     await _sfxPlayer.setAsset('Assets/sounds/win.mp3');
  //     await _sfxPlayer.play();
  //   } catch (e) {
  //     debugPrint("Win sound error: $e");
  //   }
  // }

  static Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _bgPlayer.dispose();
  }
}