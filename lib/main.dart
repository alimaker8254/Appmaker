import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

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
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: AppTheme.bgDark),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
    home: const TeamSelectionScreen(),
  );
}

class Club {
  final String name, asset;
  const Club(this.name, this.asset);
}
const clubs = [
  Club('منچسترسیتی','manchester_city.svg'), Club('لیورپول','liverpool.svg'), Club('آرسنال','arsenal.svg'), Club('منچستریونایتد','manchester_united.svg'), Club('چلسی','chelsea.svg'),
  Club('تاتنهام','tottenham.svg'), Club('نیوکاسل','newcastle.svg'), Club('استون ویلا','aston_villa.svg'), Club('وستهم','west_ham.svg'), Club('اورتون','everton.svg'),
  Club('برایتون','brighton.svg'), Club('ناتینگهام فارست','nottingham_forest.svg'), Club('بارسلونا','barcelona.svg'), Club('رئال مادرید','real_madrid.svg'), Club('اتلتیکو مادرید','atletico_madrid.svg'),
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
    return Scaffold(body: LayoutBuilder(builder: (context, c) => Stack(children: [
      Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors:[AppTheme.bgDark,Color(0xFF0A1428)])),child: CustomPaint(painter: DiagonalPainter(AppTheme.neonBlue,.08)))),
      Column(children: [
        Padding(padding: const EdgeInsets.only(top:20,bottom:10),child: Container(width:c.maxWidth*.6,height:65,decoration:BoxDecoration(borderRadius:BorderRadius.circular(40),border:Border.all(color:AppTheme.neonBlue,width:2),boxShadow:AppTheme.glow(AppTheme.neonBlue)),alignment:Alignment.center,child:Text('لطفا یک تیم را انتخاب کنید',style:AppTheme.vazir(size:28,weight:FontWeight.bold).copyWith(shadows:[Shadow(color:AppTheme.neonBlue,blurRadius:14)])))),
        Expanded(child: GridView.builder(padding:const EdgeInsets.symmetric(horizontal:15,vertical:10),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,mainAxisSpacing:12,crossAxisSpacing:12,childAspectRatio:1.55),itemCount:clubs.length,itemBuilder:(context,i){
          final club=clubs[i]; return GestureDetector(onTap:()=>setState(()=>selected=i),child:Container(decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppTheme.bgDark,AppTheme.bgCardBlue]),borderRadius:BorderRadius.circular(16),border:Border.all(color:selected==i?AppTheme.neonGold:AppTheme.neonBlue,width:selected==i?3:1.5),boxShadow:AppTheme.glow(selected==i?AppTheme.neonGold:AppTheme.neonBlue,strong:selected==i)),child:Column(children:[
            Expanded(child:Padding(padding:const EdgeInsets.all(10),child:Image.asset('assets/logos_png/${club.asset.replaceAll('.svg', '.png')}',fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const Icon(Icons.shield,color:Colors.white,size:42)))),
            Container(height:35,width:double.infinity,decoration:const BoxDecoration(color:AppTheme.bgDark,borderRadius:BorderRadius.vertical(bottom:Radius.circular(15))),alignment:Alignment.center,child:FittedBox(fit:BoxFit.scaleDown,child:Text(club.name,style:AppTheme.vazir(size:13)))),
          ])));
        })),
        Align(alignment:Alignment.bottomRight,child:Padding(padding:const EdgeInsets.only(left:20,bottom:12),child:SizedBox(width:200,height:55,child:OutlinedButton(
          style:OutlinedButton.styleFrom(side:const BorderSide(color:AppTheme.neonBlue,width:2),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),shadowColor:AppTheme.neonBlue,elevation:10),
          onPressed:selected<0?null:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>HomeScreen(club:clubs[selected]))),
          child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.check,color:Colors.white,size:28),const SizedBox(width:10),Text('تأیید',style:AppTheme.vazir(size:22,weight:FontWeight.bold))]),
        )))),
      ]),
    ])));
  }
}

