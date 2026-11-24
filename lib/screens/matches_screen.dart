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
  late List<List<_SquadPlayer>> _lineup = _copyLines(_selected.lines);
  late List<_SquadPlayer> _benchPlayers = _availableBench(_selected, const []);
  final ScrollController _benchScrollController = ScrollController();

  @override
  void dispose() {
    _benchScrollController.dispose();
    super.dispose();
  }

  static List<List<_SquadPlayer>> _copyLines(List<List<_SquadPlayer>> lines) =>
      lines.map((line) => List<_SquadPlayer>.from(line)).toList();

  List<_SquadPlayer> _availableBench(_Formation formation, List<_SquadPlayer> extra) {
    final starters = formation.lines.expand((line) => line).map((p) => p.name).toSet();
    final result = <_SquadPlayer>[];
    for (final player in [..._bench, ...extra]) {
      if (!starters.contains(player.name) && !result.any((p) => p.name == player.name)) {
        result.add(player);
      }
    }
    return result;
  }

  void _movePlayer(_PlayerDragData source, _PlayerDragData target) {
    if (source.isBench == target.isBench &&
        source.row == target.row && source.index == target.index) return;
    setState(() {
      final sourcePlayer = source.isBench
          ? _benchPlayers[source.index]
          : _lineup[source.row][source.index];
      final targetPlayer = target.isBench
          ? _benchPlayers[target.index]
          : _lineup[target.row][target.index];

      if (source.isBench && target.isBench) {
        _benchPlayers[source.index] = targetPlayer;
        _benchPlayers[target.index] = sourcePlayer;
      } else if (source.isBench) {
        _benchPlayers[source.index] = targetPlayer;
        _lineup[target.row][target.index] = sourcePlayer;
      } else if (target.isBench) {
        _lineup[source.row][source.index] = targetPlayer;
        _benchPlayers[target.index] = sourcePlayer;
      } else {
        _lineup[source.row][source.index] = targetPlayer;
        _lineup[target.row][target.index] = sourcePlayer;
      }
    });
  }

  Widget _draggablePlayerCard({
    required _SquadPlayer player,
    required _PlayerDragData slot,
    required double width,
    required double height,
    required bool compact,
  }) {
    final card = SizedBox(
      width: width,
      height: height,
      child: _SquadCard(player: player, compact: compact, showPosition: true),
    );
    return DragTarget<_PlayerDragData>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => _movePlayer(details.data, slot),
      builder: (context, candidates, rejected) => Draggable<_PlayerDragData>(
        data: slot,
        // Bench cards only respond to vertical drags, leaving horizontal
        // gestures to the bench ListView for normal scrolling.
        axis: slot.isBench ? Axis.vertical : null,
        maxSimultaneousDrags: 1,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: width,
            height: height,
            child: _SquadCard(player: player, compact: compact, showPosition: true),
          ),
        ),
        childWhenDragging: Opacity(opacity: .35, child: card),
        child: card,
      ),
    );
  }

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
    if (choice != null && mounted) {
      setState(() {
        final previousPlayers = _lineup.expand((line) => line).toList();
        _selected = choice;
        _lineup = _copyLines(choice.lines);
        _benchPlayers = _availableBench(choice, previousPlayers);
      });
    }
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
            final controlHeight = compact ? 92.0 : 116.0;
            final fieldHeight = h - controlHeight;
            // One shared card size for every formation. It scales only with
            // the screen, never with the number of tactical rows or players.
            final widthLimit = (w * .118).clamp(84.0, 178.0).toDouble();
            final heightLimit = fieldHeight * .29;
            final cardWidth = widthLimit < heightLimit ? widthLimit : heightLimit;
            final cardHeight = cardWidth * .66;
            return Column(
              children: [
                SizedBox(
                  height: fieldHeight,
                  width: w,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(child: CustomPaint(painter: _PitchPainter())),
                      for (var row = 0; row < _lineup.length; row++)
                        for (var col = 0; col < _lineup[row].length; col++)
                          Positioned(
                            left: _xForIndex(col, _selected.lines[row].length, w) - cardWidth / 2,
                            top: fieldHeight * _rowY(row, _selected.lines.length) - cardHeight / 2,
                            width: cardWidth,
                            height: cardHeight,
                            child: _draggablePlayerCard(
                              player: _lineup[row][col],
                              slot: _PlayerDragData(isBench: false, row: row, index: col),
                              width: cardWidth,
                              height: cardHeight,
                              compact: compact,
                            ),
                          ),
                    ],
                  ),
                ),
                SizedBox(
                  height: controlHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 14, vertical: compact ? 4 : 8),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const SizedBox(
                                width: 40,
                                height: 28,
                                child: Icon(Icons.arrow_back, color: Color(0xFF168BFF), size: 27),
                              ),
                            ),
                            const SizedBox(height: 7),
                            _StartControl(compact: compact),
                          ],
                        ),
                        SizedBox(width: compact ? 7 : 12),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: compact ? 5 : 10, vertical: compact ? 4 : 7),
                            decoration: BoxDecoration(
                              color: const Color(0xD905210D),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFF39FF14), width: 2.5),
                              boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.48), blurRadius: 15, spreadRadius: 1)],
                            ),
                            child: ListView.separated(
                              controller: _benchScrollController,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              itemCount: _benchPlayers.length,
                              separatorBuilder: (_, __) => SizedBox(width: compact ? 6 : 10),
                              itemBuilder: (context, index) {
                                final benchWidth = (w * .105).clamp(112.0, 140.0).toDouble();
                                final benchHeight = controlHeight - (compact ? 8 : 16);
                                return _draggablePlayerCard(
                                  player: _benchPlayers[index],
                                  slot: _PlayerDragData(isBench: true, row: 0, index: index),
                                  width: benchWidth,
                                  height: benchHeight,
                                  compact: false,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: compact ? 7 : 12),
                        _BenchVerticalScroller(
                          controller: _benchScrollController,
                          height: controlHeight - (compact ? 8 : 16),
                          width: 12,
                        ),
                        SizedBox(width: compact ? 5 : 8),
                        _FormationControl(
                          label: _selected.name,
                          compact: compact,
                          onTap: _chooseFormation,
                        ),
                      ],
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

  double _rowY(int row, int count) {
    // Formation-specific vertical lanes, tuned to the supplied reference
    // layouts. Goalkeeper remains the deepest player in every formation.
    final lanes = switch (_selected.name) {
      '4-2-3-1' => const [.10, .29, .48, .69, .89],
      '4-3-3' => const [.14, .43, .69, .89],
      '4-4-2' => const [.14, .42, .69, .89],
      '3-4-3' => const [.14, .41, .69, .89],
      '5-3-2' => const [.16, .43, .69, .89],
      '4-2-4' => const [.15, .44, .69, .89],
      '3-5-2' => const [.15, .43, .69, .89],
      _ => const [.14, .40, .66, .89],
    };
    if (row < lanes.length) return lanes[row];
    return .89;
  }

  // Balanced horizontal lanes: 2/3/4/5-player lines are centered as a
  // group rather than stretched to the touchlines.
  double _xForIndex(int index, int count, double width) {
    const centers = <int, List<double>>{
      1: [.50],
      2: [.40, .60],
      3: [.32, .50, .68],
      4: [.21, .40, .60, .79],
      5: [.14, .32, .50, .68, .86],
    };
    final positions = centers[count] ?? centers[5]!;
    return width * positions[index];
  }
}


