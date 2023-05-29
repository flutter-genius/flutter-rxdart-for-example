import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:hittapa/global_export.dart';

class CategoryScreen extends StatefulWidget {
  final VenueModel venue;
  final AppState appstate;

  CategoryScreen({this.venue, this.appstate});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _tooltip = false, _isShowWarning = false, isAdminEvent;
  ScrollController _listViewController = new ScrollController(initialScrollOffset: 0);
  List<ScrollController> _categoriesControllers = [];
  List<double> _beforePositionLists = [];
  int _currentIndex = 100;
  var _categories;
  var _recents;
  UserModel _user;

  @override
  void initState() {
    var state = widget.appstate;
    _categories = state.eventCategories;
    _recents = state.user.recentSubcategories ?? [];
    if (_recents.length > 0) {
      ScrollController _scrollController = new ScrollController(initialScrollOffset: 0);
      _scrollController.addListener(_scrollListener);
      _categoriesControllers.add(_scrollController);
      _beforePositionLists.add(0);
    }
    for (int i = 0; i < _categories.length; i++) {
      ScrollController _scrollController = new ScrollController(initialScrollOffset: 0);
      _scrollController.addListener(_scrollListener);
      _categoriesControllers.add(_scrollController);
      _beforePositionLists.add(0);
    }
    super.initState();
    Timer(Duration(milliseconds: 200), _showDialog);
  }

  changeEventType(value) {
    print(value);
    isAdminEvent = value;
  }

