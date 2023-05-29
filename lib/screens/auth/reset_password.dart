import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_header.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({@required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState _buttonStatus = ButtonState.normal;
  String password = '', code = '';
  bool _isVerified = false;


  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: HittapaHeader(),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: SvgPicture.asset('assets/arrow-back.svg'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  SizedBox(
                    width: 55,
                  )
                ],
              ),
              body: _isVerified ? _veriWidget() : _checkWidget()
              );
        });
  }

  Widget _checkWidget () {
    return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: HittapaOutline(
                        child: TextFormField(
                          onSaved: (value) => this.code = value,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 15, color: BORDER_COLOR),
                          decoration: InputDecoration(
                              hintText: LocaleKeys.forgot_password_verify_code.tr(),
                              hintStyle:
                                  TextStyle(color: HINT_COLOR, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              labelText: LocaleKeys.forgot_password_verify_code.tr(),),
                          validator: validateCode,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: ProgressButton(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: HittapaRoundButton(
                                      text: LocaleKeys.forgot_password_verify.tr().toUpperCase(),
                                      isGoogleColor: true,
                                      //                              onClick: () => onLogin(),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => onCheck(),
                              backgroundColor: Colors.transparent,
                              buttonState: _buttonStatus,
                              progressColor: GRADIENT_COLOR_ONE,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              );

  }

  Widget _veriWidget () {
    return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child : Center(
                        child: Text(
                          LocaleKeys.forgot_reset_password.tr(), style: TextStyle(color: GOOGLE_COLOR, fontSize: 15, fontWeight: FontWeight.w600)
                        ),)
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: HittapaOutline(
                        child: TextField(
                          controller: _emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 15, color: BORDER_COLOR),
                          decoration: InputDecoration(
                              hintStyle:
                                  TextStyle(color: HINT_COLOR, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              labelText: LocaleKeys.forgot_password_email.tr(),),
                          autofocus: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: HittapaOutline(
                        child: TextFormField(
                          onSaved: (value) => this.password = value,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(fontSize: 15, color: BORDER_COLOR),
                          decoration: InputDecoration(
                              hintText: LocaleKeys.login_password.tr(),
                              hintStyle:
                                  TextStyle(color: HINT_COLOR, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              labelText: LocaleKeys.login_password.tr(),),
                          validator: validatePassword,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: ProgressButton(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: HittapaRoundButton(
                                      text: LocaleKeys.forgot_reset_password.tr().toUpperCase(),
                                      isGoogleColor: true,
                                      //                              onClick: () => onLogin(),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => onReset(),
                              backgroundColor: Colors.transparent,
                              buttonState: _buttonStatus,
                              progressColor: GRADIENT_COLOR_ONE,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              );
  }

  // login request with email and password
  onCheck() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      Map<String, dynamic> _data = {
        'email' : widget.email,
        'code' : code
      };

      var result = await NodeAuthService().checkVerifyCode(_data);
        if(result==null || !result['status']){
          hittaPaToast(LocaleKeys.toast_verify_faild.tr(), 1);
        } else{
          setState(() {
            _isVerified = true;
          });
        }
      setState(() {
        _buttonStatus = ButtonState.normal;
      });
    }
  }

  // reset password
  onReset() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      Map<String, dynamic> _data = {
        'email' : widget.email,
        'password' : password
      };

      var result = await NodeAuthService().resetPassword(_data);
        if(result==null || !result['status']){
          hittaPaToast(LocaleKeys.toast_verify_faild.tr(), 1);
        } else{
          navigateToLoginScreen(context, widget.email);
        }
      setState(() {
        _buttonStatus = ButtonState.normal;
      });
    }
  }
}
