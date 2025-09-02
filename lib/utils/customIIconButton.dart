import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
          child: Icon(icon, color: theme.colorScheme.onSurface),
        ),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(delay: 2000.ms, duration: 1800.ms, color: theme.colorScheme.primary.withOpacity(0.3)),
    );
  }
}
