import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/club.dart';

class BuyCoachScreen extends StatefulWidget {
  final Club club;
  const BuyCoachScreen({super.key, required this.club});

  @override
  State<BuyCoachScreen> createState() => _BuyCoachScreenState();
}

class _BuyCoachScreenState extends State<BuyCoachScreen> {
  static const _blue = Color(0xFF087BFF);
  static const _cyan = Color(0xFF16D9FF);
  static const _gold = Color(0xFFFFE21A);
  static const _red = Color(0xFFFF1838);
  static const _savedKey = 'lpm_hired_coach_v1';

  static const List<_Coach> _coaches = [
    _Coach('Pep Guardiola', 90, 5000000, ['مالکیت توپ', 'بازی ترکیبی'], 97, ['مالکیت توپ', 'بازی ترکیبی']),
    _Coach('Carlo Ancelotti', 96, 4500000, ['انعطاف تاکتیکی', 'مدیریت بازی'], 96, ['انعطاف تاکتیکی', 'مدیریت بازی']),
    _Coach('Jürgen Klopp', 95, 4000000, ['ضدپرس', 'پرس شدید'], 95, ['ضدپرس', 'پرس شدید']),
    _Coach('Luis Enrique', 94, 3500000, ['مالکیت توپ', 'پرس شدید'], 94, ['مالکیت توپ', 'پرس شدید']),
    _Coach('Diego Simeone', 93, 3000000, ['دفاع عمیق', 'سازمان دفاعی'], 93, ['دفاع عمیق', 'سازمان دفاعی']),
    _Coach('Massimiliano Allegri', 91, 2500000, ['سازمان دفاعی', 'ضدحمله'], 91, ['سازمان دفاعی', 'ضدحمله']),
    _Coach('Thomas Tuchel', 92, 2500000, ['پرس شدید', 'انعطاف تاکتیکی'], 92, ['پرس شدید', 'انعطاف تاکتیکی']),
    _Coach('Zinedine Zidane', 94, 3500000, ['ضدحمله', 'مدیریت تیم'], 94, ['ضدحمله', 'مدیریت تیم']),
    _Coach('Mikel Arteta', 90, 2000000, ['بازی ترکیبی', 'پرس شدید'], 90, ['بازی ترکیبی', 'پرس شدید']),
    _Coach('José Mourinho', 95, 4000000, ['ضدحمله', 'دفاع عمیق'], 95, ['ضدحمله', 'دفاع عمیق']),
  ];

  int _selected = 0;
  String? _hiredId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadHired();
  }

  Future<void> _loadHired() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hired = prefs.getString(_savedKey);
      if (!mounted) return;
      setState(() {
        _hiredId = hired;
        final index = _coaches.indexWhere((c) => c.name == hired);
        if (index >= 0) _selected = index;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _hire() async {
    final coach = _coaches[_selected];
    if (_hiredId == coach.name || _saving) return;
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_savedKey, coach.name);
      if (!mounted) return;
      setState(() => _hiredId = coach.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('مربی ${coach.name} برای باشگاه شما انتخاب شد', textDirection: TextDirection.rtl),
          backgroundColor: const Color(0xFF087D32),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ثبت مربی انجام نشد', textDirection: TextDirection.rtl)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1150 ? 5 : (width >= 850 ? 4 : (width >= 560 ? 3 : 2));
    return Scaffold(
      backgroundColor: const Color(0xFF02091B),
      body: Stack(children: [
        const Positioned.fill(child: _ShopBackground()),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(54, 8, 54, 8),
              child: Container(
                height: 62,
                constraints: const BoxConstraints(maxWidth: 470),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF071633), Color(0xFF02091B)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _cyan, width: 2),
                  boxShadow: [BoxShadow(color: _blue.withOpacity(.65), blurRadius: 14, spreadRadius: 1)],
                ),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('خرید مربی', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
                  Text('MANAGER SHOP', style: TextStyle(color: Color(0xFF9ADFFF), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ]),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 22),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  _CoachDetails(
                    coach: _coaches[_selected],
                    hired: _hiredId == _coaches[_selected].name,
                    loading: _loading,
                    saving: _saving,
                    onHire: _hire,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xB906142B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _cyan, width: 1.8),
                      boxShadow: [BoxShadow(color: _blue.withOpacity(.28), blurRadius: 13)],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _coaches.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 9,
                        mainAxisSpacing: 9,
                        childAspectRatio: width < 560 ? .94 : .88,
                      ),
                      itemBuilder: (context, index) => _CoachCard(
                        coach: _coaches[index],
                        selected: _selected == index,
                        hired: _hiredId == _coaches[index].name,
                        onTap: () => setState(() => _selected = index),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: IconButton(
            tooltip: 'بازگشت',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: _cyan, size: 27),
          ),
        ),
      ]),
    );
  }
}

