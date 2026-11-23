import 'package:flutter/material.dart';
import '../models/club.dart';

class MatchesScreen extends StatelessWidget {
  final Club club;
  const MatchesScreen({super.key, required this.club});

  static const _starters = <_SquadPlayer>[
    _SquadPlayer('Vinícius Jr.', 'LW', 95),
    _SquadPlayer('Mbappé', 'CF', 96),
    _SquadPlayer('Salah', 'RW', 95),
    _SquadPlayer('De Bruyne', 'CM', 93),
    _SquadPlayer('Modrić', 'CM', 94),
    _SquadPlayer('Bellingham', 'CM', 93),
    _SquadPlayer('Davies', 'LB', 91),
    _SquadPlayer('Rüdiger', 'CB', 92),
    _SquadPlayer('Dias', 'CB', 94),
    _SquadPlayer('Hakimi', 'RB', 90),
    _SquadPlayer('Courtois', 'GK', 95),
  ];

  static const _bench = <_SquadPlayer>[
    _SquadPlayer('Alisson', 'GK', 89),
    _SquadPlayer('Laporte', 'CB', 87),
    _SquadPlayer('Grimaldo', 'LB', 86),
    _SquadPlayer('Kroos', 'CM', 88),
    _SquadPlayer('Pedri', 'CM', 90),
    _SquadPlayer('Dembélé', 'RW', 87),
    _SquadPlayer('Vlahović', 'ST', 85),
    _SquadPlayer('Son', 'LW', 88),
    _SquadPlayer('Rodri', 'CDM', 89),
    _SquadPlayer('Foden', 'CAM', 86),
    _SquadPlayer('Kane', 'ST', 90),
    _SquadPlayer('Gvardiol', 'CB', 85),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031008),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.center, radius: 1.1,
            colors: [Color(0xFF087A20), Color(0xFF034312), Color(0xFF010B04)]),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final compact = h < 500;
            final fieldHeight = h * .685;
            final benchHeight = h * .185;
            return Column(
              children: [
                SizedBox(
                  height: fieldHeight,
                  width: w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(child: CustomPaint(painter: _PitchPainter())),
                      Positioned(
                        left: w * .025, top: fieldHeight * .085,
                        child: _FormationBadge(compact: compact),
                      ),
                      for (var i = 0; i < _starters.length; i++)
                        _StarterPosition(
                          player: _starters[i],
                          x: _positions[i].$1,
                          y: _positions[i].$2,
                          cardWidth: (w * .115).clamp(104.0, 180.0).toDouble(),
                          fieldWidth: w,
                          fieldHeight: fieldHeight,
                          compact: compact,
                        ),
                    ],
                  ),
                ),
                Container(
                  height: benchHeight,
                  margin: EdgeInsets.symmetric(horizontal: w * .03),
                  padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14, vertical: compact ? 5 : 8),
                  decoration: BoxDecoration(
                    color: const Color(0xD905210D),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF39FF14), width: 2.5),
                    boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.55), blurRadius: 18, spreadRadius: 2)],
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: _bench.length,
                    separatorBuilder: (_, __) => SizedBox(width: compact ? 8 : 15),
                    itemBuilder: (context, index) => SizedBox(
                      width: (w * .112).clamp(100.0, 174.0).toDouble(),
                      child: _SquadCard(player: _bench[index], compact: compact),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: (w * .28).clamp(230.0, 430.0),
                      height: compact ? 46 : 62,
                      child: ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('شروع مسابقه به‌زودی فعال می‌شود', textDirection: TextDirection.rtl)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF075DFF),
                          foregroundColor: Colors.white,
                          elevation: 12,
                          shadowColor: const Color(0xFF00CFFF),
                          shape: const StadiumBorder(side: BorderSide(color: Color(0xFF00DFFF), width: 2.5)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.play_arrow, size: compact ? 29 : 38),
                          SizedBox(width: compact ? 5 : 10),
                          Text('Start Match', style: TextStyle(fontSize: compact ? 18 : 26, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Normalized coordinates within the pitch area, measured at card centers.
  static const _positions = <(double, double)>[
    (.31, .16), (.50, .135), (.70, .16),
    (.33, .47), (.50, .47), (.68, .47),
    (.205, .735), (.405, .755), (.61, .755), (.805, .735),
    (.50, .92),
  ];
}

class _SquadPlayer {
  final String name;
  final String position;
  final int rating;
  const _SquadPlayer(this.name, this.position, this.rating);
}

class _StarterPosition extends StatelessWidget {
  final _SquadPlayer player;
  final double x, y, cardWidth, fieldWidth, fieldHeight;
  final bool compact;
  const _StarterPosition({required this.player, required this.x, required this.y, required this.cardWidth,
    required this.fieldWidth, required this.fieldHeight, required this.compact});

  @override
  Widget build(BuildContext context) {
    final cardHeight = cardWidth * .68;
    return Positioned(
      left: fieldWidth * x - cardWidth / 2,
      top: fieldHeight * y - cardHeight / 2,
      width: cardWidth,
      height: cardHeight,
      child: _SquadCard(player: player, compact: compact),
    );
  }
}

class _SquadCard extends StatelessWidget {
  final _SquadPlayer player;
  final bool compact;
  const _SquadCard({required this.player, required this.compact});

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF00CFFF);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF103B5E), Color(0xFF07182A), Color(0xFF020B16)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cyan, width: 2),
        boxShadow: [BoxShadow(color: cyan.withOpacity(.55), blurRadius: 12, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 4, 7, 0),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${player.rating}', style: TextStyle(color: Colors.white, fontSize: compact ? 20 : 27, fontWeight: FontWeight.w900)),
                  Text(player.position, style: TextStyle(color: const Color(0xFFFFE500), fontSize: compact ? 15 : 20, fontWeight: FontWeight.bold)),
                ])),
                Expanded(child: Icon(Icons.person, color: Colors.white.withOpacity(.9), size: compact ? 51 : 70)),
              ]),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: compact ? 2 : 4, horizontal: 3),
            decoration: const BoxDecoration(color: Color(0xE8071828), borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
            alignment: Alignment.center,
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(player.name, maxLines: 1,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 12 : 16))),
          ),
        ],
      ),
    );
  }
}

