import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: Sizes.screenWidth,
          height: Sizes.screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.boardBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: Sizes.screenHeight * 0.06),

              /// TITLE
              const TextConst(
                title: "💎 Leader Board 💎",
                size: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

              SizedBox(height: Sizes.screenHeight * 0.03),

              Container(
                width: Sizes.screenWidth * 0.92,
                height: Sizes.screenHeight * 0.73,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blueAccent.shade200,
                    width: 2,
                  ),
                ),
                child: _leaderList(),
              ),

              SizedBox(height: Sizes.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  /// Leader List Widget
  Widget _leaderList() {
    final players = [
      {"rank": 1, "name": "Tanisha Sharma", "country": "🇮🇳", "rating": 2400},
      {"rank": 2, "name": "Rohit Verma", "country": "🇮🇳", "rating": 2100},
      {"rank": 3, "name": "Alex King", "country": "🇺🇸", "rating": 1980},
      {"rank": 4, "name": "Sakura Hideo", "country": "🇯🇵", "rating": 1900},
      {"rank": 5, "name": "Maria Lopez", "country": "🇪🇸", "rating": 1850},
      {"rank": 6, "name": "Oliver Smith", "country": "🇬🇧", "rating": 1800},
      {"rank": 7, "name": "Chen Ming", "country": "🇨🇳", "rating": 1750},
      {"rank": 8, "name": "Kunal Patil", "country": "🇮🇳", "rating": 1720},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: players.length,
      itemBuilder: (context, i) {
        final p = players[i];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
            color: Colors.white.withOpacity(0.07),
          ),
          child: Row(
            children: [
              TextConst(
                title: "${p["rank"]}.",
                size: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade300,
              ),
              const SizedBox(width: 10),
              TextConst(
                title: "${p["country"]} ${p["name"]}",
                size: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              const Spacer(),
              TextConst(
                title: "${p["rating"]}",
                size: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
