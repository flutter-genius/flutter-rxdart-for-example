import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/widgets/hittapa_header.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:progress_button/progress_button.dart';
import 'package:hittapa/global_export.dart';


class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  ForgotPasswordScreen({@required this.email});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState _buttonStatus = ButtonState.normal;


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
          Function dispatch = store.dispatch;

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
              body: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
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
                              labelText: LocaleKeys.forgot_password_email.tr(),
                              ),
                          autofocus: true,
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
                                      text: LocaleKeys.forgot_password_request.tr().toUpperCase(),
                                      isGoogleColor: true,
                                      //                              onClick: () => onLogin(),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => onRequest(dispatch),
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
              ));
        });
  }

  // login request with email and password
  onRequest(Function dispatch) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _buttonStatus = ButtonState.inProgress;
      });

      var result = await NodeAuthService().forgotPassword(widget.email);
        if(result==null || !result['status']){
          hittaPaToast(result['data']==null ? LocaleKeys.toast_request_failed.tr() : result['data'], 1);
        } else{
          navigateToResetPasswordScreen(context, widget.email);
        }
      setState(() {
        _buttonStatus = ButtonState.normal;
      });
    }
  }
}
