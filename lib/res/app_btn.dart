import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:flutter/material.dart';
import '../generated/assets.dart';
import 'font_family.dart';



class AppBtn extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isLoading;

  const AppBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: Sizes.screenHeight * 0.1,
        padding: const EdgeInsets.only(bottom: 8),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsConstButton),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ?  const CircularProgressIndicator(color: ChessColor.white,)
       : TextConst(
          title: title,
          color: ChessColor.white,
          fontFamily: FontFamily.robotoBlack,
          size: 22,
        ),
      ),
    );
  }
}
