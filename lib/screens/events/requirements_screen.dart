import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/widgets/age_slider.dart';
import 'package:hittapa/widgets/counter_button.dart';
import 'package:hittapa/widgets/driver_license_selector.dart';
import 'package:hittapa/widgets/gender_selector.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/language_new_picker.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:hittapa/widgets/tempo_selector.dart';
import 'package:language_pickers/language.dart';
import 'package:language_pickers/languages.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global_export.dart';

import '../../config.dart';

class RequirementsScreen extends StatefulWidget {
  final List<PostRequirement> requirements;
  final EventModel event;

  RequirementsScreen({this.requirements, this.event});
  @override
  _RequirementsScreenState createState() => _RequirementsScreenState();
}

class _RequirementsScreenState extends State<RequirementsScreen> {
  Function _dispatch;
  bool _tooltip = false;
  UserModel user;

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          _dispatch = store.dispatch;
          user = store.state.user;
          List<String> _recentLanguages = user.recentLanguages;
          return Scaffold(
            backgroundColor: CARD_BACKGROUND_COLOR,
            body: Container(
              height: MediaQuery.of(context).size.height-100,
              child: ListView.builder(
                // ignore: null_aware_before_operator
                itemCount: widget.requirements?.length + 2,
                itemBuilder: (context, index) {
                  if (index==0) return _title();
                  if (index==3) return participle();
                  if(index > 3) {
                    return _getWidget(widget.requirements[index-2], context, _recentLanguages);
                  } else {
                    return _getWidget(widget.requirements[index-1], context, _recentLanguages);
                  }
                },
              ),
            ),
            );
        });
  }

  Widget _title() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 40),
                child: SimpleTooltip(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  borderColor: BORDER_COLOR,
                  child: Text(
                    LocaleKeys.create_event_participant_requirements.tr(),
                    style: TextStyle(
                        color: TITLE_TEXT_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  show: _tooltip,
                  tooltipDirection: TooltipDirection.down,
                  content: Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(LocaleKeys.create_event_participant_requirements_consist.tr(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 26,),
                        Text(LocaleKeys.global_gender.tr(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
                        SizedBox(height: 9,),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),),
                        SizedBox(height: 16,),
                        Text(LocaleKeys.event_detail_age_range.tr() + '(from 18 to 65+)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
                        SizedBox(height: 9,),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),),
                        SizedBox(height: 16,),
                        Text(LocaleKeys.create_event_primarily_speaking.tr(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
                        SizedBox(height: 9,),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),),
                        SizedBox(height: 16,),
                        Text(LocaleKeys.event_detail_children_age.tr() + ' (from 0 to 17)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
                        SizedBox(height: 9,),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),),
                        SizedBox(height: 16,),
                        Text(LocaleKeys.global_tempo.tr(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
                        SizedBox(height: 9,),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
                          style: TextStyle(fontSize: 13, color: GRADIENT_COLOR_ONE),),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap:  () async{
                  await _openDialog();
                },
                child:  Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: GOOGLE_COLOR,
                  ),
                  child: Text('?', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            child: Divider(
              color: SEPARATOR_COLOR,
              thickness: 1,
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget participle() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 10),
            child: Center(
              child:Text(
                'Set number of participants',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: GOOGLE_COLOR, fontWeight: FontWeight.w600),
              ),
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CounterButton(
                child: Image.asset(
                  'assets/images/minus.png',
                  height: 38,
                ),
                onTap: () =>
                    _dispatch(DecrementEventParticipantsNo()),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  color: CARD_BACKGROUND_COLOR,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/group_icon.svg',
                          width: 21,
                          height: 20,
                          color: TITLE_TEXT_COLOR,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.event.unLimitedMaxParticipantsNo
                              ? '∞'
                              : widget.event.maxParticipantsNo
                              .toString(),
                          style: TextStyle(
                              fontSize: 21,
                              color: TITLE_TEXT_COLOR,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Except yourself',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: BORDER_COLOR),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: Checkbox(
                            value: widget.event.unLimitedMaxParticipantsNo,
                            onChanged: (value) => _dispatch(
                                SetUnlimitedEventParticipantsNo(
                                    value)),
                            activeColor: BORDER_COLOR,
                            checkColor: Colors.white,
                            hoverColor: GRAY_COLOR,
                          ),
                          height: 19,
                          width: 19,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          LocaleKeys.create_event_unlimited.tr(),
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: BORDER_COLOR),
                        )
                      ],
                    )
                  ],
                ),
              ),
              CounterButton(
                child: Image.asset(
                  'assets/images/plus-1.png',
                  height: 38,
                ),
                onTap: () {
                  _dispatch(IncrementEventParticipantsNo());
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  // open dialog language picker
  void _openCupertinoLanguagePicker(PostRequirement requirement, BuildContext context, List<String> _recentLanguages) => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        Map<String, String> _selectedLanguage = {"isoCode": requirement.value, "name": requirement.other}; 
        List<dynamic> _relists = defaultLanguagesList;
        if (requirement.value != null) {
          _relists.removeWhere((element) => element['isoCode'] == requirement.value);
          _relists.insert(0, _selectedLanguage);
        }
        if (user.eventLanguage != null) {
          _selectedLanguage = _relists.firstWhere((element) => element['isoCode'] == user.eventLanguage);
          _relists.removeWhere((element) => element['isoCode'] == user.eventLanguage);
          _relists.insert(0, _selectedLanguage);
        }
       return LanguageNewPicker(
          defaultLanguages: _relists,
          recentLanguages: _recentLanguages,
           onValuePicked: (Language language) {
            this.savePostRequirement( requirement.requirementId, language.isoCode, language.name);
            _dispatch(SetEventLanguage(language: language.isoCode));
            _dispatch(updateUser(
                user.copyWith(
                  eventLanguage: language.isoCode
                )
            ));
          },
        );
      });

  // generate widget function for each requirements
  Widget _getWidget(PostRequirement requirement, BuildContext context, List<String> _recentLanguages) {
    switch (requirement.requirementId) {
      case 1:
        if (requirement.value==null && user.requirements[0].value != null) {
          this.savePostRequirement(
              requirement.requirementId,
              user.requirements[0].value.toString(),
              '');
        }
        return GenderSelector(
          selected: requirement.value ?? ' ',
          onTaped: (value) {
            this.savePostRequirement(requirement.requirementId, value, '');
            _dispatch(SetEventGender(gender: enumHelper.str2enum(GenderType.values, value)));
          },
        );
      case 2:
        if ((requirement.value ?? '').length <= 0) {
          this.savePostRequirement(
              requirement.requirementId,
              user.requirements[2].value != null ? user.requirements[2].value.toString() : 18.toString(),
              user.requirements[2].other != null ? user.requirements[2].other.toString() : 65.toString());
        }
        print(requirement.toMap());
        return Container(
          margin: EdgeInsets.only(left: 15, right: 20, top: 30, bottom: 1),
          child: AgeSlider(
            text: LocaleKeys.global_select_age_range.tr() + ' ('+ LocaleKeys.global_from.tr()  +' ${requirement.value ?? 18} ' + LocaleKeys.global_to.tr() + 
                ' ${requirement.other ?? 65})',
            min: 18,
            max: 65,
            ageRangeEnd: int.parse(requirement.other.isEmpty ? '65' : requirement.other),
            ageRangeStart: int.parse(requirement.value.isEmpty ? '18' : requirement.value),
            onChange: (double newLowerValue, double newUpperValue) {
              this.savePostRequirement(
                  requirement.requirementId,
                  newLowerValue.toInt().toString(),
                  newUpperValue.toInt().toString());
            },
          ),
        );
      case 3:
        if (requirement.value==null && user.requirements[1].value != null) {
          this.savePostRequirement(
              requirement.requirementId,
              user.requirements[1].value,
              user.requirements[1].other,);
        }
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                LocaleKeys.create_event_primarily_speaking.tr(),
                style: TextStyle(
                    fontSize: 17,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: NAVIGATION_NORMAL_TEXT_COLOR),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
                onTap: () => _openCupertinoLanguagePicker(requirement, context, _recentLanguages),
              )
            ],
          ),
        );
      case 9:
        if ((requirement.value ?? '').length <= 0) {
          this.savePostRequirement(
              requirement.requirementId,
              0.toString(),
              17.toString());
        }
        print(requirement.toMap());
        return Container(
          margin: EdgeInsets.only(left: 15, right: 20, top: 24, bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.event_detail_children_age.tr() + ' ('+ LocaleKeys.global_from.tr() +' ${requirement.value ?? 0} '
                          + LocaleKeys.global_to.tr() +' ${requirement.other ?? 17})',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: BORDER_COLOR),
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                          'Integer odio metus, iaculis ut ornare vitae, auctor vel '
                          'urna. Ut mattis mauris',
                      style: TextStyle(
                          fontFamily: appTheme.fontFamily1,
                          color: GRADIENT_COLOR_ONE,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AgeSlider(
                text: null,
                min: 0,
                max: 17,
                ageRangeEnd: int.parse(requirement.other.isEmpty ? '17' : requirement.other),
                ageRangeStart: int.parse(requirement.value.isEmpty ? '0' : requirement.value),
                onChange: (double newLowerValue, double newUpperValue) {
                  this.savePostRequirement(
                      requirement.requirementId,
                      newLowerValue.toInt().toString(),
                      newUpperValue.toInt().toString());
                },
              )
            ],
          ),
        );
      case 7:
        return TempoSelector(
          onTaped: (value) {
            this.savePostRequirement(requirement.requirementId, value, '');
          },
          selected: requirement.value,
        );
      case 8:
        return DriverLicenseSelector(
          onTaped: (value) {
            this.savePostRequirement(requirement.requirementId, value, '');
          },
          selected: requirement.value,
        );
      default:
        if (requirement.value == null)
          this.savePostRequirement(requirement.requirementId, 'none', '');
        return SizedBox(
          height: 0,
        );
    }
  }

  savePostRequirement(int requirementID, String value, String other) {
    widget.requirements
        .where((element) => element.requirementId == requirementID)
        .first.value = value;
    widget.requirements
        .where((element) => element.requirementId == requirementID)
        .first.other = other;
    _dispatch(SetEventRequirements(requirements: widget.requirements));
  }

  _openDialog() async{
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(LocaleKeys.create_event_participant_requirements_consist.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 26,),
            Text(LocaleKeys.global_gender.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
            SizedBox(height: 9,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
              style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),),
            SizedBox(height: 16,),
            Text(LocaleKeys.event_detail_age_range.tr() + '('+ LocaleKeys.global_from.tr() +' 18 '+ LocaleKeys.global_to.tr() +' 65+)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
            SizedBox(height: 9,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
              style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),),
            SizedBox(height: 16,),
            Text(LocaleKeys.create_event_primarily_speaking.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
            SizedBox(height: 9,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
              style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),),
            SizedBox(height: 16,),
            Text(LocaleKeys.event_detail_children_age.tr() + ' ('+ LocaleKeys.global_from.tr() +' 0 t'+ LocaleKeys.global_to.tr() +'17)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
            SizedBox(height: 9,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
              style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),),
            SizedBox(height: 16,),
            Text(LocaleKeys.global_tempo.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BORDER_COLOR),),
            SizedBox(height: 9,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Integer odio metus, iaculis ut ornare vitae, auctor vel urna.',
              style: TextStyle(fontSize: 17, color: GRADIENT_COLOR_ONE),),
          ],
        ),
        icon: Container(),
        secondButton: HittapaRoundButton(
          text: LocaleKeys.global_close.tr().toUpperCase(),
          isPopUp: true,
          onClick: ()  => Navigator.of(context).pop(),
          isNormal: true,
        )
    ));
  }
}


