import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neon_container.dart';

class NeonCard extends StatelessWidget {
  const NeonCard({super.key, required this.title, required this.subtitle,
    required this.icon, required this.color, this.onTap});
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18), onTap: onTap,
      child: NeonContainer(
        neonColor: color, borderRadius: 18,
        gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [color.withOpacity(.24), AppColors.navy]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 34, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: AppColors.white,
            fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.secondary, fontSize: 11)),
        ]),
      ),
    ),
  );
}
