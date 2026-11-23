import 'package:flutter/material.dart';
import '../models/club.dart';

class HomeScreen extends StatelessWidget {
  final Club club;
  const HomeScreen({super.key, required this.club});

  static const green = Color(0xFF39FF14);
  static const blue = Color(0xFF00BFFF);
  static const gold = Color(0xFFFFD700);
  static const purple = Color(0xFFB44CFF);
  static const cyan = Color(0xFF00F5E9);
  static const bg = Color(0xFF030805);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final compact = screen.height < 360 || screen.width < 760;
    // Row is RTL: first item is rendered at the right edge.
    // Reverse each row's data order so the visual layout matches the reference.
    final cards = <_CardData>[
      _CardData('مسابقات', 'Matches', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _MatchArt()),
      _CardData('جدول لیگ', 'League Table', blue, const [Color(0xFF0A2442), Color(0xFF050B16)], const _LeagueArt()),
      _CardData('ارتقا بازیکنان', 'Player Upgrade', gold, const [Color(0xFF38270A), Color(0xFF140D04)], const _UpgradeArt()),
      _CardData('خرید مربی', 'Hire Coach', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _CoachArt()),
      _CardData('تاکتیک‌ها', 'Tactics', blue, const [Color(0xFF0A2442), Color(0xFF050B16)], const _TacticsArt()),
      _CardData('خرید بازیکن', 'Buy Player', gold, const [Color(0xFF38270A), Color(0xFF140D04)], const _TeamArt()),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF071A0B), Color(0xFF030805)]),
          ),
          child: CustomPaint(
            painter: _BackgroundLines(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.width * .01, vertical: compact ? 4 : 7),
                child: Column(
                  children: [
                    SizedBox(height: compact ? 66 : 72, child: _TopBar(club: club, compact: compact)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Column(
                        children: [
                          for (int r = 0; r < 2; r++) ...[
                            if (r == 1) const SizedBox(height: 15),
                            Expanded(
                              child: Row(
                                children: [
                                  for (int c = 0; c < 3; c++) ...[
                                    if (c != 0) const SizedBox(width: 15),
                                    Expanded(child: _DashboardCard(data: cards[r * 3 + c], compact: compact)),
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

  @override
  Widget build(BuildContext context) {
    final logo = club.networkLogo;
    return Center(
      child: FractionallySizedBox(
        widthFactor: .98,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: compact ? 9 : 17, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1228),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF39FF14), width: 2),
            boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.6), blurRadius: 20, spreadRadius: 3)],
          ),
          child: Row(
            children: [
              SizedBox(
                width: compact ? 34 : 43, height: compact ? 40 : 50,
                child: ClipOval(child: logo != null
                  ? Image.network(logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                  : Image.asset('assets/logos_png/${club.asset.replaceAll('.svg', '.png')}', fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink())),
              ),
              SizedBox(width: compact ? 5 : 9),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('باشگاه من', maxLines: 1, style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 12 : 16)),
                Text('My Club', style: TextStyle(fontFamily: 'Vazirmatn', color: const Color(0xFFCDD4DC), fontSize: compact ? 9 : 12)),
              ]),
              const Spacer(),
              Text('Lv. 12', style: TextStyle(color: Colors.white, fontSize: compact ? 12 : 16, fontWeight: FontWeight.w600)),
              SizedBox(width: compact ? 5 : 10),
              SizedBox(width: compact ? 82 : 150, height: 14,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00BFFF), width: 1)),
                  padding: const EdgeInsets.all(2),
                  child: Align(alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: .6,
                    child: DecoratedBox(decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(.75), blurRadius: 9, spreadRadius: 1)])))),
                )),
              SizedBox(width: compact ? 7 : 13),
              _Resource(icon: Icons.monetization_on, text: '250,000', color: const Color(0xFFFFD700), compact: compact),
              SizedBox(width: compact ? 5 : 9),
              _Resource(icon: Icons.diamond, text: '15', color: const Color(0xFFB44CFF), compact: compact),
              SizedBox(width: compact ? 7 : 13),
              Icon(Icons.settings, color: const Color(0xFF00BFFF), size: compact ? 19 : 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _Resource extends StatelessWidget {
  final IconData icon; final String text; final Color color; final bool compact;
  const _Resource({required this.icon, required this.text, required this.color, required this.compact});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: compact ? 3 : 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: color, width: 1.2)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: compact ? 13 : 17), const SizedBox(width: 4),
      Text(text, style: TextStyle(color: Colors.white, fontSize: compact ? 9 : 14)),
    ]),
  );
}

