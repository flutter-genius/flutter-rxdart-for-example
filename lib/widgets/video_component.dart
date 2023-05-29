import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoComponent extends StatefulWidget {
  final bool isView;
  final VideoModel video;
  final Function onClick;
  VideoComponent({this.isView, this.video, this.onClick}); 

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  // ignore: unused_field
  VideoPlayerController _controller;
  ChewieController _chewieController;
  

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.video.url),
      autoInitialize: true,
      looping: true,
      autoPlay: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
      aspectRatio: 9 / 10,
      isLive: false,
      showControlsOnInitialize: true,
      showControls: true,
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
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.isView ? AspectRatio(
                aspectRatio: 9 / 10,
                child: Chewie(
                  controller: _chewieController,
                ),
              ) : AspectRatio(
                aspectRatio: 9 / 10,
                    child: Hero(
                      key: Key(widget.video.id),
                      tag: 'event_hero_${widget.video.id}',
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: widget.video.thumbNail ?? '',
                          placeholder: (context, url) => Container(
                            height: 80,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 24),
              child: Text(
                widget.video.description,
                style: TextStyle(
                    color: BACKGROUND_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ],
        )
      ),
      // onTap: widget.onClick,
    );
  }
}