class _Coach {
  final String name;
  final int rating, price, detailRating;
  final List<String> features, detailFeatures;
  const _Coach(this.name, this.rating, this.price, this.features, this.detailRating, this.detailFeatures);
}

class _CoachCard extends StatelessWidget {
  final _Coach coach;
  final bool selected, hired;
  final VoidCallback onTap;
  const _CoachCard({required this.coach, required this.selected, required this.hired, required this.onTap});

  static const _gold = Color(0xFFFFE21A);
  static const _red = Color(0xFFFF1838);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFB80020), Color(0xFF48000D), Color(0xFF17030B)]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFFFFF4F4) : _red, width: selected ? 2.2 : 1.3),
          boxShadow: [BoxShadow(color: _red.withOpacity(selected ? .62 : .32), blurRadius: selected ? 10 : 6)],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Center(child: Icon(Icons.person_rounded,
                color: const Color(0xFFD7E8FF),
                size: 48,
                shadows: [Shadow(color: Colors.white.withOpacity(.35), blurRadius: 6)])),
            ),
            Text(coach.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            RichText(text: TextSpan(children: [
              TextSpan(text: '${coach.rating}', style: const TextStyle(color: _gold, fontSize: 17, fontWeight: FontWeight.w900)),
              const TextSpan(text: '  قدرت کلی', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ])),
            const SizedBox(height: 2),
            ...coach.features.map((feature) => Text('• $feature', maxLines: 1, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontSize: 9, fontWeight: FontWeight.w600))),
            const SizedBox(height: 3),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.monetization_on, color: _gold, size: 15),
              const SizedBox(width: 3),
              Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(_money(coach.price),
                style: const TextStyle(color: _gold, fontSize: 13, fontWeight: FontWeight.w900)))),
            ]),
            const SizedBox(height: 4),
            SizedBox(width: double.infinity, height: 27, child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                backgroundColor: hired ? const Color(0xFF3A101A) : const Color(0xFF8D0018),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFFA2B1), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(hired ? 'انتخاب‌شده' : 'انتخاب مربی',
                maxLines: 1, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, fontWeight: FontWeight.w900)),
            )),
          ]),
        ),
      ),
    );
  }
}

class _CoachDetails extends StatelessWidget {
  final _Coach coach;
  final bool hired, loading, saving;
  final VoidCallback onHire;
  const _CoachDetails({required this.coach, required this.hired, required this.loading, required this.saving, required this.onHire});

  static const _gold = Color(0xFFFFE21A);
  static const _cyan = Color(0xFF16D9FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF06152B), Color(0xFF020817)]),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _cyan, width: 1.8),
        boxShadow: [BoxShadow(color: const Color(0xFF087BFF).withOpacity(.35), blurRadius: 12)],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 500;
        return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: compact ? 66 : 82,
            height: compact ? 76 : 88,
            decoration: BoxDecoration(
              gradient: const RadialGradient(colors: [Color(0xFFFF294B), Color(0xFF850018), Color(0xFF28000B)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF526B), width: 1.2),
            ),
            child: const Icon(Icons.person_rounded, color: Color(0xFFDCEBFF), size: 54),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(coach.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 5, children: [
              Text('${coach.detailRating}', style: const TextStyle(color: _gold, fontSize: 22, fontWeight: FontWeight.w900)),
              const Text('قدرت کلی', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              const Icon(Icons.monetization_on, color: _gold, size: 16),
              Text(_money(coach.price), style: const TextStyle(color: _gold, fontSize: 13, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 3),
            Text('ویژگی‌ها: ${coach.detailFeatures.join(' • ')}', maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontSize: 11, fontWeight: FontWeight.w700)),
          ])),
          const SizedBox(width: 9),
          SizedBox(
            width: compact ? 90 : 125,
            height: 42,
            child: ElevatedButton(
              onPressed: loading || saving || hired ? null : onHire,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB90022),
                disabledBackgroundColor: const Color(0xFF3B1A24),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white70,
                side: const BorderSide(color: Color(0xFFFFA4B3), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(hired ? 'انتخاب‌شده' : 'خرید مربی', textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, fontWeight: FontWeight.w900)),
            ),
          ),
        ]);
      }),
    );
  }
}

class _ShopBackground extends StatelessWidget {
  const _ShopBackground();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _ShopBackgroundPainter(), child: const SizedBox.expand());
}

class _ShopBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFF06152F), Color(0xFF020817), Color(0xFF02091B)],
    ).createShader(Offset.zero & size));
    final glow = Paint()..shader = RadialGradient(colors: [const Color(0xFF064E9C).withOpacity(.25), Colors.transparent])
      .createShader(Rect.fromCircle(center: Offset(size.width * .5, size.height * .1), radius: size.width * .7));
    canvas.drawRect(Offset.zero & size, glow);
    final lines = Paint()..color = const Color(0xFF148BFF).withOpacity(.10)..strokeWidth = 1;
    for (double x = -size.height; x < size.width + size.height; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), lines);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _money(int value) => value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
