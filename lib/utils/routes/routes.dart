import 'package:new_chess/level_selection/hard_offline_game_board.dart';
import 'package:new_chess/level_selection/level_selection_page.dart';
import 'package:new_chess/level_selection/medium_offline_game_board.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/view/auth/email_verification_page.dart';
import 'package:new_chess/view/auth/forget_password.dart';
import 'package:new_chess/view/auth/sign_in_page.dart';
import 'package:new_chess/view/auth/sign_up_page.dart';
import 'package:new_chess/view/game/game_board.dart';
import 'package:new_chess/view/game/loading_screen.dart';
import 'package:new_chess/view/game/offline_game_board.dart';
import 'package:new_chess/view/game/play_w_frd_load_screen.dart';
import 'package:new_chess/view/setting/edit_profile.dart';
import 'package:new_chess/view/setting/profile.dart';
import 'package:new_chess/view/setting/setting.dart';
import 'package:new_chess/view/setting/wallet_history.dart';
import 'package:new_chess/view/splash_screen.dart';
import 'package:new_chess/view/dashboard_page.dart';
import 'package:flutter/material.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splash:
        return (context) => const SplashScreen();
      case RoutesName.signIn:
        return (context) => const SignInPage();
      case RoutesName.signUp:
        return (context) => const SignUpPage();
      case RoutesName.emailVerify:
        return (context) => const EmailVerification();
      case RoutesName.dashboard:
        return (context) => const Dashboard();
      case RoutesName.forgotPass:
        return (context) => ForgotPassword();
      case RoutesName.gameBoard:
        return (context) =>  const GameBoard();
      case RoutesName.loading:
        return (context) => const LoadingScreen();
      case RoutesName.setting:
        return (context) => const Setting();
      case RoutesName.profile:
        return (context) =>  const Profile();
      case RoutesName.editProfile:
        return (context) => const EditProfile();
      case RoutesName.offlineGameBoard:
        return (context) => const OfflineGameBoard(isAgainstComputer: true);
      case RoutesName.playWFrdLoad:
        return (context) => const PlayWFrdLoadScreen();
      case RoutesName.walletHistory:
        return (context) => const WalletHistory();
      case RoutesName.levelSelection:
        return (context) => const LevelSelectionPage();
      case RoutesName.mediumOffline:
        return (context) => const MediumOfflineGameBoard(isAgainstComputer: true);
      case RoutesName.hardOffline:
        return (context) => const HardOfflineGameBoard(isAgainstComputer: true);

      default:
        return (context) => const Scaffold(
              body: Center(
                child: Text(
                  'No Route Found!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            );
    }
  }
}
