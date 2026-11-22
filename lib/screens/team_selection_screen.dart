import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import 'home_screen.dart';

class _Team {
  const _Team(this.name, this.tag, this.color);
  final String name, tag;
  final Color color;
}

class TeamSelectionScreen extends StatefulWidget {
  const TeamSelectionScreen({super.key});
  @override
  State<TeamSelectionScreen> createState() => _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen> {
  static const teams = [
    _Team('رئال مادرید','RMA',Color(0xFFFFD700)),
    _Team('بارسلونا','BAR',Color(0xFFBF00FF)),
    _Team('منچسترسیتی','MCI',Color(0xFF00BFFF)),
    _Team('لیورپول','LIV',Color(0xFFFF3B3B)),
    _Team('آرسنال','ARS',Color(0xFFFF4D4D)),
    _Team('منچستریونایتد','MUN',Color(0xFFFF3030)),
    _Team('بایرن مونیخ','BAY',Color(0xFFFF4545)),
    _Team('دورتموند','BVB',Color(0xFFFFD700)),
    _Team('پاری‌سن‌ژرمن','PSG',Color(0xFF00BFFF)),
    _Team('یوونتوس','JUV',Color(0xFFFFFFFF)),
    _Team('اینتر','INT',Color(0xFF00BFFF)),
    _Team('میلان','MIL',Color(0xFFFF4545)),
    _Team('اتلتیکو مادرید','ATM',Color(0xFFFF4545)),
    _Team('چلسی','CHE',Color(0xFF4169E1)),
    _Team('تاتنهام','TOT',Color(0xFFFFFFFF)),
  ];
  int? selectedIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _DiagonalLinesPainter())),
      SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.sports_soccer, color: AppColors.neonCyan, size: 32),
            const SizedBox(width: 10),
            const Text('مدیر فوتبال', style: TextStyle(fontSize: 25,
              color: AppColors.white, fontWeight: FontWeight.w900)),
            const Spacer(),
            const Text('تیم رؤیایی خود را انتخاب کن',
              style: TextStyle(color: AppColors.secondary, fontSize: 16)),
          ]),
          const SizedBox(height: 18),
          Expanded(child: GridView.builder(
            itemCount: teams.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, childAspectRatio: 1.1,
              crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (context, index) {
              final team = teams[index];
              final selected = selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(.9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: selected ? AppColors.neonGold : team.color.withOpacity(.65),
                      width: selected ? 3 : 1.4),
                    boxShadow: selected ? [BoxShadow(
                      color: AppColors.neonGold.withOpacity(.55),
                      blurRadius: 18, spreadRadius: 2)] : [],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.shield, size: 38, color: team.color),
                    const SizedBox(height: 5),
                    Text(team.name, textAlign: TextAlign.center, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.white,
                        fontWeight: FontWeight.bold, fontSize: 13)),
                    if (selected) const Icon(Icons.check_circle,
                      color: AppColors.neonGold, size: 17),
                  ]),
                ),
              );
            },
          )),
          const SizedBox(height: 12),
          SizedBox(width: 250, child: NeonButton(
            label: 'شروع مدیریت تیم', icon: Icons.rocket_launch,
            onPressed: selectedIndex == null ? null : () {
              final team = teams[selectedIndex!];
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => HomeScreen(teamName: team.name,
                  teamShortName: team.tag, teamColor: team.color)));
            },
          )),
        ]),
      )),
    ]),
  );
}

class _DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.neonCyan.withOpacity(.07)..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
