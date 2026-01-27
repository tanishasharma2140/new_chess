import 'package:new_chess/repo/auth_repo.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_btn.dart';
import 'package:new_chess/res/custom_textfield.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool rememberChecked = true;
  bool isLoading = false;

  final FirebaseAuthServices _auth = FirebaseAuthServices();
  // final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ChessColor.bgGrey,
        body: Column(
          children: [
            SizedBox(
              height: Sizes.screenHeight * 0.055,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.signIn);
                },
                child: const Align(
                  alignment: Alignment.topRight,
                  child: TextConst(
                    title: "SIGN IN",
                    color: ChessColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Sizes.screenHeight * 0.05,
            ),
            Center(
              child: Image.asset(
                Assets.assetsChessLogo,
                height: Sizes.screenHeight * 0.08,
                width: Sizes.screenWidth * 0.4,
              ),
            ),
            SizedBox(
              height: Sizes.screenHeight * 0.055,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.screenHeight * 0.03,
                  horizontal: Sizes.screenWidth * 0.035,
                ),
                width: Sizes.screenWidth * 0.95,
                decoration: BoxDecoration(
                  color: ChessColor.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // CustomTextField(
                    //   controller: userNameController,
                    //   height: Sizes.screenHeight * 0.06,
                    //   prefixIcon: Icons.person,
                    //   iconColor: Colors.white.withOpacity(0.5),
                    //   hintText: "User Name",
                    //   hintStyle:
                    //   TextStyle(color: Colors.white.withOpacity(0.5)),
                    //   filledColor: ChessColor.bgGrey,
                    //   focusedBorderColor: Colors.white.withOpacity(0.5),
                    // ),
                    // SizedBox(height: Sizes.screenHeight * 0.02),
                    CustomTextField(
                      controller: emailController,
                      height: Sizes.screenHeight * 0.06,
                      prefixIcon: Icons.email,
                      iconColor: Colors.white.withOpacity(0.5),
                      hintText: "Email",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      filledColor: ChessColor.bgGrey,
                      focusedBorderColor: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    CustomTextField(
                      controller: passwordController,
                      height: Sizes.screenHeight * 0.06,
                      prefixIcon: Icons.lock,
                      iconColor: Colors.white.withOpacity(0.5),
                      hintText: "Password",
                      obscureText: true,
                      suffixIcon: Icons.remove_red_eye,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      filledColor: ChessColor.bgGrey,
                      focusedBorderColor: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    CustomTextField(
                      controller: confirmPasswordController,
                      height: Sizes.screenHeight * 0.06,
                      prefixIcon: Icons.lock,
                      iconColor: Colors.white.withOpacity(0.5),
                      hintText: "Confirm Password",
                      obscureText: true,
                      suffixIcon: Icons.remove_red_eye,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      filledColor: ChessColor.bgGrey,
                      focusedBorderColor: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              rememberChecked = !rememberChecked;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: rememberChecked
                                  ? ChessColor.buttonColor
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: rememberChecked
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const TextConst(
                          title: 'I Agree to the',
                          color: ChessColor.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const TextConst(
                          title: 'T&C',
                          color: ChessColor.blue,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const TextConst(
                          title: 'and',
                          color: ChessColor.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const TextConst(
                          title: 'Privacy Policy',
                          color: ChessColor.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.06),
                    AppBtn(
                      title: "Sign Up",
                      isLoading: isLoading,
                      onTap: () {
                      if (emailController.text.isEmpty) {
                          Utils.show("Enter Your Email", context);
                        } else if (passwordController.text.isEmpty) {
                          Utils.show("Enter Password", context);
                        } else if (confirmPasswordController.text.isEmpty) {
                          Utils.show("Enter Confirm Password", context);
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          Utils.show("Passwords do not match", context);
                        } else if (!rememberChecked) {
                          Utils.show("Please accept the T&C and Privacy Policy",
                              context);
                        } else {
                          _signUp(context);
                        }
                      },
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp(context) async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      user.sendEmailVerification();
      Navigator.pushNamed(context, RoutesName.emailVerify,arguments: 1);
    } else {
      debugPrint("Some Error Occur");
    }
  }

}
