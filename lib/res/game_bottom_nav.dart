import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/view/bottom_bar/leader_board.dart';
import 'package:new_chess/view/bottom_bar/prize.dart';
import 'package:new_chess/view/bottom_bar/setting.dart';
import 'package:new_chess/view/dashboard_page.dart';

class MainRoot extends StatefulWidget {
  const MainRoot({super.key});

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  int selectedIndex = 2;

  final List<Widget> pages = const [
    Setting(),
    LeaderBoard(),
    Dashboard(),
    Prize(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: pages,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: GameBottomNav(
              selectedIndex: selectedIndex,
              onTabChange: (i) {
                setState(() => selectedIndex = i);
              },
            ),
          )
        ],
      ),
    );
  }
}

class GameBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const GameBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 4;
    double baseHeight = 70;
    double topExtra = 20;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        children: List.generate(4, (i) => _navItem(i, w, baseHeight, topExtra)),
      ),
    );
  }

  Widget _navItem(int index, double width, double baseHeight, double topExtra) {
    bool isSelected = selectedIndex == index;
    double iconSize = isSelected ? 40 : 28;

    return GestureDetector(
      onTap: () => onTabChange(index),
      child: SizedBox(
        width: width,
        height: baseHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: isSelected ? -topExtra : 0,
              child: SizedBox(
                width: width,
                height: baseHeight + (isSelected ? topExtra : 0),
                child: Image.asset(
                  isSelected ? Assets.iconsTriangle : Assets.iconsButton,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: baseHeight / 2 - iconSize / 2,
              child: Image.asset(
                _icon(index),
                width: iconSize,
                height: iconSize,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _icon(int index) {
    switch (index) {
      case 0: return Assets.iconsSetting;
      case 1: return Assets.iconsLeaderBoard;
      case 2: return Assets.iconsHome;
      case 3: return Assets.iconsAchivements;
      default: return Assets.iconsHome;
    }
  }
}


