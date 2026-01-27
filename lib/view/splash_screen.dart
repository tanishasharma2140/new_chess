// import 'package:new_chess/generated/assets.dart';
// import 'package:new_chess/res/app_colors.dart';
// import 'package:new_chess/res/sizing_const.dart';
// import 'package:new_chess/view_model/services/services.dart';
// import 'package:flutter/material.dart';
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
// class _SplashScreenState extends State<SplashScreen> {
//   Services services = Services();
//   @override
//   void initState() {
//     super.initState();
//     services.checkAuthentication(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ChessColor.bgGrey,
//       body: Column(
//         children: [
//           SizedBox(height: Sizes.screenHeight * 0.1),
//           Center(
//             child: Image.asset(
//               Assets.assetsChessLogo,
//               width: 150,
//               height: 150,
//               fit: BoxFit.contain,
//             ),
//           ),
//           SizedBox(height: Sizes.screenHeight * 0.1),
//           SizedBox(
//             width: double.infinity,
//             height: 450,
//             child: Image.asset(
//               Assets.assetsSplashBackground,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/view/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0;
  bool fadeOut = false;

  @override
  void initState() {
    super.initState();

    // Fake loading simulation (game style)
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (progress < 1) {
        setState(() => progress += 0.015);
        return true;
      } else {
        // Fade out + Navigate
        setState(() => fadeOut = true);

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, animation, __) {
                return FadeTransition(
                  opacity: animation,
                  child: const LoginPage(),
                );
              },
            ),
          );
        });
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // NO WHITE FLASH FIX ✔️
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: fadeOut ? 0 : 1,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.boardBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // chess logo
              Image.asset(
                Assets.boardChess,
                width: 240,
                height: 240,
              ),

              const SizedBox(height: 70),

              // Loading text
              Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 18,
                  letterSpacing: 0.9,
                ),
              ),

              const SizedBox(height: 40),

              // Loader bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
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

