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
    final fill = Paint()..shader = const LinearGradient(colors:[Color(0xFFFFFFFF),Color(0xFFB8D5F5),Color(0xFFEAF4FF)]).createShader(Rect.fromCenter(center: Offset.zero,width:side,height:side));
    final edge = Paint()..color=const Color(0xFFDAE9FF)..style=PaintingStyle.stroke..strokeWidth=3;
    shield(canvas,Offset(s.width*.23,s.height*.49),side*.78,side,fill,edge);
    shield(canvas,Offset(s.width*.77,s.height*.49),side*.78,side,fill,edge);
    final tp=TextPainter(text:const TextSpan(text:'VS',style:TextStyle(color:Color(0xFFFFE500),fontSize:42,fontWeight:FontWeight.w900)),textDirection:TextDirection.ltr)..layout();
    tp.paint(canvas,Offset((s.width-tp.width)/2,(s.height-tp.height)/2));
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
  void paint(Canvas canvas,Size s){
    final gold=Paint()..color=const Color(0xFFFFD500);
    final edge=Paint()..color=const Color(0xFFFFE34D)..style=PaintingStyle.stroke..strokeWidth=3;
    final cx=s.width*.5; final top=s.height*.02; final w=s.width*.205; final h=s.height*.90;
    final cup=Path()
      ..moveTo(cx-w*.72,top)..lineTo(cx+w*.72,top)
      ..lineTo(cx+w*.60,top+h*.47)
      ..quadraticBezierTo(cx+w*.42,top+h*.82,cx,top+h*.84)
      ..quadraticBezierTo(cx-w*.42,top+h*.82,cx-w*.60,top+h*.47)..close();
    canvas.drawPath(cup,gold); canvas.drawPath(cup,edge);
    final handles=Path()
      ..moveTo(cx-w*.70,top+h*.12)..lineTo(cx-w*1.18,top+h*.08)
      ..quadraticBezierTo(cx-w*1.25,top+h*.56,cx-w*.57,top+h*.59)
      ..moveTo(cx+w*.70,top+h*.12)..lineTo(cx+w*1.18,top+h*.08)
      ..quadraticBezierTo(cx+w*1.25,top+h*.56,cx+w*.57,top+h*.59);
    canvas.drawPath(handles,Paint()..color=const Color(0xFFFFD500)..style=PaintingStyle.stroke..strokeWidth=7..strokeCap=StrokeCap.round);
    final stem=Rect.fromLTWH(cx-w*.16,top+h*.82,w*.32,h*.17);
    canvas.drawRect(stem,gold);
    final base=RRect.fromRectAndRadius(Rect.fromLTWH(cx-w*.55,top+h*.96,w*1.10,h*.12),const Radius.circular(5));
    canvas.drawRRect(base,gold);
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
  void paint(Canvas canvas,Size s){
    final p=Paint()..color=Colors.white;
    final widths=s.width*.085;
    final heights=[s.height*.43,s.height*.68,s.height*.94];
    for(int i=0;i<3;i++){
      final x=s.width*(.25+i*.22);
      final rect=Rect.fromLTWH(x,s.height*.88-heights[i],widths,heights[i]);
      canvas.drawRRect(RRect.fromRectAndRadius(rect,Radius.circular(widths*.22)),p);
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
  void paint(Canvas canvas,Size s){
    final p=Paint()..color=Colors.white;
    void person(double x,double scale){
      final headR=s.height*.205*scale;
      final headY=s.height*.27;
      canvas.drawCircle(Offset(x,headY),headR,p);
      final body=Path()
        ..moveTo(x-headR*1.75,s.height*.86)
        ..lineTo(x-headR*1.48,s.height*.58)
        ..quadraticBezierTo(x,s.height*.48,x+headR*1.48,s.height*.58)
        ..lineTo(x+headR*1.75,s.height*.86)..close();
      canvas.drawPath(body,p);
    }
    person(s.width*.27,.78);
    person(s.width*.50,1.25);
    person(s.width*.73,.78);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _TacticsArt extends StatelessWidget {
  const _TacticsArt();
  @override
  Widget build(BuildContext context)=>CustomPaint(painter:_TacticsBoardPainter());
}
class _TacticsBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size s){
    final line=Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=3.2..strokeJoin=StrokeJoin.round;
    final board=Path()
      ..moveTo(s.width*.20,s.height*.16)
      ..lineTo(s.width*.80,s.height*.16)
      ..lineTo(s.width*.91,s.height*.83)
      ..quadraticBezierTo(s.width*.92,s.height*.88,s.width*.86,s.height*.88)
      ..lineTo(s.width*.14,s.height*.88)
      ..quadraticBezierTo(s.width*.08,s.height*.88,s.width*.09,s.height*.83)
      ..close();
    canvas.drawPath(board,line);
    final dot=Paint()..color=Colors.white;
    final xs=[.30,.50,.70]; final ys=[.28,.49,.70];
    for(final y in ys){for(final x in xs){canvas.drawCircle(Offset(s.width*x,s.height*y),s.height*.060,dot);}}
    final box=Path()
      ..moveTo(s.width*.20,s.height*.40)..lineTo(s.width*.29,s.height*.40)
      ..lineTo(s.width*.27,s.height*.59)..lineTo(s.width*.18,s.height*.59)
      ..close();
    canvas.drawPath(box,line);
    final box2=Path()
      ..moveTo(s.width*.80,s.height*.40)..lineTo(s.width*.71,s.height*.40)
      ..lineTo(s.width*.73,s.height*.59)..lineTo(s.width*.82,s.height*.59)
      ..close();
    canvas.drawPath(box2,line);
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
  void paint(Canvas canvas,Size s){
    final white=Paint()..color=Colors.white;
    final cx=s.width*.39; final r=s.height*.205;
    canvas.drawCircle(Offset(cx,s.height*.25),r,white);
    final torso=Path()
      ..moveTo(cx-r*1.75,s.height*.87)
      ..lineTo(cx-r*1.48,s.height*.55)
      ..quadraticBezierTo(cx,s.height*.43,cx+r*1.48,s.height*.55)
      ..lineTo(cx+r*1.75,s.height*.87)..close();
    canvas.drawPath(torso,white);
    final plus=Paint()..color=const Color(0xFFFFFFFF)..strokeWidth=s.height*.15..strokeCap=StrokeCap.round;
    final x=s.width*.79; final y=s.height*.49; final arm=s.height*.23;
    canvas.drawLine(Offset(x-arm,y),Offset(x+arm,y),plus);
    canvas.drawLine(Offset(x,y-arm),Offset(x,y+arm),plus);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
