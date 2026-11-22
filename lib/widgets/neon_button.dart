import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  const NeonButton({super.key, required this.label, required this.onPressed,
    this.color = AppColors.neonGreen, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_back, color: AppColors.background),
      label: Text(label, style: const TextStyle(color: AppColors.background,
        fontWeight: FontWeight.w900, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withOpacity(.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 12, shadowColor: color.withOpacity(.7)),
    ),
  );
}
