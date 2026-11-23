import 'package:flutter/material.dart';
import '../models/club.dart';

class MatchesScreen extends StatefulWidget {
  final Club club;
  const MatchesScreen({super.key, required this.club});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  static const _gk = _SquadPlayer('Courtois', 'GK', 95);
  static const _alisson = _SquadPlayer('Alisson', 'GK', 89);
  static const _vinicius = _SquadPlayer('Vinícius Jr.', 'LW', 95);
  static const _mbappe = _SquadPlayer('Mbappé', 'CF', 96);
  static const _salah = _SquadPlayer('Salah', 'RW', 95);
  static const _debruyne = _SquadPlayer('De Bruyne', 'CM', 93);
  static const _modric = _SquadPlayer('Modrić', 'CM', 94);
  static const _bellingham = _SquadPlayer('Bellingham', 'CM', 93);
  static const _davies = _SquadPlayer('Davies', 'LB', 91);
  static const _rudiger = _SquadPlayer('Rüdiger', 'CB', 92);
  static const _dias = _SquadPlayer('Dias', 'CB', 94);
  static const _hakimi = _SquadPlayer('Hakimi', 'RB', 90);
  static const _laporte = _SquadPlayer('Laporte', 'CB', 87);
  static const _grimaldo = _SquadPlayer('Grimaldo', 'LB', 86);
  static const _kroos = _SquadPlayer('Kroos', 'CM', 88);
  static const _pedri = _SquadPlayer('Pedri', 'CM', 90);
  static const _dembele = _SquadPlayer('Dembélé', 'RW', 87);
  static const _vlahovic = _SquadPlayer('Vlahović', 'ST', 85);
  static const _son = _SquadPlayer('Son', 'LW', 88);
  static const _rodri = _SquadPlayer('Rodri', 'CDM', 89);
  static const _foden = _SquadPlayer('Foden', 'CAM', 86);
  static const _kane = _SquadPlayer('Kane', 'ST', 90);
  static const _gvardiol = _SquadPlayer('Gvardiol', 'CB', 85);

  static const List<_Formation> _formations = [
    _Formation('4-3-3', [
      [_vinicius, _mbappe, _salah],
      [_debruyne, _modric, _bellingham],
      [_davies, _rudiger, _dias, _hakimi],
      [_gk],
    ]),
    _Formation('4-4-2', [
      [_mbappe, _kane],
      [_vinicius, _debruyne, _modric, _salah],
      [_davies, _rudiger, _dias, _hakimi],
      [_gk],
    ]),
    _Formation('3-4-3', [
      [_vinicius, _mbappe, _salah],
      [_davies, _debruyne, _modric, _hakimi],
      [_rudiger, _dias, _gvardiol],
      [_gk],
    ]),
    _Formation('4-2-3-1', [
      [_mbappe],
      [_vinicius, _debruyne, _salah],
      [_modric, _bellingham],
      [_davies, _rudiger, _dias, _hakimi],
      [_gk],
    ]),
    _Formation('5-3-2', [
      [_vinicius, _mbappe],
      [_salah, _debruyne, _modric],
      [_davies, _rudiger, _dias, _gvardiol, _hakimi],
      [_gk],
    ]),
    _Formation('4-2-4', [
      [_vinicius, _mbappe, _kane, _salah],
      [_modric, _bellingham],
      [_davies, _rudiger, _dias, _hakimi],
      [_gk],
    ]),
    _Formation('3-5-2', [
      [_mbappe, _kane],
      [_vinicius, _debruyne, _modric, _bellingham, _salah],
      [_rudiger, _dias, _gvardiol],
      [_gk],
    ]),
  ];

  static const _bench = <_SquadPlayer>[
    _alisson, _laporte, _grimaldo, _kroos, _pedri, _dembele, _vlahovic,
    _son, _rodri, _foden, _kane, _gvardiol,
  ];

  late _Formation _selected = _formations.first;

