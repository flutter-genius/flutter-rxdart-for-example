import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/global_export.dart';

class LocationsComponent extends StatefulWidget {
  final Function onClick;
  const LocationsComponent({
    this.onClick,
  });
  @override
  _LocationsComponentState createState() => _LocationsComponentState();
}

class _LocationsComponentState extends State<LocationsComponent> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int itemCount = 0;
  List<dynamic> _list = [];
  bool isLoad = false;

  // reload locations function
  onReload() {
    if (!isLoad) {
      initialGrid();
    }
  }

  @override
  void initState() {
    initialGrid();
    super.initState();
  }

  initialGrid() async {
    if (mounted) {
      setState(() {
        isLoad = true;
      });
    }

    _list = [];
    await loadLocations();

    if (mounted) {
      setState(() {
        isLoad = false;
      });
    }
  }

  // load and append locations array
  loadLocations({String userId}) async {
    await widget.onClick();
    Map _query = {
      'createdAt_orderby': true,
      'limit': 10,
      'startAfter': 0
    };
    if (_list.length > 0) _query['startAfter'] = _list.length;
    var _result = await NodeService().getLocations(_query);
    if(_result != null && _result['data'] != null){
      _list.addAll(_result['data']);
    }
  }

  // refresh function for smart refresher
  void _onRefresh(String userId) async {
    // monitor network fetch
    _list = [];
    await loadLocations(userId: userId);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // load locations function for smart refresher
  void _onLoading(String userId) async {
    // monitor network fetch
    await loadLocations(userId: userId);
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
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.user.uid,
      builder: (context, userId) {
        return ModalProgressHUD(
          inAsyncCall: isLoad,
          child: Container(
            child: AnimateIfVisibleWrapper(
              showItemInterval: Duration(milliseconds: 100),
              child: SmartRefresher(
                controller: _refreshController,
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  controller: scrollController,
    //                crossAxisCount: 4,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    VenueModel _location = VenueModel.fromJson(_list[index]);
                    return AnimateIfVisible(
                      visibleFraction: 0.0001,
                      reAnimateOnVisibility: true,
                      key: Key('location_item.$index'),
                      duration: Duration(milliseconds: 350),
                      builder: (
                        BuildContext context,
                        Animation<double> animation,
                      ) => FlipTransition(
                        alignment: FractionalOffset.center,
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                        ),
                        child: GestureDetector(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              height: 350,
                              child: ClipRRect(
                                child: Stack(
                                  children: <Widget>[
                                    Hero(
                                      tag: 'location_hero_${_location.id}',
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width - 28,
                                        imageUrl:
                                            _location.image ?? '',
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20))),
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width - 28,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  margin: EdgeInsets.all(14),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            _location.logo ?? DEFAULT_AVATAR),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        _location.name,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                NAVIGATION_NORMAL_TEXT_COLOR),
                                                      ),
                                                      Text(
                                                        getEventCategoriesString(
                                                            _location
                                                                .eventCategories),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: BORDER_COLOR),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  LocaleKeys.location_detail_more_info.tr(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: BORDER_COLOR),
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                )
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 18, right: 18, top: 12),
                                              child: Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                      'assets/time_outline.svg'),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    _location.is24Opened
                                                        ? LocaleKeys.create_location_open_all.tr()
                                                        : LocaleKeys.location_detail_open.tr() + ' 23:00',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: BORDER_COLOR),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Text(
                                                    _location?.point?.toStringAsFixed(1) ?? '',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 24,
                                                        color:
                                                            NAVIGATION_NORMAL_TEXT_COLOR),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 18, right: 18, top: 12),
                                              child: Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                      'assets/geopin-outline.svg'),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _location.location?.address ?? '',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: BORDER_COLOR),
                                                    ),
                                                  ),
                                                  RatingBarIndicator(
                                                    rating: _location.point ?? 0,
                                                    itemBuilder: (context, index) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 10.0,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    '(${_location.reviews})',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: BORDER_COLOR,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              )),
                          onTap: () =>
                              navigateToLocationDetailScreen(context, _location),
                        ),
                      ),
                    );
                  },
    //                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: 65,
                  ),
                ),
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
              onRefresh: () => _onRefresh(userId.toString()),
              onLoading: () => _onLoading(userId.toString()),
            ),
          ),
        ),
      );
      });
  }
}
