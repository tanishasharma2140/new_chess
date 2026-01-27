import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/app_btn.dart';
import 'package:new_chess/res/custom_textfield.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  ForgotPassword({super.key});

  void _resetPassword(context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Utils.show("Please enter your email", context);
      return;
    }

    try {
      final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        Utils.show("Email not found! Please SIGN UP first.", context);
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.show("Password reset email sent! Please check your Email!!.", context);
      await Future.delayed(const Duration(seconds: 6));
      Navigator.pop(context);

    } catch (e) {
      Utils.show("Failed to send reset email: ${e.toString()}", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.bgGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ChessColor.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ChessColor.bgGrey,
        title: TextConst(
          title: "Forget Password",
          color: ChessColor.white,
          size: Sizes.fontSizeSeven,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Sizes.screenHeight * 0.08),
              Image.asset(
                Assets.assetsChessLogo,
                height: Sizes.screenHeight * 0.1,
                width: Sizes.screenWidth * 0.5,
              ),
              SizedBox(height: Sizes.screenHeight * 0.06),
              TextConst(
                title: "Reset your password",
                size: Sizes.fontSizeSix,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
                // textAlign: TextAlign.center,
              ),
              SizedBox(height: Sizes.screenHeight * 0.04),
              CustomTextField(
                controller: emailController,
                height: Sizes.screenHeight * 0.06,
                hintText: "Enter your email",
                prefixIcon: Icons.email,
                iconColor: Colors.white.withOpacity(0.7),
                filledColor: ChessColor.bgGrey,
                focusedBorderColor: Colors.white.withOpacity(0.7),
              ),
              SizedBox(height: Sizes.screenHeight * 0.06),
              AppBtn(
                title: "Reset Password",
                onTap: () => _resetPassword(context),
              ),
              SizedBox(height: Sizes.screenHeight * 0.04),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: TextConst(
                  title: "Back to SIGN IN",
                  size: Sizes.fontSizeFour,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
