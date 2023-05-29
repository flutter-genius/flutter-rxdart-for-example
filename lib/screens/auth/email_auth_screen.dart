import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_header.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool status = false;
  String _email = '';
  ButtonState _buttonStatus = ButtonState.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(),
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
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              child: SvgPicture.asset(
                'assets/svg/hittapa_logo_dark.svg',
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width * 0.45,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: HittapaOutline(
                child: TextFormField(
                  onSaved: (value) => this._email = value,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      fontSize: 15, color: NAVIGATION_NORMAL_TEXT_COLOR),
                  decoration: InputDecoration(
                      hintText: LocaleKeys.hittapa_sign_next_enter_your_email.tr(),
                      hintStyle: TextStyle(color: HINT_COLOR, fontSize: 11),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      labelText: LocaleKeys.hittapa_sign_next_email.tr(),
                  ),
                  autofocus: true,
                  validator: validateEmail,
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
                            child: HittapaRoundGradientButton(
                              text: LocaleKeys.hittapa_sign_next_email_continue.tr()
                                  .toUpperCase(),
                              startColor: BLACK_COLOR,
                              endColor: BLACK_COLOR,
                            ),
                          )
                        ],
                      ),
                      onPressed: () => onClickContinue(),
                      backgroundColor: Colors.transparent,
                      buttonState: _buttonStatus,
                      progressColor: GOOGLE_COLOR,
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
      ),
    );
  }

  // check email registration status and routing
  onClickContinue() {
    setState(() {
      _buttonStatus = ButtonState.inProgress;
    });
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      NodeAuthService().requestEmailCheck(_email).then((var status) {
        _buttonStatus = ButtonState.normal;
        if (status.length != 0) {
          navigateToLoginScreen(context, _email);
        } else {
          navigateToRegisterScreen(context, _email);
        }
      });
    } else {
      super.setState(() {
        _buttonStatus = ButtonState.error;
        status = true;
      });
    }
  }
}
