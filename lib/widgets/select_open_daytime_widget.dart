import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart' show VenueOpenTimesModel;
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/time_range_widget.dart';
import 'package:hittapa/global_export.dart';

class SelectOpenDateTimeWidget extends StatefulWidget {
  final List<VenueOpenTimesModel> selectedVenueOpenTimesModel;
  final Function onItemChecked;
  final bool isOpenEveryDay;

  SelectOpenDateTimeWidget(
      {this.selectedVenueOpenTimesModel,
      this.onItemChecked,
      this.isOpenEveryDay});

  @override
  _SelectOpenDateTimeWidgetState createState() =>
      _SelectOpenDateTimeWidgetState();
}

class _SelectOpenDateTimeWidgetState extends State<SelectOpenDateTimeWidget> {
  bool _isOpenEveryDay;
  List<VenueOpenTimesModel> _selectedVenueOpenTimesModel;

  @override
  void initState() {
    super.initState();
    _selectedVenueOpenTimesModel = widget.selectedVenueOpenTimesModel ??
        [
          VenueOpenTimesModel(
              day: LocaleKeys.global_monday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_tuesday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_wednesday.tr(),
              closeTime: '21:00',
              openTime: '09:00',
              isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_thursday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_friday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_saturday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false),
          VenueOpenTimesModel(
              day: LocaleKeys.global_sunday.tr(), closeTime: '21:00', openTime: '09:00', isClose: false)
        ];
    _isOpenEveryDay = widget.isOpenEveryDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF696969),
              spreadRadius: -5,
              blurRadius: 14,
            ),
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
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
              LocaleKeys.create_location_select_opening_days.tr(),
              style: TextStyle(
                  fontSize: 17,
                  color: NAVIGATION_NORMAL_TEXT_COLOR,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        child: Checkbox(
                          value: _isOpenEveryDay ?? false,
                          onChanged: (value) {
                            setState(() {
                              _isOpenEveryDay = value;
                            });
                          },
                          activeColor: BORDER_COLOR,
                          checkColor: Colors.white,
                          hoverColor: GRAY_COLOR,
//                                      materialTapTargetSize: materialTapTargetSize,
                        ),
                        height: 19,
                        width: 19,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                       LocaleKeys.create_location_open_all.tr(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: NAVIGATION_NORMAL_TEXT_COLOR),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ..._selectedVenueOpenTimesModel.map((e) {
                    int index = _selectedVenueOpenTimesModel.indexOf(e);
                    VenueOpenTimesModel _openItem =
                        _selectedVenueOpenTimesModel[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            child: Checkbox(
                              value: _openItem.isClose ?? false,
                              onChanged: (bool value) {
                                setState(() {
                                   _selectedVenueOpenTimesModel[index] = _selectedVenueOpenTimesModel[index].copyWith(isClose: value);
                                });
                              },
                              activeColor: BORDER_COLOR,
                              checkColor: Colors.white,
                              hoverColor: GRAY_COLOR,
//                                      materialTapTargetSize: materialTapTargetSize,
                            ),
                            height: 19,
                            width: 19,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: Text(
                              _selectedVenueOpenTimesModel[
                              _selectedVenueOpenTimesModel.indexOf(e)]
                                  .day,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: NAVIGATION_NORMAL_TEXT_COLOR),
                            ),
                              onTap: () {
                                setState(() {
                                  _selectedVenueOpenTimesModel[index] = _selectedVenueOpenTimesModel[index]
                                      .copyWith(isClose: !_selectedVenueOpenTimesModel[index].isClose ?? true);
                                });
                              },
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          TimeRangeWidget(
                            isClose: _openItem.isClose,
                            closeTime: _openItem.closeTime,
                            openTime: _openItem.openTime,
                            onCloseTime: (value) {
                               _selectedVenueOpenTimesModel[index] = _selectedVenueOpenTimesModel[index].copyWith(
                                 closeTime: value
                               );
                            },
                            onOpenTime: (value) {
                              _selectedVenueOpenTimesModel[index] = _selectedVenueOpenTimesModel[index].copyWith(
                                openTime: value
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.global_discard.tr().toUpperCase(),
                      isNormal: true,
                      onClick: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.global_save.tr().toUpperCase(),
                      onClick: () {
                        widget.onItemChecked(
                            _selectedVenueOpenTimesModel, _isOpenEveryDay);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
            )
          ],
        ),
      ),
    );
  }
}
