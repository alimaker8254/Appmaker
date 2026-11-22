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
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: AppTheme.bgDark),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
    home: const TeamSelectionScreen(),
  );
}

const clubs = [
  Club('منچسترسیتی','manchester_city.svg'), Club('لیورپول','liverpool.svg'), Club('آرسنال','arsenal.svg'), Club('منچستریونایتد','manchester_united.svg'), Club('چلسی','chelsea.svg'),
  Club('تاتنهام','tottenham.svg'), Club('نیوکاسل','newcastle.svg'), Club('استون ویلا','aston_villa.svg'), Club('وستهم','west_ham.svg'), Club('اورتون','everton.svg'),
  Club('برایتون','brighton.svg'), Club('ناتینگهام فارست','nottingham_forest.svg'), Club('بارسلونا','barcelona.svg'), Club('رئال مادرید','real_madrid.svg'), Club('اتلتیکو مادرید','atletico_madrid.svg'), Club('سویا','',networkLogo:'https://www.footylogos.com/downloads/logo/sevilla-fc-logo-footylogos.png'),
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
        Expanded(child: GridView.builder(padding:const EdgeInsets.symmetric(horizontal:15,vertical:10),physics:const NeverScrollableScrollPhysics(),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,mainAxisSpacing:8,crossAxisSpacing:8,childAspectRatio:1.55),itemCount:clubs.length,itemBuilder:(context,i){
          final club=clubs[i]; return GestureDetector(onTap:()=>setState(()=>selected=i),child:Container(decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppTheme.bgDark,AppTheme.bgCardBlue]),borderRadius:BorderRadius.circular(16),border:Border.all(color:selected==i?AppTheme.neonGold:AppTheme.neonBlue,width:selected==i?3:1.5),boxShadow:AppTheme.glow(selected==i?AppTheme.neonGold:AppTheme.neonBlue,strong:selected==i)),child:Column(children:[
            Expanded(child:Padding(padding:const EdgeInsets.all(8),child:club.networkLogo!=null?Image.network(club.networkLogo!,fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const SizedBox.shrink()):Image.asset('assets/logos_png/${club.asset.replaceAll('.svg', '.png')}',fit:BoxFit.contain,errorBuilder:(context,error,stackTrace)=>const SizedBox.shrink()))),
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

