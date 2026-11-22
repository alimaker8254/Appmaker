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
    final cards = <_CardData>[
      _CardData('مسابقات', 'Matches', green, const [Color(0xFF0B3518), Color(0xFF06130A)], const _MatchArt()),
      _CardData('جدول لیگ', 'League Table', blue, const [Color(0xFF0A2442), Color(0xFF050B16)], const _LeagueArt()),
      _CardData('ارتقا بازیکنان', 'Player Upgrade', gold, const [Color(0xFF38270A), Color(0xFF140D04)], const _UpgradeArt()),
      _CardData('خرید بازیکن', 'Buy Player', gold, const [Color(0xFF38270A), Color(0xFF140D04)], const _TeamArt()),
      _CardData('تاکتیک‌ها', 'Tactics', blue, const [Color(0xFF0A2442), Color(0xFF050B16)], const _TacticsArt()),
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
    final line = Paint()..color = Colors.white.withOpacity(.95)..style = PaintingStyle.stroke..strokeWidth = 2.2;
    final r = Rect.fromLTWH(s.width*.12, s.height*.12, s.width*.76, s.height*.76);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(5)), line);
    canvas.drawLine(Offset(s.width/2,r.top), Offset(s.width/2,r.bottom), line);
    canvas.drawCircle(Offset(s.width/2,s.height/2), s.height*.19, line);
    canvas.drawCircle(Offset(s.width/2,s.height/2), 2.5, Paint()..color=Colors.white);
    final boxW=s.width*.17; final boxH=s.height*.40;
    canvas.drawRect(Rect.fromLTWH(r.left,r.center.dy-boxH/2,boxW,boxH),line);
    canvas.drawRect(Rect.fromLTWH(r.right-boxW,r.center.dy-boxH/2,boxW,boxH),line);
    final smallW=s.width*.07; final smallH=s.height*.22;
    canvas.drawRect(Rect.fromLTWH(r.left,r.center.dy-smallH/2,smallW,smallH),line);
    canvas.drawRect(Rect.fromLTWH(r.right-smallW,r.center.dy-smallH/2,smallW,smallH),line);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
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
  static const names = ['رئال مادرید', 'بارسلونا', 'باشگاه من', 'اتلتیکو مادرید', 'سویا'];
  static const points = ['32', '31', '33', '28', '26'];
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) => Column(
    children: [
      SizedBox(height: c.maxHeight*.18, child: const Center(
        child: Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 24),
      )),
      Container(height: c.maxHeight*.14, padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: const Color(0x553C9FE8), borderRadius: BorderRadius.circular(4)),
        child: const Row(children: [
          Expanded(flex: 1, child: Text('رتبه', textAlign: TextAlign.center, style: _tableHeader)),
          Expanded(flex: 5, child: Text('تیم', textAlign: TextAlign.center, style: _tableHeader)),
          Expanded(flex: 1, child: Text('امتیاز', textAlign: TextAlign.center, style: _tableHeader)),
        ])),
      for (int i = 0; i < 5; i++) Expanded(child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: i == 2 ? const Color(0x6639FF14) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Row(children: [
          Expanded(flex: 1, child: Text('${i+1}', textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 9))),
          Expanded(flex: 5, child: Row(children: [
            if (urls[i].isNotEmpty) Image.network(urls[i], width: 16, height: 16, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            const SizedBox(width: 3),
            Expanded(child: Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: i == 2 ? FontWeight.bold : FontWeight.normal))),
          ])),
          Expanded(flex: 1, child: Text(points[i], textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
        ]),
      )),
    ],
  ));
}
const _tableHeader = TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold);

