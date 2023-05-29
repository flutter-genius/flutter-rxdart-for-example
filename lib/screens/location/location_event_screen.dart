import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:intl/intl.dart';
import 'package:hittapa/global_export.dart';

class LocationEventScreen extends StatefulWidget {
  final List<EventModel> events;

  LocationEventScreen({this.events});

  @override
  _LocationEventScreenState createState() => _LocationEventScreenState();
}

class _LocationEventScreenState extends State<LocationEventScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Container(
      child: AnimateIfVisibleWrapper(
        showItemInterval: Duration(milliseconds: 100),
        child: StaggeredGridView.builder(
          addAutomaticKeepAlives: false,
          controller: scrollController,
          itemCount: widget.events.length,
          itemBuilder: (BuildContext context, int index) {
            EventModel _event = widget.events[index];
            Duration _duration = _event.endDT.difference(_event.startDT);

            return AnimateIfVisible(
              visibleFraction: 0.0001,
              reAnimateOnVisibility: true,
              key: Key('item.$index'),
              duration: Duration(milliseconds: 350),
              builder: (
                  BuildContext context,
                  Animation<double> animation,
                  ) =>
                  FlipTransition(
                    alignment: FractionalOffset.center,
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                    ),
                    child: GestureDetector(
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 14,
                              ),
                              Hero(
                                tag: 'event_hero_${_event.id}',
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    _event.thumbnail ?? '',
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                _event.description,
                                style: TextStyle(
                                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                                maxLines: 2,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/calendar-outline.svg',
                                    width: 14,
                                    height: 16,
                                    color: BORDER_COLOR,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    DateFormat('d MMM, HH:mm')
                                        .format(_event.startDT),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: BORDER_COLOR,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/time_outline.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    //'_duration.inDays > 0 ? (_duration.inDays.toString() + ' days, ') : ''}${_duration.inHours - 24 * _duration.inDays} hrs',
                                    _event.isFlexibleEndTime
                                        ? LocaleKeys.event_we_decide.tr()
                                        : '${_duration.inHours} hrs',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: BORDER_COLOR,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          )),
                      onTap: () => navigateToDetailScreen(context, _event),
                    ),
                  ),
            );
          },
          //                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),

          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 65),
          gridDelegate:
          SliverStaggeredGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 14.0,
              crossAxisSpacing: 14.0,
              crossAxisCount: 4,
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(2),
              staggeredTileCount: widget.events.length),
        ),
      ),
    );
  }
}
