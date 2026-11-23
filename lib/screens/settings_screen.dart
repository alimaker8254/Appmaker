import 'package:flutter/material.dart';
import '../models/club.dart';

class SettingsScreen extends StatefulWidget {
  final Club club;
  const SettingsScreen({super.key, required this.club});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _musicVolume = 70;

  static const _green = Color(0xFF39FF14);
  static const _gold = Color(0xFFFFD700);
  static const _cyan = Color(0xFF00F5E9);
  static const _blue = Color(0xFF00AFFF);
  static const _dark = Color(0xFF06101F);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 380 || size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF030805),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF071A0B), Color(0xFF030805)],
            ),
          ),
          child: CustomPaint(
            painter: _SettingsBackgroundPainter(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .05,
                  vertical: compact ? 4 : 8,
                ),
                child: Column(
                  children: [
                    SizedBox(height: compact ? 64 : 72, child: _SettingsTopBar(club: widget.club, compact: compact)),
                    SizedBox(height: compact ? 14 : 22),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _MusicCard(
                              compact: compact,
                              volume: _musicVolume,
                              onChanged: (v) => setState(() => _musicVolume = v),
                            ),
                          ),
                          SizedBox(height: compact ? 16 : 28),
                          const Expanded(flex: 1, child: _TelegramCard()),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTopBar extends StatelessWidget {
  final Club club;
  final bool compact;
  const _SettingsTopBar({required this.club, required this.compact});

  @override
  Widget build(BuildContext context) {
    final logo = club.networkLogo;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 20, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1228),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF39FF14), width: 2),
        boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.55), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          SizedBox(
            width: compact ? 34 : 48,
            height: compact ? 38 : 52,
            child: logo != null
                ? Image.network(logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                : Image.asset('assets/logos_png/${club.asset.replaceAll('.svg', '.png')}', fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
          ),
          SizedBox(width: compact ? 8 : 14),
          Text('تنظیمات', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 16 : 23)),
          const Spacer(),
          _SettingsResource(icon: Icons.diamond, value: '15', color: const Color(0xFFB44CFF), compact: compact),
          SizedBox(width: compact ? 5 : 10),
          _SettingsResource(icon: Icons.monetization_on, value: '250,000', color: const Color(0xFFFFD700), compact: compact),
          SizedBox(width: compact ? 7 : 12),
          Text('Lv. 12', style: TextStyle(color: Colors.white, fontSize: compact ? 12 : 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          IconButton(
            tooltip: 'بازگشت',
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: const Color(0xFF00BFFF), size: compact ? 20 : 27),
          ),
        ],
      ),
    );
  }
}

class _SettingsResource extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final bool compact;
  const _SettingsResource({required this.icon, required this.value, required this.color, required this.compact});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 11, vertical: compact ? 3 : 6),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: color, width: 1.4)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(color: Colors.white, fontSize: compact ? 9 : 14)),
      const SizedBox(width: 5),
      Icon(icon, color: color, size: compact ? 13 : 18),
    ]),
  );
}

class _MusicCard extends StatelessWidget {
  final bool compact;
  final double volume;
  final ValueChanged<double> onChanged;
  const _MusicCard({required this.compact, required this.volume, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 30, vertical: compact ? 12 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF382609), Color(0xFF171006)]),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFD700), width: 2.2),
        boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(.48), blurRadius: 22, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 68 : 138,
            height: compact ? 40 : 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
            ),
            child: Text('${volume.round()}%', style: TextStyle(color: Colors.white, fontSize: compact ? 16 : 30, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: compact ? 10 : 28),
          Expanded(
            flex: 4,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: compact ? 7 : 13,
                activeTrackColor: const Color(0xFFFFD21A),
                inactiveTrackColor: const Color(0xFF4B4B4B),
                thumbColor: Colors.white,
                overlayColor: const Color(0xFFFFD21A).withOpacity(.18),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: compact ? 10 : 17, elevation: 4),
                trackShape: const RoundedRectSliderTrackShape(),
              ),
              child: Slider(value: volume, min: 0, max: 100, onChanged: onChanged),
            ),
          ),
          SizedBox(width: compact ? 10 : 24),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('صدای موسیقی بازی', maxLines: 1, style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: compact ? 15 : 27, fontWeight: FontWeight.bold)),
                Text('میزان صدای موسیقی را تنظیم کنید', maxLines: 1, style: TextStyle(fontFamily: 'Vazirmatn', color: const Color(0xFFD9D9D9), fontSize: compact ? 10 : 17)),
              ],
            ),
          ),
          SizedBox(width: compact ? 14 : 30),
          Icon(Icons.volume_up_rounded, color: const Color(0xFFFFD21A), size: compact ? 43 : 70),
        ],
      ),
    );
  }
}

class _TelegramCard extends StatelessWidget {
  const _TelegramCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).height < 380 ? 16 : 30, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF06283D), Color(0xFF071629)]),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF00F5E9), width: 2.2),
        boxShadow: [BoxShadow(color: const Color(0xFF00F5E9).withOpacity(.42), blurRadius: 22, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لینک کانال تلگرام هنوز در تنظیمات پروژه ثبت نشده است.')),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).height < 380 ? 16 : 28, vertical: MediaQuery.sizeOf(context).height < 380 ? 12 : 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF16B9FF), Color(0xFF0069E8)]),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF25D9FF), width: 1.5),
                boxShadow: [BoxShadow(color: const Color(0xFF008CFF).withOpacity(.55), blurRadius: 16, spreadRadius: 2)],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.send_rounded, color: Colors.white, size: 25),
                const SizedBox(width: 12),
                Text('ورود به کانال تلگرام', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: MediaQuery.sizeOf(context).height < 380 ? 11 : 19, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          SizedBox(width: MediaQuery.sizeOf(context).height < 380 ? 12 : 28),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('کانال تلگرام ما', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: MediaQuery.sizeOf(context).height < 380 ? 16 : 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                Text('برای دریافت جدیدترین اخبار و آپدیت‌ها، وارد کانال تلگرام ما شوید', maxLines: 2, style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: MediaQuery.sizeOf(context).height < 380 ? 9 : 16)),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.sizeOf(context).height < 380 ? 18 : 36),
          Container(
            width: MediaQuery.sizeOf(context).height < 380 ? 62 : 116,
            height: MediaQuery.sizeOf(context).height < 380 ? 62 : 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF16B9FF), Color(0xFF0069E8)]),
              border: Border.all(color: const Color(0xFF18D7FF), width: 2),
              boxShadow: [BoxShadow(color: const Color(0xFF00AFFF).withOpacity(.6), blurRadius: 18, spreadRadius: 2)],
            ),
            child: Icon(Icons.send_rounded, color: Colors.white, size: MediaQuery.sizeOf(context).height < 380 ? 34 : 66),
          ),
        ],
      ),
    );
  }
}

class _SettingsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF39FF14).withOpacity(.055)..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
