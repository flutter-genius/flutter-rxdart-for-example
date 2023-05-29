import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

//ignore: must_be_immutable
class TimeRangeWidget extends StatelessWidget {
  String openTime;
  String closeTime;
  bool isClose;
  final Function onCloseTime;
  final Function onOpenTime;
  final Function onOpenStatus;

  TimeRangeWidget(
      {this.openTime,
      this.closeTime,
      this.isClose,
      this.onCloseTime,
      this.onOpenTime,
      this.onOpenStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          StatefulBuilder(
            builder: (context, setState) {
              return roundWidget(
                  child: GestureDetector(
                onTap: () async {
                  if (isClose) {
                    TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    );
                    setState(() {
                      openTime =
                          '${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
                      onOpenTime(openTime);
                    });
                  }
                },
                child: Container(
                  width: 70,
                  height: 25,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        isClose ? openTime ?? '' : LocaleKeys.global_close.tr(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: NAVIGATION_NORMAL_TEXT_COLOR),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ));
            },
          ),
          isClose
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('-'),
                )
              : Container(),
          StatefulBuilder(
            builder: (context, setState) {
              return isClose
                  ? roundWidget(
                      child: GestureDetector(
                      onTap: () async {
                        TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        setState(() {
                          closeTime =
                              '${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
                          onCloseTime(closeTime);
                        });
                      },
                      child: Container(
                        width: 70,
                        height: 25,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              closeTime ?? '',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: NAVIGATION_NORMAL_TEXT_COLOR),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ))
                  : SizedBox(
                      width: 90,
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget roundWidget({@required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: BORDER_COLOR, width: 1)),
      child: child,
    );
  }
}
