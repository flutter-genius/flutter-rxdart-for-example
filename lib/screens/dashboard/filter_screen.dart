import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event_category.dart';
import 'package:hittapa/models/event_subcategory.dart';
import 'package:hittapa/models/filter.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/widgets/gender_selector.dart';
import 'package:hittapa/widgets/language_new_picker.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:intl/intl.dart';
import 'package:language_pickers/language.dart';
import 'package:hittapa/global_export.dart';
import 'package:language_pickers/languages.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _openUnlimited = false;
  int _distance = 5;
  String _selectedLanguage;
  bool _childrenEvents;
  DateTime _fromDate;
  DateTime _toDate;
  EventCategoryModel _category;
  String _gender;
  Function _dispatch;
  List<EventCategoryModel> _categories;
  UserModel user;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        onInit: (store) {
          _categories = store.state.eventCategories;
          if (store.state.eventFilter != null) {
            _openUnlimited = store.state.eventFilter.isOpenUnLimit ?? false;
            _childrenEvents = store.state.eventFilter.isChildrenEvent ?? false;
            _distance = store.state.eventFilter.distance ?? 5;
            _selectedLanguage = store.state.eventFilter.language;
            _fromDate = store.state.eventFilter.fromDate;
            _toDate = store.state.eventFilter.toDate;
            _gender = store.state.eventFilter.gender;
            _category = store.state.eventFilter.category;
          }
          _dispatch = store.dispatch;
          user = store.state.user;
        },
        builder: (context, store) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                LocaleKeys.filter_filters.tr(),
                style: TextStyle(
                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
              leading: Container(),
            ),
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.all(16),
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        LocaleKeys.setting_distance_from_my_location.tr(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: TITLE_TEXT_COLOR),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text('<${_distance ?? 5} km',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: BORDER_COLOR))
                    ],
                  ),
                  Slider(
                    activeColor: GRADIENT_COLOR_ONE,
                    inactiveColor: SEPARATOR_COLOR,
                    onChanged: (value) {
                      setState(() {
                        _distance = value.toInt();
                      });
                    },
                    max: 100,
                    min: 3,
                    value: (_distance ?? 5).toDouble(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          LocaleKeys.create_location_category.tr(),
                          style: TextStyle(
                              color: TITLE_TEXT_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            ' (${_category == null ? 'All caregories' : _category.name})',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    trailing: SvgPicture.asset('assets/double_arrow.svg'),
                    onTap: () => openCategorySelector(),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          LocaleKeys.global_date.tr(),
                          style: TextStyle(
                              color: TITLE_TEXT_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _fromDate == null
                              ? ' ('+ LocaleKeys.create_account_select_date.tr() +')'
                              : ' (${DateFormat('yyyy-MM-dd').format(_fromDate)})',
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    trailing: SvgPicture.asset('assets/double_arrow.svg'),
                    onTap: () => onOpenDatePicker(),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text(
                          LocaleKeys.global_language.tr(),
                          style: TextStyle(
                              color: TITLE_TEXT_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            ' (${_selectedLanguage != null ? _selectedLanguage : 'All language'})',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    trailing: SvgPicture.asset('assets/double_arrow.svg'),
                    onTap: () => showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          List<dynamic> _relists = defaultLanguagesList;
                          return LanguageNewPicker(
                            defaultLanguages: _relists,
                            recentLanguages: user.recentLanguages,
                            onValuePicked: (Language language) => setState(() {
                              _selectedLanguage = language.isoCode;
                            }),
                          );
                          // return LanguagePickerCupertino(
                          //   pickerSheetHeight: 200.0,
                          //   onValuePicked: (Language language) => setState(() {
                          //     _selectedLanguage = language.isoCode;
                          //   }),
                          // );
                        }),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    leading: SizedBox(
                      child: Checkbox(
                        value: _openUnlimited ?? false,
                        onChanged: (value) {
                          setState(() {
                            _openUnlimited = value;
                          });
                        },
                        activeColor: BORDER_COLOR,
                        checkColor: Colors.white,
                        hoverColor: GRAY_COLOR,
                      ),
                      height: 19,
                      width: 19,
                    ),
                    title: Text(
                      LocaleKeys.filter_open_events.tr(),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: BORDER_COLOR),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    leading: SizedBox(
                      child: Checkbox(
                        value: _childrenEvents ?? false,
                        onChanged: (value) {
                          setState(() {
                            _childrenEvents = value;
                          });
                        },
                        activeColor: BORDER_COLOR,
                        checkColor: Colors.white,
                        hoverColor: GRAY_COLOR,
                      ),
                      height: 19,
                      width: 19,
                    ),
                    title: Text(
                     LocaleKeys.filter_children_events.tr(),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: BORDER_COLOR),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 18),
                    child: GenderSelector(
                      selected: _gender ?? ' ',
                      onTaped: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 15, right: 14, left: 14),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.filter_reset.tr(),
                      isNormal: true,
                      onClick: () => onClearFilter(),
                    ),
                  ),
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.filter_filter.tr(),
                      onClick: () => this.onSaveFilter(),
                    ),
                  )
                ],
              ),
            ),
          );
        });

  }

  // set filter function
  onSaveFilter() async {
    FilterModel eventFilter = FilterModel(
        category: _category,
        distance: _distance,
        gender: _gender,
        fromDate: _fromDate,
        toDate: _toDate,
        isChildrenEvent: _childrenEvents,
        isOpenUnLimit: _openUnlimited,
        language: _selectedLanguage);
    _dispatch(SetEventFilter(filter: eventFilter));
    Navigator.of(context).pop();
  }

  onClearFilter() async {
    setState(() {
      _category = null;
      _distance = null;
      _gender = null;
      _fromDate = null;
      _toDate = null;
      _childrenEvents = null;
      _openUnlimited = null;
      _selectedLanguage = null;
    });
  }

  // Slide up bottom sheet to select category
  openCategorySelector() {
    EventCategoryModel _selCat = _category;
    List<EventSubcategoryModel> _list = [];
    categories.forEach((f) => f['subCategories'].forEach((e) => _list.add(e)));
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF696969),
                    spreadRadius: -5,
                    blurRadius: 14,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 14, bottom: 17),
                    width: 45,
                    height: 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: CIRCLE_AVATAR_COLOR),
                  ),
                  Text(
                    LocaleKeys.create_location_select_categories.tr(),
                    style: TextStyle(
                        fontSize: 17,
                        color: NAVIGATION_NORMAL_TEXT_COLOR,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (value) {
                            _selCat = _categories[value];
                          },
                          itemExtent: 40,
                          children: _categories.map((e) {
                            return Text(e.name);
                          }).toList(),
                        ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: HittapaRoundButton(
                              text: LocaleKeys.global_select.tr(),
                              onClick: () {
                                setState(() {
                                  _category = _selCat;
                                  print(_category);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  onOpenDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2100, 12, 30), onChanged: (date) {
      // print('change $date');
    }, onConfirm: (date) {
      setState(() {
        _fromDate = date;
      });
    }, currentTime: _fromDate ?? DateTime.now(), locale: LocaleType.en);
  }
}
