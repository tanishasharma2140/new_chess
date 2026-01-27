import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:new_chess/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late StreamSubscription<DocumentSnapshot> _walletBalanceSubscription;
  late StreamSubscription<QuerySnapshot> _transactionSubscription;

  String _walletBalance = "0";
  List<DocumentSnapshot> _transactions = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isNotEmpty) {
      _walletBalanceSubscription = _firestore.collection("users").doc(userId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            _walletBalance = snapshot.data()?["wallet_balance"].toString() ?? "0";
          });
        }
      });
      _transactionSubscription = _firestore.collection("wallet_history")
          .orderBy("date", descending: true)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _transactions = snapshot.docs;
        });
      });
    }
  }
  @override
  void dispose() {
    _walletBalanceSubscription.cancel();
    _transactionSubscription.cancel();
    super.dispose();
  }

  Future<void> _addTransaction(String amount) async {
    if (amount.isEmpty) return;
    int value = int.tryParse(amount) ?? 0;
    if (value <= 0) return;

    String userId = _auth.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    DocumentReference userDoc = _firestore.collection("users").doc(userId);

    await _firestore.collection("wallet_history").add({
      "title": "Deposit",
      "amount": "+$amount Coins",
      "date": DateTime.now().toLocal().toString().substring(0, 10),
      "userId": userId,
    });

    await userDoc.update({
      "wallet_balance": FieldValue.increment(value),
    });
    Navigator.pop(context);
    _amountController.clear();
  }
  void _showAddBalanceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: ChessColor.bgGrey,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: Sizes.screenWidth * 0.04,
                right: Sizes.screenWidth * 0.04,
                top: Sizes.screenHeight * 0.02,
                bottom: MediaQuery.of(context).viewInsets.bottom + Sizes.screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(image: AssetImage(Assets.assetsAddCoins), height: 30),
                        SizedBox(width: Sizes.screenWidth * 0.02),
                        const Text(
                          "Add Coins",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ChessColor.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextConst(
                      title: "Enter Amount min-10 & max-50",
                      color: ChessColor.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Coins",
                        hintStyle: const TextStyle(color: ChessColor.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.monetization_on, color: ChessColor.white),
                        filled: true,
                        fillColor: ChessColor.buttonColor.withOpacity(0.3),
                      ),
                      style: const TextStyle(color: ChessColor.white),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        counterText: "",
                        hintStyle: const TextStyle(color: ChessColor.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.phone, color: ChessColor.white),
                        filled: true,
                        fillColor: ChessColor.buttonColor.withOpacity(0.3),
                      ),
                      maxLength: 10,
                      style: const TextStyle(color: ChessColor.white),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Remark",
                        hintStyle: const TextStyle(color: ChessColor.white),
                        suffixIcon: Padding(
                          padding:  EdgeInsets.symmetric(vertical: Sizes.screenHeight*0.02,horizontal: Sizes.screenWidth*0.035),
                          child:const TextConst(title: "(Optional)",color: ChessColor.white,),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.gpp_good, color: ChessColor.white),
                        filled: true,
                        fillColor: ChessColor.buttonColor.withOpacity(0.3),
                      ),
                      style: const TextStyle(color: ChessColor.white),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ChessColor.buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          if(_amountController.text.isEmpty){
                            Utils.show("Enter Amount", context);
                          } else if(phoneController.text.isEmpty){
                            Utils.show("Enter Phone Number... this field is required", context);
                          }else{
                            print("🔹 Add Coins button tapped!");
                            print("Entered Amount: ${_amountController.text}");
                            _addTransaction(_amountController.text);
                            // _openPaymentUrl(_amountController.text);
                          }

                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Text(
                            "Add Coins",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ChessColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Sizes.screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -45,
              right: 160,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: ChessColor.bgGrey,
                    border: Border.all(color: ChessColor.buttonColor),
                  ),
                  child: const Icon(Icons.close, color: ChessColor.yellow, size: 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.appBarColor,
      appBar: AppBar(
        backgroundColor: ChessColor.bgGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: ChessColor.white),
        ),
        title: TextConst(
          title: "Wallet History",
          color: ChessColor.white,
          fontWeight: FontWeight.bold,
          size: Sizes.fontSizeSeven,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          walletBalanceCard(_walletBalance),
          Expanded(child: _buildTransactionList()),
        ],
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddBalanceSheet,
          label: const Text("Add", style: TextStyle(color: ChessColor.white)),
          icon: const Icon(Icons.add, color: ChessColor.white, size: 15),
          backgroundColor: ChessColor.buttonColor,
        ),
    );
  }
  Widget walletBalanceCard(String balance) {
    return Container(
      width: Sizes.screenWidth * 0.45,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(vertical: Sizes.screenHeight * 0.02, horizontal: Sizes.screenWidth * 0.02),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [ChessColor.blue, ChessColor.buttonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage(Assets.assetsAddCoins), height: 50),
              Text(" $balance", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
      return const Center(child: Text("No transactions found", style: TextStyle(color: ChessColor.white)));
    }
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        var transaction = _transactions[index];
        return Container(
          height: Sizes.screenHeight * 0.08,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: ChessColor.buttonColor),
            title: Text(transaction["title"], style: const TextStyle(fontWeight: FontWeight.bold, color: ChessColor.white)),
            subtitle: Text(transaction["date"], style: const TextStyle(color: ChessColor.black)),
            trailing: Text(transaction["amount"], style: const TextStyle(fontSize: 16, color: ChessColor.buttonColor)),
          ),
        );
      },
    );
  }

  // Future<void> _openPaymentUrl(String amount) async {
  //   try {
  //     final userId = UserViewModel().getUser();
  //     if (userId.toString().isEmpty) {
  //       print("User ID is empty!");
  //       return;
  //     }
  //     String paymentLink = response["payment_link"] ?? "";
  //
  //     if (paymentLink.isEmpty) {
  //       print("Payment link is empty!");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Payment link is not available")),
  //       );
  //       return;
  //     }
  //     if (await canLaunchUrl(Uri.parse(paymentLink))) {
  //       print("Launching URL...");
  //       await launchUrl(Uri.parse(paymentLink), mode: LaunchMode.externalApplication);
  //     } else {
  //       print("Could not launch URL!");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Could not open payment URL")),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error launching URL: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );
  //   }
  // }


  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

}




