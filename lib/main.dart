import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'models/club.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Start Flutter before applying optional Android system-UI settings.
  // A platform-channel failure must never prevent the app from opening.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('APPMAKER_FLUTTER_ERROR: ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  };

  runApp(const AppmakerApp());
  _configureSystemUi();
}

Future<void> _configureSystemUi() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } catch (error, stackTrace) {
    debugPrint('APPMAKER_ORIENTATION_ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } catch (error, stackTrace) {
    debugPrint('APPMAKER_SYSTEM_UI_ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class AppmakerApp extends StatelessWidget {
  const AppmakerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppTheme.bgDark,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Vazirmatn'),
      primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(fontFamily: 'Vazirmatn'),
    ),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
    home: const TeamSelectionScreen(),
  );
}

const clubs = [
  Club('منچسترسیتی', 'manchester_city.svg'),
  Club('لیورپول', 'liverpool.svg'),
  Club('آرسنال', 'arsenal.svg'),
  Club('منچستریونایتد', 'manchester_united.svg'),
  Club('چلسی', 'chelsea.svg'),
  Club('تاتنهام', 'tottenham.svg'),
  Club('نیوکاسل', 'newcastle.svg'),
  Club('استون ویلا', 'aston_villa.svg'),
  Club('وستهم', 'west_ham.svg'),
  Club('اورتون', 'everton.svg'),
  Club('برایتون', 'brighton.svg'),
  Club('ناتینگهام فارست', 'nottingham_forest.svg'),
  Club('بارسلونا', 'barcelona.svg'),
  Club('رئال مادرید', 'real_madrid.svg'),
  Club('اتلتیکو مادرید', 'atletico_madrid.svg'),
];

const _clubDisplayNames = [
  'Manchester City', 'Liverpool', 'Arsenal', 'Manchester United', 'Chelsea',
  'Tottenham Hotspur', 'Newcastle United', 'Aston Villa', 'West Ham United', 'Everton',
  'Brighton & Hove Albion', 'Nottingham Forest', 'Barcelona', 'Real Madrid', 'Atlético Madrid',
];

class TeamSelectionScreen extends StatefulWidget {
  const TeamSelectionScreen({super.key});
  @override
  State<TeamSelectionScreen> createState() => _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final compact = height < 700 || width < 1100;
        final gap = compact ? 10.0 : 16.0;
        return Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _TeamSelectionBackground())),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .035),
              child: Column(children: [
                SizedBox(height: compact ? 5 : 9),
                Center(child: Container(
                  width: width * .55,
                  height: compact ? 66 : 82,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF07102B).withOpacity(.9),
                    borderRadius: BorderRadius.circular(48),
                    border: Border.all(color: const Color(0xFF00BFFF), width: compact ? 2 : 3),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF006BFF).withOpacity(.85), blurRadius: 18, spreadRadius: 2),
                      BoxShadow(color: const Color(0xFF00D9FF).withOpacity(.5), blurRadius: 34, spreadRadius: 4),
                    ],
                  ),
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(
                    'لطفا یک تیم را انتخاب کنید',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white,
                      fontSize: compact ? 27 : 38, fontWeight: FontWeight.w900,
                      shadows: const [Shadow(color: Color(0xFF58BFFF), blurRadius: 13)]),
                  )),
                )),
                SizedBox(height: compact ? 7 : 12),
                Expanded(child: LayoutBuilder(
                  builder: (context, gridConstraints) {
                    // Fit all 15 clubs in exactly three visible rows on every
                    // landscape screen; the non-scrollable grid must never clip
                    // the final five teams on shorter displays.
                    final bottomPadding = compact ? 5.0 : 8.0;
                    final tileWidth = (gridConstraints.maxWidth - gap * 4) / 5;
                    final tileHeight = (gridConstraints.maxHeight - 3 - bottomPadding - gap * 2) / 3;
                    return GridView.builder(
                      padding: EdgeInsets.only(top: 3, bottom: bottomPadding),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: gap,
                        crossAxisSpacing: gap,
                        childAspectRatio: tileWidth / tileHeight,
                      ),
                      itemCount: clubs.length,
                      itemBuilder: (context, visualIndex) {
                        // RTL grid: reverse data so City is at the far left as in the reference.
                        final index = clubs.length - visualIndex - 1;
                        return GestureDetector(
                          onTap: () => setState(() => selected = index),
                          child: _TeamSelectionCard(
                            club: clubs[index],
                            displayName: _clubDisplayNames[index],
                            selected: selected == index,
                            compact: compact,
                          ),
                        );
                      },
                    );
                  },
                )),
                SizedBox(height: compact ? 82 : 104, child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: compact ? 245 : 325, height: compact ? 64 : 88,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF006BFF).withOpacity(.85), blurRadius: 18, spreadRadius: 2),
                          BoxShadow(color: const Color(0xFF00D9FF).withOpacity(.45), blurRadius: 32, spreadRadius: 3),
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: selected < 0 ? null : () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => HomeScreen(club: clubs[selected])),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF07102B), foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white70,
                          side: const BorderSide(color: Color(0xFF00BFFF), width: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
                          padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 30),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.check, size: compact ? 34 : 49, color: Colors.white),
                          SizedBox(width: compact ? 9 : 14),
                          Text('تأیید', style: TextStyle(fontFamily: 'Vazirmatn',
                            fontSize: compact ? 26 : 39, fontWeight: FontWeight.w900, color: Colors.white)),
                        ]),
                      ),
                    ),
                  ),
                )),
              ]),
            ),
          ),
        ]);
      }),
    );
  }
}

