import 'package:flutter/material.dart';
import 'package:music_player/pages/settings_page.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 5,
        title: const Text(
          "P L A Y L I S T",
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 40,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.home),
                title: const Text("H O M E"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                leading: const Icon(Icons.settings),
                title: const Text("S E T T I N G S"),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final playlistProvider = Provider.of<PlaylistProvider>(context);
          final playlist = playlistProvider.playlist;

          void setCurrentSong(int index) {
            playlistProvider.currentSongIndex = index;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SongPage(),
              ),
            );
          }

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final currentSong = playlist[index];

              return ListTile(
                onTap: () {
                  setCurrentSong(index);
                },
                title: Text(currentSong.songName),
                subtitle: Text(currentSong.artistName),
                leading: Image.asset(
                  currentSong.albumArtImagePath,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
