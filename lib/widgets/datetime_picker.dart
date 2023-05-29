import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

typedef OnDateTimeChanged(DateTime dt, bool isFlexibleDate, bool isFlexibleStartTime, DateTime et, bool isFlexibleEndTime);

class DateTimePickerView extends StatefulWidget {
  final OnDateTimeChanged onDateTimeChanged;
  final Function onDiscard;
  final DateTime dateTime;
  final bool isFlexibleDate;
  final bool isFlexibleStartTime;
  final bool isFlexibleEndTime;
  final DateTime endTime;

  DateTimePickerView({
    this.onDateTimeChanged,
    this.onDiscard,
    this.dateTime,
    this.isFlexibleDate,
    this.isFlexibleStartTime,
    this.isFlexibleEndTime,
    this.endTime
  });

  @override
  _DateTimePickerViewState createState() => _DateTimePickerViewState();
}

class _DateTimePickerViewState extends State<DateTimePickerView> {
  DateTime _selectedDateTime;
  DateTime _selectedEndDateTime;
  bool _isFlexibleDate = false;
  bool _isFlexibleStartTime = false;
  bool _isFlexibleEndTime = false;
  bool _isYearScrolled = false, _isStartScrolled = false, _isEndScrolled = false;

  DateTime _selectedStartTime;
  DateTime _selectedEndTime;

  // ignore: non_constant_identifier_names
  _is_selected(int index) {
    if (index == 1 && (widget.dateTime != null || _isStartScrolled)) return true;
    if (index == 2 && (widget.endTime != null || _isEndScrolled )) return true;
    if (index == 3 && (widget.dateTime != null || _isYearScrolled)) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    _isFlexibleStartTime = widget.isFlexibleStartTime ?? false;
    _isFlexibleEndTime = widget.isFlexibleEndTime ?? false;
    _isFlexibleDate = widget.isFlexibleDate ?? false;
    _selectedDateTime = widget.dateTime ?? DateTime.now();
    _selectedEndDateTime = widget.endTime ?? DateTime.now();
    _selectedStartTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _selectedDateTime.hour, _selectedDateTime.minute);
    _selectedEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _selectedEndDateTime.hour, _selectedEndDateTime.minute+30);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 14, right: 14, top: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 75,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: 45,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: CIRCLE_AVATAR_COLOR),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  'Select date and time',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10,),
                  width: MediaQuery.of(context).size.width-180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)
                      ),
                      Text(
                        'Month',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)
                      ),
                      Text(
                        'Year',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width-100,
            height: 140,
            child: Stack(
              children: <Widget>[
                DatePickerWidget(
                  // onMonthChangeStartWithFirstDate: true,
                  locale: DateTimePickerLocale.en_us,
                  // initialDateTime: DateTime.now(),
                  // minDateTime: _selectedDateTime.isBefore(DateTime.now()) ? DateTime.now() : _selectedDateTime,
                  maxDateTime: DateTime(2100),
                  dateFormat: 'd MMM y',
                  onConfirm: (value, n) => _selectedDateTime = value,
                  onChange: (value, n){
                    setState(() {
                      _isYearScrolled = true;
                      _selectedDateTime = value;
                      _selectedStartTime = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day, _selectedStartTime.hour, _selectedStartTime.minute, _selectedStartTime.second);
                      
                    });
                  },
                  pickerTheme: DateTimePickerTheme(cancel: Container(), confirm: Container(), showTitle: false),
                ),
                _is_selected(3) ? Container() : Positioned(
                  top: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    width: MediaQuery.of(context).size.width-100,
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      'Select your event date',
                      style: TextStyle(
                        color: BORDER_COLOR,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    )
                  )
                )
              ]
            )
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
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              ]
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select start time',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Select end time',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ]
          ),
          Container(
            height: 140,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      TimePickerWidget(
                        locale: DateTimePickerLocale.en_us,
                        // initDateTime: _selectedStartTime,
                        // minDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        // maxDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
                        dateFormat: 'HH mm',
                        minuteDivider: 1,
                        onConfirm: (value, n){
                          _selectedStartTime = value;
                        },
                        onChange: (value, n) async {
                          _selectedStartTime = value;
                          _isStartScrolled = true;
                        },
                        pickerTheme: DateTimePickerTheme(
                            cancel: Container(), confirm: Container(), showTitle: false),
                      ),
                      _is_selected(1) ? Container() : Positioned(
                        top: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          width: MediaQuery.of(context).size.width/2,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'Start time',
                            style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            )
                          )
                        )
                      )
                    ]
                  )
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      TimePickerWidget(
                        locale: DateTimePickerLocale.en_us,
                        initDateTime: _selectedEndTime,
                        minDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        maxDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
                        dateFormat: 'HH mm',
                        minuteDivider: 1,
                        onConfirm: (value, n) => _selectedEndTime = value,
                        onChange: (value, n) {
                          setState(() {
                            _isEndScrolled = true;
                          });
                          _selectedEndTime = value;
                        },
                        pickerTheme: DateTimePickerTheme(
                            cancel: Container(), confirm: Container(), showTitle: false),
                      ),
                      _is_selected(2) ? Container() : Positioned(
                        top: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          width: MediaQuery.of(context).size.width/2,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'End time',
                            style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            )
                          )
                        )
                      )
                    ]
                  )
                ),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 0.8,
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
                ),
              ),
              Text(
                LocaleKeys.create_event_flexible_start.tr(),
                style: TextStyle(
                    color: BORDER_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 40),
              Transform.scale(
                scale: 0.8,
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
                  ),
                ),
              Text(
                LocaleKeys.create_event_flexible_end.tr(),
                style: TextStyle(
                    color: BORDER_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Expanded(
            child: SizedBox(),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: HittapaRoundButton(
                      isNormal: true,
                      text: LocaleKeys.global_discard.tr().toUpperCase(),
                      onClick: widget.onDiscard,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    child: HittapaRoundButton(
                      text: LocaleKeys.global_set.tr().toUpperCase(),
                      isGoogleColor: true,
                      onClick: (){
                        if (!_is_selected(1)) {
                          hittaPaToast("Please select start time", 1);
                          return;
                        }
                        if (!_is_selected(2)) {
                          hittaPaToast("Please select end time", 1);
                          return;
                        }
                        if(_selectedStartTime.isAfter(_selectedEndTime)) {
                          DateTime _d = _selectedStartTime;
                          _selectedStartTime = _selectedEndTime;
                          _selectedEndTime = _d;
                        }
                        _selectedDateTime = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day, _selectedStartTime.hour, _selectedStartTime.minute, 0);
                        _selectedEndDateTime = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day, _selectedEndTime.hour, _selectedEndTime.minute, 0);
                        if (_selectedDateTime.isBefore(DateTime.now())) {
                          hittaPaToast('Please select the later time.', 1);
                          return;
                        } else {
                          widget.onDateTimeChanged(
                          _selectedDateTime, _isFlexibleDate, _isFlexibleStartTime, _selectedEndDateTime, _isFlexibleEndTime);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
