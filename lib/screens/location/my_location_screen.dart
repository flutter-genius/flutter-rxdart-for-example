import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/screens/location/location_detail_screen.dart';
import 'package:hittapa/services/cloud_firestore_service.dart';
import 'package:hittapa/utils/animations.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/create_location_bottom_button.dart';
import 'package:hittapa/global_export.dart';

import '../../global.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  final ScrollController scrollController = ScrollController();
  bool isLoad = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store.state.user.uid,
        builder: (context, userId) {
          return Scaffold(
            backgroundColor: BACKGROUND_COLOR,
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
                LocaleKeys.location_location.tr(),
                style: TextStyle(
                    color: TITLE_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 21),
              ),
              centerTitle: true,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(FB.LOCATION_COLLECTION).where('ownerId', isEqualTo: userId.toString()).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                List<VenueModel> locations = snap.data.docs.map((e) => VenueModel.fromFB(e)).toList();
                return AnimateIfVisibleWrapper(
                  showItemInterval: Duration(milliseconds: 100),
                  child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    controller: scrollController,
                    itemCount: locations.length,
                    itemBuilder: (BuildContext context, int index) {
                      VenueModel _location = locations[index];
                      return AnimateIfVisible(
                        visibleFraction: 0.0001,
                        reAnimateOnVisibility: true,
                        key: Key('location_item.$index'),
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
                                    margin: EdgeInsets.symmetric(horizontal: 14),
                                    height: 350,
                                    child: ClipRRect(
                                      child: Stack(
                                        children: <Widget>[
                                          Hero(
                                            tag: 'location_hero_${_location.id}',
                                            child: CachedNetworkImage(
                                              width: MediaQuery.of(context).size.width -
                                                  28,
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
                                              width: MediaQuery.of(context).size.width -
                                                  28,
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
                                                              getEventCategoriesString(_location.eventCategories),
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
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color: BORDER_COLOR),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(),
                                                        ),
                                                        Text(
                                                          (_location.point ?? 0.0)
                                                              .toStringAsFixed(1),
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
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
                                                            _location.location.address,
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
                                                          rating: _location.point ?? 0.0,
                                                          itemBuilder:
                                                              (context, index) => Icon(
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
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    )),
                                onTap: () =>
                                    navigateToLocationDetailScreen(context, _location),
                              ),
                            ),
                      );
                    },
//                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 80, top: 20),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: CreateLocationBottomButton(),
          );
        });
  }
}
