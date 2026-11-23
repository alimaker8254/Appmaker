import 'package:flutter/material.dart';
import '../models/club.dart';

class BuyPlayerScreen extends StatelessWidget {
  final Club club;
  const BuyPlayerScreen({super.key, required this.club});

  static const _players = <_Player>[
    _Player('Haaland', 'CF', 97, 96, 98, 87, 95, 2000000),
    _Player('Salah', 'RW', 95, 93, 94, 85, 86, 1500000),
    _Player('De Bruyne', 'CM', 94, 88, 91, 95, 83, 1200000),
    _Player('Vinícius Jr.', 'LW', 93, 97, 90, 84, 78, 1000000),
    _Player('Rüdiger', 'CB', 92, 85, 70, 78, 90, 900000),
    _Player('Courtois', 'GK', 91, 0, 0, 0, 0, 800000, div: 90, kic: 82, han: 85, ref: 89),
    _Player('Mbappé', 'ST', 90, 97, 89, 81, 84, 700000),
    _Player('Modrić', 'CM', 89, 75, 78, 88, 72, 600000),
    _Player('Bellingham', 'CAM', 89, 82, 86, 90, 85, 580000),
    _Player('Kane', 'ST', 88, 72, 95, 84, 88, 560000),
    _Player('Rodri', 'CDM', 88, 65, 78, 91, 92, 540000),
    _Player('Son', 'LW', 87, 91, 88, 82, 78, 520000),
    _Player('Van Dijk', 'CB', 87, 78, 60, 72, 93, 500000),
    _Player('Foden', 'CAM', 86, 85, 84, 88, 74, 480000),
    _Player('Alisson', 'GK', 86, 0, 0, 0, 0, 460000, div: 88, kic: 85, han: 87, ref: 86),
    _Player('Saka', 'RW', 85, 89, 83, 84, 76, 440000),
    _Player('Pedri', 'CM', 85, 78, 75, 90, 70, 420000),
    _Player('Griezmann', 'CF', 84, 82, 86, 87, 79, 400000),
    _Player('Bernardo', 'CM', 83, 76, 79, 89, 71, 380000),
    _Player('Gvardiol', 'LB', 82, 84, 62, 75, 86, 360000),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 430;
    return Scaffold(
      backgroundColor: const Color(0xFF031008),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF062B12), Color(0xFF020A05)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _BuyTopBar(club: club, compact: compact),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB( size.width * .045, 14, size.width * .045, 24),
                  itemCount: _players.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width >= 1100 ? 4 : (size.width >= 700 ? 3 : 2),
                    crossAxisSpacing: 22,
                    mainAxisSpacing: 22,
                    childAspectRatio: compact ? .88 : .82,
                  ),
                  itemBuilder: (context, index) => _PlayerCard(player: _players[index], index: index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyTopBar extends StatelessWidget {
  final Club club;
  final bool compact;
  const _BuyTopBar({required this.club, required this.compact});

  @override
  Widget build(BuildContext context) {
    final logo = club.networkLogo;
    return Container(
      margin: EdgeInsets.fromLTRB(compact ? 12 : 20, 8, compact ? 12 : 20, 8),
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 22, vertical: compact ? 8 : 12),
      decoration: BoxDecoration(
        color: const Color(0xFF06172A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF39FF14), width: 2.5),
        boxShadow: [BoxShadow(color: const Color(0xFF39FF14).withOpacity(.65), blurRadius: 22, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'بازگشت',
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.lightBlueAccent, size: compact ? 23 : 30),
          ),
          _TopValue(icon: Icons.diamond, value: '15', color: const Color(0xFFB44CFF), compact: compact),
          SizedBox(width: compact ? 8 : 14),
          _TopValue(icon: Icons.monetization_on, value: '250,000', color: const Color(0xFFFFD700), compact: compact),
          SizedBox(width: compact ? 12 : 22),
          Expanded(
            child: Container(
              height: compact ? 13 : 19,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00BFFF), width: 1.5)),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(widthFactor: .6, child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF00BFFF), Color(0xFF39FF14)])),
              )),
            ),
          ),
          SizedBox(width: compact ? 10 : 18),
          Text('Lv. 12', style: TextStyle(color: Colors.white, fontSize: compact ? 14 : 21, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('خرید بازیکن', style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: compact ? 17 : 25)),
          SizedBox(width: compact ? 10 : 18),
          SizedBox(
            width: compact ? 42 : 58, height: compact ? 42 : 58,
            child: ClipOval(
              child: logo != null
                ? Image.network(logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white))
                : Image.asset('assets/logos_png/${club.asset.replaceAll('.svg', '.png')}', fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopValue extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final bool compact;
  const _TopValue({required this.icon, required this.value, required this.color, required this.compact});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14, vertical: compact ? 5 : 8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), border: Border.all(color: color, width: 1.5)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(color: Colors.white, fontSize: compact ? 13 : 19)),
      SizedBox(width: compact ? 5 : 8),
      Icon(icon, color: color, size: compact ? 17 : 24),
    ]),
  );
}

