import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_playout/multiaudio/MultiAudioSupport.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';

class VideoPlayerPage extends StatefulWidget {
  final String filePath;
  final String aesKey;
  final PlayerState desiredState;
  final bool showPlayerControls;

  const VideoPlayerPage(
      {Key key,
      this.desiredState,
      this.showPlayerControls,
      this.filePath,
      this.aesKey})
      : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with PlayerObserver, MultiAudioSupport {
  PlayerState currPlayerState;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    currPlayerState = widget.desiredState;
// SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(
    //     [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /* player */
        Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Video(
              autoPlay: true,
              showControls: widget.showPlayerControls,
              // title: "MTA International",
              // subtitle: "Reaching The Corners Of The Earth",
              // preferredAudioLanguage: "eng",
              // isLiveStream: false,
              position: 0,
              // url: 'https://downloads.akonnect.org/energizer/2022-02/2022_02_15_021513_0bb8f7_hin.mp4',//_url,
              url: widget
                  .filePath, // '/storage/emulated/0/Download/encrypted.mp4',
              // url: '/storage/emulated/0/Download/unencrypted.mp4',
              aesKey: widget.aesKey, // '85BE62F9AC34D107',
              onViewCreated: _onViewCreated,
              desiredState: currPlayerState, // widget.desiredState,
              // preferredTextLanguage: "en",
              // loop: false,
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (currPlayerState == PlayerState.PLAYING) {
                currPlayerState = PlayerState.PAUSED;
              } else {
                currPlayerState = PlayerState.PLAYING;
              }
              setState(() {});
            },
            child: Text('Play / Pause'))
      ],
    );
  }

  void _onViewCreated(int viewId) {
    listenForVideoPlayerEvents(viewId);
    enableMultiAudioSupport(viewId);
  }

  @override
  void onPlay() {
    // TODO: implement onPlay
    super.onPlay();
  }

  @override
  void onPause() {
    // TODO: implement onPause
    super.onPause();
  }

  @override
  void onComplete() {
    // TODO: implement onComplete
    super.onComplete();
  }

  @override
  void onTime(int position) {
    // TODO: implement onTime
    super.onTime(position);
  }

  @override
  void onSeek(int position, double offset) {
    // TODO: implement onSeek
    super.onSeek(position, offset);
  }

  @override
  void onDuration(int duration) {
    // TODO: implement onDuration
    super.onDuration(duration);
  }

  @override
  void onError(String error) {
    // TODO: implement onError
    super.onError(error);
  }
}
