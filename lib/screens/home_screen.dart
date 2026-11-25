import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/club.dart';
import 'settings_screen.dart';
import 'buy_player_screen.dart';
import 'buy_coach_screen.dart';
import 'matches_screen.dart';
import 'tactics_screen.dart';
import '../services/game_music.dart';

class HomeScreen extends StatefulWidget {
  final Club club;
  const HomeScreen({super.key, required this.club});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _designWidth = 1536;
  static const double _designHeight = 1024;

  @override
  void initState() {
    super.initState();
    GameMusic.instance.start();
  }

  @override
  void dispose() {
    GameMusic.instance.stop();
    super.dispose();
  }

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02040A),
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _designWidth / _designHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                double x(double value) => value / _designWidth * w;
                double y(double value) => value / _designHeight * h;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/home_screen.png',
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFF081426),
                        child: Center(child: Text('home_screen.png not found', style: TextStyle(color: Colors.white))),
                      ),
                    ),

                    // The club crest alone is dynamic; the rest of the artwork stays untouched.
                    Positioned(
                      left: x(1377), top: y(13), width: x(125), height: y(120),
                      child: _ClubCrest(club: widget.club),
                    ),

                    // Settings icon in the artwork remains an independent hit target.
                    Positioned(
                      left: x(35), top: y(18), width: x(120), height: y(80),
                      child: _ImageButton(
                        semanticLabel: 'Settings',
                        onTap: () => _open(SettingsScreen(club: widget.club)),
                      ),
                    ),

                    // Each artwork button has its own hit area and its own destination.
                    Positioned(
                      left: x(90), top: y(342), width: x(375), height: y(112),
                      child: _ImageButton(semanticLabel: 'Hire Coach',
                        onTap: () => _open(BuyCoachScreen(club: widget.club))),
                    ),
                    Positioned(
                      left: x(575), top: y(342), width: x(420), height: y(112),
                      child: _ImageButton(semanticLabel: 'Buy Player',
                        onTap: () => _open(BuyPlayerScreen(club: widget.club))),
                    ),
                    Positioned(
                      left: x(1050), top: y(342), width: x(420), height: y(112),
                      child: _ImageButton(semanticLabel: 'League Table',
                        onTap: () => _open(const _HomeSectionPage(
                          title: 'جدول رتبه‌بندی',
                          subtitle: 'League Table',
                          message: 'بخش جدول لیگ هنوز در بازی پیاده‌سازی نشده است.',
                        ))),
                    ),
                    Positioned(
                      left: x(45), top: y(660), width: x(425), height: y(110),
                      child: _ImageButton(semanticLabel: 'Matches',
                        onTap: () => _open(MatchesScreen(club: widget.club))),
                    ),
                    Positioned(
                      left: x(565), top: y(660), width: x(425), height: y(110),
                      child: _ImageButton(semanticLabel: 'Tactics',
                        onTap: () => _open(const TacticsScreen())),
                    ),
                    Positioned(
                      left: x(1055), top: y(660), width: x(415), height: y(110),
                      child: _ImageButton(semanticLabel: 'Player Upgrade',
                        onTap: () => _open(const _HomeSectionPage(
                          title: 'ارتقای بازیکنان',
                          subtitle: 'Player Upgrade',
                          message: 'بخش ارتقای بازیکنان هنوز در بازی پیاده‌سازی نشده است.',
                        ))),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ClubCrest extends StatelessWidget {
  final Club club;
  const _ClubCrest({required this.club});

  @override
  Widget build(BuildContext context) {
    final logo = club.networkLogo;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF061126),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFD34E), width: 2),
        boxShadow: const [BoxShadow(color: Color(0xAA168BFF), blurRadius: 12, spreadRadius: 1)],
      ),
      child: ClipOval(
        child: logo != null
            ? Image.network(logo, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _assetLogo())
            : _assetLogo(),
      ),
    );
  }

  Widget _assetLogo() => Image.asset(
    'assets/logos_png/${club.asset.replaceAll('.svg', '.png')}',
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 42),
  );
}

class _ImageButton extends StatefulWidget {
  final String semanticLabel;
  final VoidCallback onTap;
  const _ImageButton({required this.semanticLabel, required this.onTap});

  @override
  State<_ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<_ImageButton> {
  bool _pressed = false;

  void _pressStart(TapDownDetails _) => setState(() => _pressed = true);
  void _pressEnd() => setState(() => _pressed = false);

  void _activate() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _pressStart,
        onTapUp: (_) {
          _pressEnd();
          _activate();
        },
        onTapCancel: _pressEnd,
        child: AnimatedScale(
          scale: _pressed ? .965 : 1,
          duration: const Duration(milliseconds: 85),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 85),
            decoration: BoxDecoration(
              color: _pressed ? const Color(0x3329BFFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: _pressed
                  ? Border.all(color: const Color(0x99FFFFFF), width: 1.2)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeSectionPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  const _HomeSectionPage({
    required this.title,
    required this.subtitle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081A35),
        title: Text(title, style: const TextStyle(fontFamily: 'Vazirmatn')),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1B34),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00BFFF), width: 1.5),
            boxShadow: const [BoxShadow(color: Color(0x5500BFFF), blurRadius: 18)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle, textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFF00D9FF), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Text(message, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
