import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/club.dart';

class HomeScreen extends StatelessWidget {
  final Club club;
  const HomeScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 420 || size.width < 760;
    final cards = <_DashboardCard>[
      _DashboardCard('مسابقات', 'Matches', AppTheme.neonGreen,
          const [Color(0xFF0A3A1A), Color(0xFF051208)], const PitchGraphic()),
      _DashboardCard('جدول لیگ', 'League Table', AppTheme.neonBlue,
          const [Color(0xFF0A1F3A), Color(0xFF050B14)], const LeagueGraphic()),
      _DashboardCard('ارتقا بازیکنان', 'Player Upgrade', AppTheme.neonGold,
          const [Color(0xFF3A2A0A), Color(0xFF1A0A00)], const PlayerGraphic(upgrade: true)),
      _DashboardCard('خرید بازیکن', 'Buy Player', AppTheme.neonGreen,
          const [Color(0xFF0A3A1A), Color(0xFF051208)], const PlayerGraphic()),
      _DashboardCard('تاکتیک‌ها', 'Tactics', AppTheme.neonPurple,
          const [Color(0xFF2A0A3A), Color(0xFF15051E)], const TacticsGraphic()),
      _DashboardCard('خرید مربی', 'Hire Coach', AppTheme.neonOrange,
          const [Color(0xFF3A1A0A), Color(0xFF1A0A00)], const CoachGraphic()),
    ];

    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A2510), Color(0xFF051208)],
            ),
          ),
          child: CustomPaint(
            painter: _DashboardBackgroundPainter(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(compact ? 8 : 12, 6, compact ? 8 : 12, 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: compact ? 56 : 64,
                      child: _TopBar(club: club, compact: compact),
                    ),
                    SizedBox(height: compact ? 7 : 10),
                    Expanded(
                      child: Column(
                        children: [
                          for (var row = 0; row < 2; row++) ...[
                            if (row > 0) SizedBox(height: compact ? 7 : 10),
                            Expanded(
                              child: Row(
                                children: [
                                  for (var col = 0; col < 3; col++) ...[
                                    if (col > 0) SizedBox(width: compact ? 7 : 10),
                                    Expanded(
                                      child: DashboardTile(
                                        card: cards[row * 3 + col],
                                        compact: compact,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
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

class _TopBar extends StatelessWidget {
  final Club club;
  final bool compact;
  const _TopBar({required this.club, required this.compact});

  Widget _clubLogo() {
    if (club.networkLogo != null) {
      return Image.network(
        club.networkLogo!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }
    return Image.asset(
      'assets/logos_png/${club.asset.replaceAll('.svg', '.png')}',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textSize = compact ? 12.0 : 15.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1224),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppTheme.neonGreen, width: 1.4),
        boxShadow: AppTheme.glow(AppTheme.neonGreen),
      ),
      child: Row(
        children: [
          SizedBox(
            width: compact ? 38 : 46,
            height: compact ? 44 : 52,
            child: _clubLogo(),
          ),
          SizedBox(width: compact ? 6 : 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('باشگاه من', style: AppTheme.vazir(size: textSize, weight: FontWeight.bold)),
              Text('My Club', style: AppTheme.vazir(size: compact ? 9 : 11, color: AppTheme.textSecondary)),
            ],
          ),
          const Spacer(),
          Text('Lv. 12', style: AppTheme.vazir(size: compact ? 12 : 15)),
          SizedBox(width: compact ? 6 : 10),
          SizedBox(
            width: compact ? 66 : 112,
            height: compact ? 9 : 11,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.neonBlue, width: 1),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: .6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.neonGold,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.glow(AppTheme.neonGold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: compact ? 10 : 18),
          _resource(Icons.monetization_on, '250,000', AppTheme.neonGold, compact),
          SizedBox(width: compact ? 6 : 12),
          _resource(Icons.diamond, '3 LP', AppTheme.neonPurple, compact),
          SizedBox(width: compact ? 8 : 16),
          Icon(Icons.settings, color: AppTheme.neonBlue, size: compact ? 19 : 23),
        ],
      ),
    );
  }

  Widget _resource(IconData icon, String value, Color color, bool small) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 4 : 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: small ? 13 : 16),
          const SizedBox(width: 4),
          Text(value, style: AppTheme.vazir(size: small ? 9 : 11)),
        ],
      ),
    );
  }
}

class _DashboardCard {
  final String fa, en;
  final Color color;
  final List<Color> gradient;
  final Widget graphic;
  const _DashboardCard(this.fa, this.en, this.color, this.gradient, this.graphic);
}

class DashboardTile extends StatelessWidget {
  final _DashboardCard card;
  final bool compact;
  const DashboardTile({super.key, required this.card, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: card.gradient,
        ),
        borderRadius: BorderRadius.circular(compact ? 12 : 17),
        border: Border.all(color: card.color, width: 1.5),
        boxShadow: AppTheme.glow(card.color),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(7, 5, 7, compact ? 23 : 29),
            child: Column(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: SizedBox.expand(child: card.graphic),
                )),
                Text(
                  card.fa,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.vazir(size: compact ? 12 : 16, weight: FontWeight.bold),
                ),
                Text(
                  card.en,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.vazir(size: compact ? 9 : 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: compact ? 27 : 34,
              height: compact ? 23 : 29,
              decoration: BoxDecoration(
                color: card.color,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(9)),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.chevron_right, color: Colors.black, size: compact ? 19 : 23),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()..color = AppTheme.neonGreen.withOpacity(.045)..strokeWidth = 1;
    for (var x = -size.height; x < size.width; x += 54) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x + size.height, size.height), line);
    }
    final dots = Paint()..color = AppTheme.neonGreen.withOpacity(.055);
    for (double y = 0; y < size.height; y += 11) {
      for (double x = 0; x < size.width; x += 13) {
        canvas.drawCircle(Offset(x, y), .65, dots);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PitchGraphic extends StatelessWidget {
  const PitchGraphic({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _PitchPainter(), child: const SizedBox.expand());
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(.92)..style = PaintingStyle.stroke..strokeWidth = 2;
    final rect = Rect.fromLTWH(size.width * .08, size.height * .06, size.width * .84, size.height * .88);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(7)), p);
    canvas.drawLine(Offset(size.width / 2, rect.top), Offset(size.width / 2, rect.bottom), p);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height * .17, p);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2.5, Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.left, size.height * .32, size.width * .17, size.height * .36), p);
    canvas.drawRect(Rect.fromLTWH(rect.right - size.width * .17, size.height * .32, size.width * .17, size.height * .36), p);
    canvas.drawRect(Rect.fromLTWH(rect.left, size.height * .42, size.width * .07, size.height * .16), p);
    canvas.drawRect(Rect.fromLTWH(rect.right - size.width * .07, size.height * .42, size.width * .07, size.height * .16), p);
    canvas.drawArc(Rect.fromCircle(center: Offset(rect.left + size.width * .17, size.height / 2), radius: size.height * .12), -1.1, 2.2, false, p);
    canvas.drawArc(Rect.fromCircle(center: Offset(rect.right - size.width * .17, size.height / 2), radius: size.height * .12), 2.0, 2.2, false, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LeagueGraphic extends StatelessWidget {
  const LeagueGraphic({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.emoji_events, color: AppTheme.neonGold, size: 18),
          const SizedBox(width: 5),
          Text('LEAGUE TABLE', style: AppTheme.vazir(size: 10, weight: FontWeight.bold)),
        ]),
        const SizedBox(height: 3),
        _row('#', 'CLUB', 'PTS', header: true),
        _row('1', 'Real Madrid', '32', logo: 'real_madrid.png'),
        _row('2', 'Barcelona', '31', logo: 'barcelona.png'),
        _row('3', 'My Club', '33', highlight: true),
        _row('4', 'Atletico Madrid', '28', logo: 'atletico_madrid.png'),
        _row('5', 'Sevilla', '26', network: true),
      ],
    );
  }

  Widget _row(String rank, String name, String points, {
    bool header = false, bool highlight = false, String? logo, bool network = false,
  }) {
    Widget crest;
    if (network) {
      crest = Image.network(
        'https://www.footylogos.com/downloads/logo/sevilla-fc-logo-footylogos.png',
        width: 15, height: 15, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(width: 15, height: 15),
      );
    } else if (logo != null) {
      crest = Image.asset('assets/logos_png/$logo', width: 15, height: 15, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(width: 15, height: 15));
    } else {
      crest = const SizedBox(width: 15, height: 15);
    }
    return Container(
      color: highlight ? AppTheme.neonGreen.withOpacity(.16) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: Row(children: [
        Expanded(flex: 1, child: Text(rank, textAlign: TextAlign.center,
          style: AppTheme.vazir(size: header ? 8 : 9, weight: header ? FontWeight.bold : FontWeight.normal))),
        Expanded(flex: 5, child: header
          ? Text(name, textAlign: TextAlign.center, style: AppTheme.vazir(size: 8, weight: FontWeight.bold))
          : Row(children: [
              crest,
              const SizedBox(width: 3),
              Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: AppTheme.vazir(size: 9, weight: highlight ? FontWeight.bold : FontWeight.normal))),
            ])),
        Expanded(flex: 1, child: Text(points, textAlign: TextAlign.center,
          style: AppTheme.vazir(size: header ? 8 : 9))),
      ]),
    );
  }
}