class HomeScreen extends StatelessWidget {
  final Club club;
  const HomeScreen({super.key,required this.club});
  @override
  Widget build(BuildContext context) {
    final cards=[
      _DashboardCard('مسابقات','Matches',AppTheme.neonGreen,const [Color(0xFF0A3A1A),Color(0xFF051208)],const PitchGraphic()),
      _DashboardCard('جدول لیگ','League Table',AppTheme.neonBlue,const [Color(0xFF0A1F3A),Color(0xFF050B14)],const LeagueGraphic()),
      _DashboardCard('ارتقا بازیکنان','Player Upgrade',AppTheme.neonGold,const [Color(0xFF3A2A0A),Color(0xFF1A0A00)],const PlayerGraphic(upgrade:true)),
      _DashboardCard('خرید بازیکن','Buy Player',AppTheme.neonGreen,const [Color(0xFF0A3A1A),Color(0xFF051208)],const PlayerGraphic()),
      _DashboardCard('تاکتیک‌ها','Tactics',AppTheme.neonPurple,const [Color(0xFF2A0A3A),Color(0xFF15051E)],const TacticsGraphic()),
      _DashboardCard('خرید مربی','Hire Coach',AppTheme.neonOrange,const [Color(0xFF3A1A0A),Color(0xFF1A0A00)],const CoachGraphic()),
    ];
    return Scaffold(body:Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF0A2510),Color(0xFF051208)])),child:CustomPaint(painter:DiagonalPainter(AppTheme.neonGreen,.05,texture:true),child:Padding(padding:const EdgeInsets.all(15),child:Column(children:[
      Container(height:85,width:double.infinity,padding:const EdgeInsets.symmetric(horizontal:20),decoration:BoxDecoration(color:const Color(0xFF0A1224),borderRadius:BorderRadius.circular(25),border:Border.all(color:AppTheme.neonGreen,width:2),boxShadow:AppTheme.glow(AppTheme.neonGreen)),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        Row(children:[Container(width:60,height:60,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:AppTheme.neonGold,width:2)),child:const Icon(Icons.sports_soccer,color:AppTheme.neonGold,size:34)),const SizedBox(width:10),Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(club.name,style:AppTheme.vazir(size:20,weight:FontWeight.bold)),Text('My Club',style:AppTheme.vazir(size:12,color:AppTheme.textSecondary))])]),
        Row(children:[Text('Lv. 12',style:AppTheme.vazir(size:18)),const SizedBox(width:10),Container(width:150,height:16,decoration:BoxDecoration(borderRadius:BorderRadius.circular(12),border:Border.all(color:AppTheme.neonBlue)),child:Align(alignment:Alignment.centerRight,child:FractionallySizedBox(widthFactor:.6,child:Container(decoration:BoxDecoration(color:AppTheme.neonGold,borderRadius:BorderRadius.circular(12),boxShadow:AppTheme.glow(AppTheme.neonGold))))))]),
        Row(children:[_pill(Icons.monetization_on,'250,000',AppTheme.neonGold),const SizedBox(width:8),_pill(Icons.diamond,'3 LP',AppTheme.neonPurple),const SizedBox(width:12),const Icon(Icons.settings,color:AppTheme.neonBlue,size:30)]),
      ])),
      const SizedBox(height:15),
      Expanded(child:GridView.count(crossAxisCount:3,childAspectRatio:1.1,mainAxisSpacing:15,crossAxisSpacing:15,children:cards.map((e)=>DashboardTile(card:e)).toList())),
    ])))));
  }
  Widget _pill(IconData icon,String value,Color color)=>Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),border:Border.all(color:color),boxShadow:AppTheme.glow(color)),child:Row(children:[Icon(icon,color:color,size:19),const SizedBox(width:5),Text(value,style:AppTheme.vazir(size:14))]));
}

class _DashboardCard {
  final String fa,en; final Color color; final List<Color> gradient; final Widget graphic;
  const _DashboardCard(this.fa,this.en,this.color,this.gradient,this.graphic);
}
class DashboardTile extends StatelessWidget {
  final _DashboardCard card;
  const DashboardTile({super.key,required this.card});
  @override
  Widget build(BuildContext context)=>Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:card.gradient),borderRadius:BorderRadius.circular(20),border:Border.all(color:card.color,width:2),boxShadow:AppTheme.glow(card.color)),child:Stack(children:[
    Center(child:Column(children:[Expanded(child:Padding(padding:const EdgeInsets.fromLTRB(12,12,12,0),child:card.graphic)),Text(card.fa,style:AppTheme.vazir(size:20,weight:FontWeight.bold),maxLines:1,overflow:TextOverflow.ellipsis),Text(card.en,style:AppTheme.vazir(size:14,color:AppTheme.textSecondary),maxLines:1),const SizedBox(height:8)])),
    Positioned(left:10,bottom:10,child:CircleAvatar(radius:20,backgroundColor:card.color,child:const Icon(Icons.arrow_back_ios,color:Colors.black,size:17))),
  ]));
}

