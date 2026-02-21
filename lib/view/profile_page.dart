import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Map<String, dynamic> _user = {
    'name': 'You',
    'username': '@chess_legend',
    'avatar': '♙',
    'rating': 1845,
    'rank': 10,
    'wins': 87,
    'losses': 34,
    'draws': 12,
    'winStreak': 5,
    'totalGames': 133,
    'coins': 4250,
    'level': 14,
    'xp': 720,
    'xpMax': 1000,
    'joinDate': 'Jan 2024',
    'country': '🇮🇳 India',
  };

  @override
  Widget build(BuildContext context) {
    final int wins = _user['wins'] as int;
    final int losses = _user['losses'] as int;
    final int draws = _user['draws'] as int;
    final int total = _user['totalGames'] as int;
    final double winRate = total > 0 ? wins / total : 0;

    return Scaffold(
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
            _topWoodenHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    // ── Avatar Card ───────────────────────────────────────────
                    _avatarCard(),
                    const SizedBox(height: 12),
      
                    // ── Stats Row ─────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: '⭐',
                            label: 'Rating',
                            value: '${_user['rating']}',
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                            icon: '🏅',
                            label: 'Global Rank',
                            value: '#${_user['rank']}',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _statCard(
                            icon: '🪙',
                            label: 'Coins',
                            value: '${_user['coins']}',
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
      
                    // ── Game Stats ────────────────────────────────────────────
                    _gameStatsCard(wins, losses, draws, total, winRate),
                    const SizedBox(height: 12),
      
                    // ── Win Streak ────────────────────────────────────────────
                    _winStreakCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────────────────────────
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
        "♟  PROFILE",
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
                offset: Offset(2, 2)),
          ],
        ),
      ),
    );
  }

  // ── AVATAR CARD ──────────────────────────────────────────────────────────────
  Widget _avatarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor:
                const Color(0xFF64B5F6).withOpacity(0.25),
                child: Text(
                  _user['avatar'],
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Lv.${_user['level']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.kanitReg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _user['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _user['username'],
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_user['country']}  •  Since ${_user['joinDate']}',
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 11,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
          const SizedBox(height: 16),
          // XP Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'XP Progress',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontFamily: FontFamily.kanitReg),
              ),
              Text(
                '${_user['xp']} / ${_user['xpMax']}',
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontFamily: FontFamily.kanitReg),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_user['xp'] as int) / (_user['xpMax'] as int),
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── STAT CARD ────────────────────────────────────────────────────────────────
  Widget _statCard({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: FontFamily.kanitReg,
            ),
          ),
        ],
      ),
    );
  }

  // ── GAME STATS CARD ──────────────────────────────────────────────────────────
  Widget _gameStatsCard(int wins, int losses, int draws, int total,
      double winRate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Game Stats',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: FontFamily.kanitReg,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _resultBadge('W', wins, Colors.greenAccent),
              const SizedBox(width: 8),
              _resultBadge('L', losses, Colors.redAccent),
              const SizedBox(width: 8),
              _resultBadge('D', draws, Colors.white54),
            ],
          ),
          const SizedBox(height: 12),
          // Win rate bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Expanded(
                  flex: (winRate * 100).round(),
                  child: Container(
                    height: 10,
                    color: Colors.greenAccent,
                  ),
                ),
                Expanded(
                  flex: ((losses / total) * 100).round(),
                  child: Container(
                    height: 10,
                    color: Colors.redAccent.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  flex: ((draws / total) * 100).round(),
                  child: Container(
                    height: 10,
                    color: Colors.white24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Win Rate: ${(winRate * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontFamily: FontFamily.kanitReg),
              ),
              Text(
                '$total total games',
                style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontFamily: FontFamily.kanitReg),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultBadge(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── WIN STREAK CARD ──────────────────────────────────────────────────────────
  Widget _winStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_user['winStreak']} Win Streak',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const Text(
                "Keep going! You're on fire 🔥",
                style: TextStyle(
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