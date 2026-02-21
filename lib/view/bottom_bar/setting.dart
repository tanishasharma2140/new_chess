import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/view/game_history.dart';
import 'package:new_chess/view/terms_of_services.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// PROFILE
                _glass(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage(Assets.boardChess),
                      ),
                      const SizedBox(height: 12),

                      /// Name
                      const TextConst(
                        title: "Tanisha Sharma",
                        size: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 4),

                      /// Country
                      TextConst(
                        title: "India 🇮🇳",
                        size: 14,
                        color: Colors.white.withOpacity(0.75),
                      ),

                      const SizedBox(height: 8),

                      /// Rating Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                          color: Colors.white.withOpacity(0.12),
                        ),
                        child: const TextConst(
                          title: "Rating: 1240",
                          size: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// ACCOUNT
                _sectionTitle("Account"),
                const SizedBox(height: 12),
                _optionTile("Edit Profile"),
                _optionTile("Change Password"),
                _optionTile("Privacy & Security"),
                GestureDetector(
                    onTap: (){
                      // Navigator.push(context, CupertinoPageRoute(builder: (context)=> GameHistory()));
                    },
                    child: _optionTile("Game History")),

                const SizedBox(height: 32),

                /// SUPPORT
                _sectionTitle("Support"),
                const SizedBox(height: 12),
                _optionTile("Help & FAQ"),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> TermsOfServices()));
                    },
                    child: _optionTile("Terms of Service")),
                _optionTile("Contact Support"),

                const SizedBox(height: 40),

                /// LOGOUT
                _glass(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: TextConst(
                      title: "LOG OUT",
                      size: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// GLASS BASE
Widget _glass({required Widget child, EdgeInsetsGeometry? padding}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.22),
              Colors.white.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    ),
  );
}

/// SECTION TITLE (with TextConst)
Widget _sectionTitle(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: TextConst(
      title: title,
      size: 17,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}

/// OPTION TILE (with TextConst)
Widget _optionTile(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: _glass(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextConst(title: title, size: 15, color: Colors.white),
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6)),
        ],
      ),
    ),
  );
}
