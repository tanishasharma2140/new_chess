import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/repo/auth_repo.dart';
import 'package:new_chess/res/app_btn.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/custom_textfield.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  bool rememberChecked = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  Navigator.pushNamed(context, RoutesName.signUp);
                },
                child: const Align(
                    alignment: Alignment.topRight,
                    child: TextConst(
                      title: "SIGN UP",
                      color: ChessColor.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            SizedBox(
              height: Sizes.screenHeight * 0.04,
            ),
            Center(
              child: Image.asset(
                Assets.assetsChessLogo,
                height: Sizes.screenHeight * 0.08,
                width: Sizes.screenWidth * 0.4,
              ),
            ),
            SizedBox(
              height: Sizes.screenHeight * 0.045,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.screenHeight * 0.03,
                  horizontal: Sizes.screenWidth * 0.035,
                ),
                // height: Sizes.screenHeight * 0.9,
                width: Sizes.screenWidth * 0.95,
                decoration: BoxDecoration(
                  color: ChessColor.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailController,
                      height: Sizes.screenHeight * 0.06,
                      prefixIcon: Icons.person,
                      iconColor: Colors.white.withOpacity(0.5),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
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
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      filledColor: ChessColor.bgGrey,
                      focusedBorderColor: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.01),
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
                          title: 'Remember me',
                          color: ChessColor.white,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesName.forgotPass);
                          },
                          child: const TextConst(
                            title: 'Forget Password?',
                            color: ChessColor.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.06),
                    AppBtn(
                        title: "Sign In",
                        onTap: () {
                          if (emailController.text.isEmpty) {
                            Utils.show("Please Enter Email", context);
                          } else if (passwordController.text.isEmpty) {
                            Utils.show("Please Enter Password", context);
                          } else if (!rememberChecked) {
                            Utils.show("Please accept the T&C and Privacy Policy",
                                context);
                          } else {
                            _signIn(context);
                          }
                        }),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextConst(
                            title: "OR",
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.03),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ChessColor.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.assetsGoogleLogo,
                            height: Sizes.screenHeight * 0.09,
                            width: Sizes.screenWidth * 0.15,
                          ),
                          const SizedBox(width: 30),
                          TextConst(
                            title: 'Log in with Google',
                            fontWeight: FontWeight.bold,
                            size: Sizes.fontSizeSix,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn(context) async {
    String email = emailController.text;
    String password = passwordController.text;
    UserViewModel userViewModel = UserViewModel();

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var status = userDoc['status'];
          if (status == 0) {
            user.sendEmailVerification();
            Navigator.pushNamed(context, RoutesName.emailVerify,arguments: 0);
          } else {
            userViewModel.saveUser(user.uid);
            Navigator.pushNamed(context, RoutesName.dashboard);
          }
        } else {
          Utils.show("User data not found. Please try again.", context);
        }
      } else {
        Utils.show("Provided credentials don't match", context);
      }
    } catch (e) {
      Utils.show("Error: ${e.toString()}", context);
    }
  }
}
