import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class AgeSlider extends StatelessWidget {
  final String text;
  final int ageRangeStart;
  final int ageRangeEnd;
  final int max;
  final int min;
  final Function onChange;
  AgeSlider(
      {@required this.text,
        @required this.ageRangeStart,
        @required this.ageRangeEnd,
        @required this.onChange,
        @required this.max,
        @required this.min});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text != null
              ? Row(
            children: [
              SizedBox(width: 5,),
              Text(
                LocaleKeys.global_select_age_range.tr(),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: BORDER_COLOR),
              ),
              Text(
                '('+ LocaleKeys.global_from.tr() +' ${(ageRangeStart ?? min)} '+ LocaleKeys.global_to.tr() +' ${ageRangeEnd ?? max}'
                    '${ageRangeEnd == null ? '+' : ageRangeEnd >= max ? '+' : ''})',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )
            ],
          ) : Container(),
          SizedBox(
            height: 7,
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTickMarkColor: Colors.transparent,
                valueIndicatorColor: GOOGLE_COLOR,
                activeTrackColor: GOOGLE_COLOR,
                thumbColor: GOOGLE_COLOR,
                showValueIndicator: ShowValueIndicator.always,
                trackHeight: 3,
            ),
            child: frs.RangeSlider(
              min: min.toDouble(),
              max: max.toDouble(),
              lowerValue: (ageRangeStart ?? min).toDouble(),
              upperValue: (ageRangeEnd ?? max).toDouble(),
              divisions: max - min,
              showValueIndicator: true,
              valueIndicatorMaxDecimals: 1,
              onChangeEnd: onChange,
              onChanged: onChange,
            ),
          )
        ],
      ),
    );
  }
}
