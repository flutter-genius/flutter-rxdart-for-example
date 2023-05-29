/// !!!!! ----- important for me about the ads ----- !!!!!
/// currently for the ads
/// get the all ads from the database
/// and then will modify the ads in app

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/ads_card.dart';
import 'package:hittapa/widgets/video_card.dart';
import 'package:hittapa/widgets/video_component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/widgets/radar_scan.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
// import 'package:extended_image/extended_image.dart';

class EventGridComponent extends StatefulWidget {
  final Function onClick;

  EventGridComponent({this.onClick});
  @override
  EventGridComponentState createState() => EventGridComponentState();
}

class EventGridComponentState extends State<EventGridComponent> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<dynamic> _list = [];
  List<dynamic> _eventList = [];
  List<AdsModel> _adsLists = [];
  List<VideoModel> _videoLists = [];
  UserModel user;
  bool isLoading = false, isTop = true, isClicked = false, isFechting = false, isVideoScreen = false;
  int _totalEvents = 0;
  FilterModel _filtermodel;
  Map query = {
    'distance': null,
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
  Geoflutterfire geo = Geoflutterfire();
  BuildContext _context;
  GeoLocationModel _geoLocationData = new GeoLocationModel();

  loadEvents(FilterModel filter, bool isrefresh) async {
    if (isFechting)
      return;
    else
      isFechting = true;
    await Future.delayed(Duration(seconds: 3));
    await widget.onClick();
    List<dynamic> _newDocumentList = [];
    List<AdsModel> _currentAdsList = [];
    List<VideoModel> _currentVideoList = [];
    Map _query = query;
    if (filter != null) {
      if (filter.category != null) {
        _query['categoryId'] = filter.category.id.toString();
      } else {
        _query['categoryId'] = null;
      }

      if (filter.gender != null) {
        _query['gender'] = filter.gender;
      } else {
        _query['gender'] = null;
      }

      if (filter.isChildrenEvent != null && filter.isChildrenEvent) {
        _query['categoryId'] = '5faaa4dadceaa674dee0f613';
      }

      if ((filter.isOpenUnLimit ?? false)) {
        _query['isUnLimitActivities'] = true;
      } else {
        _query['isUnLimitActivities'] = null;
      }

      if (filter.fromDate != null) {
        _query['startDT_greater'] = filter.fromDate.toUtc()?.millisecondsSinceEpoch;
        _query['startDT_less'] = filter.fromDate.add(Duration(days: 1)).toUtc()?.millisecondsSinceEpoch;
      } else {
        _query['startDT_greater'] = DateTime.now().toUtc()?.millisecondsSinceEpoch;
        _query['startDT_less'] = null;
      }

      if (filter.language != null) {
        _query['language'] = filter.language;
      } else {
        _query['language'] = null;
      }

      // ignore: null_aware_before_operator
      if (user?.location?.coordinates != null && user.location?.coordinates?.length > 1) {
        if (filter.distance != null) {
          if (filter.location != null) {
            _query['distance'] = [filter.location.coordinates[0], filter.location.coordinates[1], DegreeToKilo * filter.distance];
          } else {
            // _query['distance'] = [user.location.coordinates[0], user.location.coordinates[1], DegreeToKilo*filter.distance];
          }
        } else {
          if (filter.location != null) {
            _query['distance'] = [filter.location.coordinates[0], filter.location.coordinates[1], DegreeToKilo * 50];
          } else {
            // _query['distance'] = [user.location.coordinates[0], user.location.coordinates[1], DegreeToKilo*50];
          }
        }
      }
    }

    if (_eventList.length > 0 && !isrefresh) {
      _query['startAfter'] = _totalEvents;
    } else {
      _query['startAfter'] = 0;
    }

    if (user != null) {
      _query['user_gender'] = enumHelper.enum2str(user.gender).toUpperCase();
      if (user?.birthday?.year != null) {
        _query['user_age'] = DateTime.now().year - user?.birthday?.year;
      } else {
        _query['user_age'] = DateTime.now().year - 0;
      }
    }
    var _result = await NodeService().getEvents(_query);
    if (_result == null || _result['status'] == false || _result['data']['events'] == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isFechting = false;
        });
      }
    } else {
      _result = _result['data'];
      if (_result['events'] != null && _result['events'].length > 0) {
        _newDocumentList = _result['events'];
      }
      // if (_result['ads'] != null && _result['ads'].length > 0) {
      //   if (_result['ads'] != null && _result['ads'].length > 0) {
      //     for (int i = 0; i < _result['ads'].length; i++) {
      //       AdsModel _ads = AdsModel.fromJson(_result['ads'][i]);
      //       _currentAdsList.add(_ads);
      //     }
      //     _currentAdsList.shuffle();

      //     /// array order randomize
      //     _adsLists = _currentAdsList;
      //   }
      // }
      // if (_result['videos'] != null && _result['videos'].length > 0) {
      //   if (_result['videos'] != null && _result['videos'].length > 0) {
      //     for (int i = 0; i < _result['videos'].length; i++) {
      //       VideoModel _video = VideoModel.fromJson(_result['videos'][i]);
      //       _currentVideoList.add(_video);
      //     }
      //     _videoLists = _currentVideoList;
      //   }
      // }
      if (mounted) {
        setState(() {
          if (_newDocumentList.length > 0) {
            _totalEvents = _totalEvents + _newDocumentList.length;
            _newDocumentList.sort((a, b) {
              if (a == null || b == null) return 0;
              return b['createdAtDT'].compareTo(a['createdAtDT']);
            });
            for (var i = 0; i < _newDocumentList.length; i++) {
              _list.add(_newDocumentList[i]);
              if (i % 10 == 0 && _videoLists.length > 0) {
                _list.add('video');
              }
              if (i % 10 == 4 && _adsLists.length > 0) {
                _list.add('ads');
              }
            }
            if (_newDocumentList.length < 5 && _adsLists.length > 0) {
              _list.add('ads');
            }
            _eventList.addAll(_newDocumentList);
          }

          _newDocumentList = [];
          _currentAdsList = [];
          _currentVideoList = [];

          isLoading = false;
          isFechting = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isClicked = false;
    scrollController.addListener(() {
      if (mounted) {
        scrollController.position.isScrollingNotifier.addListener(() {
          Provider.of<IsScroller>(_context, listen: false).isAction = true;
          if (!scrollController.position.isScrollingNotifier.value) {
            Provider.of<IsScroller>(_context, listen: false).isTop = true;
          } else {
            Provider.of<IsScroller>(_context, listen: false).isTop = false;
          }
        });
      }
    });
  }

  // Reload event listener for smart refresher
  void _onRefresh(FilterModel filter) async {
    // monitor network fetch
    if (mounted) {
      setState(() {
        _list = [];
        _eventList = [];
        _adsLists = [];
        _videoLists = [];
        _totalEvents = 0;
        isLoading = true;
      });
    }
    Timer(Duration(seconds: 1), () async {
      await loadEvents(filter, true);
      _refreshController.refreshCompleted();
      try {
        if (_context != null) Provider.of<IsScroller>(_context, listen: false).isTop = true;
      } catch (e) {
        print(e);
      }
    });
  }

  void _onLoading(FilterModel filter) async {
    await loadEvents(filter, false);
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  fixConnect() {
    setState(() {
      isLoading = true;
    });
    loadEvents(_filtermodel, true);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      onInit: (store) {
        user = store.state.user;
        _geoLocationData = store.state.geoLocationData;
        _filtermodel = store.state.eventFilter;
        loadEvents(store.state.eventFilter, true);
      },
      // ignore: non_constant_identifier_names
      onDidChange: (store, StoreConnector) {
        _filtermodel = store.state.eventFilter;
        _onRefresh(
          store.state.eventFilter,
        );
      },
      builder: (context, store) {
        AppState state = store.state;
        if (isLoading)
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - MediaQuery.of(context).size.width / 5 * 4),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.width - 20,
                    child: _geoLocationData == null
                        ? RadarPage()
                        : RadarPage(
                            latitude: _geoLocationData.geoLatitude,
                            longitude: _geoLocationData.geoLongitude,
                          ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Searching for events nearby...',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        if (_list.length < 1) {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/no_event.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            floatingActionButton: AddEventButton(context, state),
          );
        }

        return Scaffold(
          floatingActionButton: AddEventButton(context, state),
          body: Container(
            // margin: EdgeInsets.symmetric(horizontal: 14),
            child: isVideoScreen
                ? videoView(store.state.eventFilter)
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    child: waterfallView(store.state.eventFilter),
                  ),
          ),
        );
      },
    );
  }

  Widget videoView(FilterModel eventFilter) {
    return Container(
      decoration: BoxDecoration(color: BLACK_COLOR),
      child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "HittaPå guide video tips",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: BACKGROUND_COLOR),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isVideoScreen = false;
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/close.svg',
                    width: 25,
                    height: 22,
                    color: BACKGROUND_COLOR,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: InViewNotifierList(
              isInViewPortCondition: (double deltaTop, double deltaBottom, double vpHeight) {
                return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
              },
              itemCount: _videoLists.length,
              builder: (BuildContext context, int index) {
                VideoModel _video = _videoLists[index];
                return InViewNotifierWidget(
                  id: '$index',
                  builder: (context, isInView, child) {
                    return VideoComponent(
                      video: _video,
                      isView: isInView,
                      onClick: () {
                        navigateToVideoPlayScreen(context, _video);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget waterfallView(FilterModel eventFilter) {
    if (_list.isEmpty) return Container();
    return SmartRefresher(
      controller: _refreshController,
      child: WaterfallFlow.builder(
          itemCount: _list.length,
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 10.0,
              lastChildLayoutTypeBuilder: (index) => index == _list.length ? LastChildLayoutType.foot : LastChildLayoutType.none,
              collectGarbage: (List<int> garbages) {
                ///collectGarbage
                garbages.forEach((index) {
                  // EventModel _event = EventModel.fromJson(_list[index]);
                  // final provider = ExtendedNetworkImageProvider(
                  //   _event.imageUrl,
                  // );
                  // provider.evict();
                });
              },
              closeToTrailing: false),
          itemBuilder: (BuildContext context, int index) {
            if (_list.length > index && _list[index] == 'ads') return AdsCard(_adsLists, index);
            if (_list.length > index && _list[index] == 'video') {
              return VideoCard(
                videoIndex: index,
                videoList: _videoLists,
                onClick: () {
                  setState(() {
                    isVideoScreen = true;
                  });
                },
              );
            }

            EventModel _event = EventModel.fromJson(_list[index]);
            Duration _duration = _event.endDT.difference(_event.startDT);
            return GestureDetector(
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
                            _event.imageUrl ?? '',
                        placeholder: (context, url) => Container(
                          height: 80,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _event.description,
                    style: TextStyle(color: NAVIGATION_NORMAL_TEXT_COLOR, fontWeight: FontWeight.w600, fontSize: 13),
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
                        DateFormat('d MMM HH:mm').format(_event.startDT),
                        style: TextStyle(fontSize: 11, color: BORDER_COLOR, fontWeight: FontWeight.w600),
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
                            : _duration.inHours == 0
                                ? '${_duration.inMinutes} mins'
                                : '${_duration.inHours} hrs',
                        style: TextStyle(fontSize: 11, color: BORDER_COLOR, fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              )),
              onTap: () async {
                if (!isClicked) {
                  isClicked = true;
                  var _result = await NodeService().getEventById(_event.id);
                  if (_result != null && _result['data'] != null) {
                    _event = EventModel.fromJson(_result['data']);
                    navigateToDetailScreen(context, _event);
                  }
                  isClicked = false;
                }
              },
            );
          }),
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      onRefresh: () {
        _onRefresh(eventFilter);
      },
      onLoading: () => _onLoading(eventFilter),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
      ),
    );
  }
}