class DiagonalPainter extends CustomPainter {
  final Color color; final double opacity; final bool texture;
  DiagonalPainter(this.color,this.opacity,{this.texture=false});
  @override
  void paint(Canvas canvas,Size size){
    final p=Paint()..color=color.withOpacity(opacity)..strokeWidth=1;
    for(int i=-size.height.toInt();i<size.width.toInt();i+=55){canvas.drawLine(Offset(i.toDouble(),0),Offset(i+size.height,size.height),p);}
    if(texture){final dot=Paint()..color=AppTheme.neonGreen.withOpacity(.07);for(double y=0;y<size.height;y+=9){for(double x=0;x<size.width;x+=12){canvas.drawCircle(Offset(x,y),.7,dot);}}}
  }
  @override bool shouldRepaint(covariant DiagonalPainter old)=>false;
}
class PitchGraphic extends StatelessWidget {
  const PitchGraphic({super.key});
  @override Widget build(BuildContext context)=>CustomPaint(painter:PitchPainter(),child:const SizedBox.expand());
}
class PitchPainter extends CustomPainter {
  @override void paint(Canvas c,Size s){final p=Paint()..color=Colors.white.withOpacity(.9)..style=PaintingStyle.stroke..strokeWidth=2;final r=Rect.fromLTWH(s.width*.18,s.height*.12,s.width*.64,s.height*.76);c.drawRect(r,p);c.drawLine(Offset(s.width/2,r.top),Offset(s.width/2,r.bottom),p);c.drawCircle(Offset(s.width/2,s.height/2),s.width*.12,p);c.drawRect(Rect.fromLTWH(r.left,r.top,s.width*.13,s.height*.2),p);c.drawRect(Rect.fromLTWH(r.right-s.width*.13,r.top,s.width*.13,s.height*.2),p);}
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
class LeagueGraphic extends StatelessWidget {
  const LeagueGraphic({super.key});
  @override Widget build(BuildContext context)=>Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Row(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.emoji_events,color:AppTheme.neonGold,size:23),Text(' جدول لیگ',style:AppTheme.vazir(size:13,weight:FontWeight.bold))]),
    const SizedBox(height:4),_leagueRow('رتبه','تیم','امتیاز',true),_leagueRow('1','رئال مادرید','32'),_leagueRow('2','بارسلونا','31'),Container(color:AppTheme.neonGreen.withOpacity(.18),child:_leagueRow('3','باشگاه من','33')),_leagueRow('4','اتلتیکو','28'),_leagueRow('5','سویا','26')
  ]);
  Widget _leagueRow(String a,String b,String d,[bool header=false])=>Padding(padding:const EdgeInsets.symmetric(vertical:1,horizontal:5),child:Row(children:[Expanded(child:Text(a,style:AppTheme.vazir(size:header?9:10,weight:header?FontWeight.bold:FontWeight.normal),textAlign:TextAlign.center)),Expanded(flex:3,child:header?Text(b,style:AppTheme.vazir(size:9),textAlign:TextAlign.center):Row(mainAxisAlignment:MainAxisAlignment.center,children:[if(b=='رئال مادرید')Image.asset('assets/logos_png/real_madrid.png',width:14,height:14,fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const SizedBox(width:14,height:14)),if(b=='بارسلونا')Image.asset('assets/logos_png/barcelona.png',width:14,height:14,fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const SizedBox(width:14,height:14)),if(b=='اتلتیکو')Image.asset('assets/logos_png/atletico_madrid.png',width:14,height:14,fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const SizedBox(width:14,height:14)),Flexible(child:Text(b,style:AppTheme.vazir(size:10),textAlign:TextAlign.center,maxLines:1,overflow:TextOverflow.ellipsis))])),Expanded(child:Text(d,style:AppTheme.vazir(size:header?9:10),textAlign:TextAlign.center))]));
}
class PlayerGraphic extends StatelessWidget {
  final bool upgrade; const PlayerGraphic({super.key,this.upgrade=false});
  @override Widget build(BuildContext context)=>FittedBox(child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.accessibility_new,color:Colors.white,size:64),if(upgrade)const Icon(Icons.trending_up,color:Colors.white,size:48)else const Icon(Icons.search,color:Colors.white,size:55)]));
}
class TacticsGraphic extends StatelessWidget {
  const TacticsGraphic({super.key});
  @override Widget build(BuildContext context)=>CustomPaint(painter:TacticsPainter(),child:const SizedBox.expand());
}
class TacticsPainter extends CustomPainter {
  @override void paint(Canvas c,Size s){final p=Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=2;c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s.width*.12,s.height*.12,s.width*.76,s.height*.76),const Radius.circular(8)),p);final fill=Paint()..color=Colors.white;for(final o in [Offset(s.width*.3,s.height*.35),Offset(s.width*.65,s.height*.3),Offset(s.width*.45,s.height*.68)]){c.drawCircle(o,6,fill);}c.drawLine(Offset(s.width*.32,s.height*.38),Offset(s.width*.6,s.height*.32),p);c.drawLine(Offset(s.width*.62,s.height*.35),Offset(s.width*.48,s.height*.62),p);}
  @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
class CoachGraphic extends StatelessWidget {
  const CoachGraphic({super.key});
  @override Widget build(BuildContext context)=>const FittedBox(child:Icon(Icons.person_outline,color:Colors.white,size:100));
}
