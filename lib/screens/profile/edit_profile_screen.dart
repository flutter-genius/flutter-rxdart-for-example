import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/file_upload.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/image_picker_handler.dart';
import 'package:hittapa/widgets/login_gender_selecter.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:intl/intl.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';

import '../../config.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  EditProfileScreen(this.user);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final dateFormat = DateFormat("yyyy,MM,d");
  ButtonState _buttonStatus = ButtonState.normal;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _newpasswordController = new TextEditingController();

  String _name;
  DateTime _birthday;
  String _gender;
  String _avatar;
  String _email;
  bool _isChangePassword = false;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init(context);
    _name = widget.user.username;
    _birthday = widget.user.birthday;
    _avatar = widget.user.avatar;
    _gender = enumHelper.enum2str(widget.user.gender);
    _email = widget.user.email;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocaleKeys.edit_profile_edit_profile.tr(),
          style:
              TextStyle(color: TITLE_TEXT_COLOR, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Container(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: Text(LocaleKeys.edit_profile_users_are_willing.tr(),
                style: TextStyle(fontSize: 12, color: GOOGLE_COLOR),),),
            ),
            SizedBox(
              height: 15
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 170,
                  height: 170,
                  child: Stack(
                    children: <Widget>[
                      _image == null
                          ? Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(85)),
                                  color: CIRCLE_AVATAR_COLOR),
                              child: GestureDetector(
                                onTap: () => imagePicker.showDialog(context),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(85),
                                    child: CachedNetworkImage(
                                      imageUrl: _avatar ?? '',
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, err) =>
                                          SvgPicture.asset(
                                              'assets/avatar_placeholder.svg'),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(85),
                              child: Container(
                                height: 170.0,
                                width: 170.0,
                                decoration: BoxDecoration(
                                  color: BORDER_COLOR,
                                  // image: DecorationImage(
                                  //   image: ExactAssetImage(_image.path),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  // //                          border: Border.all(color: Colors.red, width: 5.0),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(60.0)),
                                ),
                                child: Image.file(_image, fit: BoxFit.cover,),
                              ),
                            ),
                      Positioned(
                        top: 6,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () => imagePicker.showDialog(context),
                            child: SvgPicture.asset(
                              "assets/edit_icon.svg",
                              color: GRADIENT_COLOR_ONE,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 35, bottom: 1),
              child: Text(LocaleKeys.edit_profile_email.tr(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: BORDER_COLOR)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: HittapaOutline(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  style: TextStyle(
                      fontSize: 15,
                      color: BORDER_COLOR,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.edit_profile_email.tr(),
                    hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  initialValue: _email,
                  autofocus: false,
                  validator: validateEmail,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 1),
              child: Text(LocaleKeys.edit_profile_first_name.tr(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: BORDER_COLOR)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: HittapaOutline(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _name = value,
                  style: TextStyle(
                      fontSize: 15,
                      color: BORDER_COLOR,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.edit_profile_first_name.tr(),
                    hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  initialValue: _name,
                  autofocus: false,
                  validator: validateName,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 1),
              child: Text(
                LocaleKeys.edit_profile_date_birth.tr(),
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: BORDER_COLOR),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: HittapaOutline(
                child: DateTimeField(
                  initialValue: _birthday,
                  format: dateFormat,
                  decoration: InputDecoration(
                      hintText: LocaleKeys.edit_profile_date_birth.tr(),
                      labelText: '',
                      hintStyle: TextStyle(color: HINT_COLOR, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      suffixIcon: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset(
                          'assets/calendar-outline.svg',
                        ),
                      )),
                  onSaved: (dt) => _birthday = dt,
                  onShowPicker: (context, currentValue) {
                    return Platform.isIOS ? DatePicker.showDatePicker(context,
                        sdone: LocaleKeys.create_account_done.tr(),
                        stitle: LocaleKeys.create_account_select_date.tr(),
                        scancel: LocaleKeys.create_account_cancel.tr(),
                        showTitleActions: true,
                        minTime: DateTime(1900),
                        maxTime: DateTime(
                            DateTime.now().year - MINIMAL_USER_AGE),
                        onChanged: (date) {
                          if (debug) print('change $date');
                          _birthday = date;
                        }, onConfirm: (date) {
                          if (debug) print("CreateAccountScreen");
                          _birthday = date;
                        },
                        currentTime: _birthday ??
                            DateTime(DateTime.now().year -
                                MINIMAL_USER_AGE),
                        locale: LocaleType.en) : 
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime(DateTime.now().year - MINIMAL_USER_AGE),
                      lastDate: DateTime(DateTime.now().year - MINIMAL_USER_AGE),
                    );
                  },
                  validator: validateBirthDay,
                ),
              ),
            ),
            AuthGenderSelector(
              onTaped: (value) {
                setState(() {
                  _gender = value;
                });
              },
              selected: _gender ?? ' ',
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _isChangePassword = !_isChangePassword;
                });

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      LocaleKeys.edit_profile_change_password.tr(),
                      style: TextStyle(
                          color: TITLE_TEXT_COLOR,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 7),
                      child: Text(
                        ' *********** ',
                        style: TextStyle(
                            color: BORDER_COLOR,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SvgPicture.asset('assets/double_arrow.svg')
                  ],
                ),
              ),
            ),
            _isChangePassword ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 1),
                  child: Text(LocaleKeys.edit_profile_old_password.tr(),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: BORDER_COLOR)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: HittapaOutline(
                    child: TextFormField(
                      controller: _passwordController,
                      onSaved: (value) {
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                          fontSize: 15,
                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0)),
                      validator: validatePassword,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 1),
                  child: Text(LocaleKeys.edit_profile_new_password.tr(),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: BORDER_COLOR)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: HittapaOutline(
                    child: TextFormField(
                      controller: _newpasswordController,
                      onSaved: (value) {
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                          fontSize: 15,
                          color: NAVIGATION_NORMAL_TEXT_COLOR),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0)),
                      validator: validatePassword,
                    ),
                  ),
                ),
              ],
            ) : Container(),
            SizedBox(height: 20)

          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 27),
              child: ProgressButton(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: HittapaRoundButton(
                        isNormal: true,
                        text: LocaleKeys.global_discard.tr().toUpperCase(),
                        onClick: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: HittapaRoundButton(
                        text: LocaleKeys.global_confirm.tr().toUpperCase(),
                        onClick: () => onComplete(),
                        isGoogleColor: true,
                      ),
                    )
                  ],
                ),
                onPressed: () => onComplete(),
                backgroundColor: Colors.transparent,
                buttonState: _buttonStatus,
                progressColor: GRADIENT_COLOR_ONE,
              ),
            ),
          )
        ],
      ),
    );
  }

  onComplete() async {
    if (!_formKey.currentState.validate()) {
      hittaPaToast(LocaleKeys.toast_select_your_profile.tr(), 1);
      return;
    }

    if (_isChangePassword && _passwordController.text != widget.user.password) {
      hittaPaToast(LocaleKeys.toast_input_correct_old_password.tr(), 1);
      return;
    }


    setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      _formKey.currentState.save();
      var _isCheckResult = await NodeAuthService().requestEmailCheck(_email);
      if(_isCheckResult != null && _isCheckResult != false && _isCheckResult.length > 0 && _email != widget.user.email) {
        setState(() {
          _buttonStatus = ButtonState.normal;
        });
        hittaPaToast(LocaleKeys.toast_this_email_is_already.tr(), 1);
        return;

      } else {
        var userUid = widget.user.id;        
        String url = _avatar;
        if (_image != null) {
          url = await uploadAvatarApi(_image, widget.user.uid);
        }
        UserModel _user = widget.user.copyWith(
            id: userUid,
            email: _email,
            password: _isChangePassword ? _newpasswordController.text : widget.user.password,
            username: _name,
            avatar: url,
            birthday: _birthday,
            gender: enumHelper.str2enum(GenderType.values, _gender),
        );

        var _result = await NodeAuthService().updateUser(_user.toJson(), _user.uid);
        if(_result != null){
          _user = UserModel.fromJson(_result).copyWith(
            apiToken: _result['apiToken']
          );
          apiToken = _result['apiToken'];
        }

        setState(() {
          _buttonStatus = ButtonState.normal;
        });
        Navigator.of(context).pop(_user);

        }
  }

  @override
  userImage(File image) {
    setState(() {
      this._image = image;
    });
  }
}
