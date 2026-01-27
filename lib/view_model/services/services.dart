import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Services{
  Future<String?> getUserData() => UserViewModel().getUser();
  void checkAuthentication(context) async {
    // UserViewModel().remove();
    getUserData().then((value) async {
      if (kDebugMode) {
        print(value.toString());
        print('valueId');
      }
      if (value == null || value == '') {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, RoutesName.signIn);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, RoutesName.dashboard);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}