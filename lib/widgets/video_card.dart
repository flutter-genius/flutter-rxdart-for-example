import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/models/models.dart';

class VideoCard extends StatefulWidget {
  final int videoIndex;
  final List<VideoModel> videoList;
  final Function onClick;
  VideoCard({this.videoIndex, this.videoList, this.onClick}); 

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  int mainLength;
  VideoModel _currentVideo;

  @override
  void initState() {
    super.initState();
    mainLength = widget.videoIndex~/11;
    _currentVideo = widget.videoList[mainLength%widget.videoList.length];
  }

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        margin: EdgeInsets.only(top: 14),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: <Widget>[
              Hero(
                key: Key(widget.videoIndex.toString()),
                tag: 'event_hero_${widget.videoIndex.toString()}',
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: //_event.thumbnail ??
                        _currentVideo.thumbNail ??
                        '',
                    placeholder: (context, url) => Container(
                      height: 80,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                    ),
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                ),
                child: Center(
                  child: Text('Video', style: TextStyle(fontSize: 12),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}