import 'package:flutter/material.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/widgets/neo_box.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _animation = Tween<double>(begin: 0, end: 0.2).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastEaseInToSlowEaseOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTransition({required bool isNext}) {
    setState(() => _isTransitioning = true);

    if (isNext) {
      _controller.forward(from: 0).then((_) {
        setState(() => _isTransitioning = false);
        Provider.of<PlaylistProvider>(context, listen: false).skipNext();
        _controller.reset();
      });
    } else {
      _controller.reverse(from: 1).then((_) {
        setState(() => _isTransitioning = false);
        Provider.of<PlaylistProvider>(context, listen: false).skipPrevious();
        _controller.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    final currentSong =
        playlistProvider.playlist[playlistProvider.currentSongIndex!];

    String formatDuration(Duration duration) {
      return "${duration.inMinutes}:${((((duration.inSeconds / 60) - duration.inMinutes) * 60).toInt()).toString().padLeft(2, '0')}";
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(currentSong.songName),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Swippable
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (!_isTransitioning) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right
                      _animateTransition(isNext: false);
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left
                      _animateTransition(isNext: true);
                    }
                  }
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value * 06 * math.pi),
                      child: NeoBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                currentSong.albumArtImagePath,
                                height: 300,
                                width: 400,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSong.artistName)
                                  ],
                                ),
                                const Icon(
                                  Icons.favorite,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(playlistProvider.currentDuraton)),
                    const Icon(Icons.shuffle),
                    GestureDetector(
                      onTap: playlistProvider.toggleLoop,
                      child: Icon(playlistProvider.loop == Loop.one
                          ? Icons.repeat_one_on_outlined
                          : playlistProvider.loop == Loop.off
                              ? Icons.repeat_outlined
                              : Icons.repeat_on_outlined),
                    ),
                    Text(formatDuration(playlistProvider.totalDuraton))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                ),
                child: Slider(
                  activeColor: Colors.green,
                  inactiveColor: Theme.of(context).colorScheme.primary,
                  value: playlistProvider.currentDuraton.inSeconds.toDouble(),
                  min: 0,
                  max: playlistProvider.totalDuraton.inSeconds.toDouble(),
                  onChanged: (double value) {
                    playlistProvider.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: playlistProvider.skipPrevious,
                      child: const NeoBox(
                        child: Icon(Icons.skip_previous),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: playlistProvider.togglePlay,
                      child: NeoBox(
                        child: Icon(playlistProvider.isPlaying
                            ? Icons.pause_sharp
                            : Icons.play_arrow),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _animateTransition(isNext: true),
                      child: const NeoBox(
                        child: Icon(Icons.skip_next),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
