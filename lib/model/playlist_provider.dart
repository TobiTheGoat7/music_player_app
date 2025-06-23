import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player_app/model/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: '2 Levels of Encounter',
      artistName: 'Apostle Michael Orokpo',
      albumArtImagePath: "assets/IMG_9673.jpg",
      audioFilePath:
          "2-Levels-Of-Encounter-with-Apostle-Joshua-Selman-09-07-2023.mp3",
    ),
    Song(
      songName: 'Build Me an Altar',
      artistName: 'Bro. Gbile Akanni',
      albumArtImagePath: "assets/IMG_9673.jpg",
      audioFilePath: "BUILD ME AN ALTAR BY GBILE AKANNI_64kbps.mp3",
    ),
    Song(
      songName: 'Mental Transformation',
      artistName: 'Pastor Daniel Olawande',
      albumArtImagePath: "assets/IMG_9673.jpg",
      audioFilePath: "Mental Transformation _P.Daniel .mp3",
    ),
  ];

  //current song playing index
  int? _currentSongIndex;

  /*
AUDIOPLAYER
*/

  //audio player

  final AudioPlayer _audioPlayer = AudioPlayer();

  //duration

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //comstuctor
  PlaylistProvider() {
    listenToDuration();
  }
  //initially not playing

  bool _isPlaying = false;

  ///play the song

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioFilePath;
    await _audioPlayer.stop;
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pause cuurent song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pauseor resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }
  //seek specific position in the current song

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  //play next song
  void playNext() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to the next sng if not last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if its last song
        currentSongIndex = 0;
      }
    }
  }

  //play previous song

  void playPreviousSong() async {
    //if more than 2 seconds has passed, restart current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if its the first song, loop to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //list to duration
  void listenToDuration() {
    //listen to total duration

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    //listen to current duartion
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }
  //dispose audio player

  /*
GETTERS
*/

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
SETTERS
*/

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); //play song at new index
    }
    notifyListeners();
  }
}
