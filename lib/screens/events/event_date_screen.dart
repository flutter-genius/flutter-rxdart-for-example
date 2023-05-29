import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/events.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/widgets/cupertino_date_picker.dart';
import 'package:hittapa/widgets/datetime_picker.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

class EventDateScreen extends StatefulWidget {
  final OnDateTimeChanged onDateTimeChanged;
  final Function onDiscard;
  final DateTime startTime;
  final bool isFlexibleDate;
  final bool isFlexibleStartTime;
  final bool isFlexibleEndTime;
  final DateTime endTime;

  EventDateScreen({
    this.onDateTimeChanged,
    this.onDiscard,
    this.startTime,
    this.isFlexibleDate,
    this.isFlexibleStartTime,
    this.isFlexibleEndTime,
    this.endTime
  });
  @override
  _EventDateScreenState createState() => _EventDateScreenState();
}

class _EventDateScreenState extends State<EventDateScreen> {
  // ignore: non_constant_identifier_names
  String _year= '', _month='', _day='', _hour='', _minute='', _end_hour = '', _end_minute='';
  List monthList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  bool _isFlexibleDate = false, _isFlexibleStartTime = false, _isFlexibleEndTime = false;

  @override
  void initState() {      
    super.initState();
    _isFlexibleDate = widget.isFlexibleDate ?? false;
    _isFlexibleStartTime = widget.isFlexibleStartTime ?? false;
    _isFlexibleEndTime = widget.isFlexibleEndTime ?? false;
    if (!_isFlexibleDate && widget.startTime != null) {
      _year = widget.startTime?.year.toString();
      // _month = _addPrefix(widget.startTime?.month.toString());
      _month = monthList[widget.startTime.month-1];
      _day = _addPrefix(widget.startTime?.day.toString());
    }
    if (!_isFlexibleStartTime && widget.startTime != null) {
      _hour = _addPrefix(widget.startTime?.hour.toString());
      _minute = _addPrefix(widget.startTime?.minute.toString());
    }
    if (!_isFlexibleEndTime && widget.endTime != null) {
      _end_hour = _addPrefix(widget.endTime?.hour.toString());
      _end_minute = _addPrefix(widget.endTime?.minute.toString());
    }
  }