class _Player {
  final String name, position;
  final int rating, pac, sho, pas, phy, price;
  final int? div, kic, han, ref;
  const _Player(this.name, this.position, this.rating, this.pac, this.sho, this.pas, this.phy, this.price,
      {this.div, this.kic, this.han, this.ref});
}

class _PlayerCard extends StatelessWidget {
  final _Player player;
  final int index;
  const _PlayerCard({required this.player, required this.index});

  @override
  Widget build(BuildContext context) {
    const accents = [Color(0xFFFFD21A), Color(0xFF00CFFF), Color(0xFF39FF14)];
    final accent = accents[index % accents.length];
    final goalkeeper = player.position == 'GK';
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: index % 3 == 1 ? const [Color(0xFF06345A), Color(0xFF06111D)] :
            (index % 3 == 2 ? const [Color(0xFF07351A), Color(0xFF06140A)] : const [Color(0xFF332B08), Color(0xFF111407)])),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: accent, width: 2.5),
        boxShadow: [BoxShadow(color: accent.withOpacity(.52), blurRadius: 18, spreadRadius: 1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    FittedBox(fit: BoxFit.scaleDown, child: Text('${player.rating}', style: const TextStyle(color: Colors.white, fontSize: 39, fontWeight: FontWeight.w900))),
                    Text(player.position, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ])),
                  Expanded(child: Center(child: Icon(Icons.person, color: Colors.white.withOpacity(.88), size: 76))),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              decoration: BoxDecoration(color: const Color(0xDD06151A), borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accent.withOpacity(.35))),
              alignment: Alignment.center,
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(player.name, maxLines: 1,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19))),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: goalkeeper
                ? _StatGrid(items: [('DIV', player.div!), ('KIC', player.kic!), ('HAN', player.han!), ('REF', player.ref!)])
                : _StatGrid(items: [('PAC', player.pac), ('PAS', player.pas), ('SHO', player.sho), ('PHY', player.phy)]),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: accent.withOpacity(.45)))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.monetization_on, color: Color(0xFFFFD700), size: 22),
                const SizedBox(width: 6),
                Text(_formatPrice(player.price), style: const TextStyle(color: Color(0xFFFFE000), fontSize: 19, fontWeight: FontWeight.bold)),
              ]),
            ),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF25352A),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.lock_outline, color: Colors.white70, size: 20),
                  SizedBox(width: 9),
                  Text('فعلاً غیرفعال', style: TextStyle(color: Colors.white70, fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 16)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPrice(int value) => value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
}

class _StatGrid extends StatelessWidget {
  final List<(String, int)> items;
  const _StatGrid({required this.items});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(child: Row(children: [
        Expanded(child: _Stat(items[0].$1, items[0].$2)),
        Expanded(child: _Stat(items[1].$1, items[1].$2)),
      ])),
      Expanded(child: Row(children: [
        Expanded(child: _Stat(items[2].$1, items[2].$2)),
        Expanded(child: _Stat(items[3].$1, items[3].$2)),
      ])),
    ],
  );
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    Text('$value', style: const TextStyle(color: Colors.white, fontSize: 15)),
  ]);
}
