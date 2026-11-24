import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TacticsScreen extends StatefulWidget {
  const TacticsScreen({super.key});
  @override
  State<TacticsScreen> createState() => _TacticsScreenState();
}

class _TacticsScreenState extends State<TacticsScreen> {
  static const green = Color(0xFF39FF14), cyan = Color(0xFF00DFFF), gold = Color(0xFFFFD700);
  static const keyName = 'lpm_tactics_v1';
  static const styles = <_Style>[
    _Style('مالکیت توپ','Possession',Icons.sports_soccer,[72,68,42,48,62,35,82,25]),
    _Style('ضدحمله','Counter Attack',Icons.flash_on,[68,72,60,50,78,72,48,62]),
    _Style('پرس شدید','High Press',Icons.bolt,[74,82,92,78,84,55,62,35]),
    _Style('دفاع عمیق','Deep Block',Icons.shield,[38,78,25,22,35,72,62,48]),
    _Style('فوتبال مستقیم','Direct Play',Icons.sports,[55,52,58,62,78,88,28,82]),
    _Style('بازی از جناحین','Wing Play',Icons.assistant_navigation,[88,58,52,55,72,58,42,45]),
    _Style('ضدپرس','Gegenpressing',Icons.sync,[70,84,95,76,82,48,68,28]),
    _Style('بازی متعادل','Balanced',Icons.balance,[60,60,60,55,60,50,55,45]),
  ];
  static const labels = ['عرض بازی','فشردگی تیم','شدت پرس','ارتفاع خط دفاع','سرعت بازی','مستقیم بودن پاس','پاس‌های کوتاه','پاس‌های بلند'];
  static const ends = [['کم','زیاد'],['باز','فشرده'],['کم','زیاد'],['عقب','جلو'],['آهسته','سریع'],['کوتاه','مستقیم'],['کم','زیاد'],['کم','زیاد']];
  // Names mirror the match screen's squad and bench.
  static const starters = ['Courtois','Vinícius Jr.','Mbappé','Salah','De Bruyne','Modrić','Bellingham','Davies','Rüdiger','Dias','Hakimi'];
  static const bench = ['Alisson','Laporte','Grimaldo','Kroos','Pedri','Dembélé','Vlahović','Son','Rodri','Foden','Kane','Gvardiol'];

  int style = 7;
  late List<double> team = styles[style].values.map((v)=>v.toDouble()).toList();
  final Map<String,bool> toggles = {'جابجایی بازیکنان':true,'جلو آمدن دفاع راست (RB)':true,'جلو آمدن دفاع چپ (LB)':true,'جابه‌جایی وینگرها':true,'شوت از پشت محوطه':true};
  final Map<String,double> individual = {'جابجایی بازیکنان':70,'جلو آمدن دفاع راست (RB)':65,'جلو آمدن دفاع چپ (LB)':65,'میزان دوندگی':80,'جابه‌جایی وینگرها':70,'شوت از پشت محوطه':60,'بازگشت سریع هنگام ازدست‌دادن توپ':75};
  final Set<String> running = {}, recovery = {};
  bool loaded=false, saving=false;