  _addPrefix(String info) {
    if (info != '' && info.length == 1) {
      return "0" + info;
    } else {
      return info;
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          EventModel event = state.newEvent;
          UserModel user = state.user;
          return Scaffold(
            backgroundColor: CARD_BACKGROUND_COLOR,
            appBar: AppBar(
              leading: IconButton(
                icon: SvgPicture.asset('assets/arrow-back.svg', color: GOOGLE_COLOR,),
                onPressed: () => Navigator.of(context).pop(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              backgroundColor: Colors.white,
              title: Text(
                "Select date and time",
                style: TextStyle(
                    color: TITLE_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 21),
              ),
              centerTitle: true,
            ),
            body: Container(
              child: ListView(
                shrinkWrap: true,
                physics: MediaQuery.of(context).size.height > 450 ? const NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HittapaCupertinoDatePicker(
                        dateType: HittapaDateType.date,
                        value: _day,
                        title: 'Day',
                        isSelected: _day != '',
                        isTitled: true,
                        onChange: (value) {
                          setState(() {
                            _day = value;
                          });
                        }
                      ),
                      HittapaCupertinoDatePicker(
                        dateType: HittapaDateType.month,
                        value: _month,
                        title: 'Month',
                        isSelected: _month != '',
                        isTitled: true,
                        onChange: (value) {
                          setState(() {
                            // _month = monthList[int.parse(value)-1];
                            _month = value;
                          });
                        }
                      ),
                      HittapaCupertinoDatePicker(
                        dateType: HittapaDateType.year,
                        value: _year,
                        title: 'Year',
                        isSelected: _year != '',
                        isTitled: true,
                        onChange: (value) {
                          setState(() {
                            _year = value;
                          });
                        }
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Transform.scale(scale: 0.8,
                        child: Checkbox(
                          value: _isFlexibleDate,
                          onChanged: (value) {
                            setState(() {
                              _isFlexibleDate = value;
                            });
                          },
                          activeColor: BORDER_COLOR,
                          checkColor: Colors.white,
                          hoverColor: GRAY_COLOR,
                          tristate: false,
                        ),),
                      Text(
                        LocaleKeys.create_event_flexible_date.tr(),
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      ]
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Select start time",
                            style: TextStyle(
                                color: TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Row(
                            children: [
                              HittapaCupertinoDatePicker(
                                dateType: HittapaDateType.hour,
                                value: _hour,
                                title: 'Hour',
                                isSelected: _hour != '',
                                isTitled: false,
                                onChange: (value) {
                                  setState(() {
                                    _hour = value;
                                  });
                                }
                              ),
                              HittapaCupertinoDatePicker(
                                dateType: HittapaDateType.minute,
                                value: _minute,
                                title: 'Min',
                                isSelected: _minute != '',
                                isTitled: false,
                                onChange: (value) {
                                  setState(() {
                                    _minute = value;
                                  });
                                }
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Transform.scale(scale: 0.8,
                                child: Checkbox(
                                  value: _isFlexibleStartTime,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFlexibleStartTime = value;
                                    });
                                  },
                                  activeColor: BORDER_COLOR,
                                  checkColor: Colors.white,
                                  hoverColor: GRAY_COLOR,
                                  tristate: false,
                                ),),
                              Text(
                                LocaleKeys.create_event_flexible_start.tr(),
                                style: TextStyle(
                                    color: BORDER_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              ]
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Select end time",
                            style: TextStyle(
                                color: TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Row(
                            children: [
                              HittapaCupertinoDatePicker(
                                dateType: HittapaDateType.hour,
                                value: _end_hour,
                                title: 'Hour',
                                isSelected: _end_hour != '',
                                isTitled: false,
                                onChange: (value) {
                                  setState(() {
                                    _end_hour = value;
                                  });
                                }
                              ),
                              HittapaCupertinoDatePicker(
                                dateType: HittapaDateType.minute,
                                value: _end_minute,
                                title: 'Min',
                                isSelected: _end_minute != '',
                                isTitled: false,
                                onChange: (value) {
                                  setState(() {
                                    _end_minute = value;
                                  });
                                }
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Transform.scale(scale: 0.8,
                                child: Checkbox(
                                  value: _isFlexibleEndTime,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFlexibleEndTime = value;
                                    });
                                  },
                                  activeColor: BORDER_COLOR,
                                  checkColor: Colors.white,
                                  hoverColor: GRAY_COLOR,
                                  tristate: false,
                                ),),
                              Text(
                                LocaleKeys.create_event_flexible_end.tr(),
                                style: TextStyle(
                                    color: BORDER_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              ]
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      Text(
                        "Selected date time",
                        style: TextStyle(
                            color: TITLE_TEXT_COLOR,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.all(width: 1, color: BORDER_COLOR)
                        ),
                        margin: EdgeInsets.only(top: 10),
                        width: 160,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _day == '' ? ' - ' : _day + ' ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: DART_TEXT_COLOR,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  _month == '' ? ' - ' : _month + ' ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                                Text(
                                  _year == '' ? ' - ' : _year + ' ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _hour == '' ? ' - :' : _hour + ':',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                                Text(
                                  _minute == '' ? ' - ' : _minute + ' - ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                                Text(
                                  _end_hour == '' ? ' - :' : _end_hour + ':',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                                Text(
                                  _end_minute == '' ? ' - ' : _end_minute,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: DART_TEXT_COLOR
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: HittapaRoundButton(
                          text: "SAVE THE CHOOSED DATE AND TIME",
                          isGoogleColor: true,
                          onClick: () {
                            if (!_isFlexibleDate && _day == '') {
                              hittaPaToast("Please select day.", 1);
                              return;
                            }
                            if (!_isFlexibleDate && _month == '') {
                              hittaPaToast("Please select month.", 1);
                              return;
                            }
                            if (!_isFlexibleDate && _year == '') {
                              hittaPaToast("Please select year.", 1);
                              return;
                            }
                            if (!_isFlexibleStartTime && _hour == '') {
                              hittaPaToast("Please select start time.", 1);
                              return;
                            }
                            if (!_isFlexibleStartTime && _minute == '') {
                              hittaPaToast("Please select start time.", 1);
                              return;
                            }
                            if (!_isFlexibleEndTime && _end_hour == '') {
                              hittaPaToast("Please select end time.", 1);
                              return;
                            }
                            if (!_isFlexibleEndTime && _end_minute == '') {
                              hittaPaToast("Please select end time.", 1);
                              return;
                            }
                            if (!_isFlexibleDate) {
                              if ([4,6,9,11].contains((monthList.indexOf(_month)+1)) && _day == '31') {
                                hittaPaToast("Please select correct date.", 1);
                                return;
                              }
                              if ((monthList.indexOf(_month) + 1) == 2) {
                                int year = int.parse(_year);
                                if (year%4==0 && year%100!=0 && int.parse(_day) > 29) {
                                  hittaPaToast("Please select correct date.", 1);
                                  return;
                                }
                                if (year%4!=0 && year%100!=0 && int.parse(_day) > 28) {
                                  hittaPaToast("Please select correct date.", 1);
                                  return;
                                }
                              }
                            }
                            DateTime _startTime = DateTime.now(), _endTime = DateTime.now(), _currentTime = DateTime.now();
                            if (!_isFlexibleDate) {
                              int year = int.parse(_year), month = monthList.indexOf(_month) + 1, day = int.parse(_day);
                              if (year < _currentTime.year) {
                                hittaPaToast("Please select after time than now.", 1);
                                return;
                              }
                              if (year == _currentTime.year && month < _currentTime.month) {
                                hittaPaToast("Please select after time than now.", 1);
                                return;
                              }
                              if (year == _currentTime.year && month == _currentTime.month && day < _currentTime.day) {
                                hittaPaToast("Please select after time than now.", 1);
                                return;
                              }
                              _startTime = DateTime(int.parse(_year), monthList.indexOf(_month) + 1, int.parse(_day));
                              _endTime = DateTime(int.parse(_year), monthList.indexOf(_month) + 1, int.parse(_day));
                            }
                            if (!_isFlexibleStartTime && !_isFlexibleDate) {
                              _startTime = DateTime(_startTime.year, _startTime.month, _startTime.day, int.parse(_hour), int.parse(_minute));
                              if (_startTime.isBefore(_currentTime)) {
                                hittaPaToast("Please select after time than now.", 1);
                                return;
                              }
                            }
                            if (!_isFlexibleEndTime && !_isFlexibleDate) {
                              _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day, int.parse(_end_hour), int.parse(_end_minute));
                              if (_endTime.isBefore(_currentTime)) {
                                hittaPaToast("Please select after time than now.", 1);
                                return;
                              }
                            }
                            if (!_isFlexibleStartTime && !_isFlexibleEndTime) {
                              if (_startTime.isAfter(_endTime)) {
                                var _m = _startTime;
                                _startTime = _endTime;
                                _endTime = _m;
                              }
                            }

                            // widget.onDateTimeChanged(_startTime, _isFlexibleDate, _isFlexibleStartTime, _endTime, _isFlexibleEndTime);
                            dispatch(UpdateEvent(event.copyWith(
                              startDT: _startTime, 
                              isFlexibleDate: _isFlexibleDate, 
                              isFlexibleEndTime:   _isFlexibleEndTime,
                              isFlexibleStartTime: _isFlexibleStartTime, 
                              endDT: _endTime,
                            )));
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          );
        });
  }
}