class _BenchVerticalScroller extends StatefulWidget {
  final ScrollController controller;
  final double height;
  final double width;

  const _BenchVerticalScroller({
    required this.controller,
    required this.height,
    required this.width,
  });

  @override
  State<_BenchVerticalScroller> createState() => _BenchVerticalScrollerState();
}

class _BenchVerticalScrollerState extends State<_BenchVerticalScroller> {
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackHeight = constraints.maxHeight;
          final hasScroll = widget.controller.hasClients &&
              widget.controller.position.maxScrollExtent > 0;
          final position = hasScroll ? widget.controller.position : null;
          final viewport = position?.viewportDimension ?? 0;
          final content = viewport + (position?.maxScrollExtent ?? 0);
          final thumbHeight = hasScroll
              ? (trackHeight * viewport / content).clamp(24.0, trackHeight)
              : trackHeight;
          final maxThumbTravel = (trackHeight - thumbHeight).clamp(0.0, trackHeight);
          final maxScroll = position?.maxScrollExtent ?? 0;
          final currentOffset = position?.pixels ?? 0;
          final thumbTop = maxScroll > 0
              ? (currentOffset / maxScroll * maxThumbTravel).clamp(0.0, maxThumbTravel)
              : 0.0;

          void updateFromLocalY(double localY) {
            if (!widget.controller.hasClients) return;
            final p = widget.controller.position;
            final available = (trackHeight - thumbHeight).clamp(0.0, trackHeight);
            if (available <= 0 || p.maxScrollExtent <= 0) return;
            final top = (localY - _dragOffset).clamp(0.0, available);
            widget.controller.jumpTo(top / available * p.maxScrollExtent);
          }

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: (details) {
              _dragOffset = details.localPosition.dy - thumbTop;
              if (_dragOffset < 0 || _dragOffset > thumbHeight) {
                _dragOffset = thumbHeight / 2;
                updateFromLocalY(details.localPosition.dy);
              }
            },
            onVerticalDragUpdate: (details) {
              updateFromLocalY(details.localPosition.dy);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A3550),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF087DBB), width: .7),
                  ),
                ),
                Positioned(
                  top: thumbTop,
                  child: Container(
                    width: widget.width,
                    height: thumbHeight,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF087DFF), Color(0xFF00DFFF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF8CEBFF), width: 1),
                      boxShadow: const [
                        BoxShadow(color: Color(0x9900BFFF), blurRadius: 7, spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlayerDragData {
  final bool isBench;
  final int row;
  final int index;
  const _PlayerDragData({required this.isBench, required this.row, required this.index});
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
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: cyan, width: 2),
        boxShadow: [BoxShadow(color: cyan.withOpacity(.48), blurRadius: 10, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 4, 7, 2),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Icon(Icons.person, color: Colors.white.withOpacity(.92), size: compact ? 42 : 55),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('${player.rating}',
                              style: TextStyle(color: Colors.white, fontSize: compact ? 20 : 25, height: 1.0, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        if (showPosition) ...[
                          SizedBox(width: compact ? 7 : 9),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(player.position,
                                style: TextStyle(color: const Color(0xFFFFE500), fontSize: compact ? 16 : 20, height: 1.0, fontWeight: FontWeight.w900)),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: compact ? 3 : 5, horizontal: 3),
            decoration: const BoxDecoration(color: Color(0xF2071828),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14))),
            alignment: Alignment.center,
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(player.name, maxLines: 1,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 12 : 14))),
          ),
        ],
      ),
    );
  }
}

