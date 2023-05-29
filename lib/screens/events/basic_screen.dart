import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/events.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/location.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/datetime_picker.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:intl/intl.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/global_export.dart';

class BasicInfoScreen extends StatefulWidget {
  final GlobalKey<FormState> fKey;
  BasicInfoScreen({this.fKey});
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  bool _tooltip = false;
  String _name;

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
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 14, left: 14),
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(top: 0, bottom: 0, left: 40),
                              child: SimpleTooltip(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.9,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                borderColor: BORDER_COLOR,
                                child: Text(
                                  LocaleKeys.create_event_basic_information.tr(),
                                  style: TextStyle(
                                      color: TITLE_TEXT_COLOR,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                show: _tooltip,
                                tooltipDirection: TooltipDirection.down,
                                content: Material(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        LocaleKeys.create_event_basic_requires.tr(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 26,
                                      ),
                                      Text(
                                        LocaleKeys.create_event_number.tr(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: BORDER_COLOR),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                                        ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: GRADIENT_COLOR_ONE),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        LocaleKeys.create_event_date.tr(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: BORDER_COLOR),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                                        ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: GRADIENT_COLOR_ONE),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        LocaleKeys.create_event_duration.tr(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: BORDER_COLOR),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                                        ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: GRADIENT_COLOR_ONE),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        LocaleKeys.create_event_meeting_point.tr(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: BORDER_COLOR),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                                        ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: GRADIENT_COLOR_ONE),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await _openDialog();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: GOOGLE_COLOR,
                                ),
                                child: Text(
                                  '?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(),
                          child: Divider(
                            color: SEPARATOR_COLOR,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Event date & time',
                                      style: TextStyle(
                                          color: BORDER_COLOR,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigateToEventDateScreen(
                                          context: context,
                                          onDiscard: () =>Navigator.of(context).pop(),
                                          startTime: event.startDT,
                                          endTime: event.endDT,
                                          isFlexibleDate: event.isFlexibleDate,
                                          isFlexibleStartTime: event.isFlexibleStartTime,
                                          isFlexibleEndTime: event.isFlexibleEndTime,
                                          onDateTimeChanged: (startDT, isFDate, isFSTime, endDT, isFETime) {
                                            dispatch(UpdateEvent(event.copyWith(
                                              startDT: startDT, 
                                              isFlexibleDate: isFDate, 
                                              isFlexibleEndTime:   isFETime,
                                              isFlexibleStartTime: isFSTime, 
                                              endDT: endDT,
                                            )));
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: HittapaOutline(
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              event.startDT != null
                                                  ? Expanded(
                                                      child: Text(
                                                        event.isFlexibleDate
                                                            ? LocaleKeys.create_event_any_date.tr()
                                                            : '' +
                                                                DateFormat((event.isFlexibleDate
                                                                            ? ''
                                                                            : 'EEE, d MMM, ') +
                                                                        (event.isFlexibleEndTime
                                                                            ? ''
                                                                            : 'HH:mm'))
                                                                    .format(event
                                                                        .startDT) +
                                                                '~' +
                                                                ((event.isFlexibleDate &&
                                                                        event
                                                                            .isFlexibleEndTime)
                                                                    ? ' ' + LocaleKeys.create_event_and_time.tr()
                                                                    : event
                                                                            .isFlexibleEndTime
                                                                        ? LocaleKeys.create_event_any_time.tr()
                                                                        : DateFormat('HH:mm')
                                                                            .format(event.endDT)),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        softWrap: false,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                        LocaleKeys.create_event_select.tr(),
                                                        style: TextStyle(
                                                          color: BORDER_COLOR,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                              if (event.startDT != null)
                                                Icon(Icons.keyboard_arrow_down)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          LocaleKeys.create_event_meeting_point.tr(),
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(
                              fontFamily: appTheme.fontFamily1,
                              color: GRADIENT_COLOR_ONE,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        GestureDetector(
                          child: HittapaOutline(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/geo_pin.svg'),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    event.location == null
                                        ? LocaleKeys.create_event_select_on_the_map.tr()
                                        : event.location.address,
                                    style: TextStyle(
                                      color: BORDER_COLOR,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            navigateToMapScreen(context, event, user.uid)
                                .then((data) {
                              var address =
                                  data == null ? null : data['address'];
                              if (address != null) {
                                dispatch(SetEventLocation(LocationModel(
                                  country: address.countryCode,
                                  city: address.locality,
                                  state: address.adminArea,
                                  street: address.thoroughfare ??
                                      address.subAdminArea,
                                  address: data['addressLine'],
                                  postCode: address.postalCode,
                                  coordinates: [
                                    address.coordinates.latitude,
                                    address.coordinates.longitude
                                  ],
                                )));
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Form(
                          key: widget.fKey,
                          child: Container(
                            height: 255,
                            margin: EdgeInsets.only(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  LocaleKeys.create_event_title.tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: BORDER_COLOR),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                HittapaOutline(
                                  child: TextFormField(
                                    initialValue: event.name ?? '',
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 15, color: BORDER_COLOR),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: HINT_COLOR, fontSize: 15),
                                      hintText: LocaleKeys.create_event_title.tr(),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                    validator: validateRequired,
                                    onSaved: (value) {
                                      _name = value;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Text(
                                  LocaleKeys.create_event_description.tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: BORDER_COLOR),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                HittapaOutline(
                                  height: 90,
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 15, color: BORDER_COLOR),
                                    minLines: 2,
                                    maxLines: 8,
                                    initialValue: event.description,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    validator: validateRequired,
                                    onSaved: (value) {
                                      dispatch(UpdateEvent(event.copyWith(
                                          description: value, name: _name)));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _openDialog() async {
    await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) => ConfirmDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.create_event_basic_requires.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    LocaleKeys.create_event_number.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                    ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                    style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    LocaleKeys.create_event_date.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                    ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                    style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    LocaleKeys.create_event_duration.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                    ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                    style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    LocaleKeys.create_event_meeting_point.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                    ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                    style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),
                  ),
                ],
              ),
              icon: Container(),
              secondButton: HittapaRoundButton(
                text: LocaleKeys.global_close.tr(),
                isPopUp: true,
                onClick: () => Navigator.of(context).pop(),
                isNormal: true,
              ),
            ));
  }
}
