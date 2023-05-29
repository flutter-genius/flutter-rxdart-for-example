import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/covid.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/hittapa_imageview.dart';
import 'package:hittapa/widgets/no_internet.dart';
import 'package:kenburns/kenburns.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hittapa/models/models.dart';
import 'package:intl/intl.dart';
import 'package:hittapa/global_export.dart';

class CovidComponent extends StatefulWidget {
  final Function onClick;

  const CovidComponent({Key key, this.onClick}) : super(key: key);
  @override
  _CovidComponentState createState() => _CovidComponentState();
}

class _CovidComponentState extends State<CovidComponent> {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int itemCount = 0;
  List<dynamic> _list = [];
  bool isLoad = false, isInternet = true;

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
    await widget.onClick();
    if (mounted) {
      setState(() {
        isLoad = true;
      });
    }

    _list = [];
    await loadInformations();

    if (mounted) {
      setState(() {
        isLoad = false;
      });
    }
  }

  // load and append locations array
  loadInformations({String userId}) async {
    Map _query = {
      'createdAt_orderby': true,
      'limit': 10,
      'startAfter': 0
    };
    if (_list.length > 0) _query['startAfter'] = _list.length;
    var _result = await NodeService().getCovidInformations(_query);
    if(_result == null) {
      isInternet = false;
    } else {
      isInternet = true;
      if(_result != null && _result['data'] != null){
        _list.addAll(_result['data']);
      }
    }
  }

  // refresh function for smart refresher
  void _onRefresh(String userId) async {
    // monitor network fetch
    _list = [];
    await loadInformations(userId: userId);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // load locations function for smart refresher
  void _onLoading(String userId) async {
    // monitor network fetch
    await loadInformations(userId: userId);
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
          return isInternet ? ModalProgressHUD(
            inAsyncCall: isLoad,
            child:AnimateIfVisibleWrapper(
                showItemInterval: Duration(milliseconds: 100),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 250,
                        decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/workflows/workflow_1.jpeg'),
                            fit: BoxFit.fitWidth)
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8, left: 14, right: 14),
                        child: Text(
                          "Table soccer or chess for fun at the park", 
                          style: TextStyle(
                            color: NAVIGATION_NORMAL_TEXT_COLOR, 
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0, left: 14, right: 14),
                        child: Text(
                        "Let's go and have an awesome cycling trip together in the woods. Everyone is invited, so feel free to join us! You will need, obviously, your bike and some positive energy:). Btw, if you know any special sports in the local forest that we should go to, let me know in the advanced I can plany our trip better!:)", 
                        style: TextStyle(
                          color: NAVIGATION_NORMAL_TEXT_COLOR, 
                          fontSize: 15,
                          fontWeight: FontWeight.w200
                        ),
                      ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8, left: 14, right: 14),
                        child: Text(
                        "Table soccer or chess for fun at the park", 
                        style: TextStyle(
                          color: NAVIGATION_NORMAL_TEXT_COLOR, 
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0, left: 14, right: 14),
                        child: Text(
                        "Let's go and have an awesome cycling trip together in the woods. Everyone is invited, so feel free to join us! You will need, obviously, your bike and some positive energy:). Btw, if you know any special sports in the local forest that we should go to, let me know in the advanced I can plany our trip better!:)", 
                        style: TextStyle(
                          color: NAVIGATION_NORMAL_TEXT_COLOR, 
                          fontSize: 15,
                          fontWeight: FontWeight.w200
                        ),
                      ),
                      ),
                      Container(
                        height: 190,
                          child: ListView.builder(
                          addAutomaticKeepAlives: false,
                          scrollDirection: Axis.horizontal,
                          controller: scrollController,
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            CovidModel _information = CovidModel.fromJson(_list[index]);
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
                                        width: 140,
                                        decoration: BoxDecoration(
                                          color: SEPARATOR2_COLOR,
                                          borderRadius: BorderRadius.all(Radius.circular(12))
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                image: DecorationImage(
                                                  image: NetworkImage(_information.image ?? _information.images[0] ?? ''),
                                                  fit: BoxFit.cover,
                                                )
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                      width: 130,
                                                      child: Text(
                                                        _information.title != null ? _information.title + " part of the description show " : '', 
                                                        style: TextStyle(
                                                          color: NAVIGATION_NORMAL_TEXT_COLOR, 
                                                          fontSize: 14, 
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                          'assets/time_outline.svg',
                                                          width: 14,
                                                          height: 14,
                                                          color: NAVIGATION_NORMAL_TEXT_COLOR,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          DateFormat('HH:mm d MMM')
                                                              .format(_information.publishDate),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: NAVIGATION_NORMAL_TEXT_COLOR,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ),
                                      onTap: () {
                                        navigateToCovidDetailScreen(context, _information);
                                      }

                                    ),
                                  ),
                            );
                          },
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: 5,
                          ),
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0, left: 14, right: 14),
                        child: Text(
                        "Let's go and have an awesome cycling trip together in the woods. Everyone is invited, so feel free to join us! You will need, obviously, your bike and some positive energy:). Btw, if you know any special sports in the local forest that we should go to, let me know in the advanced I can plany our trip better!:) Let's go and have an awesome cycling trip together in the woods. Everyone is invited, so feel free to join us! You will need, obviously, your bike and some positive energy:). Btw, if you know any special sports in the local forest that we should go to, let me know in the advanced I can plany our trip better!:)", 
                        style: TextStyle(
                          color: NAVIGATION_NORMAL_TEXT_COLOR, 
                          fontSize: 15,
                          fontWeight: FontWeight.w200
                        ),
                      ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: BORDER_COLOR
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 0, left: 14, right: 14),
                              child: Text(
                                "Fa den sensst information om Covide-19 fran", 
                                style: TextStyle(
                                  color: BACKGROUND_COLOR, 
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0, left: 14, right: 14),
                              child: Text(
                                "fokk hamsomymdignhertan sefami liskyard", 
                                style: TextStyle(
                                  color: BACKGROUND_COLOR, 
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      
                      // Expanded(child: SmartRefresher(
                      //   controller: _refreshController,
                      //   child: ListView.builder(
                      //     addAutomaticKeepAlives: false,
                      //     controller: scrollController,
                      //     itemCount: _list.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       CovidModel _information = CovidModel.fromJson(_list[index]);
                      //       return AnimateIfVisible(
                      //         visibleFraction: 0.0001,
                      //         reAnimateOnVisibility: true,
                      //         key: Key('location_item.$index'),
                      //         duration: Duration(milliseconds: 350),
                      //         builder: (
                      //             BuildContext context,
                      //             Animation<double> animation,
                      //             ) => FlipTransition(
                      //               alignment: FractionalOffset.center,
                      //               scale: CurvedAnimation(
                      //                 parent: animation,
                      //                 curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                      //               ),
                      //               child: GestureDetector(
                      //                 child: Container(
                      //                     margin: EdgeInsets.symmetric(
                      //                         horizontal: 14, vertical: 10),
                      //                     child: ClipRRect(
                      //                       child: Stack(
                      //                         children: <Widget>[
                      //                           Hero(
                      //                             tag: 'covid_hero_${_information.id}',
                      //                             child:ClipRRect(
                      //                               child: CachedNetworkImage(
                      //                                 imageUrl: _information.image ?? _information.images[0] ?? '',
                      //                                 placeholder: (context, url) => Center(
                      //                                   child: CircularProgressIndicator(),
                      //                                 ),
                      //                                 width: double.infinity,
                      //                                 fit: BoxFit.fill,
                      //                               ),
                      //                               borderRadius:
                      //                               BorderRadius.all(Radius.circular(10)),
                      //                             ),
                      //                           ),
                      //                           Positioned(
                      //                             top: 0,
                      //                             right: 15,
                      //                             child: Container(
                      //                               height: 30,
                      //                               width: 105,
                      //                               decoration: BoxDecoration(
                      //                                 color: GOOGLE_COLOR,
                      //                                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                      //                               ),
                      //                               child: Row(
                      //                                 children: <Widget>[
                      //                                   SizedBox(
                      //                                     width: 5,
                      //                                   ),
                      //                                   SvgPicture.asset(
                      //                                     'assets/time_outline.svg',
                      //                                     width: 14,
                      //                                     height: 16,
                      //                                     color: Colors.white,
                      //                                   ),
                      //                                   SizedBox(
                      //                                     width: 10,
                      //                                   ),
                      //                                   Text(
                      //                                     DateFormat('HH:mm d MMM')
                      //                                         .format(_information.publishDate),
                      //                                     style: TextStyle(
                      //                                         fontSize: 11,
                      //                                         color: Colors.white,
                      //                                         fontWeight: FontWeight.w600),
                      //                                   ),
                      //                                   SizedBox(
                      //                                     width: 5,
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           Positioned(
                      //                             bottom: 20,
                      //                             left: 20,
                      //                             child: Container(
                      //                               width: 200,
                      //                               child: Text(_information.title != null ? _information.title : '', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),),
                      //                             ),
                      //                           )
                      //                         ],
                      //                       ),
                      //                       borderRadius: BorderRadius.all(Radius.circular(20)),
                      //                     )),
                      //                 onTap: () {
                      //                   navigateToCovidDetailScreen(context, _information);
                      //                 }

                      //               ),
                      //             ),
                      //       );
                      //     },
                      //     physics: BouncingScrollPhysics(),
                      //     padding: EdgeInsets.only(
                      //       bottom: 65,
                      //     ),
                      //   ),
                      //   enablePullDown: true,
                      //   enablePullUp: true,
                      //   header: WaterDropHeader(),
                      //   onRefresh: () => _onRefresh(userId.toString()),
                      //   onLoading: () => _onLoading(userId.toString()),
                      // ),)
                    ],
                  ),
                )
            ),
          )
              : NoInternet(onClick: initialGrid);
        });
  }
}