class PlayerGraphic extends StatelessWidget {
  final bool upgrade;
  const PlayerGraphic({super.key, this.upgrade = false});
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _PlayerPainter(upgrade: upgrade),
    child: const SizedBox.expand(),
  );
}

class _PlayerPainter extends CustomPainter {
  final bool upgrade;
  _PlayerPainter({required this.upgrade});
  @override
  void paint(Canvas canvas, Size s) {
    final white = Paint()..color = Colors.white.withOpacity(.95);
    final shade = Paint()..color = const Color(0xFFB8D8D2);
    final cx = s.width * .48;
    final headR = s.shortestSide * .105;
    canvas.drawCircle(Offset(cx, s.height * .19), headR, white);
    final torso = Path()
      ..moveTo(cx - s.width * .14, s.height * .39)
      ..quadraticBezierTo(cx, s.height * .29, cx + s.width * .14, s.height * .39)
      ..lineTo(cx + s.width * .18, s.height * .67)
      ..quadraticBezierTo(cx, s.height * .74, cx - s.width * .18, s.height * .67)
      ..close();
    canvas.drawPath(torso, white);
    final limbs = Paint()..color = Colors.white.withOpacity(.95)..strokeWidth = s.shortestSide * .075..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - s.width * .12, s.height * .43), Offset(cx - s.width * .29, s.height * .61), limbs);
    canvas.drawLine(Offset(cx + s.width * .12, s.height * .43), Offset(cx + s.width * .29, s.height * .57), limbs);
    canvas.drawLine(Offset(cx - s.width * .07, s.height * .67), Offset(cx - s.width * .14, s.height * .91), limbs);
    canvas.drawLine(Offset(cx + s.width * .07, s.height * .67), Offset(cx + s.width * .16, s.height * .91), limbs);
    canvas.drawCircle(Offset(cx - s.width * .035, s.height * .18), 1.5, shade);
    if (upgrade) {
      final gold = Paint()..color = AppTheme.neonGold..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      final path = Path()
        ..moveTo(s.width * .66, s.height * .63)
        ..lineTo(s.width * .81, s.height * .46)
        ..lineTo(s.width * .79, s.height * .55)
        ..moveTo(s.width * .81, s.height * .46)
        ..lineTo(s.width * .91, s.height * .47);
      canvas.drawPath(path, gold);
    } else {
      final lens = Paint()..color = AppTheme.neonGreen..style = PaintingStyle.stroke..strokeWidth = 4;
      canvas.drawCircle(Offset(s.width * .78, s.height * .35), s.shortestSide * .105, lens);
      canvas.drawLine(Offset(s.width * .85, s.height * .43), Offset(s.width * .95, s.height * .54), lens);
    }
  }
  @override
  bool shouldRepaint(covariant _PlayerPainter old) => old.upgrade != upgrade;
}