class _CardData {
  final String fa, en; final Color neon; final List<Color> gradient; final Widget art;
  const _CardData(this.fa, this.en, this.neon, this.gradient, this.art);
}

class _DashboardCard extends StatelessWidget {
  final _CardData data; final bool compact;
  const _DashboardCard({required this.data, required this.compact});
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: data.gradient),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: data.neon, width: 2),
      boxShadow: [BoxShadow(color: data.neon.withOpacity(.6), blurRadius: 20, spreadRadius: 3)],
    ),
    child: Stack(children: [
      Positioned(
        left: compact ? 7 : 12, right: compact ? 7 : 12,
        top: compact ? 5 : 9, bottom: compact ? 48 : 62,
        child: Center(
          child: SizedBox.expand(child: data.art),
        ),
      ),
      Positioned(
        left: compact ? 8 : 14, right: compact ? 8 : 14,
        bottom: compact ? 7 : 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text(data.fa, maxLines: 1,
              style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: compact ? 13 : 18, fontWeight: FontWeight.bold))),
            FittedBox(fit: BoxFit.scaleDown, child: Text(data.en, maxLines: 1,
              style: TextStyle(fontFamily: 'Vazirmatn', color: const Color(0xFFD0D6DA), fontSize: compact ? 10 : 13))),
          ],
        ),
      ),
      Positioned(left: 0, bottom: 0, child: Container(
        width: compact ? 29 : 39, height: compact ? 25 : 34,
        decoration: BoxDecoration(color: data.neon, borderRadius: const BorderRadius.only(topRight: Radius.circular(9))),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_back, color: Colors.white, size: compact ? 18 : 23),
      )),
    ]),
  );
}

class _BackgroundLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF39FF14).withOpacity(.05)..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// The six card symbols below are intentionally drawn as clean, bold silhouettes
// to match the supplied dashboard reference. Card frames and navigation arrows
// remain in _DashboardCard and are not modified.

