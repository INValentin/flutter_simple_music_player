import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

enum Loop { off, all, one }

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Let You Love Me",
      albumArtImagePath: "assets/images/cover_1.jpg",
      artistName: "Rita Ora",
      audioPath: "audios/let_you_love.mp3",
    ),
    Song(
      songName: "Swing Little Girl",
      artistName: "Charlie Chaplin",
      audioPath: "audios/swing_high.mp3",
      albumArtImagePath: "assets/images/cover_2.jpg",
    ),
    Song(
      songName: "Why You Got To Be",
      artistName: "Nervous Auto-pilot",
      audioPath: "audios/you_got_be.mp3",
      albumArtImagePath: "assets/images/cover_3.jpg",
    ),
    Song(
      songName: "Symphony No.5 Fate",
      artistName: "Beethoven",
      audioPath: "audios/symphony_of_fate.mp3",
      albumArtImagePath: "assets/images/cover_4.jpg",
    ),
  ];

  int? _currentSongIndex;

  // enum Color { red, green, blue }

  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Loop _loop = Loop.all;

  Duration _totalDuration = Duration.zero;
  Duration _currentDuration = Duration.zero;

  // Consturctor
  PlaylistProvider() {
    listenToDuration();
  }

  // duration listener
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((currentDuration) {
      _currentDuration = currentDuration;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((data) {
      if (_loop == Loop.off) {
        isPlaying = false;
        _audioPlayer.stop();
      } else if (_loop == Loop.all) {
        skipNext();
      } else {
        skipPrevious();
      }
    });
  }

  // play
  void play() async {
    if (_isPlaying) await _audioPlayer.stop();

    await _audioPlayer.play(
      AssetSource(_playlist[_currentSongIndex!].audioPath),
    );
    isPlaying = true;
  }

  // Pause
  void pause() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  // seek
  void seek(Duration pos) async {
    await _audioPlayer.seek(pos);
  }

  // toggle Play
  void togglePlay() {
    _isPlaying ? pause() : play();
  }

  // skipPrev
  void skipPrevious() {
    if (_isPlaying && currentDuraton.inSeconds > 5) {
      // restart the song
      seek(Duration.zero);
      play();
    } else {
      // Go to previous song
      if (currentSongIndex == 0) {
        currentSongIndex = _playlist.length - 1;
      } else {
        currentSongIndex =
            currentSongIndex != null ? (currentSongIndex! - 1) : 0;
      }
    }
  }

  // skipNext
  void skipNext() {
    currentSongIndex = ((_currentSongIndex ?? -1) + 1) % playlist.length;
  }

  // Toggle Loop
  void toggleLoop() {
    if (_loop == Loop.off) {
      loop = Loop.all;
    } else if (_loop == Loop.all) {
      loop = Loop.one;
    } else {
      loop = Loop.off;
    }
  }

  // Getters
  int? get currentSongIndex => _currentSongIndex;

  List<Song> get playlist => _playlist;
  Loop get loop => _loop;
  Duration get totalDuraton => _totalDuration;
  Duration get currentDuraton => _currentDuration;
  bool get isPlaying => _isPlaying;

  // // Setters
  set currentSongIndex(int? index) {
    _currentSongIndex = index;

    if (_currentSongIndex != null && !_isPlaying) {
      play();
    }
    notifyListeners();
  }

  set isPlaying(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }

  set loop(Loop loop) {
    _loop = loop;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    _audioPlayer.release(); // Release the resources
    _audioPlayer.dispose(); // Dispose of the player
    super.dispose();
  }
}
