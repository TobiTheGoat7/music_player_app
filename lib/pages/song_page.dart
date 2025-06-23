import 'package:flutter/material.dart';
import 'package:music_player_app/model/playlist_provider.dart';
import 'package:music_player_app/pages/neubox.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;

        final currentSong = playlist[value.currentSongIndex ?? 0];

        // return scaffold
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //BACK BUTTON
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),

                      //TITLE
                      Text('P L A Y L I S T,'),

                      //MENU BUTTTON
                      IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                    ],
                  ),
                  SizedBox(height: 25),
                  //album artwork
                  Neubox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        //SONG AND ARTIST NAME
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              Icon(Icons.favorite, color: Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  //song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start and end time
                            Text(formatTime(value.currentDuration)),

                            // shuffle icon
                            Icon(Icons.shuffle),

                            //repaat icon
                            Icon(Icons.repeat),
                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),

                      //song duration progress
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                        ),
                        child: Slider(
                          value: value.currentDuration.inSeconds.toDouble(),
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {
                            //during wwhen user is slding
                          },
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));

                            //sliding has ifnisjjef
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  //playback controls
                  Row(
                    children: [
                      //skip prevous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,

                          child: Neubox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      SizedBox(width: 25),
                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,

                          child: Neubox(
                            child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      //skip forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNext,

                          child: Neubox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
