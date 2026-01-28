import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';

class GameHistory extends StatefulWidget {
  const GameHistory({super.key});

  @override
  State<GameHistory> createState() => _GameHistoryState();
}

class _GameHistoryState extends State<GameHistory> {
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
                title: "🎯 Game History 🎯",
                size: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

              SizedBox(height: Sizes.screenHeight * 0.03),

              Container(
                width: Sizes.screenWidth * 0.92,
                height: Sizes.screenHeight * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.orangeAccent.shade200,
                    width: 2,
                  ),
                ),
                child: _historyList(),
              ),

              SizedBox(height: Sizes.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  /// STATIC LIST DATA
  Widget _historyList() {
    final history = [
      {"name": "Rohit Verma", "country": "🇮🇳", "result": "WIN", "date": "Jan 03, 2026 • 12:40 PM"},
      {"name": "Alex King", "country": "🇺🇸", "result": "LOSE", "date": "Jan 02, 2026 • 07:22 PM"},
      {"name": "Sakura Hideo", "country": "🇯🇵", "result": "DRAW", "date": "Jan 01, 2026 • 10:20 AM"},
      {"name": "Maria Lopez", "country": "🇪🇸", "result": "WIN", "date": "Dec 29, 2025 • 02:12 PM"},
      {"name": "Oliver Smith", "country": "🇬🇧", "result": "LOSE", "date": "Dec 27, 2025 • 09:33 PM"},
      {"name": "Chen Ming", "country": "🇨🇳", "result": "WIN", "date": "Dec 26, 2025 • 11:10 AM"},
      {"name": "Chen Ming", "country": "🇨🇳", "result": "LOSE", "date": "Dec 26, 2025 • 11:10 AM"},
      {"name": "Chen Ming", "country": "🇨🇳", "result": "LOSE", "date": "Dec 26, 2025 • 11:10 AM"},
      {"name": "Chen Ming", "country": "🇨🇳", "result": "WIN", "date": "Dec 26, 2025 • 11:10 AM"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: history.length,
      itemBuilder: (context, i) {
        final h = history[i];

        Color badgeColor =
        h["result"] == "WIN" ? Colors.green :
        h["result"] == "LOSE" ? Colors.red :
        Colors.amber;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
            color: Colors.white.withOpacity(0.07),
          ),
          child: Row(
            children: [
              /// AVATAR
              CircleAvatar(
                radius: 24,
                backgroundColor: ChessColor.white,
                backgroundImage: const AssetImage(Assets.iconsProfile),
              ),

              const SizedBox(width: 12),

              /// NAME + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: "${h["country"]} ${h["name"]}",
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    TextConst(
                      title: "${h["date"]}",
                      size: 13,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),

              /// RESULT BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextConst(
                  title: "${h["result"]}",
                  size: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
