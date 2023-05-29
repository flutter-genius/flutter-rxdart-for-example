import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlay extends StatefulWidget {
  final VideoModel currentVideo;
  VideoPlay({this.currentVideo});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(widget.currentVideo.url),
        autoInitialize: true,
        looping: true,
        autoPlay: true,
        allowFullScreen: true,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: NAVIGATION_NORMAL_TEXT_COLOR
              ),
            ),
          );
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset('assets/svg/close.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          SizedBox(
            width: 55,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        )
      ),
    );
  }
}