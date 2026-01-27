import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class Launcher {
  // static launchWhatsApp(context, String phone) async {
  //   var whatsAppUrlAndroid = 'whatsapp://send?phone=+91$phone&text=hello';
  //   if (await canLaunchUrl(Uri.parse(whatsAppUrlAndroid))) {
  //     await launchUrl(Uri.parse(whatsAppUrlAndroid));
  //   } else {
  //     Utils.showErrorMessage(context, "Whatsapp not installed");
  //   }
  // }

  // static launchDialPad(context, String phone) async {
  //   var phoneCall = "tel:$phone";
  //   if (await canLaunchUrl(Uri.parse(phoneCall))) {
  //     await launchUrl(Uri.parse(phoneCall));
  //   } else {
  //     Utils.showErrorMessage(context, "Number Busy");
  //   }
  // }
  //
  // static launchEmail(context, String email) async {
  //   var callEmail = "mailto:$email";
  //   if (await canLaunchUrl(Uri.parse(callEmail))) {
  //     await launchUrl(Uri.parse(callEmail));
  //   } else {
  //     Utils.showErrorMessage(context, "email not login");
  //   }
  // }
  //
  // static launchOnWeb(context, String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     if (kDebugMode) {
  //       print("Url not found");
  //     }
  //   }
  // }

  // static shareApk(String urlData, context) async {
  //   if (urlData.isNotEmpty) {
  //     await Share.share(
  //       "Hi, I recommend Courier for mini trucks requirement. It's convenient & cost effective. Download app ${Uri.parse(urlData)} & get up to Rs 50 cashback on first ride.",
  //     );
  //   } else {
  //     if (kDebugMode) {
  //       print('Inter Url');
  //     }
  //   }
  // }
  static shareApk(String gameRoomId, context) async {
    if (gameRoomId.isNotEmpty) {
      await Share.share(
          "Hey, join me in an exciting chess game! Use this game room ID: $gameRoomId to start the match and show off your skills. Let's play and have fun!😎😎"
      );
    } else {
      if (kDebugMode) {
        print('Game Room ID is empty');
      }
    }
  }

}
