import 'package:flutter/material.dart';
import 'package:hittapa/models/models.dart' show VenueOpenTimesModel;
import 'package:hittapa/global_export.dart';

import '../global.dart';

class TimeTableData {
  String label = '';
  String value = '';

  TimeTableData(this.label, this.value);
}

//ignore: must_be_immutable
class LocationTimeTableWidget extends StatelessWidget {
  final List<VenueOpenTimesModel> openTimes;
  List<TimeTableData> _tables = [];

  LocationTimeTableWidget({@required this.openTimes}) {
    String _label = '';
    String _value = '';
    VenueOpenTimesModel _openTime;
    openTimes.forEach((element) {
      _openTime = element;
       _label = element.day.substring(0, 3);
        _value = !_openTime.isClose
            ? '${_openTime.openTime.substring(0, 5)} - ${_openTime.closeTime.substring(0, 5)}'
            : LocaleKeys.global_close.tr();
      _tables.add(TimeTableData(_label, _value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 + 20,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _tables
                .map((e) => Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Text(
                        '${e.label} :',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TITLE_TEXT_COLOR),
                      ),
                    ))
                .toList(),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _tables
                .map((e) => Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Text(
                        e.value,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TITLE_TEXT_COLOR),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
