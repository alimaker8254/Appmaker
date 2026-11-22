import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_card.dart';
import '../widgets/neon_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.teamName,
    required this.teamShortName, required this.teamColor});
  final String teamName, teamShortName;
  final Color teamColor;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _PitchPainter())),
      SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Column(children: [
          SizedBox(height: 76, child: NeonContainer(
            neonColor: AppColors.neonGreen, borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: [
              CircleAvatar(radius: 25, backgroundColor: teamColor.withOpacity(.18),
                child: Text(teamShortName, style: TextStyle(color: teamColor,
                  fontWeight: FontWeight.w900, fontSize: 12))),
              const SizedBox(width: 12),
              Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(teamName, style: const TextStyle(color: AppColors.white,
                  fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('سطح ۱۲', style: TextStyle(
                  color: AppColors.neonCyan, fontSize: 12)),
              ]),
              const SizedBox(width: 14),
              SizedBox(width: 110, child: Column(
                mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('پیشرفت ۶۰٪', style: TextStyle(
                  color: AppColors.secondary, fontSize: 11)),
                const SizedBox(height: 5),
                ClipRRect(borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(value: .6, minHeight: 8,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation(AppColors.neonGreen))),
              ])),
              const Spacer(),
              const _Resource(icon: Icons.monetization_on,
                value: '۲۵۰٬۰۰۰', color: AppColors.neonGold),
              const SizedBox(width: 22),
              const _Resource(icon: Icons.bolt, value: '۳ LP',
                color: AppColors.neonPurple),
              const SizedBox(width: 18),
              IconButton(onPressed: () => _message(context, 'تنظیمات'),
                icon: const Icon(Icons.settings,
                  color: AppColors.secondary, size: 27)),
            ]),
          )),
          const SizedBox(height: 18),
          Expanded(child: GridView.count(
            crossAxisCount: 3, childAspectRatio: 2.45,
            crossAxisSpacing: 16, mainAxisSpacing: 14,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              NeonCard(title: 'مسابقات', subtitle: 'برنامه و نتایج بازی‌ها',
                icon: Icons.sports_soccer, color: AppColors.neonGreen,
                onTap: () => _message(context, 'مسابقات')),
              NeonCard(title: 'جدول لیگ', subtitle: 'رتبه‌بندی و امتیازات',
                icon: Icons.leaderboard, color: AppColors.neonGold,
                onTap: () => _league(context)),
              NeonCard(title: 'ارتقای بازیکن', subtitle: 'افزایش مهارت و قدرت',
                icon: Icons.trending_up, color: AppColors.neonBlue,
                onTap: () => _message(context, 'ارتقای بازیکن')),
              NeonCard(title: 'خرید بازیکن', subtitle: 'تقویت ترکیب تیم',
                icon: Icons.person_add_alt_1, color: AppColors.neonPurple,
                onTap: () => _message(context, 'بازار نقل‌وانتقالات')),
              NeonCard(title: 'تاکتیک‌ها', subtitle: 'چیدمان و استراتژی',
                icon: Icons.grid_view, color: AppColors.neonOrange,
                onTap: () => _message(context, 'تاکتیک‌ها')),
              NeonCard(title: 'استخدام مربی', subtitle: 'کادر فنی حرفه‌ای',
                icon: Icons.sports, color: AppColors.neonCyan,
                onTap: () => _message(context, 'استخدام مربی')),
            ],
          )),
        ]),
      )),
    ]),
  );

  static void _message(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title به‌زودی فعال می‌شود')));
  }

  static void _league(BuildContext context) {
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.navy,
      title: const Text('جدول لیگ', style: TextStyle(color: AppColors.neonGold)),
      content: const Column(mainAxisSize: MainAxisSize.min, children: [
        _LeagueRow('۱','رئال مادرید','۳۸'),
        _LeagueRow('۲','منچسترسیتی','۳۵'),
        _LeagueRow('۳','بایرن مونیخ','۳۲'),
        _LeagueRow('۴','لیورپول','۳۰'),
        _LeagueRow('۵','بارسلونا','۲۸'),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context),
        child: const Text('بستن'))],
    ));
  }
}

class _Resource extends StatelessWidget {
  const _Resource({required this.icon, required this.value, required this.color});
  final IconData icon;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: color, size: 22), const SizedBox(width: 6),
    Text(value, style: TextStyle(color: color,
      fontWeight: FontWeight.bold, fontSize: 14)),
  ]);
}

class _LeagueRow extends StatelessWidget {
  const _LeagueRow(this.rank, this.club, this.points);
  final String rank, club, points;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(rank, style: const TextStyle(color: AppColors.neonGold)),
      const SizedBox(width: 14), Expanded(child: Text(club)),
      Text('$points امتیاز',
        style: const TextStyle(color: AppColors.neonGreen)),
    ]),
  );
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF071F22));
    final line = Paint()..color = AppColors.neonGreen.withOpacity(.07)..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
    }
    final grass = Paint()..color = AppColors.neonGreen.withOpacity(.045)
      ..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width/2,size.height/2),
      width: size.width*.55, height: size.height*.62), grass);
    canvas.drawCircle(Offset(size.width/2,size.height/2), 42, grass);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
