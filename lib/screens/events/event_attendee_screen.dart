import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/events.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/post_requirement.dart';
import 'package:hittapa/services/file_upload.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/cupertino_date_picker.dart';
import 'package:hittapa/widgets/datetime_picker.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/image_picker_handler.dart';
import 'package:hittapa/widgets/login_gender_selecter.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_button/progress_button.dart';

class EventAttendeeScreen extends StatefulWidget {
  final Function onDiscard;
  final Function onAdd;
  final EventModel event;

  EventAttendeeScreen({
    this.onDiscard,
    this.onAdd,
    this.event,
  });
  @override
  _EventAttendeeScreenState createState() => _EventAttendeeScreenState();
}

class _EventAttendeeScreenState extends State<EventAttendeeScreen> with TickerProviderStateMixin, ImagePickerListener {
  // ignore: non_constant_identifier_names
  final dateFormat = DateFormat("dd.MMM.yyyy");
  ButtonState _buttonStatus = ButtonState.normal;
  TextEditingController _emailController, _usernameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  DateTime _birthday;
  String _name;
  String _email;
  LocationModel _location;
  GenderType _gender;
  EventModel event;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init(context);
    _emailController = new TextEditingController();
    _usernameController = new TextEditingController();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          return Scaffold(
            backgroundColor: CARD_BACKGROUND_COLOR,
            appBar: AppBar(
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/close.svg',
                  color: GOOGLE_COLOR,
                ),
                onPressed: widget.onDiscard,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
              backgroundColor: Colors.white,
              title: Text(
                "Add Manual Attendee",
                style: TextStyle(color: TITLE_TEXT_COLOR, fontWeight: FontWeight.w600, fontSize: 21),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: <Widget>[
                            _image == null
                                ? Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(borderRadius: const BorderRadius.all(const Radius.circular(60)), color: CIRCLE_AVATAR_COLOR),
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: SvgPicture.asset('assets/avatar_placeholder.svg'),
                                        ),
                                        backgroundColor: CIRCLE_AVATAR_COLOR,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Container(
                                      height: 120.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        color: BORDER_COLOR,
                                        borderRadius: const BorderRadius.all(const Radius.circular(60.0)),
                                      ),
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              top: 6,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => imagePicker.showDialog(context),
                                child: SvgPicture.asset(
                                  "assets/plus_icon.svg",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Text(
                            LocaleKeys.preview_profile_email.tr(),
                            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
                          ),
                        ),
                        HittapaOutline(
                          height: 48,
                          round: 10,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value,
                            style: TextStyle(fontSize: 15, color: BORDER_COLOR, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            // initialValue: _name,
                            // autofocus: true,
                            validator: validateEmail,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 1),
                    child: Text(LocaleKeys.preview_profile_first_name.tr(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: BORDER_COLOR)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: HittapaOutline(
                      height: 48,
                      round: 10,
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        onSaved: (value) => _name = value,
                        style: TextStyle(fontSize: 15, color: BORDER_COLOR, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: LocaleKeys.preview_profile_first_name.tr(),
                          hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        // initialValue: _name,
                        // autofocus: true,
                        validator: validateName,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 1),
                    child: Text(
                      LocaleKeys.preview_profile_date_of_birth.tr(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: BORDER_COLOR),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: HittapaOutline(
                          round: 10,
                          height: 48,
                          child: InkWell(
                            onTap: () {
                              navigateToBirthDayScreen(context, _birthday).then((data) {
                                if (data != null) {
                                  setState(() {
                                    _birthday = data;
                                  });
                                }
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _birthday != null ? dateFormat.format(_birthday) : "",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/calendar-outline.svg',
                                    ),
                                  ],
                                )),
                          ))),
                  AuthGenderSelector(
                    onTaped: (value) => setState(() {
                      _gender = enumHelper.str2enum(GenderType.values, value);
                    }),
                    selected: enumHelper.enum2str(_gender ?? null),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          child: ProgressButton(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: HittapaRoundButton(
                                    text: 'SAVE TO ADD ATTENDEE',
                                    onClick: () => onComplete(state, dispatch, context),
                                    isGoogleColor: true,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () => onComplete(state, dispatch, context),
                            backgroundColor: Colors.transparent,
                            buttonState: _buttonStatus,
                            progressColor: GRADIENT_COLOR_ONE,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  onComplete(AppState state, Function dispatch, BuildContext context) async {
    if (this._image == null) {
      hittaPaToast(LocaleKeys.toast_upload_image.tr(), 1);
      return;
    }

    if (_emailController.text == null || _emailController.text == "") {
      hittaPaToast(LocaleKeys.toast_input_email.tr(), 1);
      return;
    }

    if (validateEmail(_emailController.text) != null) {
      hittaPaToast(validateEmail(_emailController.text), 1);
      return;
    }

    if (_usernameController.text == null || _usernameController.text == "") {
      hittaPaToast(LocaleKeys.toast_input_first_name.tr(), 1);
      return;
    }

    if (_gender == null) {
      hittaPaToast(LocaleKeys.toast_select_gender.tr(), 1);
      return;
    }

    if (this._image == null || !_formKey.currentState.validate() || _gender == null) {
      hittaPaToast(LocaleKeys.toast_select_your_birthday.tr(), 1);
      return;
    } else {
      if (mounted) {
        setState(() {
          _buttonStatus = ButtonState.inProgress;
        });
      }
      _formKey.currentState.save();

      String url;
      if (this._image != null) {
        url = await uploadAvatarApi(_image, DateTime.now().toIso8601String());
      }
      List<PostRequirement> _listRequirements = [];
      for (int i = 0; i < 3; i++) {
        PostRequirement _postrequirement = PostRequirement(requirementId: i + 1, other: null, value: null, status: true);
        _listRequirements.add(_postrequirement);
      }

      UserModel _user = new UserModel();
      _user = _user.copyWith(
        birthday: _birthday,
        email: _email,
        username: _name,
        avatar: url,
        gender: _gender,
        location: _location,
        savedLocations: [],
        requirements: _listRequirements,
        userRole: 3,
      );

      try {
        var result = await NodeAuthService().addUser(_user.toJson());
        if (result != null) {
          _user = UserModel.fromJson(result);
          List<String> _pending = event.participantsPending;
          List<String> _accepted = event.participantsAccepted;
          List<String> _standby = event.participantsStandby;
          _accepted.add(_user.uid);
          NodeService().updateEvent(event.copyWith(participantsAccepted: _accepted, participantsPending: _pending, participantsStandby: _standby).toJson()).then((_) {});
          widget.onAdd();
        }
      } catch (e) {
        print(e);
        hittaPaToast('Invalid request', 1);
      }
      if (mounted) {
        setState(() {
          _buttonStatus = ButtonState.normal;
        });
      }
    }
  }

  @override
  userImage(File image) {
    this._image = image;
    setState(() {});
  }
}
