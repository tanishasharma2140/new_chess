import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnim;

  int _selectedTab = 0;

  final List<Map<String, dynamic>> _players = [
    {
      'rank': 1,
      'name': 'GrandMaster99',
      'rating': 2847,
      'wins': 342,
      'avatar': '♔',
      'badge': '🥇',
      'color': Color(0xFFFFD700),
    },
    {
      'rank': 2,
      'name': 'ChessKing_X',
      'rating': 2761,
      'wins': 298,
      'avatar': '♛',
      'badge': '🥈',
      'color': Color(0xFFC0C0C0),
    },
    {
      'rank': 3,
      'name': 'BlackPawn99',
      'rating': 2699,
      'wins': 275,
      'avatar': '♞',
      'badge': '🥉',
      'color': Color(0xFFCD7F32),
    },
    {
      'rank': 4,
      'name': 'RookMaster',
      'rating': 2645,
      'wins': 251,
      'avatar': '♜',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 5,
      'name': 'QueenSlayer',
      'rating': 2612,
      'wins': 239,
      'avatar': '♟',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 6,
      'name': 'BishopKnight',
      'rating': 2589,
      'wins': 224,
      'avatar': '♝',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 7,
      'name': 'ThunderPawn',
      'rating': 2544,
      'wins': 211,
      'avatar': '♖',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 8,
      'name': 'IceKnight42',
      'rating': 2510,
      'wins': 198,
      'avatar': '♗',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 9,
      'name': 'DarkBishop',
      'rating': 2477,
      'wins': 184,
      'avatar': '♘',
      'badge': null,
      'color': Colors.white,
    },
    {
      'rank': 10,
      'name': 'You',
      'rating': 1845,
      'wins': 87,
      'avatar': '♙',
      'badge': null,
      'color': Color(0xFF64B5F6),
      'isMe': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsBlueGradientBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          /// Header
          _topWoodenHeader(),
          const SizedBox(height: 10),

          /// Tab Row
          _buildTabRow(),
          const SizedBox(height: 10),
          _buildPodium(),
          const SizedBox(height: 8),

          Expanded(child: _buildRankList()),
        ],
      ),
    );
  }

  Widget _topWoodenHeader() {
    return Container(
      height: Sizes.screenHeight * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsWoodenTile),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        "🏆  RANKINGS",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontFamily: FontFamily.kanitReg,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTabRow() {
    final tabs = ['Global', 'Friends', 'Weekly'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                      : null,
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.kanitReg,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPodium() {
    final top3 = _players.take(3).toList();
    final order = [top3[1], top3[0], top3[2]]; // 2nd, 1st, 3rd
    final podiumBlockHeights = [55.0, 72.0, 42.0];
    final rankLabels = ['2nd', '1st', '3rd'];
    final avatarRadii = [18.0, 22.0, 16.0];
    final avatarFontSizes = [15.0, 18.0, 13.0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final player = order[i];
          return Expanded(
            child: Column(
              /// ✅ KEY FIX: mainAxisSize.min — column sirf utni height leti hai jitni chahiye
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(player['badge'], style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                CircleAvatar(
                  radius: avatarRadii[i],
                  backgroundColor: player['color'],
                  child: Text(
                    player['avatar'],
                    style: TextStyle(fontSize: avatarFontSizes[i]),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  player['name'].toString().length > 8
                      ? '${player['name'].toString().substring(0, 8)}..'
                      : player['name'],
                  style: TextStyle(
                    color: player['color'],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.kanitReg,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${player['rating']}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontFamily: FontFamily.kanitReg,
                  ),
                ),
                const SizedBox(height: 4),

                /// Podium Block
                Container(
                  height: podiumBlockHeights[i],
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      colors: i == 1
                          ? [Color(0xFFFFD700), Color(0xFFFFA000)]
                          : i == 0
                          ? [Color(0xFFB0BEC5), Color(0xFF78909C)]
                          : [Color(0xFFCD7F32), Color(0xFF8D4E00)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      rankLabels[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: FontFamily.kanitReg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRankList() {
    final rest = _players.skip(3).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: rest.length,
      itemBuilder: (context, index) => _buildRankTile(rest[index]),
    );
  }

  Widget _buildRankTile(Map<String, dynamic> player) {
    final isMe = player['isMe'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.withOpacity(0.25) : Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe ? Colors.blue.shade300 : Colors.white12,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#${player['rank']}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: (player['color'] as Color).withOpacity(0.3),
            child: Text(
              player['avatar'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              player['name'],
              style: TextStyle(
                color: player['color'],
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player['rating']}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              Text(
                '${player['wins']} wins',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
