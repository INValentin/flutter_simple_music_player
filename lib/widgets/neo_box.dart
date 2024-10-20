import 'package:flutter/material.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class NeoBox extends StatelessWidget {
  final Widget? child;
  const NeoBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.5)
                  : Colors.grey.shade500,
              offset: const Offset(4, 4),
              blurRadius: 15),
          BoxShadow(
            color: isDarkMode
                ? Colors.grey.shade700.withOpacity(0.6)
                : Colors.white,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
