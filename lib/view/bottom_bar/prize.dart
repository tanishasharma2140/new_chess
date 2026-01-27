import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';

class Prize extends StatefulWidget {
  const Prize({super.key});

  @override
  State<Prize> createState() => _PrizeState();
}

class _PrizeState extends State<Prize> {
  final List<Map<String, dynamic>> achievements = [
    {
      "icon": Icons.emoji_events,
      "title": "First Victory",
      "desc": "Win your first game",
      "progress": 1.0,
      "unlocked": true,
    },
    {
      "icon": Icons.star,
      "title": "Rising Player",
      "desc": "Reach rating 1500",
      "progress": 0.7,
      "unlocked": false,
    },
    {
      "icon": Icons.local_fire_department,
      "title": "Win Streak",
      "desc": "Win 5 games in a row",
      "progress": 0.4,
      "unlocked": false,
    },
    {
      "icon": Icons.shield,
      "title": "Defender",
      "desc": "Draw 3 consecutive games",
      "progress": 0.1,
      "unlocked": false,
    },
  ];

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
              const TextConst(
                title: "🏆 Achievements 🏆",
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
                child: _achievementList(),
              ),

              SizedBox(height: Sizes.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _achievementList() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _achievementCard(achievements[index]);
      },
    );
  }

  Widget _achievementCard(Map<String, dynamic> a) {
    IconData icon = a["icon"] as IconData;
    String title = a["title"];
    String desc = a["desc"];
    double progress = a["progress"];
    bool unlocked = a["unlocked"];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(
          color: unlocked ? Colors.yellow.shade300 : Colors.white24,
          width: 1.3,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 38,
            color: unlocked ? Colors.yellow.shade300 : Colors.white38,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: title,
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 3),
                TextConst(
                  title: desc,
                  size: 13,
                  color: Colors.white70,
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(
                    unlocked ? Colors.yellow.shade300 : Colors.white30,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          Icon(
            unlocked ? Icons.check_circle : Icons.lock,
            color: unlocked ? Colors.greenAccent : Colors.white24,
            size: 22,
          ),
        ],
      ),
    );
  }
}