class _UpgradeArt extends StatelessWidget {
  const _UpgradeArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _UpgradePainter());
}
class _UpgradePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final white=Paint()..color=Colors.white.withOpacity(.97);
    final cx=s.width*.34; final head=s.shortestSide*.085;
    canvas.drawCircle(Offset(cx,s.height*.19),head,white);
    final torso=Path()
      ..moveTo(cx-head*1.3,s.height*.43)..quadraticBezierTo(cx-head*1.6,s.height*.36,cx-head*.3,s.height*.38)
      ..lineTo(cx+head*.9,s.height*.48)..lineTo(cx+head*2.0,s.height*.66)
      ..lineTo(cx+head*1.5,s.height*.74)..lineTo(cx+head*.2,s.height*.60)
      ..lineTo(cx-head*.7,s.height*.82)..lineTo(cx-head*1.5,s.height*.77)..close();
    canvas.drawPath(torso,white);
    final limb=Paint()..color=Colors.white.withOpacity(.97)..strokeWidth=head*.62..strokeCap=StrokeCap.round;
    canvas.drawLine(Offset(cx-head*.8,s.height*.72),Offset(cx-head*1.7,s.height*.94),limb);
    canvas.drawLine(Offset(cx+head*1.1,s.height*.58),Offset(cx+head*2.25,s.height*.32),limb);
    canvas.drawLine(Offset(cx+head*2.25,s.height*.32),Offset(cx+head*2.8,s.height*.30),limb);
    canvas.drawCircle(Offset(cx+head*3.2,s.height*.23),head*.48,Paint()..color=const Color(0xFFFFD700));
    final gold=Paint()..color=const Color(0xFFFFD700)..strokeWidth=3.5..strokeCap=StrokeCap.round;
    for(int i=0;i<3;i++){
      final x=s.width*(.70+i*.10); final y=s.height*(.72-i*.19);
      canvas.drawLine(Offset(x,y+s.height*.13),Offset(x,y),gold);
      canvas.drawLine(Offset(x,y),Offset(x-5,y+7),gold);
      canvas.drawLine(Offset(x,y),Offset(x+5,y+7),gold);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TeamArt extends StatelessWidget {
  const _TeamArt();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _SearchPlayerPainter());
}
class _SearchPlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final white=Paint()..color=Colors.white.withOpacity(.97);
    final cx=s.width*.38; final r=s.shortestSide*.13;
    canvas.drawCircle(Offset(cx,s.height*.25),r,white);
    final torso=Path()..moveTo(cx-r*1.9,s.height*.88)..lineTo(cx-r*1.55,s.height*.52)
      ..quadraticBezierTo(cx,s.height*.39,cx+r*1.55,s.height*.52)..lineTo(cx+r*1.9,s.height*.88)..close();
    canvas.drawPath(torso,white);
    final lens=Offset(s.width*.68,s.height*.49); final radius=s.shortestSide*.22;
    canvas.drawCircle(lens,radius,Paint()..color=const Color(0xFFFFD700)..style=PaintingStyle.stroke..strokeWidth=5);
    canvas.drawLine(Offset(lens.dx+radius*.68,lens.dy+radius*.68),
      Offset(lens.dx+radius*1.55,lens.dy+radius*1.55),
      Paint()..color=const Color(0xFFFFD700)..strokeWidth=8..strokeCap=StrokeCap.round);
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
  void arrow(Canvas canvas, Offset a, Offset control, Offset b, Paint p) {
    final path=Path()..moveTo(a.dx,a.dy)..quadraticBezierTo(control.dx,control.dy,b.dx,b.dy);
    canvas.drawPath(path,p);
    final d=b-control; final len=d.distance;
    if(len>0){
      final ux=d.dx/len, uy=d.dy/len;
      canvas.drawLine(b,Offset(b.dx-ux*9-uy*5,b.dy-uy*9+ux*5),p);
      canvas.drawLine(b,Offset(b.dx-ux*9+uy*5,b.dy-uy*9-ux*5),p);
    }
  }
  @override
  void paint(Canvas canvas,Size s){
    final line=Paint()..color=Colors.white.withOpacity(.95)..style=PaintingStyle.stroke..strokeWidth=2.2..strokeCap=StrokeCap.round;
    final board=Rect.fromLTWH(s.width*.12,s.height*.08,s.width*.76,s.height*.82);
    canvas.drawRRect(RRect.fromRectAndRadius(board,const Radius.circular(12)),line);
    final route=Paint()..color=const Color(0xFF00BFFF)..style=PaintingStyle.stroke..strokeWidth=2.4..strokeCap=StrokeCap.round;
    final pts=[Offset(s.width*.28,s.height*.30),Offset(s.width*.49,s.height*.28),Offset(s.width*.70,s.height*.30),
      Offset(s.width*.35,s.height*.65),Offset(s.width*.63,s.height*.65)];
    for(final p in pts) canvas.drawCircle(p,5.5,Paint()..color=Colors.white);
    arrow(canvas,pts[0],Offset(s.width*.34,s.height*.12),Offset(s.width*.51,s.height*.23),route);
    arrow(canvas,pts[1],Offset(s.width*.63,s.height*.10),Offset(s.width*.72,s.height*.26),route);
    arrow(canvas,pts[3],Offset(s.width*.48,s.height*.47),Offset(s.width*.65,s.height*.57),route);
    arrow(canvas,pts[4],Offset(s.width*.49,s.height*.82),Offset(s.width*.31,s.height*.72),route);
    canvas.drawCircle(Offset(s.width*.5,s.height*.48),s.height*.10,line);
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
    canvas.drawCircle(Offset(cx,s.height*.20),r,white);
    final jacket=Path()..moveTo(cx-r*1.05,s.height*.43)..lineTo(cx-r*2.15,s.height*.57)
      ..lineTo(cx-r*2.45,s.height*.91)..lineTo(cx+r*2.45,s.height*.91)
      ..lineTo(cx+r*2.15,s.height*.57)..lineTo(cx+r*1.05,s.height*.43)
      ..lineTo(cx,s.height*.58)..close();
    canvas.drawPath(jacket,white);
    final dark=Paint()..color=const Color(0xFF193A2A);
    final lapel1=Path()..moveTo(cx-r*1.05,s.height*.43)..lineTo(cx-r*.15,s.height*.73)
      ..lineTo(cx-r*.45,s.height*.86)..lineTo(cx-r*1.0,s.height*.60)..close();
    final lapel2=Path()..moveTo(cx+r*1.05,s.height*.43)..lineTo(cx+r*.15,s.height*.73)
      ..lineTo(cx+r*.45,s.height*.86)..lineTo(cx+r*1.0,s.height*.60)..close();
    canvas.drawPath(lapel1,dark); canvas.drawPath(lapel2,dark);
    final tie=Path()..moveTo(cx,s.height*.62)..lineTo(cx-r*.25,s.height*.69)
      ..lineTo(cx,s.height*.88)..lineTo(cx+r*.25,s.height*.69)..close();
    canvas.drawPath(tie,dark);
    final p=Paint()..color=const Color(0xFF39FF14)..strokeWidth=s.shortestSide*.055..strokeCap=StrokeCap.round;
    final center=Offset(s.width*.78,s.height*.51); final len=s.shortestSide*.22;
    canvas.drawLine(Offset(center.dx-len,center.dy),Offset(center.dx+len,center.dy),p);
    canvas.drawLine(Offset(center.dx,center.dy-len),Offset(center.dx,center.dy+len),p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