class _FormationBadge extends StatelessWidget {
  final bool compact;
  const _FormationBadge({required this.compact});
  @override
  Widget build(BuildContext context) => Container(
    width: compact ? 100 : 145,
    height: compact ? 86 : 126,
    decoration: BoxDecoration(
      color: const Color(0xE9051B0C),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color(0xFF39FF14), width: 2.5),
      boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.55), blurRadius: 18, spreadRadius: 1)],
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('4-3-3', style: TextStyle(color: Colors.white, fontSize: compact ? 23 : 34, fontWeight: FontWeight.bold)),
      Icon(Icons.sports_soccer, color: Colors.white, size: compact ? 37 : 54),
    ]),
  );
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final field = Path()
      ..moveTo(s.width * .20, s.height * .025)
      ..lineTo(s.width * .80, s.height * .025)
      ..lineTo(s.width * .985, s.height * .985)
      ..lineTo(s.width * .055, s.height * .985)
      ..close();

    final fill = Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFF087A20), Color(0xFF079522), Color(0xFF006016)]).createShader(Offset.zero & s);
    canvas.drawPath(field, fill);

    final stripe = Paint()..color = const Color(0xFF9BFF72).withOpacity(.055);
    for (int i = 0; i < 9; i++) {
      final y1 = s.height * (.05 + i * .105);
      final y2 = s.height * (.05 + (i + 1) * .105);
      final band = Path()
        ..moveTo(s.width * (.20 - i * .016), y1)
        ..lineTo(s.width * (.80 + i * .016), y1)
        ..lineTo(s.width * (.80 + (i + 1) * .016), y2)
        ..lineTo(s.width * (.20 - (i + 1) * .016), y2)
        ..close();
      if (i.isEven) canvas.drawPath(band, stripe);
    }

    final line = Paint()..color = const Color(0xFFDAFFE0).withOpacity(.85)..style = PaintingStyle.stroke..strokeWidth = 2;
    final glow = Paint()..color = const Color(0xFF39FF14).withOpacity(.95)..style = PaintingStyle.stroke..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    canvas.drawPath(field, glow);
    canvas.drawPath(field, Paint()..color = const Color(0xFF39FF14)..style = PaintingStyle.stroke..strokeWidth = 3);

    // Pitch markings follow the same perspective as the outer touchlines.
    final inner = Path()
      ..moveTo(s.width * .235, s.height * .045)
      ..lineTo(s.width * .765, s.height * .045)
      ..lineTo(s.width * .94, s.height * .955)
      ..lineTo(s.width * .10, s.height * .955)
      ..close();
    canvas.drawPath(inner, line);
    canvas.drawLine(Offset(s.width*.205,s.height*.50), Offset(s.width*.795,s.height*.50), line);
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width*.50,s.height*.50), width:s.width*.17,height:s.height*.18), line);
    canvas.drawCircle(Offset(s.width*.50,s.height*.50), 3, Paint()..color=Colors.white);

    final topBox = Path()
      ..moveTo(s.width*.39,s.height*.045)..lineTo(s.width*.61,s.height*.045)
      ..lineTo(s.width*.64,s.height*.19)..lineTo(s.width*.36,s.height*.19)..close();
    final bottomBox = Path()
      ..moveTo(s.width*.36,s.height*.955)..lineTo(s.width*.64,s.height*.955)
      ..lineTo(s.width*.61,s.height*.81)..lineTo(s.width*.39,s.height*.81)..close();
    canvas.drawPath(topBox,line); canvas.drawPath(bottomBox,line);
    canvas.drawRect(Rect.fromCenter(center: Offset(s.width*.50,s.height*.115),width:s.width*.09,height:s.height*.07),line);
    canvas.drawRect(Rect.fromCenter(center: Offset(s.width*.50,s.height*.885),width:s.width*.12,height:s.height*.10),line);
    canvas.drawArc(Rect.fromCenter(center: Offset(s.width*.50,s.height*.885),width:s.width*.20,height:s.height*.17),3.14,3.14,false,line);
    canvas.drawArc(Rect.fromCenter(center: Offset(s.width*.50,s.height*.115),width:s.width*.15,height:s.height*.12),0,3.14,false,line);
    canvas.drawArc(Rect.fromCenter(center: Offset(s.width*.50,s.height*.985),width:s.width*.08,height:s.height*.07),3.14,3.14,false,line);
    canvas.drawArc(Rect.fromCenter(center: Offset(s.width*.50,s.height*.025),width:s.width*.08,height:s.height*.07),0,3.14,false,line);

    // Side boundary and penalty-area corners are subtly visible.
    canvas.drawLine(Offset(s.width*.20,s.height*.025),Offset(s.width*.055,s.height*.985),line);
    canvas.drawLine(Offset(s.width*.80,s.height*.025),Offset(s.width*.985,s.height*.985),line);
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) => false;
}
