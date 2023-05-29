import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../global.dart';
import 'package:hittapa/global_export.dart';

class SearchByLocationResultScreen extends StatefulWidget {
  final double lat;
  final double lng;

  SearchByLocationResultScreen({this.lat, this.lng});

  @override
  _SearchByLocationResultScreenState createState() =>
      _SearchByLocationResultScreenState();
}

class _SearchByLocationResultScreenState
    extends State<SearchByLocationResultScreen> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<dynamic> _list = [];
  bool isLoad = false;
  Map query = {
    'distance' : null,
    'startDT_greater': DateTime.now().toUtc()?.millisecondsSinceEpoch,
    'startDT_less': null,
    'orderBy_startDT': false,
    'orderBy_createdAtDT': true,
    'limit': 100,
    'categoryId': null,
    'gender': null,
    'isUnLimitActivities': null,
    'language': null,
    'startAfter': 0,
    'ads_gender': null,
    'ads_age': 0,
    'ads_startAfter': 0,
    'ads_limit': 1,
  };


  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  loadEvents() async {
    print('@@@@@ get events from sever');    
    Map _query = query;

    _query['distance'] = [widget.lat, widget.lng, DegreeToKilo*50];


    var _result = await NodeService().getEvents(_query);
    if(_result == null) {
      if(mounted) {
        setState(() {
        isLoad = false;
      });
      }
    } else {
      if(_result!= null && _result['data']!=null){
        _list = _result['data'];
      }
      if (mounted) {
        setState(() {

          _list.sort((a, b) {
              if (a == null || b == null) return 0;
              return b['createdAtDT'].compareTo(a['createdAtDT']);
            });
          isLoad = false;
        });
      }
    }
  }

  // Reload event listener for smart refresher
  void _onRefresh() async {
    // monitor network fetch
    _list = [];
    await loadEvents();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // load event listener for smart refresher
  void _onLoading() async {
    // monitor network fetch
    await loadEvents();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrow-back.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.event_search_result.tr(),
          style: TextStyle(
              color: TITLE_TEXT_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: AnimateIfVisibleWrapper(
          showItemInterval: Duration(milliseconds: 100),
          child: SmartRefresher(
            controller: _refreshController,
            child: StaggeredGridView.builder(
              addAutomaticKeepAlives: false,
              controller: scrollController,
//                crossAxisCount: 4,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                EventModel _event = EventModel.fromJson(_list[index]);
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
                      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
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
                                key: Key(_event.id),
                                tag: 'event_hero_${_event.id}',
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: //_event.thumbnail ??
                                        _event.imageUrl ??
                                        '',
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    width: double.infinity,
                                    fit: BoxFit.fill,
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
                      onTap: () async{
                        var _result = await NodeService().getEventById(_event.id);
                        if(_result != null && _result['data']!= null){
                          _event = EventModel.fromJson(_result['data']);
                          navigateToDetailScreen(context, _event);
                        }
                      },
                    ),
                  ),
                );
              },
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 65),
              gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 14.0,
                  crossAxisSpacing: 14.0,
                  crossAxisCount: 4,
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  staggeredTileCount: _list.length),
            ),
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
          ),
        ),
      ),
    );
  }
}
