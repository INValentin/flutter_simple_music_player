import 'package:flutter/material.dart';
import 'package:music_player/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Dark Mode"),
            Switch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (_) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme())
          ],
        ),
      ),
    );
  }
}