class _MatchArt extends StatelessWidget {
  const _MatchArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _MatchPainter());
}
class _MatchPainter extends CustomPainter {
  void shield(Canvas canvas, Offset center, double w, double h, Paint fill, Paint outline) {
    final p = Path()
      ..moveTo(center.dx, center.dy - h * .52)
      ..lineTo(center.dx + w * .50, center.dy - h * .30)
      ..lineTo(center.dx + w * .43, center.dy + h * .18)
      ..quadraticBezierTo(center.dx + w * .28, center.dy + h * .43, center.dx, center.dy + h * .52)
      ..quadraticBezierTo(center.dx - w * .28, center.dy + h * .43, center.dx - w * .43, center.dy + h * .18)
      ..lineTo(center.dx - w * .50, center.dy - h * .30)
      ..close();
    canvas.drawPath(p, fill);
    canvas.drawPath(p, outline);
  }
  @override
  void paint(Canvas canvas, Size s) {
    final side = s.height * 1.02;
    final leftCenter = Offset(s.width*.23,s.height*.49);
    final rightCenter = Offset(s.width*.77,s.height*.49);
    final shieldW = side*.78;
    final blueFill = Paint()..shader = const LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF58B9FF), Color(0xFF0756B8), Color(0xFF092D70)],
    ).createShader(Rect.fromCenter(center:leftCenter,width:shieldW,height:side));
    final redFill = Paint()..shader = const LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFFF7777), Color(0xFFCB1834), Color(0xFF760D25)],
    ).createShader(Rect.fromCenter(center:rightCenter,width:shieldW,height:side));
    final blueEdge = Paint()..color=const Color(0xFF9BD8FF)..style=PaintingStyle.stroke..strokeWidth=3;
    final redEdge = Paint()..color=const Color(0xFFFFA0A0)..style=PaintingStyle.stroke..strokeWidth=3;
    shield(canvas,leftCenter,shieldW,side,blueFill,blueEdge);
    shield(canvas,rightCenter,shieldW,side,redFill,redEdge);

    // Yellow symbols are custom vector paths, centered and kept safely inside each shield.
    final bolt = Path()
      ..moveTo(leftCenter.dx + side*.045, leftCenter.dy - side*.25)
      ..lineTo(leftCenter.dx - side*.105, leftCenter.dy + side*.015)
      ..lineTo(leftCenter.dx - side*.018, leftCenter.dy + side*.015)
      ..lineTo(leftCenter.dx - side*.055, leftCenter.dy + side*.245)
      ..lineTo(leftCenter.dx + side*.115, leftCenter.dy - side*.045)
      ..lineTo(leftCenter.dx + side*.025, leftCenter.dy - side*.045)
      ..close();
    final symbolPaint = Paint()..color=const Color(0xFFFFE500)..style=PaintingStyle.fill;
    canvas.drawPath(bolt,symbolPaint);

    final flame = Path()
      ..moveTo(rightCenter.dx, rightCenter.dy - side*.25)
      ..cubicTo(rightCenter.dx + side*.015, rightCenter.dy - side*.10,
          rightCenter.dx + side*.19, rightCenter.dy - side*.055,
          rightCenter.dx + side*.105, rightCenter.dy + side*.12)
      ..cubicTo(rightCenter.dx + side*.075, rightCenter.dy + side*.245,
          rightCenter.dx - side*.075, rightCenter.dy + side*.255,
          rightCenter.dx - side*.14, rightCenter.dy + side*.12)
      ..cubicTo(rightCenter.dx - side*.20, rightCenter.dy - side*.015,
          rightCenter.dx - side*.035, rightCenter.dy - side*.11,
          rightCenter.dx, rightCenter.dy - side*.25)
      ..close();
    canvas.drawPath(flame,symbolPaint);
    final innerFlame = Path()
      ..moveTo(rightCenter.dx + side*.012, rightCenter.dy - side*.015)
      ..cubicTo(rightCenter.dx + side*.085, rightCenter.dy + side*.075,
          rightCenter.dx + side*.025, rightCenter.dy + side*.18,
          rightCenter.dx - side*.035, rightCenter.dy + side*.13)
      ..cubicTo(rightCenter.dx - side*.075, rightCenter.dy + side*.075,
          rightCenter.dx - side*.005, rightCenter.dy + side*.035,
          rightCenter.dx + side*.012, rightCenter.dy - side*.015)
      ..close();
    canvas.drawPath(innerFlame,Paint()..color=const Color(0xFFFFF2A0));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _LeagueArt extends StatelessWidget {
  const _LeagueArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_TrophyPainter());
}
class _TrophyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final gold = Paint()..color = const Color(0xFFFFD21A);
    final shine = Paint()..color = const Color(0xFFFFEA75)..style = PaintingStyle.stroke..strokeWidth = 2;
    final cx = s.width * .5;
    final top = s.height * .16;
    final cupW = s.width * .34;
    final cupH = s.height * .55;
    final bowl = Path()
      ..moveTo(cx-cupW*.50, top)
      ..lineTo(cx+cupW*.50, top)
      ..lineTo(cx+cupW*.42, top+cupH*.55)
      ..quadraticBezierTo(cx+cupW*.30, top+cupH*.95, cx, top+cupH)
      ..quadraticBezierTo(cx-cupW*.30, top+cupH*.95, cx-cupW*.42, top+cupH*.55)
      ..close();
    canvas.drawPath(bowl, gold);
    canvas.drawPath(bowl, shine);
    final handle = Paint()..color=const Color(0xFFFFD21A)..style=PaintingStyle.stroke..strokeWidth=s.height*.075..strokeCap=StrokeCap.round;
    final left = Path()..moveTo(cx-cupW*.43,top+s.height*.10)..cubicTo(cx-cupW*1.05,top-s.height*.02,cx-cupW*1.02,top+s.height*.52,cx-cupW*.43,top+s.height*.51);
    final right = Path()..moveTo(cx+cupW*.43,top+s.height*.10)..cubicTo(cx+cupW*1.05,top-s.height*.02,cx+cupW*1.02,top+s.height*.52,cx+cupW*.43,top+s.height*.51);
    canvas.drawPath(left,handle); canvas.drawPath(right,handle);
    final stemTop=top+cupH*.90;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx-cupW*.12,stemTop,cupW*.24,s.height*.16),const Radius.circular(3)),gold);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx-cupW*.38,stemTop+s.height*.15,cupW*.76,s.height*.09),const Radius.circular(5)),gold);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _UpgradeArt extends StatelessWidget {
  const _UpgradeArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_UpgradeBarsPainter());
}
class _UpgradeBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p=Paint()..color=Colors.white;
    final barW=s.width*.105;
    final heights=[s.height*.38,s.height*.57,s.height*.76];
    const gapFactor=.065;
    final total=barW*3+s.width*gapFactor*2;
    final left=(s.width-total)/2;
    final baseline=s.height*.82;
    for(int i=0;i<3;i++){
      final x=left+i*(barW+s.width*gapFactor);
      final r=Rect.fromLTWH(x,baseline-heights[i],barW,heights[i]);
      canvas.drawRRect(RRect.fromRectAndRadius(r,Radius.circular(barW*.22)),p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TeamArt extends StatelessWidget {
  const _TeamArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_PeoplePainter());
}
class _PeoplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final white=Paint()..color=Colors.white;
    void person(double x,double scale) {
      final headR=s.height*.115*scale;
      final headCenter=Offset(x,s.height*.25);
      canvas.drawCircle(headCenter,headR,white);
      final shoulder=s.height*.48;
      final body=Path()
        ..moveTo(x-headR*1.05,shoulder)
        ..cubicTo(x-headR*1.85,shoulder+headR*.10,x-headR*2.05,s.height*.68,x-headR*2.10,s.height*.88)
        ..quadraticBezierTo(x,s.height*.96,x+headR*2.10,s.height*.88)
        ..cubicTo(x+headR*2.05,s.height*.68,x+headR*1.85,shoulder+headR*.10,x+headR*1.05,shoulder)
        ..quadraticBezierTo(x,shoulder-headR*.24,x-headR*1.05,shoulder)
        ..close();
      canvas.drawPath(body,white);
    }
    // Three compact person silhouettes, with a slightly larger central player.
    person(s.width*.32,.88);
    person(s.width*.50,1.08);
    person(s.width*.68,.88);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TacticsArt extends StatelessWidget {
  const _TacticsArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_ShuffleArrowsPainter());
}
class _ShuffleArrowsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.height * .105
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final arrowHead = Paint()..color = Colors.white..style = PaintingStyle.fill;

    // Two clean, crossing directional paths form a bold shuffle symbol.
    final upperPath = Path()
      ..moveTo(s.width*.19, s.height*.69)
      ..cubicTo(s.width*.34, s.height*.69, s.width*.37, s.height*.30, s.width*.57, s.height*.30)
      ..lineTo(s.width*.79, s.height*.30);
    canvas.drawPath(upperPath, stroke);
    final lowerPath = Path()
      ..moveTo(s.width*.19, s.height*.30)
      ..cubicTo(s.width*.36, s.height*.30, s.width*.39, s.height*.69, s.width*.57, s.height*.69)
      ..lineTo(s.width*.79, s.height*.69);
    canvas.drawPath(lowerPath, stroke);

    void head(Offset tip, double direction) {
      final p = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(tip.dx - s.width*.15, tip.dy - direction*s.height*.13)
        ..lineTo(tip.dx - s.width*.15, tip.dy + direction*s.height*.13)
        ..close();
      canvas.drawPath(p, arrowHead);
    }
    head(Offset(s.width*.84,s.height*.30), 1);
    head(Offset(s.width*.84,s.height*.69), -1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _CoachArt extends StatelessWidget {
  const _CoachArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_CoachPlusPainter());
}
class _CoachPlusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final white=Paint()..color=Colors.white;
    final cx=s.width*.405, headR=s.height*.12;
    canvas.drawCircle(Offset(cx,s.height*.20),headR,white);
    // Slightly larger professional jacket silhouette.
    final jacket=Path()
      ..moveTo(cx-headR*1.18,s.height*.39)
      ..lineTo(cx-headR*2.75,s.height*.49)
      ..quadraticBezierTo(cx-headR*3.0,s.height*.54,cx-headR*2.65,s.height*.90)
      ..lineTo(cx+headR*2.65,s.height*.90)
      ..quadraticBezierTo(cx+headR*3.0,s.height*.54,cx+headR*2.75,s.height*.49)
      ..lineTo(cx+headR*1.18,s.height*.39)
      ..lineTo(cx,s.height*.55)
      ..close();
    canvas.drawPath(jacket,white);
    final lapel=Paint()..color=const Color(0xFF0B3518)..style=PaintingStyle.stroke..strokeWidth=2.1;
    final left=Path()..moveTo(cx-headR*1.10,s.height*.405)..lineTo(cx-headR*.22,s.height*.68)..lineTo(cx-headR*.04,s.height*.54);
    final right=Path()..moveTo(cx+headR*1.10,s.height*.405)..lineTo(cx+headR*.22,s.height*.68)..lineTo(cx+headR*.04,s.height*.54);
    canvas.drawPath(left,lapel); canvas.drawPath(right,lapel);
    // Plus is closer to the shoulder, with a visible gap.
    final plus=Paint()..color=Colors.white..strokeWidth=s.height*.095..strokeCap=StrokeCap.round;
    final px=s.width*.59, py=s.height*.53, arm=s.height*.155;
    canvas.drawLine(Offset(px-arm,py),Offset(px+arm,py),plus);
    canvas.drawLine(Offset(px,py-arm),Offset(px,py+arm),plus);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