  @override
  void initState(){super.initState();_load();}
  Future<void> _load() async {
    try {
      final p=await SharedPreferences.getInstance(), raw=p.getString(keyName);
      if(raw==null){if(mounted)setState(()=>loaded=true);return;}
      final d=jsonDecode(raw) as Map<String,dynamic>;
      if(!mounted)return;
      setState((){
        style=((d['style'] as num?)?.toInt() ?? 7).clamp(0,7).toInt();
        final a=d['team'];
        team=a is List && a.length==8 ? a.map((v)=>(v as num).toDouble().clamp(0,100).toDouble()).toList() : styles[style].values.map((v)=>v.toDouble()).toList();
        if(d['toggles'] is Map){for(final k in toggles.keys){if(d['toggles'][k] is bool)toggles[k]=d['toggles'][k];}}
        if(d['individual'] is Map){for(final k in individual.keys){if(d['individual'][k] is num)individual[k]=(d['individual'][k] as num).toDouble().clamp(0,100).toDouble();}}
        final all=[...starters,...bench];
        running..clear()..addAll((d['running'] as List? ?? []).whereType<String>().where(all.contains));
        recovery..clear()..addAll((d['recovery'] as List? ?? []).whereType<String>().where(all.contains));
        loaded=true;
      });
    } catch(_){if(mounted)setState(()=>loaded=true);}
  }
  Future<void> _save() async {
    setState(()=>saving=true);
    try{
      final p=await SharedPreferences.getInstance();
      await p.setString(keyName,jsonEncode({'style':style,'team':team,'toggles':toggles,'individual':individual,'running':running.toList(),'recovery':recovery.toList()}));
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تاکتیک‌ها ذخیره شدند',textDirection:TextDirection.rtl),backgroundColor:Color(0xFF087D32)));
    }catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ذخیره‌سازی انجام نشد',textDirection:TextDirection.rtl)));}
    finally{if(mounted)setState(()=>saving=false);}
  }
  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:const Color(0xFF020A18),
    body:Stack(children:[
      const Positioned.fill(child:_Backdrop()),
      SafeArea(child:Column(children:[
        Padding(padding:const EdgeInsets.fromLTRB(48,2,48,5),child:Container(
          padding:const EdgeInsets.symmetric(horizontal:34,vertical:3),
          decoration:BoxDecoration(color:const Color(0xE9081722),borderRadius:BorderRadius.circular(24),border:Border.all(color:green,width:2),boxShadow:[BoxShadow(color:green.withOpacity(.5),blurRadius:13)]),
          child:const Column(mainAxisSize:MainAxisSize.min,children:[Text('تاکتیک‌ها',style:TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.w900)),Text('TACTICS',style:TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.bold))]),
        )),
        Expanded(child:LayoutBuilder(builder:(context,c){
          if(c.maxWidth>=850)return Row(children:[Expanded(child:_teamPanel()),const SizedBox(width:9),Expanded(child:_individualPanel())]);
          return ListView(children:[SizedBox(height:c.maxHeight*.9,child:_teamPanel()),SizedBox(height:8),SizedBox(height:c.maxHeight*.9,child:_individualPanel())]);
        })),
        Padding(padding:const EdgeInsets.fromLTRB(8,4,8,5),child:SizedBox(width:310,height:52,child:ElevatedButton.icon(
          onPressed:loaded&&!saving?_save:null,
          icon:saving?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):const Icon(Icons.save),
          label:const Text('ذخیره تاکتیک',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),
          style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFF075DFF),foregroundColor:Colors.white,side:const BorderSide(color:cyan,width:2),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),elevation:9),
        ))),
      ])),
      Positioned(top:1,right:2,child:IconButton(onPressed:()=>Navigator.of(context).maybePop(),icon:const Icon(Icons.arrow_back,color:cyan,size:27))),
    ]),
  );

  Widget _panel(String title,Widget child)=>Container(
    margin:const EdgeInsets.fromLTRB(6,3,6,5),padding:const EdgeInsets.fromLTRB(9,17,9,7),
    decoration:BoxDecoration(color:const Color(0xD8051720),borderRadius:BorderRadius.circular(22),border:Border.all(color:green,width:2.2),boxShadow:[BoxShadow(color:green.withOpacity(.3),blurRadius:14)]),
    child:Column(children:[
      Transform.translate(offset:const Offset(0,-14),child:Container(padding:const EdgeInsets.symmetric(horizontal:20,vertical:3),decoration:BoxDecoration(color:const Color(0xFF061421),borderRadius:BorderRadius.circular(22),border:Border.all(color:green,width:1.8),boxShadow:[BoxShadow(color:green.withOpacity(.4),blurRadius:8)]),child:Text(title,style:const TextStyle(color:gold,fontSize:16,fontWeight:FontWeight.w900)))),
      Expanded(child:Transform.translate(offset:const Offset(0,-8),child:child)),
    ]),
  );

  Widget _teamPanel()=>_panel('تنظیم تاکتیک‌های تیمی',Column(children:[
    const Text('انتخاب سبک بازی',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:12)),
    const SizedBox(height:4),
    Expanded(flex:5,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),itemCount:8,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4,crossAxisSpacing:5,mainAxisSpacing:5,childAspectRatio:1.45),
      itemBuilder:(context,i){final s=styles[i],active=i==style;return InkWell(onTap:()=>setState(() { style=i; team=s.values.map((v)=>v.toDouble()).toList(); }),child:Container(
        padding:const EdgeInsets.all(3),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF0A2B42),Color(0xFF04111E)]),borderRadius:BorderRadius.circular(11),border:Border.all(color:active?green:const Color(0xFF168CB2),width:active?2.5:1.2),boxShadow:active?[BoxShadow(color:green.withOpacity(.6),blurRadius:10)]:[]),
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(s.icon,color:Colors.white,size:20),FittedBox(child:Text(s.fa,style:const TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.bold))),FittedBox(child:Text(s.en,textDirection:TextDirection.ltr,style:const TextStyle(color:Colors.white70,fontSize:8)))]),
      ));},
    )),
    const SizedBox(height:5),
    Expanded(flex:8,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),itemCount:8,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:6,mainAxisSpacing:5,childAspectRatio:3.55),
      itemBuilder:(context,i)=>_slider(labels[i],team[i],(v)=>setState(()=>team[i]=v),left:ends[i][0],right:ends[i][1]),
    )),
  ]));

  Widget _slider(String title,double value,ValueChanged<double> onChanged,{String? left,String? right,bool enabled=true})=>Container(
    padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),
    decoration:BoxDecoration(color:const Color(0xB90B2635),borderRadius:BorderRadius.circular(11),border:Border.all(color:const Color(0xFF17647B))),
    child:Row(children:[
      Expanded(flex:3,child:Text(title,maxLines:2,overflow:TextOverflow.ellipsis,textDirection:TextDirection.rtl,style:TextStyle(color:enabled?Colors.white:Colors.white38,fontSize:10,fontWeight:FontWeight.bold))),
      if(left!=null)Text(left,style:const TextStyle(color:Colors.white70,fontSize:8)),
      Expanded(flex:5,child:SliderTheme(data:SliderTheme.of(context).copyWith(activeTrackColor:const Color(0xFF20F06B),inactiveTrackColor:const Color(0xFF17496B),thumbColor:cyan,trackHeight:4,thumbShape:const RoundSliderThumbShape(enabledThumbRadius:7)),child:Slider(value:value.clamp(0,100).toDouble(),min:0,max:100,divisions:100,onChanged:enabled?onChanged:null))),
      if(right!=null)Text(right,style:const TextStyle(color:Colors.white70,fontSize:8)),
      Container(width:40,alignment:Alignment.center,padding:const EdgeInsets.symmetric(vertical:3),decoration:BoxDecoration(color:const Color(0xFF071725),borderRadius:BorderRadius.circular(7),border:Border.all(color:const Color(0xFF16718B))),child:Text(value.round().toString()+'%',style:TextStyle(color:enabled?Colors.white:Colors.white38,fontWeight:FontWeight.w900,fontSize:12))),
    ]),
  );

  BoxDecoration get _rowDecoration=>BoxDecoration(color:const Color(0xB9071B28),borderRadius:BorderRadius.circular(12),border:Border.all(color:const Color(0xFF155B70)));
  Widget _individualPanel()=>_panel('تنظیم تاکتیک‌های فردی',ListView(padding:EdgeInsets.zero,children:[
    _toggle('جابجایی بازیکنان'),_toggle('جلو آمدن دفاع راست (RB)'),_toggle('جلو آمدن دفاع چپ (LB)'),
    _players('میزان دوندگی بیشتر',running,'میزان دوندگی'),
    _toggle('جابه‌جایی وینگرها'),_toggle('شوت از پشت محوطه'),
    _players('بازگشت سریع هنگام ازدست‌دادن توپ',recovery,'بازگشت سریع هنگام ازدست‌دادن توپ'),
  ]));

  Widget _toggle(String name){
    final on=toggles[name]??false;
    return Container(margin:const EdgeInsets.only(bottom:5),padding:const EdgeInsets.symmetric(horizontal:7,vertical:3),decoration:_rowDecoration,child:Column(children:[
      Row(children:[Expanded(child:Text(name,textDirection:TextDirection.rtl,style:const TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.bold))),_yesNo(on,(v)=>setState(()=>toggles[name]=v))]),
      _slider('میزان',individual[name]!, (v)=>setState(()=>individual[name]=v),enabled:on),
    ]));
  }

  Widget _players(String title,Set<String> selected,String sliderKey)=>Container(
    margin:const EdgeInsets.only(bottom:5),padding:const EdgeInsets.all(6),decoration:_rowDecoration,
    child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Text(title,textDirection:TextDirection.rtl,style:const TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.bold)),
      Wrap(spacing:3,runSpacing:1,children:[...starters.map((p)=>_chip(p,selected)),...bench.map((p)=>_chip(p,selected))]),
      _slider('شدت',individual[sliderKey]!, (v)=>setState(()=>individual[sliderKey]=v),enabled:selected.isNotEmpty),
      if(selected.isEmpty)const Text('ابتدا حداقل یک بازیکن انتخاب کنید',textDirection:TextDirection.rtl,style:TextStyle(color:Colors.white54,fontSize:9)),
    ]),
  );

  Widget _chip(String name,Set<String> selected){
    final on=selected.contains(name);
    return FilterChip(selected:on,onSelected:(v)=>setState(()=>v?selected.add(name):selected.remove(name)),showCheckmark:false,visualDensity:VisualDensity.compact,materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
      backgroundColor:const Color(0xFF0B3343),selectedColor:const Color(0xFF087D35),side:BorderSide(color:on?green:const Color(0xFF176B83)),
      label:Text(name,style:const TextStyle(color:Colors.white,fontSize:9)));
  }

  Widget _yesNo(bool on,ValueChanged<bool> change)=>Row(mainAxisSize:MainAxisSize.min,children:[
    _choice('خیر',!on,()=>change(false)),_choice('بله',on,()=>change(true)),
  ]);
  Widget _choice(String text,bool active,VoidCallback tap)=>InkWell(onTap:tap,child:AnimatedContainer(duration:const Duration(milliseconds:140),width:52,padding:const EdgeInsets.symmetric(vertical:4),alignment:Alignment.center,
    decoration:BoxDecoration(color:active?const Color(0xFF087D32):const Color(0xFF061522),borderRadius:BorderRadius.circular(9),border:Border.all(color:active?green:const Color(0xFF17536B)),boxShadow:active?[BoxShadow(color:green.withOpacity(.5),blurRadius:8)]:[]),
    child:Text(text,style:const TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.bold))));
}

class _Style{final String fa,en;final IconData icon;final List<int> values;const _Style(this.fa,this.en,this.icon,this.values);}
class _Backdrop extends StatelessWidget{const _Backdrop();@override Widget build(BuildContext context)=>CustomPaint(painter:_BackdropPainter(),child:const SizedBox.expand());}
class _BackdropPainter extends CustomPainter{
 @override void paint(Canvas c,Size s){
  c.drawRect(Offset.zero&s,Paint()..color=const Color(0xFF010711));
  final p=Paint()..shader=const RadialGradient(colors:[Color(0xFF0C2B42),Color(0xFF030C18),Color(0xFF010711)]).createShader(Offset.zero&s);c.drawRect(Offset.zero&s,p);
  final line=Paint()..color=const Color(0xFF0D5C76).withOpacity(.12);for(double x=-s.height;x<s.width+s.height;x+=52){c.drawLine(Offset(x,0),Offset(x+s.height,s.height),line);}
  final grass=Paint()..shader=const LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Color(0xFF063018),Color(0xFF071D12)],stops:[0,.78,1]).createShader(Offset(0,s.height*.78)&Size(s.width,s.height*.22));c.drawRect(Offset(0,s.height*.78)&Size(s.width,s.height*.22),grass);
 }
 @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
