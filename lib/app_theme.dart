import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const bgDark = Color(0xFF050B14);
  static const bgCardBlue = Color(0xFF111A30);
  static const neonBlue = Color(0xFF00BFFF);
  static const neonGreen = Color(0xFF39FF14);
  static const neonGold = Color(0xFFFFD700);
  static const neonPurple = Color(0xFF9D00FF);
  static const neonOrange = Color(0xFFFF8C00);
  static const textWhite = Colors.white;
  static const textSecondary = Color(0xFFB0C4DE);

  static TextStyle vazir({double size = 14, FontWeight weight = FontWeight.normal, Color color = textWhite}) =>
      GoogleFonts.vazirmatn(fontSize: size, fontWeight: weight, color: color);

  static List<BoxShadow> glow(Color color, {bool strong = false}) => [
    BoxShadow(color: color.withOpacity(strong ? .95 : .8), blurRadius: strong ? 16 : 10, spreadRadius: strong ? 2 : 1),
    BoxShadow(color: color.withOpacity(strong ? .6 : .4), blurRadius: strong ? 34 : 25, spreadRadius: strong ? 5 : 3),
  ];

  static BoxDecoration neon(Color color, {bool selected = false, Gradient? gradient}) => BoxDecoration(
    gradient: gradient,
    color: gradient == null ? bgCardBlue : null,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: selected ? neonGold : color, width: selected ? 3 : 1.5),
    boxShadow: glow(selected ? neonGold : color, strong: selected),
  );
}
