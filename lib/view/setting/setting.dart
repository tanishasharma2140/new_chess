import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.bgGrey,
      appBar: AppBar(
        backgroundColor: ChessColor.appBarColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ChessColor.white,
            )),
        centerTitle: true,
        title: TextConst(
          title: "Setting",
          color: ChessColor.white,
          size: Sizes.fontSizeEight,
        ),
      ),
      body: Container(
        width: Sizes.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsDashboardBackground),
           fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.screenWidth * 0.05,
              vertical: Sizes.screenHeight * 0.02),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.profile);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.only(),
                  leading: const Image(
                    image: AssetImage(Assets.assetsProfile),
                    height: 25,
                  ),
                  title: TextConst(
                    title: "Profile",
                    color: ChessColor.white,
                    size: Sizes.fontSizeSix,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: Sizes.screenWidth * 0.0005,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(),
                leading: const Image(
                  image: AssetImage(Assets.assetsMessage),
                  height: 25,
                ),
                title: TextConst(
                  title: "Message",
                  color: ChessColor.white,
                  size: Sizes.fontSizeSix,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: Sizes.screenWidth * 0.0005,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(),
                leading: const Image(
                  image: AssetImage(Assets.assetsStar),
                  height: 25,
                ),
                title: TextConst(
                  title: "Rate this App",
                  color: ChessColor.white,
                  size: Sizes.fontSizeSix,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: Sizes.screenWidth * 0.0005,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            ChessColor.appBarColor,
                        title: TextConst(
                          title: "Log Out",
                          color: ChessColor.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontFamily.robotoBlack,
                          size: Sizes.fontSizeEight,
                        ),
                        content: TextConst(
                          title: "Are you sure you want to log out?",
                          color: ChessColor.white,
                          size: Sizes.fontSizeSix,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              UserViewModel userViewModel = UserViewModel();
                              userViewModel.remove();
                              Navigator.pushReplacementNamed(
                                  context, RoutesName.signIn);
                            },
                            child: const TextConst(
                              title: "Yes",
                              color: ChessColor.buttonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const TextConst(
                              title: "No",
                              color: ChessColor.buttonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.only(),
                  leading: const Image(
                    image: AssetImage(Assets.assetsLogOut),
                    height: 25,
                  ),
                  title: TextConst(
                    title: "LogOut",
                    color: ChessColor.white,
                    size: Sizes.fontSizeSix,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: Sizes.screenWidth * 0.0005,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