//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:new_chess/generated/assets.dart';
// import 'package:new_chess/res/app_colors.dart';
// import 'package:new_chess/res/sizing_const.dart';
// import 'package:new_chess/res/text_const.dart';
// import 'package:flutter/material.dart';
//
// class WalletHistory extends StatefulWidget {
//   const WalletHistory({super.key});
//
//   @override
//   State<WalletHistory> createState() => _WalletHistoryState();
// }
//
// class _WalletHistoryState extends State<WalletHistory> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _amountController = TextEditingController();
//
//   Future<void> _addTransaction(String amount) async {
//     if (amount.isEmpty) return;
//
//     int value = int.tryParse(amount) ?? 0;
//     if (value <= 0) return;
//
//     await _firestore.collection("wallet_history").add({
//       "title": "Deposit",
//       "amount": "+$amount Coins",
//       "date": DateTime.now().toLocal().toString().substring(0, 10),
//     });
//
//     Navigator.pop(context);
//     _amountController.clear();
//   }
//
//   Widget _buildTransactionList() {
//     return StreamBuilder(
//       stream: _firestore.collection("wallet_history").orderBy("date", descending: true).snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No transactions found", style: TextStyle(color: ChessColor.white)));
//         }
//
//         var transactions = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             var transaction = transactions[index];
//             return Container(
//               height: Sizes.screenHeight * 0.08,
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.account_balance_wallet, color: ChessColor.buttonColor),
//                 title: Text(transaction["title"], style: const TextStyle(fontWeight: FontWeight.bold, color: ChessColor.white)),
//                 subtitle: Text(transaction["date"], style: const TextStyle(color: ChessColor.black)),
//                 trailing: Text(transaction["amount"], style: const TextStyle(fontSize: 16, color: ChessColor.buttonColor)),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showAddBalanceSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       backgroundColor: ChessColor.bgGrey,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: Sizes.screenWidth * 0.04,
//             right: Sizes.screenWidth * 0.04,
//             top: Sizes.screenHeight * 0.02,
//             bottom: MediaQuery.of(context).viewInsets.bottom + Sizes.screenHeight * 0.02,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Title Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Image(image: AssetImage(Assets.assetsAddCoins), height: 30),
//                     SizedBox(width: Sizes.screenWidth * 0.02),
//                     const Text("Add Coins", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ChessColor.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//
//                 // Text Field
//                 TextField(
//                   controller: _amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: "Enter Coins",
//                     hintStyle: const TextStyle(color: ChessColor.white),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     prefixIcon: const Icon(Icons.monetization_on, color: ChessColor.white),
//                     filled: true,
//                     fillColor: ChessColor.buttonColor.withOpacity(0.3),
//                   ),
//                   style: const TextStyle(color: ChessColor.white),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Add Coins Button
//                 Container(
//                   width: double.infinity,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: ChessColor.buttonColor,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () => _addTransaction(_amountController.text),
//                     borderRadius: BorderRadius.circular(12),
//                     child: const Center(
//                       child: Text("Add Coins", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ChessColor.white)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ChessColor.appBarColor,
//       appBar: AppBar(
//         backgroundColor: ChessColor.bgGrey,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back, color: ChessColor.white),
//         ),
//         title: TextConst(
//           title: "Wallet History",
//           color: ChessColor.white,
//           fontWeight: FontWeight.bold,
//           size: Sizes.fontSizeSeven,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(colors: [ChessColor.blue, ChessColor.buttonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
//             ),
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
//                 SizedBox(height: 5),
//                 Text("₹ 2,500", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//           Expanded(child: _buildTransactionList()),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showAddBalanceSheet,
//         label: const Text("Add", style: TextStyle(color: ChessColor.white)),
//         icon: const Icon(Icons.add, color: ChessColor.white, size: 15),
//         backgroundColor: ChessColor.buttonColor,
//       ),
//     );
//   }
// } total balance me jitta wallet me balance ho uttadikhaye