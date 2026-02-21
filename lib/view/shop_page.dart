import 'package:flutter/material.dart';
import 'package:new_chess/generated/assets.dart';
import 'package:new_chess/res/font_family.dart';
import 'package:new_chess/res/sizing_const.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnim;

  int _selectedTab = 0;
  int _coins = 4250;

  // ── BOARDS ──────────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _boards = [
    {
      'id': 1,
      'name': 'Classic Wood',
      'desc': 'Traditional oak board',
      'icon': '🟫',
      'price': 800,
      'tag': 'Popular',
      'tagColor': Color(0xFFFFD700),
      'owned': true,
      'gradient': [Color(0xFF8D6E63), Color(0xFF4E342E)],
    },
    {
      'id': 2,
      'name': 'Marble Elite',
      'desc': 'Premium white marble finish',
      'icon': '⬜',
      'price': 2000,
      'tag': 'Premium',
      'tagColor': Color(0xFFE91E63),
      'owned': false,
      'gradient': [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
    },
    {
      'id': 3,
      'name': 'Neon Grid',
      'desc': 'Cyberpunk glowing board',
      'icon': '🟩',
      'price': 1800,
      'tag': 'New',
      'tagColor': Color(0xFF64B5F6),
      'owned': false,
      'gradient': [Color(0xFF00E676), Color(0xFF1DE9B6)],
    },
    {
      'id': 4,
      'name': 'Dark Obsidian',
      'desc': 'Sleek matte black board',
      'icon': '⬛',
      'price': 1500,
      'tag': 'Rare',
      'tagColor': Color(0xFFCE93D8),
      'owned': false,
      'gradient': [Color(0xFF37474F), Color(0xFF212121)],
    },
    {
      'id': 5,
      'name': 'Royal Purple',
      'desc': 'Regal velvet purple board',
      'icon': '🟪',
      'price': 1200,
      'tag': null,
      'tagColor': null,
      'owned': false,
      'gradient': [Color(0xFFAB47BC), Color(0xFF6A1B9A)],
    },
    {
      'id': 6,
      'name': 'Golden Legend',
      'desc': 'Championship gold board',
      'icon': '🟨',
      'price': 3000,
      'tag': 'Legendary',
      'tagColor': Color(0xFFFF6F00),
      'owned': false,
      'gradient': [Color(0xFFFFD700), Color(0xFFFF8F00)],
    },
  ];

  // ── COIN PACKS ───────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _coinPacks = [
    {
      'id': 101,
      'name': 'Starter Pack',
      'coins': 500,
      'bonus': 0,
      'price': '₹49',
      'icon': '🪙',
      'tag': null,
      'tagColor': null,
      'gradient': [Color(0xFF78909C), Color(0xFF455A64)],
    },
    {
      'id': 102,
      'name': 'Bronze Bag',
      'coins': 1200,
      'bonus': 100,
      'price': '₹99',
      'icon': '💰',
      'tag': 'Popular',
      'tagColor': Color(0xFFFFD700),
      'gradient': [Color(0xFFCD7F32), Color(0xFF8D4E00)],
    },
    {
      'id': 103,
      'name': 'Silver Chest',
      'coins': 2500,
      'bonus': 300,
      'price': '₹199',
      'icon': '🏆',
      'tag': 'Best Value',
      'tagColor': Color(0xFF64B5F6),
      'gradient': [Color(0xFFB0BEC5), Color(0xFF78909C)],
    },
    {
      'id': 104,
      'name': 'Gold Vault',
      'coins': 6000,
      'bonus': 1000,
      'price': '₹399',
      'icon': '💎',
      'tag': 'Sale',
      'tagColor': Color(0xFFE91E63),
      'gradient': [Color(0xFFFFD700), Color(0xFFFFA000)],
    },
    {
      'id': 105,
      'name': 'Diamond Hoard',
      'coins': 15000,
      'bonus': 3500,
      'price': '₹799',
      'icon': '👑',
      'tag': 'Max Value',
      'tagColor': Color(0xFFCE93D8),
      'gradient': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
    },
    {
      'id': 106,
      'name': 'Legendary Stash',
      'coins': 35000,
      'bonus': 10000,
      'price': '₹1499',
      'icon': '🌟',
      'tag': 'Legendary',
      'tagColor': Color(0xFFFF6F00),
      'gradient': [Color(0xFFEF5350), Color(0xFF880E4F)],
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

  // ── BUILD ────────────────────────────────────────────────────────────────────
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
          _buildCoinBar(),
          const SizedBox(height: 10),
          _buildTabRow(),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedTab == 0
                ? _buildBoardGrid()
                : _buildCoinPackList(),
          ),
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
        "🛒  SHOP",
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

  // ── COIN BAR ─────────────────────────────────────────────────────────────────
  Widget _buildCoinBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🪙', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              AnimatedBuilder(
                animation: _shimmerAnim,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        colors: const [
                          Color(0xFFFFD700),
                          Colors.white,
                          Color(0xFFFFD700),
                        ],
                        stops: [
                          (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnim.value.clamp(0.0, 1.0),
                          (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ).createShader(rect);
                    },
                    child: Text(
                      '$_coins Coins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: FontFamily.kanitReg,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _selectedTab = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                '+ Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB ROW ──────────────────────────────────────────────────────────────────
  Widget _buildTabRow() {
    const tabs = ['🎯  Boards', '🪙  Coins'];
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── BOARDS GRID ──────────────────────────────────────────────────────────────
  Widget _buildBoardGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: _boards.length,
      itemBuilder: (context, index) => _buildBoardCard(_boards[index]),
    );
  }

  Widget _buildBoardCard(Map<String, dynamic> board) {
    final bool owned = board['owned'] == true;
    final bool canAfford = _coins >= (board['price'] as int);

    return GestureDetector(
      onTap: () {
        if (!owned) _showBoardBuyDialog(board);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: owned
                ? Colors.greenAccent.withOpacity(0.5)
                : Colors.white12,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      gradient: LinearGradient(
                        colors: (board['gradient'] as List<Color>)
                            .map((c) => c.withOpacity(0.35))
                            .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        board['icon'],
                        style: const TextStyle(fontSize: 52),
                      ),
                    ),
                  ),
                  if (board['tag'] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                          (board['tagColor'] as Color).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          board['tag'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ),
                    ),
                  if (owned)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: FontFamily.kanitReg,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    board['desc'],
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: FontFamily.kanitReg,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: owned
                          ? LinearGradient(colors: [
                        Colors.greenAccent.withOpacity(0.3),
                        Colors.green.withOpacity(0.3),
                      ])
                          : canAfford
                          ? const LinearGradient(colors: [
                        Color(0xFFFFD700),
                        Color(0xFFFFA000),
                      ])
                          : LinearGradient(colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.2),
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: owned
                          ? [
                        const Text(
                          'Owned',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        )
                      ]
                          : [
                        const Text('🪙',
                            style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Text(
                          '${board['price']}',
                          style: TextStyle(
                            color: canAfford
                                ? Colors.white
                                : Colors.white38,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: FontFamily.kanitReg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── COIN PACKS LIST ──────────────────────────────────────────────────────────
  Widget _buildCoinPackList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _coinPacks.length,
      itemBuilder: (context, index) =>
          _buildCoinPackTile(_coinPacks[index]),
    );
  }

  Widget _buildCoinPackTile(Map<String, dynamic> pack) {
    final int total = (pack['coins'] as int) + (pack['bonus'] as int);
    return GestureDetector(
      onTap: () => _showCoinBuyDialog(pack),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12, width: 1.2),
        ),
        child: Row(
          children: [
            // Icon
            Text(pack['icon'], style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            // Name + coins — Expanded prevents overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pack['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: FontFamily.kanitReg,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    (pack['bonus'] as int) > 0
                        ? '🪙 $total  (+${pack['bonus']} bonus)'
                        : '🪙 ${pack['coins']} coins',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 11,
                      fontFamily: FontFamily.kanitReg,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  pack['price'],
                  textAlign: TextAlign.center,
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
      ),
    );
  }

  // ── BOARD BUY DIALOG ─────────────────────────────────────────────────────────
  void _showBoardBuyDialog(Map<String, dynamic> board) {
    final bool canAfford = _coins >= (board['price'] as int);
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
              Text(board['icon'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 10),
              Text(
                board['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                board['desc'],
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontFamily: FontFamily.kanitReg,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '${board['price']} Coins',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: FontFamily.kanitReg,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!canAfford) ...[
                const Text(
                  '❌ Not enough coins!',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: FontFamily.kanitReg,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedTab = 1);
                  },
                  child: Text(
                    'Buy Coins →',
                    style: TextStyle(
                      color: Colors.amber.shade300,
                      fontFamily: FontFamily.kanitReg,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.amber.shade300,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
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
                            fontFamily: FontFamily.kanitReg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (canAfford) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _coins -= board['price'] as int;
                            board['owned'] = true;
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ ${board['name']} purchased!',
                                style: const TextStyle(
                                    fontFamily: FontFamily.kanitReg),
                              ),
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFFA000)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Buy Now',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── COIN BUY DIALOG ──────────────────────────────────────────────────────────
  void _showCoinBuyDialog(Map<String, dynamic> pack) {
    final int total = (pack['coins'] as int) + (pack['bonus'] as int);
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
              Text(pack['icon'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 10),
              Text(
                pack['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: FontFamily.kanitReg,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Coins',
                            style: TextStyle(
                                color: Colors.white54,
                                fontFamily: FontFamily.kanitReg)),
                        Text('🪙 ${pack['coins']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.kanitReg)),
                      ],
                    ),
                    if ((pack['bonus'] as int) > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Bonus',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: FontFamily.kanitReg)),
                          Text('🎁 +${pack['bonus']}',
                              style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontFamily.kanitReg)),
                        ],
                      ),
                      const Divider(color: Colors.white12, height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontFamily.kanitReg)),
                          Text('🪙 $total',
                              style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: FontFamily.kanitReg)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                            fontFamily: FontFamily.kanitReg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Trigger IAP / payment gateway here
                        setState(() => _coins += total);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🪙 $total coins added!',
                              style: const TextStyle(
                                  fontFamily: FontFamily.kanitReg),
                            ),
                            backgroundColor: Colors.amber.shade800,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          pack['price'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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