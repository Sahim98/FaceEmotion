import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  const Video({super.key,this.url});
  final url;
  
  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  YoutubePlayerController? _controller;

  void runPlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url).toString(),
      flags: YoutubePlayerFlags(
          enableCaption: false, isLive: false, autoPlay: false),
    );
  }

  @override
  void initState() {
    runPlayer();
    super.initState();
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller!),
      builder: (context, player) {
        return Scaffold(
          body: player,
        );
      },
    );
  }
}
