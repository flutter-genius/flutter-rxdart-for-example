import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:provider/provider.dart';
import 'package:hittapa/global_export.dart';

class PassedComponent extends StatefulWidget {
  final Function onClick;

  const PassedComponent({Key key, this.onClick}) : super(key: key);
  @override
  _PassedComponentState createState() => _PassedComponentState();
}

class _PassedComponentState extends State<PassedComponent> {
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;
  var _activities = [];
  String _userId;

  // ScrollController scrollController;
  // ignore: non_constant_identifier_names
  double device_height;
  bool isTop = true;

  _loadData() async{
    await widget.onClick();
    Map _data = {
      'id': _userId,
      'startDT': DateTime.now().toUtc()?.millisecondsSinceEpoch
    };
    var _result = await NodeService().getPastEventsAccepted(_data);
    if(_result != null && _result['data']!=null){
      _sortData(_result['data']);
    }

    _result = await NodeService().getPastEventsByUser(_data);
    if(_result != null && _result['data']!=null){
      _sortData(_result['data']);
    }
  }

  _sortData(events) async {
    events.forEach((e) {
      EventModel _event = EventModel.fromJson(e);
      int _index = _activities.indexWhere((element) => element.id == _event.id);
      if (_index < 0) _activities.add(_event);
      else _activities[_index] = _event;
    });
    if (mounted) setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    device_height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) {
            _userId = store.state.user.uid;
            _loadData();
        },
        builder: (context,store) {
          AppState state = store.state;
          return NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                  Provider.of<IsScroller>(context, listen: false).isTop = false;
                } else if (scrollNotification is ScrollUpdateNotification) {
                  Provider.of<IsScroller>(context, listen: false).isTop = false;
                } else if (scrollNotification is ScrollEndNotification) {
                  Provider.of<IsScroller>(context, listen: false).isTop = true;
                }
            },
            child: Scaffold(
            floatingActionButton: AddEventButton(context, state),
            body: ModalProgressHUD(
              child: Builder(builder: (context) {
                if (_activities.length < 1) {
                  return Center(child: Text(LocaleKeys.activites_no_activites.tr(),));
                }
                _activities.sort((a, b) => b.startDT.toUtc()?.millisecondsSinceEpoch
                    ?.compareTo(a.startDT.toUtc()?.millisecondsSinceEpoch));
                var _list = groupBy(_activities, (obj) => (obj as EventModel).startDT.month);
                return NotificationListener<ScrollNotification>(
                  // ignore: missing_return
                  onNotification: (e){
                    // print("opopopopopopopo");
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 65),
                    itemCount: _list.values.length,
                    itemBuilder: (context, index) {
                      final monthName = getMonthName(_list.keys.toList()[index]);
                      return Container(
                        height: 210,
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 32,
                                  ),
                                  Text(
                                    monthName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: TITLE_TEXT_COLOR),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 190,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: const Color(0xFF696969),
                                        spreadRadius: -5,
                                        blurRadius: 14,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: _list.values.toList()[index].map<Widget>((f) {
                                      return GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 15, right: 7, left: 7),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius
                                                        .circular(16)),
                                                    image: DecorationImage(
                                                        image:
                                                        CachedNetworkImageProvider(
                                                            f.imageUrl ?? f.imageUrls[0] ?? ''),
                                                        fit: BoxFit.cover)),
                                                width: 90,
                                                height: 120,
                                                child: Container(
                                                  alignment: Alignment.topRight,
                                                  height: 20,
                                                  child: Padding(
                                                  child: generateLabel(
                                                      f.statusType(_userId)),
                                                    padding:
                                                    EdgeInsets.only(top: 0),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            16)),
                                                    gradient: LinearGradient(
                                                      begin:
                                                      Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.transparent
                                                      ],
                                                      tileMode:
                                                      TileMode.repeated,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      DateFormat('MM.dd, HH:mm')
                                                          .format(f.startDT),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: BORDER_COLOR,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                      textAlign: TextAlign.center,
                                                      softWrap: true,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          var _event = new EventModel();
                                          var _result = await NodeService().getEventById(f.id);
                                          if(_result != null && _result['data'] != null){
                                            _event = EventModel.fromJson(_result['data']);
                                          }
                                          navigateToDetailScreen(context,  _event);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                )
              ); }),
              inAsyncCall: _isLoading,
            ),
          )
          );
        });
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
      case ApplicantStatusType.past:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LocaleKeys.activites_pending.tr(),
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
                  left: 3,
                  child: SvgPicture.asset('assets/svg/pending.svg', width: 13, height: 13,),
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
