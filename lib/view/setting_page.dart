import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';
import 'package:new_chess/view/game_history.dart';
// import 'package:new_chess/screens/game_history_page.dart'; // adjust path

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = false;
  bool _autoPromote = true;
  bool _showCoordinates = false;
  String _selectedTheme = 'Dark Blue';

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
          _topWoodenHeader(),
          const SizedBox(height: 10),
          Expanded(child: _buildSettingsContent()),
        ],
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
        "⚙️  SETTINGS",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontFamily: FontFamily.kanitReg,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(2, 2)),
          ],
        ),
      ),
    );
  }

  // ── SETTINGS CONTENT ─────────────────────────────────────────────────────────
  Widget _buildSettingsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _sectionLabel('👤  My Account'),
          _buildActionTile(
            icon: '📋',
            label: 'Game History',
            subtitle: 'View all your past games',
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) =>  GameHistoryPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          _sectionLabel('🔔  Sound & Notifications'),
          _buildToggleTile(
            icon: '🔊',
            label: 'Sound Effects',
            value: _soundEnabled,
            onChanged: (v) => setState(() => _soundEnabled = v),
          ),
          _buildToggleTile(
            icon: '📳',
            label: 'Vibration',
            value: _vibrationEnabled,
            onChanged: (v) => setState(() => _vibrationEnabled = v),
          ),
          _buildToggleTile(
            icon: '🔔',
            label: 'Push Notifications',
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),

          const SizedBox(height: 14),

          // ── Danger Zone ──────────────────────────────────────────────────────
          _sectionLabel('⚠️  Danger Zone'),
          _buildActionTile(
            icon: '🚪',
            label: 'Log Out',
            subtitle: 'Sign out of your account',
            onTap: () => _showLogoutDialog(),
          ),
          _buildActionTile(
            icon: '🗑️',
            label: 'Delete Account',
            subtitle: 'Permanently remove your data',
            onTap: () => _showDeleteDialog(),
            isDestructive: true,
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Chess App  v1.0.0',
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 11,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── SECTION LABEL ────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: FontFamily.kanitReg,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ── ACTION TILE ──────────────────────────────────────────────────────────────
  Widget _buildActionTile({
    required String icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.redAccent.withOpacity(0.08)
              : Colors.black26,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDestructive
                ? Colors.redAccent.withOpacity(0.3)
                : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDestructive ? Colors.redAccent : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.kanitReg,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDestructive
                            ? Colors.redAccent.withOpacity(0.6)
                            : Colors.white38,
                        fontSize: 11,
                        fontFamily: FontFamily.kanitReg,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive
                  ? Colors.redAccent.withOpacity(0.5)
                  : Colors.white24,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── TOGGLE TILE ──────────────────────────────────────────────────────────────
  Widget _buildToggleTile({
    required String icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: FontFamily.kanitReg,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD700),
            activeTrackColor: const Color(0xFFFFD700).withOpacity(0.3),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white12,
          ),
        ],
      ),
    );
  }

  // ── DIALOGS ──────────────────────────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A2A3A),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚪', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text(
                'Log Out?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        // TODO: logout logic
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Log Out',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A2A3A),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🗑️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text(
                'Delete Account?',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This will permanently delete your account and all data. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        // TODO: delete account logic
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}