  _showDialog() async {
    await showDialog(
        context: globalContext,
        useSafeArea: false,
        builder: (context) => ConfirmDialog(
            title: Container(
              width: 200,
              height: 180,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: SvgPicture.asset(
                    'assets/restrict.svg',
                    fit: BoxFit.cover,
                  )),
                ],
              ),
            ),
            firstButton: HittapaRoundGradientButton(
              text: "I AGREE CONTINUE",
              onClick: () {
                Navigator.of(context).pop();
                setState(() {
                  _isShowWarning = true;
                });
                if (_user?.userRole == 1) {
                  _showAdminDialog();
                }
              },
              startColor: LIGHTBLUE_BUTTON_COLOR,
              endColor: LIGHTBLUE_BUTTON_COLOR,
            ),
            icon: Container(),
            yourWidget: Column(
              children: <Widget>[
                Text(
                  LocaleKeys.create_event_covid_restrictions.tr(),
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: BACKGROUND_COLOR),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: Text(
                    'Due to the spread of the COVID 19 we kindly recoment the practicing of physical distancing, this means we keep' + 'a distance of at leat 1m from each other.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: BACKGROUND_COLOR),
                  ),
                ),
                SizedBox(height: 30),
              ],
            )));
  }

  _showAdminDialog() async {
    await showDialog(
        context: globalContext,
        useSafeArea: false,
        builder: (context) {
          int _selectedIndex = 0;
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                body: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Post your event as",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: BACKGROUND_COLOR,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(70)),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: GRAY_COLOR,
                                                      blurRadius: 0.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(70)),
                                                    child: Container(
                                                      child: CachedNetworkImage(
                                                        width: 70,
                                                        height: 70,
                                                        imageUrl: _user?.avatar ?? DEFAULT_AVATAR,
                                                        placeholder: (context, url) => Center(
                                                          child: SvgPicture.asset(
                                                            'assets/avatar_placeholder.svg',
                                                            width: 70,
                                                            height: 70,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, err) => Center(
                                                          child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: SvgPicture.asset('assets/svg/hittapa-admin-mark.svg'),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            changeEventType(true);
                                            setState(() {
                                              _selectedIndex = 1;
                                            });
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 70,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: BACKGROUND_COLOR),
                                                    child: Container(
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: _selectedIndex == 1 ? CHECKED_COLOR : BACKGROUND_COLOR),
                                                    ),
                                                  ),
                                                  Text('Admin', style: TextStyle(color: BACKGROUND_COLOR)),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(70)),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: GRAY_COLOR,
                                                      blurRadius: 0.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(70)),
                                                    child: Container(
                                                      child: CachedNetworkImage(
                                                        width: 70,
                                                        height: 70,
                                                        imageUrl: _user?.avatar ?? DEFAULT_AVATAR,
                                                        placeholder: (context, url) => Center(
                                                          child: SvgPicture.asset(
                                                            'assets/avatar_placeholder.svg',
                                                            width: 70,
                                                            height: 70,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, err) => Center(
                                                          child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: SvgPicture.asset('assets/safe_icon.svg'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            changeEventType(false);
                                            setState(() {
                                              _selectedIndex = 2;
                                            });
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 70,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: BACKGROUND_COLOR),
                                                    child: Container(
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: _selectedIndex == 2 ? CHECKED_COLOR : BACKGROUND_COLOR),
                                                    ),
                                                  ),
                                                  Text('User', style: TextStyle(color: BACKGROUND_COLOR)),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: Text(
                                'Due to the spread of the COVID 19 we kindly recoment the practicing of physical distancing, this means we keep' + 'a distance of at leat 1m from each other.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: BACKGROUND_COLOR),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        )),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HittapaRoundGradientButton(
                              text: "CONTINUE",
                              onClick: () {
                                if (_selectedIndex != 0) Navigator.of(context).pop();
                              },
                              startColor: _selectedIndex == 0 ? SHADOW_COLOR : LIGHTBLUE_BUTTON_COLOR,
                              endColor: _selectedIndex == 0 ? SHADOW_COLOR : LIGHTBLUE_BUTTON_COLOR,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _scrollListener() {
    for (int i = 0; i < _categories.length; i++) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        var _d = _listViewController.position.pixels;
        if (_categoriesControllers[i].hasClients) {
          if (_categoriesControllers[i].position.pixels > _beforePositionLists[i]) {
            _currentIndex = i;
          }
          if (_categoriesControllers[i].position.atEdge) {
            if (_categoriesControllers[i].hasClients && _categoriesControllers[i].position.pixels != 0) {
              // _categoriesControllers[i].animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
              // if (_d < MediaQuery.of(context).size.height) {
              //   _listViewController.animateTo(_d + 250, duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
              // }
            }
          }
          if (_categoriesControllers[i].position.pixels > 0 && _categoriesControllers[i].position.pixels == _beforePositionLists[i] && i != _currentIndex) {
            _categoriesControllers[i].animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
            _beforePositionLists[i] = 1000;
          } else {
            _beforePositionLists[i] = _categoriesControllers[i].position.pixels;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/arrow-back.svg'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
          actions: <Widget>[],
          backgroundColor: Colors.white,
          title: SimpleTooltip(
            minWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            borderColor: BORDER_COLOR,
            hideOnTooltipTap: true,
            child: Text(
              LocaleKeys.create_event_select_category.tr(),
              style: TextStyle(color: TITLE_TEXT_COLOR, fontWeight: FontWeight.w600, fontSize: 21),
            ),
            show: _tooltip,
            tooltipDirection: TooltipDirection.down,
            content: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.create_event_select_category.tr(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    LocaleKeys.create_event_number.tr(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                    ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.'
                    ' Ut mattis mauris ut sodales aliquet. Lorem ipsum dolor sit amet, '
                    'consectetur adipiscing elit. Integer odio metus, iaculis ut ornare'
                    ' vitae, auctor vel urna. Ut mattis mauris ut sodales aliquet.Lorem'
                    ' ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Integer odio metus, iaculis ut ornare vitae, auctor vel urna.'
                    ' Ut mattis mauris ut sodales aliquet.Lorem ipsum dolor sit amet,'
                    ' consectetur adipiscing elit. Integer odio metus, i'
                    'aculis ut ornare vitae, auctor vel urna. Ut mattis mauris ut'
                    ' sodales aliquet.Lorem ipsum dolor sit amet, consectetur '
                    'adipiscing elit. Integer odio metus, iaculis ut ornare vitae,'
                    ' auctor vel urna. Ut mattis mauris ut sodales aliquet.',
                    style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),
                  )
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: StoreConnector<AppState, dynamic>(
            converter: (store) => store,
            builder: (context, store) {
              AppState state = store.state;
              Function dispatch = store.dispatch;
              var categories = state.eventCategories;
              var recents = state.user.recentSubcategories ?? [];
              _user = state.user;
              return Container(
                  margin: EdgeInsets.only(top: 25),
                  child: ListView.builder(
                      controller: _listViewController,
                      itemCount: recents.length > 0 ? 1 + (categories ?? []).length : (categories ?? []).length,
                      itemBuilder: (context, index) {
                        if (recents.length > 0 && index == 0) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 32,
                                  ),
                                  Row(children: [Text('Recents', style: TextStyle(color: DART_TEXT_COLOR, fontSize: 16)), SizedBox(width: 10), SvgPicture.asset('assets/time_outline.svg')])
                                ]),
                                Container(
                                    child: SingleChildScrollView(
                                        controller: _categoriesControllers[index],
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7),
                                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: recents
                                                  .map((subcategory) => GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 15, right: 7, left: 7, bottom: 15),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ClipRRect(
                                                              child: Container(
                                                                width: 90,
                                                                height: 120,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned.fill(
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: subcategory.thumbnail ?? '',
                                                                        placeholder: (context, url) => Icon(Icons.image),
                                                                        errorWidget: (context, url, err) => Icon(Icons.error),
                                                                        fit: BoxFit.cover,
                                                                        width: 90,
                                                                        height: 120,
                                                                      ),
                                                                    ),
                                                                    ((subcategory.isSuspended ?? false) || (subcategory.isRestrict ?? false))
                                                                        ? Positioned.fill(
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                              child: Container(color: Colors.black.withOpacity(0)),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    ((subcategory.isSuspended ?? false) || (subcategory.isRestrict ?? false))
                                                                        ? Positioned.fill(
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.block,
                                                                                size: 50,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container()
                                                                  ],
                                                                ),
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(16)),
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets.only(top: 10),
                                                                width: 90,
                                                                child: Center(
                                                                  child: Text(
                                                                    subcategory.name,
                                                                    style: TextStyle(fontSize: 13, color: BORDER_COLOR, fontWeight: FontWeight.w600),
                                                                    textAlign: TextAlign.center,
                                                                    softWrap: true,
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        if (subcategory.isRestrict || subcategory.isSuspended) {
                                                          await showDialog(
                                                              context: context,
                                                              useSafeArea: false,
                                                              builder: (context) => ConfirmDialog(
                                                                  title: Container(
                                                                    width: 200,
                                                                    height: 180,
                                                                    clipBehavior: Clip.antiAlias,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                    child: Stack(
                                                                      children: <Widget>[
                                                                        Positioned.fill(
                                                                            child: (subcategory?.isSuspended ?? false)
                                                                                ? CachedNetworkImage(
                                                                                    imageUrl: subcategory?.thumbnail ?? '',
                                                                                    errorWidget: (context, msg, err) => Container(
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    'assets/restrict.svg',
                                                                                    fit: BoxFit.cover,
                                                                                  )),
                                                                        // (subcategory?.isSuspended ?? false) ? Positioned.fill(
                                                                        //   child:
                                                                        //   BackdropFilter(
                                                                        //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                        //     child: Container(color: Colors.black.withOpacity(0)),
                                                                        //   ),
                                                                        // ) : Container(),
                                                                        (subcategory?.isSuspended ?? false)
                                                                            ? Positioned.fill(
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.block,
                                                                                    size: 65,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  firstButton: (subcategory?.isSuspended ?? false)
                                                                      ? HittapaRoundGradientButton(
                                                                          text: "I GOT IT",
                                                                          onClick: () => Navigator.of(context).pop(),
                                                                          startColor: LIGHTBLUE_BUTTON_COLOR,
                                                                          endColor: LIGHTBLUE_BUTTON_COLOR,
                                                                        )
                                                                      : HittapaRoundGradientButton(
                                                                          text: "I AGREE CONTINUE",
                                                                          onClick: () {
                                                                            EventCategoryModel category = categories.firstWhere((element) => element.id == subcategory.categoryId);
                                                                            dispatch(createNewEvent(venue: widget.venue, category: category, subcategory: subcategory, isAdminEvent: isAdminEvent));
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(Routes.NEW_EVENT);
                                                                          },
                                                                          startColor: LIGHTBLUE_BUTTON_COLOR,
                                                                          endColor: LIGHTBLUE_BUTTON_COLOR,
                                                                        ),
                                                                  icon: Container(),
                                                                  yourWidget: Column(
                                                                    children: <Widget>[
                                                                      Text(
                                                                        LocaleKeys.create_event_covid_restrictions.tr(),
                                                                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: BACKGROUND_COLOR),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(top: 18),
                                                                        child: Text(
                                                                          'Due to the spread of the COVID 19 we kindly recoment the practicing of physical distancing, this means we keep' +
                                                                              'a distance of at leat 1m from each other.',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: 18, color: BACKGROUND_COLOR),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 30),
                                                                    ],
                                                                  )));
                                                          // navigateToCovidRestrictionScreen(context, subcategory: subcategory, router: Routes.NEW_EVENT);
                                                        } else {
                                                          EventCategoryModel category = categories.firstWhere((element) => element.id == subcategory.categoryId);
                                                          dispatch(createNewEvent(venue: widget.venue, category: category, subcategory: subcategory, isAdminEvent: isAdminEvent));
                                                          Navigator.of(context).pushNamed(Routes.NEW_EVENT);
                                                          // navigateToSubCategoryConfirmScreen(context, subcategory: subcategory, router: Routes.NEW_EVENT);
                                                        }
                                                      }))
                                                  .toList(),
                                            ))))
                              ]));
                        } else {
                          EventCategoryModel category = recents.length > 0 ? categories[index - 1] : categories[index];
                          return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 32,
                                  ),
                                  Text(category.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: TITLE_TEXT_COLOR))
                                ]),
                                Container(
                                    child: SingleChildScrollView(
                                        controller: _categoriesControllers[index],
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7),
                                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: category.subcategories
                                                  .map((subcategory) => GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 15, right: 7, left: 7, bottom: 15),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ClipRRect(
                                                              child: Container(
                                                                width: 90,
                                                                height: 120,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned.fill(
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: subcategory.thumbnail ?? '',
                                                                        placeholder: (context, url) => Icon(Icons.image),
                                                                        errorWidget: (context, url, err) => Icon(Icons.error),
                                                                        fit: BoxFit.cover,
                                                                        width: 90,
                                                                        height: 120,
                                                                      ),
                                                                    ),
                                                                    ((subcategory.isSuspended ?? false) || (subcategory.isRestrict ?? false))
                                                                        ? Positioned.fill(
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                              child: Container(color: Colors.black.withOpacity(0)),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    ((subcategory.isSuspended ?? false) || (subcategory.isRestrict ?? false))
                                                                        ? Positioned.fill(
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.block,
                                                                                size: 50,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container()
                                                                  ],
                                                                ),
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(16)),
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets.only(top: 10),
                                                                width: 90,
                                                                child: Center(
                                                                  child: Text(
                                                                    subcategory.name,
                                                                    style: TextStyle(fontSize: 13, color: BORDER_COLOR, fontWeight: FontWeight.w600),
                                                                    textAlign: TextAlign.center,
                                                                    softWrap: true,
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        if (subcategory.isRestrict || subcategory.isSuspended) {
                                                          // navigateToCovidRestrictionScreen(context, subcategory: subcategory, router: Routes.NEW_EVENT);
                                                          await showDialog(
                                                              context: context,
                                                              useSafeArea: false,
                                                              builder: (context) => ConfirmDialog(
                                                                  title: Container(
                                                                    width: 200,
                                                                    height: 180,
                                                                    clipBehavior: Clip.antiAlias,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                    child: Stack(
                                                                      children: <Widget>[
                                                                        Positioned.fill(
                                                                            child: (subcategory?.isSuspended ?? false)
                                                                                ? CachedNetworkImage(
                                                                                    imageUrl: subcategory?.thumbnail ?? '',
                                                                                    errorWidget: (context, msg, err) => Container(
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    'assets/restrict.svg',
                                                                                    fit: BoxFit.cover,
                                                                                  )),
                                                                        // (subcategory?.isSuspended ?? false) ? Positioned.fill(
                                                                        //   child:
                                                                        //   BackdropFilter(
                                                                        //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                                        //     child: Container(color: Colors.black.withOpacity(0)),
                                                                        //   ),
                                                                        // ) : Container(),
                                                                        (subcategory?.isSuspended ?? false)
                                                                            ? Positioned.fill(
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.block,
                                                                                    size: 65,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  firstButton: (subcategory?.isSuspended ?? false)
                                                                      ? HittapaRoundGradientButton(
                                                                          text: "I GOT IT",
                                                                          onClick: () => Navigator.of(context).pop(),
                                                                          startColor: LIGHTBLUE_BUTTON_COLOR,
                                                                          endColor: LIGHTBLUE_BUTTON_COLOR,
                                                                        )
                                                                      : HittapaRoundGradientButton(
                                                                          text: "I AGREE CONTINUE",
                                                                          onClick: () {
                                                                            EventCategoryModel category = categories.firstWhere((element) => element.id == subcategory.categoryId);
                                                                            dispatch(createNewEvent(venue: widget.venue, category: category, subcategory: subcategory, isAdminEvent: isAdminEvent));
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(Routes.NEW_EVENT);
                                                                          },
                                                                          startColor: LIGHTBLUE_BUTTON_COLOR,
                                                                          endColor: LIGHTBLUE_BUTTON_COLOR,
                                                                        ),
                                                                  icon: Container(),
                                                                  yourWidget: Column(
                                                                    children: <Widget>[
                                                                      Text(
                                                                        LocaleKeys.create_event_covid_restrictions.tr(),
                                                                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: BACKGROUND_COLOR),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(top: 18),
                                                                        child: Text(
                                                                          'Due to the spread of the COVID 19 we kindly recoment the practicing of physical distancing, this means we keep' +
                                                                              'a distance of at leat 1m from each other.',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: 18, color: BACKGROUND_COLOR),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 30),
                                                                    ],
                                                                  )));
                                                        } else {
                                                          EventCategoryModel category = categories.firstWhere((element) => element.id == subcategory.categoryId);
                                                          dispatch(createNewEvent(venue: widget.venue, category: category, subcategory: subcategory, isAdminEvent: isAdminEvent));
                                                          Navigator.of(context).pushNamed(Routes.NEW_EVENT);
                                                          // navigateToSubCategoryConfirmScreen(context, subcategory: subcategory, router: Routes.NEW_EVENT);
                                                        }
                                                      }))
                                                  .toList(),
                                            ))))
                              ]));
                        }
                      }));
            }));
  }
}
