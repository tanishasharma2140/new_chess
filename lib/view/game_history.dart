import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';

class GameHistoryPage extends StatelessWidget {
  const GameHistoryPage({super.key});

  static const List<Map<String, dynamic>> _history = [
    {
      'opponent': 'GrandMaster99',
      'opponentAvatar': '♔',
      'result': 'Win',
      'rating': '+12',
      'moves': 42,
      'duration': '18m',
      'date': 'Today',
      'opening': 'Sicilian Defense',
    },
    {
      'opponent': 'RookMaster',
      'opponentAvatar': '♜',
      'result': 'Loss',
      'rating': '-8',
      'moves': 31,
      'duration': '12m',
      'date': 'Today',
      'opening': "Queen's Gambit",
    },
    {
      'opponent': 'BlackPawn99',
      'opponentAvatar': '♞',
      'result': 'Win',
      'rating': '+14',
      'moves': 57,
      'duration': '24m',
      'date': 'Yesterday',
      'opening': 'Italian Game',
    },
    {
      'opponent': 'QueenSlayer',
      'opponentAvatar': '♟',
      'result': 'Draw',
      'rating': '+2',
      'moves': 68,
      'duration': '31m',
      'date': 'Yesterday',
      'opening': 'Ruy Lopez',
    },
    {
      'opponent': 'IceKnight42',
      'opponentAvatar': '♗',
      'result': 'Win',
      'rating': '+10',
      'moves': 39,
      'duration': '15m',
      'date': '2 days ago',
      'opening': 'Kings Indian',
    },
    {
      'opponent': 'DarkBishop',
      'opponentAvatar': '♘',
      'result': 'Loss',
      'rating': '-6',
      'moves': 25,
      'duration': '9m',
      'date': '2 days ago',
      'opening': 'French Defense',
    },
    {
      'opponent': 'ThunderPawn',
      'opponentAvatar': '♖',
      'result': 'Win',
      'rating': '+11',
      'moves': 44,
      'duration': '19m',
      'date': '3 days ago',
      'opening': 'Sicilian Defense',
    },
    {
      'opponent': 'ChessKing_X',
      'opponentAvatar': '♛',
      'result': 'Loss',
      'rating': '-9',
      'moves': 35,
      'duration': '14m',
      'date': '4 days ago',
      'opening': 'Caro-Kann',
    },
    {
      'opponent': 'BishopKnight',
      'opponentAvatar': '♝',
      'result': 'Win',
      'rating': '+13',
      'moves': 51,
      'duration': '22m',
      'date': '5 days ago',
      'opening': 'English Opening',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No default AppBar — full custom
      backgroundColor: Colors.transparent,
      body: Container(
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
            _woodenHeader(context),
            const SizedBox(height: 10),
            _buildSummaryRow(),
            const SizedBox(height: 10),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ── WOODEN HEADER with back button ───────────────────────────────────────────
  Widget _woodenHeader(BuildContext context) {
    return Container(
      height: Sizes.screenHeight * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsWoodenTile),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back button — left side
            Positioned(
              left: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Title — center
            const Text(
              "📋  GAME HISTORY",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: FontFamily.kanitReg,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(2, 2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── W/L/D SUMMARY ROW ────────────────────────────────────────────────────────
  Widget _buildSummaryRow() {
    int wins = _history.where((g) => g['result'] == 'Win').length;
    int losses = _history.where((g) => g['result'] == 'Loss').length;
    int draws = _history.where((g) => g['result'] == 'Draw').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _summaryChip('${wins}W', Colors.greenAccent),
          const SizedBox(width: 8),
          _summaryChip('${losses}L', Colors.redAccent),
          const SizedBox(width: 8),
          _summaryChip('${draws}D', Colors.white54),
          const Spacer(),
          Text(
            '${_history.length} games',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: FontFamily.kanitReg,
        ),
      ),
    );
  }

  // ── LIST ─────────────────────────────────────────────────────────────────────
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _history.length,
      itemBuilder: (context, index) => _buildTile(_history[index]),
    );
  }

  Widget _buildTile(Map<String, dynamic> game) {
    final bool isWin = game['result'] == 'Win';
    final bool isDraw = game['result'] == 'Draw';
    final Color resultColor = isWin
        ? Colors.greenAccent
        : isDraw
        ? Colors.white54
        : Colors.redAccent;
    final Color ratingColor = (game['rating'] as String).startsWith('+')
        ? Colors.greenAccent
        : isDraw
        ? Colors.white54
        : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: resultColor.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Color bar
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white10,
            child: Text(
              game['opponentAvatar'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game['opponent'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: FontFamily.kanitReg,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${game['opening']}  •  ${game['moves']} moves  •  ${game['duration']}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontFamily: FontFamily.kanitReg,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Result + rating + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: resultColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  game['result'],
                  style: TextStyle(
                    color: resultColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    fontFamily: FontFamily.kanitReg,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                game['rating'],
                style: TextStyle(
                  color: ratingColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              Text(
                game['date'],
                style: const TextStyle(
                  color: Colors.white30,
                  fontSize: 9,
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