class _TeamSelectionCard extends StatelessWidget {
  final Club club;
  final String displayName;
  final bool selected;
  final bool compact;
  const _TeamSelectionCard({required this.club, required this.displayName, required this.selected, required this.compact});

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xFF00BFFF);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF07132F), Color(0xFF02091F), Color(0xFF06112D)]),
        borderRadius: BorderRadius.circular(compact ? 18 : 25),
        border: Border.all(color: selected ? const Color(0xFFFFD700) : neon, width: selected ? 3 : 2.5),
        boxShadow: [
          BoxShadow(color: (selected ? const Color(0xFFFFD700) : neon).withOpacity(.8),
            blurRadius: compact ? 13 : 20, spreadRadius: 1),
          BoxShadow(color: const Color(0xFF005DFF).withOpacity(.35), blurRadius: 27, spreadRadius: 2),
        ],
      ),
      child: Stack(children: [
        Positioned(left: 7, right: 7, top: 5, bottom: compact ? 39 : 45,
          child: Padding(padding: EdgeInsets.all(compact ? 5 : 8),
            child: Image.asset(
              'assets/logos_png/' + club.asset.replaceAll('.svg', '.png'),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, height: compact ? 39 : 45,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF050D2B),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: neon, width: 2),
              boxShadow: [BoxShadow(color: neon.withOpacity(.65), blurRadius: 12)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(displayName,
              maxLines: 1, textDirection: TextDirection.ltr,
              style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white,
                fontSize: compact ? 14 : 19, fontWeight: FontWeight.w900,
                shadows: const [Shadow(color: Colors.white54, blurRadius: 5)]),
            )),
          ),
        ),
      ]),
    );
  }
}

class _TeamSelectionBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF020725));
    final stripePaint = Paint()..shader = const LinearGradient(
      colors: [Color(0x00002BFF), Color(0xFF1027A8), Color(0xFF06145E), Color(0x00002BFF)],
      stops: [0, .28, .68, 1],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    for (double x = -size.height * 1.3; x < size.width + size.height; x += size.width * .105) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + size.height * .42, 0)
        ..lineTo(x - size.height * .58, size.height)
        ..lineTo(x - size.height, size.height)
        ..close();
      canvas.drawPath(path, stripePaint);
    }
    final glow = Paint()..shader = RadialGradient(
      colors: [const Color(0xFF143BFF).withOpacity(.18), Colors.transparent],
    ).createShader(Rect.fromCircle(center: Offset(size.width * .5, size.height * .48), radius: size.width * .75));
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class DiagonalPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final bool texture;
  DiagonalPainter(this.color, this.opacity, {this.texture = false});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(opacity)..strokeWidth = 1;
    for (var x = -size.height; x < size.width; x += 55) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x + size.height, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(covariant DiagonalPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.opacity != opacity || oldDelegate.texture != texture;
}
