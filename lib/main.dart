import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/team_selection_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FootballManagerApp());
}

class FootballManagerApp extends StatelessWidget {
  const FootballManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonGreen,
        surface: AppColors.navy,
      ),
      textTheme: GoogleFonts.vazirmatnTextTheme(ThemeData.dark().textTheme),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مدیر فوتبال',
      theme: AppTheme.build(base),
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const TeamSelectionScreen(),
    );
  }
}