class _StartControl extends StatelessWidget {
  final bool compact;
  const _StartControl({required this.compact});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: compact ? 70 : 86,
    height: compact ? 62 : 82,
    child: ElevatedButton(
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('شروع مسابقه به‌زودی فعال می‌شود', textDirection: TextDirection.rtl)),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: const Color(0xFF075DFF),
        foregroundColor: Colors.white,
        elevation: 9,
        shadowColor: const Color(0xFF00CFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF00DFFF), width: 2.2)),
      ),
      child: Text('START', style: TextStyle(fontSize: compact ? 15 : 17, fontWeight: FontWeight.w900)),
    ),
  );
}

class _FormationControl extends StatelessWidget {
  final String label;
  final bool compact;
  final VoidCallback onTap;
  const _FormationControl({required this.label, required this.compact, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: compact ? 76 : 94,
        height: compact ? 62 : 82,
        decoration: BoxDecoration(
          color: const Color(0xE9051B0C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF39FF14), width: 2.2),
          boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.48), blurRadius: 12, spreadRadius: 1)],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(label,
            style: TextStyle(color: Colors.white, fontSize: compact ? 16 : 19, fontWeight: FontWeight.bold))),
          Icon(Icons.sports_soccer, color: Colors.white, size: compact ? 25 : 31),
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
