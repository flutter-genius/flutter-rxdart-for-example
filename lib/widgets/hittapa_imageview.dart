import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:kenburns/kenburns.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//ignore: must_be_immutable
class HittapaImageView extends StatelessWidget {
  final List<String> images;
  final List<File> files;
  final String eventId;
  final String title;
  final UserModel eventOwner;
  final UserModel user;
  final bool isGuest;
  PageController controller = PageController(keepPage: true);

  HittapaImageView({this.images, this.files, this.eventId, this.title, this.eventOwner, this.user, this.isGuest}) {
    if ((files ?? []).length < 1)
      pageSwipe();
  }

  pageSwipe() {
    if (((images ?? []).length + (files ?? []).length) < 2 && !controller.hasClients) {
      return;
    }
    Timer(Duration(seconds: 3), () {
      try {
        if (controller.page < ((images ?? []).length + (files ?? []).length) - 1) {
          controller.jumpToPage(controller.page.toInt() + 1);
          pageSwipe();
        } else {
          controller.jumpToPage(0);
          pageSwipe();
        }
      } catch (e) {
        // print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: Hero(
            key: Key(eventId),
            tag: 'event_hero_$eventId',
            child: PageView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller,
              pageSnapping: true,
              children: <Widget>[
                ...((images ?? []).map((e) {
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomRight:  Radius.circular(isGuest ? 50 : 0)),
                      child: KenBurns(
                      maxScale: 2.0,
                      minAnimationDuration: const Duration(milliseconds: 3000),
                      child: ClipRRect(                        
                        child: CachedNetworkImage(
                        imageUrl: e ?? '',
                        placeholder: (context, url) => Center(
                          child: const Icon(Icons.image),
                        ),
                        errorWidget: (context, url, err) => Center(
                          child: const Icon(Icons.broken_image),
                        ),
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                      ),)
                    ),)
                  );
                }).toList()),
                ...(files ?? []).map((e) {
                  return KenBurns(
                    maxScale: 2.0,
                    minAnimationDuration: const Duration(milliseconds: 3000),
                    child: Image(
                      image: ExactAssetImage(e.path),
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ],
            ),
          )),
          Container(
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withAlpha(128), Colors.transparent])),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 2 / 3,
            child: Container(
              height: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Colors.black.withAlpha(128),
                  Colors.transparent
                ])),
            ),
          ),
          Positioned(
            bottom: isGuest ? 10 : 60,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: (images ?? []).length + (files ?? []).length > 1
                  ? SmoothPageIndicator(
                    controller: controller,
                    count: (images ?? []).length + (files ?? []).length,
                    effect: SlideEffect(
                      dotWidth: (MediaQuery.of(context).size.width - 14) /
                        ((images ?? []).length + (files ?? []).length) - 7,
                      dotHeight: 3,
                      activeDotColor: Colors.white,
                      dotColor: SEPARATOR_COLOR),
                    )
                  : Container(),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: isGuest ? eventOwnerWidgetOnImage(eventOwner, false, false) : Container(),
          ),
        ],
      ),
    );
  }
}
