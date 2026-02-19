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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/view/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;
  bool fadeOut = false;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() async {
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (progress < 1) {
        setState(() {
          progress += 0.02;
        });
      } else {
        timer.cancel();
        setState(() => fadeOut = true);

        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, animation, __) => FadeTransition(
                opacity: animation,
                child: const LoginPage(),
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // no white flash
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: fadeOut ? 0 : 1,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.assetsBackground), // background image
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🔥 Chess Logo
              Image.asset(
                Assets.assetsChessClashLogo,
                width: 220,
              ),

              const SizedBox(height: 90),

              /// LOADING TEXT
              const Text(
                "LOADING...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              /// GREEN PROGRESS BAR (image jaisa)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A3F00), // brown border like image
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF66FF00),
                                Color(0xFF2ECC00),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
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

