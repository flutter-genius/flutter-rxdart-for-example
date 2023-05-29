import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import '../../global.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:hittapa/global_export.dart';

class OldComponent extends StatefulWidget {
  final Function onClick;

  const OldComponent({Key key, this.onClick}) : super(key: key);
  @override
  _OldComponentState createState() => _OldComponentState();
}

class _OldComponentState extends State<OldComponent> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int itemCount = 0;
  List<dynamic> _list = [];
  bool isLoad = true;
  String _userId;

  // ignore: non_constant_identifier_names
  double device_height;
  bool isTop = true;

  @override
  void initState() {
    Provider.of<IsScroller>(context, listen: false).isTop = true;
   
    super.initState();

    scrollController.addListener(() {
      if(mounted) {
        scrollController.position.isScrollingNotifier.addListener(() { 
        if(!scrollController.position.isScrollingNotifier.value) {
          Provider.of<IsScroller>(context, listen: false).isTop = true;
        } else {
          Provider.of<IsScroller>(context, listen: false).isTop = false;
        }
      });
      }
    });

    

     loadEvents();
  }

  loadEvents() async {
    // ignore: unnecessary_statements
    await widget.onClick();
    List<dynamic> newDocumentList = [];
    Map _query = {
      'startDT': DateTime.now().toUtc()?.millisecondsSinceEpoch,
      'orderby_startDT' : true,
      'startAfter' : 0,
      'limit': 100
    };
    if (_list.length > 0)
      _query['startAfter'] = _list.length;
    var _result = await NodeService().pastEvents(_query);
    if(_result!= null && _result['data'] != null)
      newDocumentList = _result['data'];
    if(mounted) {
      setState(() {
      isLoad = false;
      _list.addAll(newDocumentList);
    });
    }
  }

  // Reload event listener for smart refresher
  void _onRefresh() async {
    // monitor network fetch
    _list = [];
    await loadEvents();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    Provider.of<IsScroller>(context, listen: false).isTop = false;
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
    device_height = MediaQuery.of(context).size.height;
    if (isLoad) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_list.length < 1) {
      return Container(
        child: Image.asset(
          'assets/no_event.jpeg',
          fit: BoxFit.cover,
        ),
      );
    }
      
      return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) {
          _userId = store.state.user.uid;
        },
        builder: (context, store){
          AppState state = store.state;
          return Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: AnimateIfVisibleWrapper(
                showItemInterval: Duration(milliseconds: 100),
                child: SmartRefresher(
                  controller: _refreshController,
                  child: waterfallWidget(),
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                ),
              ),
            ),
            floatingActionButton: AddEventButton(context, state),
          );
        },
      );
  }

  Widget waterfallWidget() {
    return  WaterfallFlow.builder(
        itemCount: _list.length,
        controller: scrollController,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),

        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 10.0,
          lastChildLayoutTypeBuilder: (index) => index == _list.length
              ? LastChildLayoutType.foot
              : LastChildLayoutType.none,
        ),
        itemBuilder:(BuildContext context, int index) {
          EventModel _event = EventModel.fromJson(_list[index]);
          Duration _duration = _event.endDT.difference(_event.startDT);
          print(_event.id);
          return AnimateIfVisible(
            visibleFraction: 0.0001,
            reAnimateOnVisibility: true,
            key: Key('item.$index'),
            duration: Duration(milliseconds: 350),
            builder: (context, animation) => FlipTransition(
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
                          Stack(
                            children: [
                              Hero(
                                key: Key(_event.id),
                                tag: 'event_hero_${_event.id}',
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: _event.imageUrl ?? _event.imageUrls[0] ?? '',
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
                              Positioned(
                                top: 0,
                                right: 20,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  height: 20,
                                  child: Padding(
                                    child: generateLabel(
                                        _event.statusType(_userId)),
                                    padding: EdgeInsets.only(top: 0),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(16)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                      tileMode:
                                      TileMode.repeated,
                                    ),
                                  ),
                                ),
                              )
                            ],
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
                                //_duration.inDays > 0 ? (_duration.inDays.toString() + ' days, ') : ''}${_duration.inHours - 24 * _duration.inDays} hrs',
                                _event.isFlexibleEndTime
                                    ? LocaleKeys.event_we_decide.tr()
                                    : _duration.inHours == 0 ? '${_duration.inMinutes} mins' : '${_duration.inHours} hrs',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: BORDER_COLOR,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      )),
                  onTap: () async {
                    var _result = await NodeService().getEventById(_event.id);
                    if(_result != null && _result['data'] != null){
                      _event = EventModel.fromJson(_result['data']);
                    }
                    navigateToDetailScreen(context,  _event);
                  }
              ),
            ),
          );
        }
    );
  }

  Widget smartWidget() {
    return StaggeredGridView.builder(
      addAutomaticKeepAlives: false,
      controller: scrollController,
      //                crossAxisCount: 4,
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        EventModel _event = EventModel.fromJson(_list[index]);
        Duration _duration = _event.endDT.difference(_event.startDT);
        print(_event.id);
        return AnimateIfVisible(
          visibleFraction: 0.0001,
          reAnimateOnVisibility: true,
          key: Key('item.$index'),
          duration: Duration(milliseconds: 350),
          builder: (context, animation) => FlipTransition(
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
                        Stack(
                          children: [
                            Hero(
                              key: Key(_event.id),
                              tag: 'event_hero_${_event.id}',
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: _event.imageUrl ?? _event.imageUrls[0] ?? '',
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
                            Positioned(
                              top: 0,
                              right: 20,
                              child: Container(
                                alignment: Alignment.topRight,
                                height: 20,
                                child: Padding(
                                  child: generateLabel(
                                      _event.statusType(_userId)),
                                  padding: EdgeInsets.only(top: 0),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(16)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.transparent
                                    ],
                                    tileMode:
                                    TileMode.repeated,
                                  ),
                                ),
                              ),
                            )
                          ],
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
                onTap: () async {
                  var _result = await NodeService().getEventById(_event.id);
                  if(_result != null && _result['data'] != null){
                    _event = EventModel.fromJson(_result['data']);
                  }
                  navigateToDetailScreen(context,  _event);
                }
            ),
          ),
        );
      },

      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 65),
      gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 14.0,
          crossAxisSpacing: 14.0,
          crossAxisCount: 4,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          staggeredTileCount: _list.length),
    );
  }

  // get event status label
  Widget generateLabel(ApplicantStatusType type) {
    switch (type) {
      case ApplicantStatusType.pastMy:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LocaleKeys.activites_mine.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 3,
            ),
            Stack(
              children: [
                SvgPicture.asset('assets/svg/tapped.svg', width: 20, height: 22,),
                Positioned(
                  top: 4,
                  left: 2,
                  child: SvgPicture.asset('assets/svg/mine.svg', width: 13, height: 13,),
                )
              ],
            ),
          ],
        );
      case ApplicantStatusType.pastAttendees:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LocaleKeys.activites_joined.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 3,
            ),
            Stack(
              children: [
                SvgPicture.asset('assets/svg/tapped.svg', width: 20, height: 22,),
                Positioned(
                  top: 5,
                  left: 4,
                  child: SvgPicture.asset('assets/svg/joined.svg', width: 13, height: 10,),
                )
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
