import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/location.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/age_slider.dart';
import 'package:hittapa/widgets/gender_selector.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/language_new_picker.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:language_pickers/language.dart';
import 'package:language_pickers/languages.dart';
import 'package:redux/redux.dart';
import 'package:hittapa/global_export.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _fontSize = 10;
  double _distance = 5;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          var user = state.user;

          if (user.id == null) {
            return Container();
          }

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
                LocaleKeys.setting_setting.tr(),
                style: TextStyle(
                    color: TITLE_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 21),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        LocaleKeys.setting_text_size.tr(),
                        style: TextStyle(
                            color: TITLE_TEXT_COLOR,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      SvgPicture.asset('assets/A-A.svg'),
                    ],
                  ),
                ),
                Slider(
                  value: _fontSize,
                  min: 10,
                  max: 20,
                  activeColor: GOOGLE_COLOR,
                  inactiveColor: SHADOW_COLOR,
                  label: 'TEXt',
                  onChanged: (v) {
                    setState(() {
                      _fontSize = v;
                    });
                  },
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  child: Text(
                    LocaleKeys.setting_this_is_reference_text.tr(),
                    style: TextStyle(
                        color: BORDER_COLOR,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                /// events requirements default setting
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            right: 16, top: 24, left: 16, bottom: 12),
                        child: Text(
                          LocaleKeys.setting_events_requirements.tr().toLowerCase(),
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        children: user?.requirements?.map((e){
                          return _getWidget(e, context, dispatch, user);
                        })?.toList(),
                      )
                    ],
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            right: 16, top: 24, left: 16, bottom: 12),
                        child: Text(
                          LocaleKeys.setting_locations.tr().toUpperCase(),
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          children: <Widget>[
                            //                Text('Distance from my current location', style: TextStyle(color: TITLE_TEXT_COLOR, fontSize: 17, fontWeight: FontWeight.w500),),
                            Expanded(
                              child: Text(
                                LocaleKeys.setting_distance_from_my_location.tr(),
                                style: TextStyle(
                                    color: TITLE_TEXT_COLOR,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text('< ${_distance.toStringAsFixed(2)} km',
                                style: TextStyle(
                                    color: BORDER_COLOR,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      Slider(
                        value: _distance,
                        min: 2,
                        max: 100,
                        activeColor: GOOGLE_COLOR,
                        inactiveColor: SHADOW_COLOR,
                        label: 'TEXt',
                        onChanged: (v) {
                          setState(() {
                            _distance = v;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: 16, top: 24, left: 16, bottom: 12),
                        child: Text(
                          LocaleKeys.setting_saved_locations.tr().toUpperCase(),
                          style: TextStyle(
                              color: BORDER_COLOR,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        children: user?.savedLocations?.map((e) => Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: SEPARATOR2_COLOR,
                                      style: BorderStyle.solid, width: 1))),
                          margin: EdgeInsets.symmetric(horizontal: 16,),
                          padding: EdgeInsets.symmetric(vertical: 13),
                          child: Text(e==null || e.address==null ? '' : e.address,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                color: TITLE_TEXT_COLOR,
                                fontWeight:
                                FontWeight.w500),
                          ),
                        ))?.toList(),
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 32),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.add_circle_outline,
                                color: PRIMARY_COLOR,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                LocaleKeys.setting_add_new_location.tr(),
                                style: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          navigateToMapScreen(context, null, user?.uid).then((value) {
                            Address address = value==null ? null : value['address'];
                            LocationModel _location = LocationModel(
                              coordinates: [address.coordinates.latitude, address.coordinates.longitude],
                              city: address.locality,
                              address: address.addressLine,
                              country: address.countryName,
                              state: address.adminArea,
                              street: address.thoroughfare ?? address.subAdminArea,
                              postCode: address.postalCode,
                            );
                            List<LocationModel> _d = user.savedLocations;
                            _d.add(_location);
                            dispatch(updateUser(
                                user.copyWith(
                                    savedLocations: _d
                                )
                            ));
                           setState(() {});
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            right: 16, top: 24, left: 16, bottom: 10),
                        child: Text(LocaleKeys.setting_notifications.tr().toUpperCase(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_applied_event.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 30,
                              child: CupertinoSwitch(
                                  value:
                                      user?.isEnableNotificationAppliedEvent ??
                                          false,
                                  onChanged: (v) => dispatch(updateUser(
                                      user.copyWith(
                                          isEnableNotificationAppliedEvent:
                                              v)))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_acceptance.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 30,
                              child: CupertinoSwitch(
                                value: user?.isEnableNotificationAcceptEvent ??
                                    false,
                                onChanged: (v) => dispatch(updateUser(
                                    user.copyWith(
                                        isEnableNotificationAcceptEvent: v))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_message.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 30,
                              child: CupertinoSwitch(
                                value:
                                    user?.isEnableNotificationMessage ?? false,
                                onChanged: (v) => dispatch(updateUser(user
                                    .copyWith(isEnableNotificationMessage: v))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_activity_reminder.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 30,
                              child: CupertinoSwitch(
                                value:
                                    user?.isEnableNotificationReminderActivity ??
                                        false,
                                onChanged: (v) => dispatch(updateUser(
                                    user.copyWith(
                                        isEnableNotificationReminderActivity:
                                            v))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 24),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocaleKeys.setting_feedback_reminder.tr(),
                              style: TextStyle(
                                  color: TITLE_TEXT_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 30,
                              child: CupertinoSwitch(
                                value:
                                    user?.isEnableNotificationReminderFeedback ??
                                        false,
                                onChanged: (v) => dispatch(updateUser(
                                    user.copyWith(
                                        isEnableNotificationReminderFeedback:
                                            v))),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      right: 16, left: 16, top: 18, bottom: 10),
                  child: GestureDetector(
                    child: Text(LocaleKeys.setting_logout.tr(),
                        style: TextStyle(
                            color: TITLE_TEXT_COLOR,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                    onTap: () => logout(store),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                  margin: const EdgeInsets.only(
                      right: 16, left: 16, top: 10, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.setting_disable.tr(),
                      style: TextStyle(
                          color: TITLE_TEXT_COLOR,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                      Text(LocaleKeys.setting_coming_soon.tr(),
                      style: TextStyle(
                          color: GRADIENT_COLOR_ONE,
                          fontSize: 17,
                          fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: SvgPicture.asset('assets/hittapa_logo.svg', width: 50, height: 50,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(LocaleKeys.setting_version.tr() + ' 1.0', style: TextStyle(fontSize: 14, color: Colors.grey),),
                  ),
                ),
              ],
            ),
          );
        });
  }

  logout(Store<AppState> store) async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(LocaleKeys.setting_logout.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),),
        firstButton: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(left: 30),
            child: Text(
              LocaleKeys.global_discard.tr().toUpperCase(),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
              ),
            ),
          )
        ),
        secondButton: InkWell(
          onTap: ()async {
            navigateToSettingScreenLogout(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
            decoration: BoxDecoration(
              color: GRADIENT_COLOR_ONE,
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Text(
              LocaleKeys.setting_logout.tr().toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            ),
          ),
        ),
        icon: Container(),
        yourWidget: Column(
          children: <Widget>[
            Center(
              child: Text(
                LocaleKeys.create_event_we_value_your_opinion.tr(), style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
            ),
          ],
        )
    ));
  }


  Widget _getWidget(PostRequirement requirement, BuildContext context, Function _dispatch, UserModel user) {
    if (requirement == null) return Container();
    switch (requirement.requirementId) {
      case 1:
        return GenderSelector(
          selected: requirement.value ?? ' ',
          onTaped: (value) {
            this.savePostRequirement(requirement.requirementId, value, '', user, _dispatch);
          },
        );
      case 3:
        if ((requirement.value ?? '').length <= 0) {
          this.savePostRequirement(
              requirement.requirementId,
              18.toString(),
              65.toString(), user, _dispatch);
        }
        print(requirement.toMap());
        return Container(
          margin: EdgeInsets.only(left: 15, right: 20, top: 30, bottom: 1),
          child: AgeSlider(
            text: LocaleKeys.global_select_age_range.tr() + ' ('+ LocaleKeys.global_from.tr() +' ${requirement.value ?? 18} ' + LocaleKeys.global_to.tr() +
                ' ${requirement.other ?? 65})',
            min: 18,
            max: 65,
            ageRangeEnd: int.parse(requirement.other.isEmpty ? '65': requirement.other),
            ageRangeStart: int.parse(requirement.value.isEmpty ? '18' : requirement.value),
            onChange: (double newLowerValue, double newUpperValue) {
              this.savePostRequirement(
                  requirement.requirementId,
                  newLowerValue.toInt().toString(),
                  newUpperValue.toInt().toString(), user, _dispatch);
            },
          ),
        );
      case 2:
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                LocaleKeys.setting_set_favourites_event_speaking_language.tr(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BORDER_COLOR),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: HittapaOutline(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          requirement.value != null
                              ? requirement.other
                              : LocaleKeys.global_select_a_language.tr(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: NAVIGATION_NORMAL_TEXT_COLOR),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
                onTap: () => _openCupertinoLanguagePicker(requirement, context, user, _dispatch),
              )
            ],
          ),
        );
      default:
        if (requirement.value == null)
          this.savePostRequirement(requirement.requirementId, 'none', '', user, _dispatch);
        return SizedBox(
          height: 0,
        );
    }
  }

  savePostRequirement(int requirementID, String value, String other, UserModel user, Function dispatch) {
    user.requirements
        .where((element) => element.requirementId == requirementID)
        .first.value = value;
    user.requirements
        .where((element) => element.requirementId == requirementID)
        .first.other = other;
    dispatch(updateUser(user.copyWith(
      requirements: user.requirements)));
  }

  void _openCupertinoLanguagePicker(PostRequirement requirement, BuildContext context, UserModel user, Function _dispatch) => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        Map<String, String> _selectedLanguage = {"isoCode": requirement.value, "name": requirement.other}; 
        List<dynamic> _relists = defaultLanguagesList;
        if (requirement.value != null) {
          _relists.removeWhere((element) => element['isoCode'] == requirement.value);
          _relists.insert(0, _selectedLanguage);
        }
        return LanguageNewPicker(
          defaultLanguages: _relists,
          recentLanguages: user.recentLanguages,
           onValuePicked: (Language language) {
              this.savePostRequirement(requirement.requirementId, language.isoCode, language.name, user, _dispatch);
            _dispatch(SetEventLanguage(language: language.isoCode));
          },
        );
        // return LanguagePickerCupertino(
        //   buttonTitle: LocaleKeys.create_event_primarily_speaking.tr(),
        //   pickerSheetHeight: 200.0,
        //   onValuePicked: (Language language) {
        //     this.savePostRequirement(requirement.requirementId, language.isoCode, language.name, user, _dispatch);
        //     _dispatch(SetEventLanguage(language: language.isoCode));
        //   },
        // );
      }
  );
}
