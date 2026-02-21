import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/view/home_page.dart';
import 'package:new_chess/view/leader_board_page.dart';
import 'package:new_chess/view/profile_page.dart';
import 'package:new_chess/view/setting_page.dart';
import 'package:new_chess/view/shop_page.dart';

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
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: pages[selectedIndex],
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90, // 100 se kam karo
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsBottomNavImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, Assets.assetsBottomHome, "Home"),
          _navItem(1, Assets.assetsBottomLeaderboard, "LeaderBoard"),
          _navItem(2, Assets.assetsShop, "Shop"),
          _navItem(3, Assets.assetsBottomSetting, "More"),
        ],
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
          ..scale(isSelected ? 1.08 : 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isSelected ? 28 : 24,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),

            // const SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.amber,
                fontSize: isSelected ? 14 : 13,
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





class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("More Page",style: TextStyle(color: Colors.white),));
  }
}