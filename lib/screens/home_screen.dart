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
    final compact = screen.height < 430 || screen.width < 780;
    final cards = <_CardData>[
      _CardData('مسابقات', 'Matches', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _MatchArt()),
      _CardData('جدول لیگ', 'League Table', blue, const [Color(0xFF0A2442), Color(0xFF050B16)], const _LeagueArt()),
      _CardData('ارتقا بازیکنان', 'Player Upgrade', gold, const [Color(0xFF38270A), Color(0xFF140D04)], const _UpgradeArt()),
      _CardData('خرید بازیکن', 'Buy Player', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _TeamArt()),
      _CardData('تاکتیک‌ها', 'Tactics', cyan, const [Color(0xFF082D3A), Color(0xFF041018)], const _TacticsArt()),
      _CardData('خرید مربی', 'Hire Coach', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _CoachArt()),
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
                    SizedBox(height: compact ? 60 : 72, child: _TopBar(club: club, compact: compact)),
                    SizedBox(height: compact ? 7 : 12),
                    Expanded(
                      child: Column(
                        children: [
                          for (int r = 0; r < 2; r++) ...[
                            if (r == 1) SizedBox(height: compact ? 9 : 15),
                            Expanded(
                              child: Row(
                                children: [
                                  for (int c = 0; c < 3; c++) ...[
                                    if (c != 0) SizedBox(width: compact ? 9 : 15),
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
    final logo = club.networkLogo ??
        'https://upload.wikimedia.org/wikipedia/en/c/cc/Chelsea_FC.svg';
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
                child: ClipOval(child: Image.network(logo, fit: BoxFit.contain,
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
      Padding(
        padding: EdgeInsets.fromLTRB(compact ? 7 : 12, compact ? 5 : 9, compact ? 7 : 12, compact ? 27 : 38),
        child: Column(children: [
          Expanded(child: SizedBox.expand(child: data.art)),
          FittedBox(fit: BoxFit.scaleDown, child: Text(data.fa, maxLines: 1,
            style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: compact ? 13 : 18, fontWeight: FontWeight.bold))),
          FittedBox(fit: BoxFit.scaleDown, child: Text(data.en, maxLines: 1,
            style: TextStyle(fontFamily: 'Vazirmatn', color: const Color(0xFFD0D6DA), fontSize: compact ? 10 : 13))),
        ]),
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

class _MatchArt extends StatelessWidget {
  const _MatchArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _MatchPainter());
}
class _MatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final silver = Paint()..shader = const LinearGradient(colors: [Colors.white, Color(0xFF9EAAB6), Colors.white]).createShader(Offset.zero & s);
    final edge = Paint()..color = const Color(0xFF263342)..style = PaintingStyle.stroke..strokeWidth = 2.2;
    Path shield(double x) => Path()..moveTo(x - s.width*.14, s.height*.17)..lineTo(x + s.width*.14, s.height*.17)
      ..lineTo(x + s.width*.12, s.height*.61)..quadraticBezierTo(x, s.height*.86, x - s.width*.12, s.height*.61)..close();
    for (final x in [s.width*.22, s.width*.78]) {
      final path = shield(x); canvas.drawShadow(path, Colors.black, 5, true); canvas.drawPath(path, silver); canvas.drawPath(path, edge);
      final stripe = Paint()..color = const Color(0xFF526477)..strokeWidth = 2;
      canvas.drawLine(Offset(x, s.height*.2), Offset(x, s.height*.68), stripe);
      canvas.drawLine(Offset(x-s.width*.08, s.height*.39), Offset(x+s.width*.08, s.height*.39), stripe);
    }
    final tp = TextPainter(text: const TextSpan(text: 'VS', style: TextStyle(color: Color(0xFFFFD700), fontSize: 30, fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 12)])), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset((s.width-tp.width)/2, (s.height-tp.height)*.43));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeagueArt extends StatelessWidget {
  const _LeagueArt();
  static const urls = [
    'https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Real_Madrid_CF.svg/64px-Real_Madrid_CF.svg.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/4/47/FC_Barcelona_%28crest%29.svg/64px-FC_Barcelona_%28crest%29.svg.png',
    '',
    'https://upload.wikimedia.org/wikipedia/en/thumb/f/f4/Atletico_Madrid_2017_logo.svg/64px-Atletico_Madrid_2017_logo.svg.png',
    'https://upload.wikimedia.org/wikipedia/en/thumb/3/3b/Sevilla_FC_logo.svg/64px-Sevilla_FC_logo.svg.png',
  ];
  static const names = ['Real Madrid', 'Barcelona', 'My Club', 'Atletico Madrid', 'Sevilla'];
  static const points = ['32', '31', '33', '28', '26'];
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) => Column(
    children: [
      SizedBox(height: c.maxHeight*.22, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 25),
        const SizedBox(width: 6),
        const Text('LEAGUE TABLE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ])),
      Container(height: c.maxHeight*.13, padding: const EdgeInsets.symmetric(horizontal: 4),
        color: const Color(0x553C9FE8), child: const Row(children: [
          Expanded(flex: 1, child: Text('رتبه', textAlign: TextAlign.center, style: _tableHeader)),
          Expanded(flex: 5, child: Text('تیم', textAlign: TextAlign.center, style: _tableHeader)),
          Expanded(flex: 1, child: Text('امتیاز', textAlign: TextAlign.center, style: _tableHeader)),
        ])),
      for (int i = 0; i < 5; i++) Expanded(child: Container(
        color: i == 2 ? const Color(0x5539FF14) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(children: [
          Expanded(flex: 1, child: Text('${i+1}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 9))),
          Expanded(flex: 5, child: Row(children: [
            if (urls[i].isNotEmpty) Image.network(urls[i], width: 16, height: 16, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(width: 16, height: 16)),
            if (urls[i].isEmpty) const SizedBox(width: 16, height: 16),
            const SizedBox(width: 3),
            Expanded(child: Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: i == 2 ? FontWeight.bold : FontWeight.normal))),
          ])),
          Expanded(flex: 1, child: Text(points[i], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
        ]),
      )),
    ],
  ));
}
const _tableHeader = TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold);

class _UpgradeArt extends StatelessWidget {
  const _UpgradeArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _BarsPainter());
}
class _BarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final base = s.height*.83; final barW = s.width*.14;
    final heights = [s.height*.34, s.height*.55, s.height*.76];
    for (int i=0;i<3;i++) {
      final rect = Rect.fromLTWH(s.width*(.19+i*.25), base-heights[i], barW, heights[i]);
      final paint = Paint()..shader = const LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Color(0xFFFFFF75),Color(0xFFFFA000)]).createShader(rect);
      canvas.drawRRect(RRect.fromRectAndRadius(rect,const Radius.circular(6)),paint);
      canvas.drawCircle(Offset(rect.center.dx,rect.top-7),3,Paint()..color=const Color(0xFFFFE66D));
    }
    final axis=Paint()..color=Colors.white.withOpacity(.75)..strokeWidth=2;
    canvas.drawLine(Offset(s.width*.1,base),Offset(s.width*.92,base),axis);
    final path=Path()..moveTo(s.width*.18,s.height*.42)..lineTo(s.width*.43,s.height*.27)..lineTo(s.width*.68,s.height*.13)..lineTo(s.width*.63,s.height*.13)..moveTo(s.width*.68,s.height*.13)..lineTo(s.width*.67,s.height*.19);
    canvas.drawPath(path,Paint()..color=const Color(0xFFFFD700)..style=PaintingStyle.stroke..strokeWidth=3..strokeCap=StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TeamArt extends StatelessWidget {
  const _TeamArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _SilhouettesPainter());
}
class _SilhouettesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final fill=Paint()..color=Colors.white.withOpacity(.96);
    for(int i=0;i<3;i++){
      final cx=s.width*(.25+i*.25); final r=s.shortestSide*.09;
      canvas.drawCircle(Offset(cx,s.height*.25),r,fill);
      final body=Path()..moveTo(cx-r*1.35,s.height*.49)..quadraticBezierTo(cx,s.height*.37,cx+r*1.35,s.height*.49)
        ..lineTo(cx+r*1.75,s.height*.88)..quadraticBezierTo(cx,s.height*.96,cx-r*1.75,s.height*.88)..close();
      canvas.drawPath(body,fill);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TacticsArt extends StatelessWidget {
  const _TacticsArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_TacticsPainter());
}
class _TacticsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size s){
    final line=Paint()..color=Colors.white.withOpacity(.9)..style=PaintingStyle.stroke..strokeWidth=2;
    final r=Rect.fromLTWH(s.width*.16,s.height*.06,s.width*.68,s.height*.88);
    canvas.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(8)),line);
    canvas.drawLine(Offset(s.width/2,r.top),Offset(s.width/2,r.bottom),line);
    canvas.drawCircle(Offset(s.width/2,s.height/2),s.height*.13,line);
    canvas.drawRect(Rect.fromLTWH(r.left+s.width*.12,r.top,s.width*.44,s.height*.13),line);
    canvas.drawRect(Rect.fromLTWH(r.left+s.width*.12,r.bottom-s.height*.13,s.width*.44,s.height*.13),line);
    final pts=<Offset>[
      Offset(s.width*.5,s.height*.12),Offset(s.width*.32,s.height*.28),Offset(s.width*.5,s.height*.28),Offset(s.width*.68,s.height*.28),
      Offset(s.width*.27,s.height*.49),Offset(s.width*.5,s.height*.47),Offset(s.width*.73,s.height*.49),
      Offset(s.width*.32,s.height*.7),Offset(s.width*.5,s.height*.7),Offset(s.width*.68,s.height*.7),Offset(s.width*.5,s.height*.88),
    ];
    for(final p in pts){canvas.drawCircle(p,5,Paint()..color=Colors.white);canvas.drawCircle(p,5,Paint()..color=const Color(0xFF00F5E9)..style=PaintingStyle.stroke..strokeWidth=1.2);}
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _CoachArt extends StatelessWidget {
  const _CoachArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_CoachPainter());
}
class _CoachPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size s){
    final white=Paint()..color=Colors.white.withOpacity(.97);
    final cx=s.width*.39; final r=s.shortestSide*.12;
    canvas.drawCircle(Offset(cx,s.height*.24),r,white);
    final torso=Path()..moveTo(cx-r*1.8,s.height*.83)..lineTo(cx-r*1.35,s.height*.49)
      ..quadraticBezierTo(cx,s.height*.37,cx+r*1.35,s.height*.49)..lineTo(cx+r*1.8,s.height*.83)..close();
    canvas.drawPath(torso,white);
    final p=Paint()..color=const Color(0xFF39FF14)..strokeWidth=s.shortestSide*.055..strokeCap=StrokeCap.round;
    final center=Offset(s.width*.77,s.height*.53); final len=s.shortestSide*.22;
    canvas.drawLine(Offset(center.dx-len,center.dy),Offset(center.dx+len,center.dy),p);
    canvas.drawLine(Offset(center.dx,center.dy-len),Offset(center.dx,center.dy+len),p);
    canvas.drawCircle(center,len*1.42,Paint()..color=const Color(0xFF39FF14)..style=PaintingStyle.stroke..strokeWidth=2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
