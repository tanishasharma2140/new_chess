import 'dart:async';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});
  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}
class _EmailVerificationState extends State<EmailVerification> {

  late Timer timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireBaseDataBase = FirebaseFirestore.instance;
  // int arg = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final int? argument = ModalRoute.of(context)?.settings.arguments as int?;
      print('%%%${argument}');
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if(argument!=0){
          _saveUserDataToFireBaseDatabase(context);
        }
        await _auth.currentUser?.reload();
        if (_auth.currentUser!.emailVerified == true) {
          timer.cancel();
          _updateUserDataToFireBaseDatabase(context);
        }
      });
    });
  }

  Future<void> _saveUserDataToFireBaseDatabase(context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _fireBaseDataBase.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'status': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        Utils.show("Failed to store user data: $e", context);
      }
    }
  }

  Future<void> _updateUserDataToFireBaseDatabase(context) async {
    UserViewModel userViewModel =UserViewModel();
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _fireBaseDataBase.collection('users').doc(user.uid).update({
          'status': 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        userViewModel.saveUser(user.uid);
        Navigator.pushNamed(context, RoutesName.dashboard);
      } catch (e) {
        Utils.show("Failed to store user data: $e", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.bgGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "Assets/e-pending.gif",
                height: 150,
              ),
              const SizedBox(height: 24),

              const Text(
                "Verify Your Email Address",
                style: TextStyle(
                  color: ChessColor.buttonColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "We’ve sent a verification link to your email. Please click it and verify your email address.",
                style: TextStyle(
                  color: ChessColor.white,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
