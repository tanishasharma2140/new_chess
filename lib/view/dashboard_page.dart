import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_chess/res/text_const.dart' show TextConst;
import 'package:provider/provider.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view_model/services/game_service.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  // final List<String> imagePaths = [
  //   Assets.boardPlayWithFriend,
  //   Assets.boardPlayWithComp,
  // ];

  late PageController _pageController;
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize page controller with initial page as 0 (Play with Friend)
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    currentPage = 0.0;

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _slideAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: Sizes.screenWidth * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.20),
                      Colors.white.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// TITLE
                    const Text(
                      "Exit Game?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Are you sure you want to exit?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// BUTTONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _glassButton(
                          title: "No",
                          onTap: () => Navigator.of(context).pop(false),
                        ),
                        _glassButton(
                          title: "Yes",
                          onTap: () => SystemNavigator.pop(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )) ?? false;
  }


  final List<ChessBoardModel> chessBoardList = [

    ChessBoardModel(
      // title: 'Play with Friends',
      // subtitle: 'Local multiplayer mode',
      gameType: 1,
      image: Assets.assetsOnline,
    ),
    ChessBoardModel(
      // title: 'Play with Friends',
      // subtitle: 'Local multiplayer mode',
      gameType: 3,
      image: Assets.boardPlayWithFriend,
    ),
    ChessBoardModel(
      // title: 'Play with Computer',
      // subtitle: 'Practice with AI',
      gameType: 4,
      image: Assets.boardPlayWithComp,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final gameCon = Provider.of<GameController>(context);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: ChessColor.bgGrey,
        body: Container(
          width: Sizes.screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.boardBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: Sizes.screenHeight*0.1),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.boardChess),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Sizes.screenHeight*0.08),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: chessBoardList.length,
                  padEnds: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final scale = (1 - (currentPage - index).abs() * 0.3);
                    final offset = (currentPage - index) * 120;
                    final chessBoard = chessBoardList[index];

                    return Transform(
                      transform: Matrix4.identity()
                        ..scale(scale, scale)
                        ..translate(offset),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          gameCon.initGame(chessBoard.gameType, context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: SizedBox(
                              height: Sizes.screenHeight*0.3,
                              width: Sizes.screenWidth*0.6,
                              // color: Colors.red,
                              child: Image.asset(
                                chessBoard.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: Sizes.screenHeight*0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  chessBoardList.length,
                      (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage.round() == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizes.screenHeight*0.07),
            ],
          ),
        ),
      ),
    );
  }
  Widget _glassButton({
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 1.3,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.22),
              Colors.white.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: TextConst(
            title: title,
            size: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
class ChessBoardModel {

  final int gameType;
  final String image;
  ChessBoardModel({
    required this.gameType,
    required this.image,
  });
}

// import 'package:new_chess/generated/assets.dart';
// import 'package:new_chess/res/app_colors.dart';
// import 'package:new_chess/res/sizing_const.dart';
// import 'package:new_chess/utils/routes/routes_name.dart';
// import 'package:new_chess/view_model/services/game_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//
//   Future<bool> _onWillPop(BuildContext context) async {
//     return (await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: ChessColor.bgGrey,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         title: const Text(
//           "Exit App",
//           style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: ChessColor.white),
//         ),
//         content:  Text(
//           "Are you sure you want to exit this app?",
//           style: TextStyle(fontSize: 14, color: ChessColor.white.withOpacity(0.5)),
//         ),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: ChessColor.buttonColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 height: Sizes.screenHeight*0.05,
//                 child: TextButton(
//                   onPressed: () => Navigator.of(context).pop(false), // Cancel button
//                   child: const Text(
//                     "No",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: ChessColor.buttonColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 height: Sizes.screenHeight*0.05,
//                 child: TextButton(
//                   onPressed: () => SystemNavigator.pop(), // Exit app
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     )) ??
//         false;
//   }
//
//
//
//   final List<ChessBoardModel> chessBoardList = [
//     ChessBoardModel(
//       title: 'Play Online',
//       subtitle: 'Challenge players globally',
//        gameType: 1,
//       image: Assets.assetsPlayOnline,
//     ),
//     ChessBoardModel(
//       title: 'Play with Computer',
//       subtitle: 'Practice with AI',
//       gameType: 2,
//       image: Assets.assetsPlayWComp,
//     ),
//     ChessBoardModel(
//       title: 'Play with Friends',
//       subtitle: 'Local multiplayer mode',
//       gameType: 3,
//       image: Assets.assetsPlayWFrd,
//     ),
//     ChessBoardModel(
//       title: 'Play with Computer',
//       subtitle: 'Practice with AI',
//       gameType: 4,
//       image: Assets.assetsPlayWComp,
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final gameCon = Provider.of<GameController>(context);
//     return WillPopScope(
//       onWillPop: () => _onWillPop(context),
//       child: Scaffold(
//         backgroundColor: ChessColor.bgGrey,
//         body: Container(
//             width: Sizes.screenWidth,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(Assets.boardBackground),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child:    Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: Sizes.screenHeight * 0.035,
//                 horizontal: Sizes.screenWidth * 0.035,
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(bottom: Sizes.screenHeight * 0.02),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const SizedBox(width: 10),
//                         Image.asset(
//                           Assets.assetsChessLogo,
//                           height: Sizes.screenHeight * 0.057,
//                           width: Sizes.screenWidth * 0.28,
//                           fit: BoxFit.fill,
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, RoutesName.setting);
//                           },
//                           icon: Icon(
//                             Icons.settings,
//                             color: Colors.grey,
//                             size: Sizes.screenHeight * 0.03,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: List.generate(
//                         chessBoardList.length,
//                             (index) {
//                           final chessBoard = chessBoardList[index];
//                           return GestureDetector(
//                             onTap: () {
//                               gameCon.initGame(chessBoard.gameType, context);
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: Sizes.screenHeight * 0.01,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     Assets.assetsDashboardImg,
//                                     height: Sizes.screenHeight * 0.15,
//                                     width: Sizes.screenHeight * 0.15,
//                                     fit: BoxFit.fill,
//                                   ),
//                                   SizedBox(width: Sizes.screenWidth * 0.03),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         chessBoard.title,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 20.0,
//                                           fontWeight: FontWeight.bold,
//                                           fontStyle: FontStyle.italic,
//                                           shadows: [
//                                             Shadow(
//                                               color: Colors.blueAccent,
//                                               offset: Offset(2, 2),
//                                               blurRadius: 4,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: Sizes.screenHeight * 0.005),
//                                       Text(
//                                         chessBoard.subtitle,
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 15.0,
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                       ),
//                                       SizedBox(height: Sizes.screenHeight * 0.005),
//                                       Image.asset(
//                                         chessBoard.image,
//                                         height: Sizes.screenHeight * 0.03,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//         ),
//
//       ),
//     );
//   }
// }
//
// class ChessBoardModel {
//   final String title;
//   final String subtitle;
//   final int gameType;
//   final String image;
//
//   ChessBoardModel({
//     required this.title,
//     required this.subtitle,
//     required this.gameType,
//     required this.image,
//   });
// }