  Future<void> _chooseFormation() async {
    final choice = await showDialog<_Formation>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF061B10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFF39FF14), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('انتخاب آرایش تیم', textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: _formations.map((formation) {
                  final active = formation.name == _selected.name;
                  return SizedBox(
                    width: 112, height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(formation),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: active ? const Color(0xFF075D26) : const Color(0xFF0B2530),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: active ? const Color(0xFF39FF14) : const Color(0xFF00CFFF), width: 1.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(formation.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice != null && mounted) setState(() => _selected = choice);
  }

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
            final fiveRows = _selected.lines.length == 5;
            final cardWidth = (w * (fiveRows ? .095 : .108)).clamp(88.0, 168.0).toDouble();
            final cardHeight = cardWidth * .66;
            final rowYs = fiveRows
                ? const [ .135, .315, .495, .675, .875 ]
                : const [ .16, .405, .65, .875 ];
            return Column(
              children: [
                SizedBox(
                  height: fieldHeight,
                  width: w,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(child: CustomPaint(painter: _PitchPainter())),
                      Positioned(
                        left: w * .025, top: fieldHeight * .075,
                        child: _FormationBadge(label: _selected.name, compact: compact, onTap: _chooseFormation),
                      ),
                      for (var row = 0; row < _selected.lines.length; row++)
                        for (var col = 0; col < _selected.lines[row].length; col++)
                          Positioned(
                            left: _xForIndex(col, _selected.lines[row].length, w) - cardWidth / 2,
                            top: fieldHeight * rowYs[row] - cardHeight / 2,
                            width: cardWidth,
                            height: cardHeight,
                            child: _SquadCard(
                              player: _selected.lines[row][col],
                              compact: compact,
                              showPosition: true,
                            ),
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
                      width: (w * .105).clamp(92.0, 158.0).toDouble(),
                      child: _SquadCard(player: _bench[index], compact: true, showPosition: true),
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

  // Keep all cards within the playable width and distribute each line evenly.
  double _xForIndex(int index, int count, double width) {
    if (count == 1) return width * .50;
    const left = .16;
    const right = .84;
    return width * (left + (right - left) * index / (count - 1));
  }
}

class _Formation {
  final String name;
  final List<List<_SquadPlayer>> lines; // forwards, midfield, defence, goalkeeper
  const _Formation(this.name, this.lines);
}

class _SquadPlayer {
  final String name;
  final String position;
  final int rating;
  const _SquadPlayer(this.name, this.position, this.rating);
}

class _SquadCard extends StatelessWidget {
  final _SquadPlayer player;
  final bool compact;
  final bool showPosition;
  const _SquadCard({required this.player, required this.compact, required this.showPosition});

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
              padding: const EdgeInsets.fromLTRB(7, 3, 7, 0),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                    child: Text('${player.rating}', style: TextStyle(color: Colors.white, fontSize: compact ? 19 : 25, fontWeight: FontWeight.w900))),
                  FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                    child: Text(player.position, style: TextStyle(color: const Color(0xFFFFE500), fontSize: compact ? 16 : 20, fontWeight: FontWeight.w900))),
                ])),
                Expanded(child: Icon(Icons.person, color: Colors.white.withOpacity(.92), size: compact ? 47 : 64)),
              ]),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: compact ? 2 : 4, horizontal: 3),
            decoration: const BoxDecoration(color: Color(0xE8071828), borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
            alignment: Alignment.center,
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(player.name, maxLines: 1,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 12 : 15))),
          ),
        ],
      ),
    );
  }
}

class _FormationBadge extends StatelessWidget {
  final String label;
  final bool compact;
  final VoidCallback onTap;
  const _FormationBadge({required this.label, required this.compact, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        width: compact ? 100 : 145,
        height: compact ? 86 : 126,
        decoration: BoxDecoration(
          color: const Color(0xE9051B0C),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF39FF14), width: 2.5),
          boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.55), blurRadius: 18, spreadRadius: 1)],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: compact ? 23 : 34, fontWeight: FontWeight.bold)),
          Icon(Icons.sports_soccer, color: Colors.white, size: compact ? 37 : 54),
        ]),
      ),
    ),
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
    canvas.drawLine(Offset(s.width*.20,s.height*.025),Offset(s.width*.055,s.height*.985),line);
    canvas.drawLine(Offset(s.width*.80,s.height*.025),Offset(s.width*.985,s.height*.985),line);
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) => false;
}
