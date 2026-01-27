import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/app_colors.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/res/text_const.dart';
import 'package:new_chess/utils/routes/routes_name.dart';
import 'package:new_chess/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int? _selectedGameType;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<QuerySnapshot> _gameHistorySubscription;
  List<DocumentSnapshot> _gameHistoryList = [];

  @override
  void initState() {
    super.initState();
    _gameHistorySubscription = _firestore
        .collection('game_history')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _gameHistoryList = snapshot.docs;
      });
    });
  }

  Stream<DocumentSnapshot> _getUserData() {
    String userId = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<void> addGameToHistory(BuildContext context, int gameType, String winnerId) async {
    _selectedGameType = gameType;
    try {
      DocumentReference newGameRoomRef = await FirebaseFirestore.instance
          .collection('game_history')
          .add({
        'userId': FirebaseAuth.instance.currentUser?.uid ?? '',
        'gameType': _selectedGameType,
        'winnerId': winnerId,
        'status': winnerId == FirebaseAuth.instance.currentUser?.uid ? 'Win' : 'Loss',
        'createdAt': FieldValue.serverTimestamp(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      Utils.show("Game History Created successfully!", context);
    } catch (e) {
      debugPrint("Error: $e");
      Utils.show("Failed to create game room: $e", context);
    }
  }
  dynamic userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChessColor.bgGrey,
      appBar: AppBar(
        backgroundColor: ChessColor.bgGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ChessColor.white,
          ),
        ),
        title: TextConst(
          title: "Profile",
          color: ChessColor.white,
          fontWeight: FontWeight.bold,
          size: Sizes.fontSizeSeven,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: ChessColor.white,
            ),
            color: ChessColor.bgGrey,
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  Navigator.pushNamed(context, RoutesName.editProfile);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text('Edit Profile', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text('Share Profile',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: Sizes.screenWidth * 0.015),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                  color: ChessColor.buttonColor,
                ));
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          }
           userData = snapshot.data!.data() as Map<String, dynamic>;
          String firstName = userData['first_name'] ?? 'N/A';
          String lastName = userData['last_name'] ?? 'N/A';
          int coinBalance = userData['coin_balance'] ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                color: ChessColor.appBarColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[700],
                      radius: 30.0,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'clara112233',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$firstName $lastName",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Row(
                          children: [
                            Image(
                              image: AssetImage(Assets.assetsIndFlag),
                              height: 25,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'India',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        TextConst(
                          title: "Joined Jan 4, 2025",
                          size: Sizes.fontSizeFour,
                          color: ChessColor.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.screenHeight * 0.02,
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.03),
                child: const TextConst(
                  title: "Wallet",
                  color: ChessColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Sizes.screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.walletHistory);
                },
                child: Container(
                  height: Sizes.screenHeight * 0.075,
                  width: Sizes.screenWidth,
                  color: ChessColor.appBarColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.screenWidth * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            padding: EdgeInsets.all(Sizes.screenHeight * 0.005),
                            child: Image(
                              image: const AssetImage(Assets.assetsCoin),
                              height: Sizes.screenHeight * 0.045,
                            ),
                          ),
                          SizedBox(width: Sizes.screenWidth * 0.03),
                          TextConst(
                            title: "Coin Balance",
                            color: ChessColor.white,
                            size: Sizes.fontSizeFive,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "$coinBalance",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: Sizes.screenHeight * 0.02,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: Sizes.screenHeight * 0.02,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Sizes.screenHeight * 0.02),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.03),
                child: const Row(
                  children: [
                    TextConst(
                      title: "Recent Games",
                      color: ChessColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ChessColor.white,
                      size: 12,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.screenHeight * 0.02,
              ),
              Container(
                height: Sizes.screenHeight * 0.08,
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(horizontal: Sizes.screenWidth * 0.04),
                color: ChessColor.appBarColor,
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: ChessColor.white,
                          size: Sizes.screenHeight * 0.03,
                        ),
                        SizedBox(width: Sizes.screenWidth * 0.03),
                        TextConst(
                          title: "Game History",
                          color: ChessColor.white,
                          size: Sizes.fontSizeFive,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Example: add the winner's ID+ when a game finishes
                        // String winnerId = FirebaseAuth.instance.currentUser!.uid;
                        // addGameToHistory(context, _selectedGameType ?? 0, winnerId);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.screenHeight * 0.02,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                color: ChessColor.appBarColor,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text("User ID",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text("Name",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text("Status",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _gameHistoryList.length,
                  itemBuilder: (context, index) {
                    var gameData = _gameHistoryList[index].data() as Map<String, dynamic>;
                    String randomId = _gameHistoryList[index].id;
                    String userId = gameData['userId'] ?? 'N/A';
                    String winnerId = gameData['winnerId'] ?? 'N/A';
                    String status = gameData['status'] ?? "In Progress";
                    // debugPrint(userData);
                    String result =  winnerId == userId
                        ? 'Win'
                        : 'Loss';
                    final myData = gameData[userData['uid']];
                    String playerName = userId == _auth.currentUser?.uid
                        ? "$firstName $lastName"
                        : 'Opponent';
                    return Container(
                      decoration: BoxDecoration(
                        color: ChessColor.appBarColor,
                        border: Border.all(color: ChessColor.white, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                myData['id'],
                                style: const TextStyle(color: ChessColor.blue, fontSize: 10),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                myData['name'],
                                style: const TextStyle(color: ChessColor.white, fontSize: 10),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                myData['status'], // Display "Win" or "Loss"
                                style: TextStyle(
                                  color: myData['status'] == 'Win' ? Colors.green : Colors.red,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          );
        },
      ),
    );
  }
}