class TacticsGraphic extends StatelessWidget {
  const TacticsGraphic({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _TacticsPainter(), child: const SizedBox.expand());
}

class _TacticsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final line = Paint()..color = Colors.white.withOpacity(.9)..style = PaintingStyle.stroke..strokeWidth = 2;
    final fill = Paint()..color = AppTheme.neonPurple;
    final r = Rect.fromLTWH(s.width * .08, s.height * .06, s.width * .84, s.height * .88);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), line);
    canvas.drawLine(Offset(s.width / 2, r.top), Offset(s.width / 2, r.bottom), line);
    canvas.drawCircle(Offset(s.width / 2, s.height / 2), s.height * .13, line);
    final positions = [
      Offset(s.width * .25, s.height * .25), Offset(s.width * .5, s.height * .22), Offset(s.width * .75, s.height * .25),
      Offset(s.width * .32, s.height * .48), Offset(s.width * .68, s.height * .48),
      Offset(s.width * .22, s.height * .73), Offset(s.width * .5, s.height * .78), Offset(s.width * .78, s.height * .73),
    ];
    for (final pos in positions) {
      canvas.drawCircle(pos, s.shortestSide * .055, Paint()..color = Colors.white);
      canvas.drawCircle(pos, s.shortestSide * .055, Paint()..color = AppTheme.neonPurple..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
    canvas.drawLine(positions[3], positions[4], line);
    canvas.drawLine(positions[3], positions[6], line);
    canvas.drawLine(positions[4], positions[6], line);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CoachGraphic extends StatelessWidget {
  const CoachGraphic({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _CoachPainter(), child: const SizedBox.expand());
}

class _CoachPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final white = Paint()..color = Colors.white.withOpacity(.95);
    final stroke = Paint()..color = AppTheme.neonOrange..style = PaintingStyle.stroke..strokeWidth = 3;
    final cx = s.width * .43;
    canvas.drawCircle(Offset(cx, s.height * .2), s.shortestSide * .10, white);
    final body = Path()
      ..moveTo(cx - s.width * .19, s.height * .83)
      ..lineTo(cx - s.width * .13, s.height * .48)
      ..quadraticBezierTo(cx, s.height * .37, cx + s.width * .13, s.height * .48)
      ..lineTo(cx + s.width * .19, s.height * .83)
      ..close();
    canvas.drawPath(body, white);
    canvas.drawLine(Offset(cx - s.width * .1, s.height * .52), Offset(cx + s.width * .1, s.height * .52), stroke);
    final board = Rect.fromLTWH(s.width * .64, s.height * .36, s.width * .27, s.height * .43);
    canvas.drawRRect(RRect.fromRectAndRadius(board, const Radius.circular(5)), stroke);
    canvas.drawLine(Offset(board.left + 7, board.top + 12), Offset(board.right - 7, board.top + 12), stroke);
    canvas.drawCircle(Offset(board.left + board.width * .32, board.top + board.height * .52), 3, stroke);
    canvas.drawCircle(Offset(board.left + board.width * .68, board.top + board.height * .72), 3, stroke);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
