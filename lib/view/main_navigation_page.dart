import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/view/home_page.dart';
import 'package:new_chess/view/leader_board_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {

  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    LeaderBoardPage(),
    ShopPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: pages[selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsBottomNavImage),
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(0, Assets.assetsBottomHome, "Home"),
            _navItem(1, Assets.assetsBottomLeaderboard, "LeaderBoard"),
            _navItem(2, Assets.assetsShop, "Shop"),
            _navItem(3, Assets.assetsBottomSetting, "More"),
          ],
        ),
      ),
    );
  }
  Widget _navItem(int index, String imagePath, String title) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.08 : 1.0), // 👈 subtle scale
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isSelected ? 30 : 28, // 👈 very small size change
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.amber,
                fontSize: isSelected ? 15 : 14, // 👈 slight text change
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}



class ShopPage extends StatelessWidget {
  const ShopPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Shop Page",style: TextStyle(color: Colors.white),));
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("More Page",style: TextStyle(color: Colors.white),));
  }
}