import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/screens/auth/account_confirm_screen.dart';
import 'package:hittapa/screens/auth/profile_preview_screen.dart';
import 'package:hittapa/screens/intro/workflow_screen.dart';
import 'package:hittapa/screens/main/create_account_screen.dart';
import 'package:hittapa/screens/screens.dart';

import 'package:hittapa/services/socket_service.dart';
import 'package:hittapa/global.dart';

const _debug = true; // || debug;
bool isCreatAccount = false;
bool isDone = false;

class MainScreen extends StatelessWidget {
  final SocketService socketService = injector.get<SocketService>();

  @override
  Widget build(BuildContext context) {
    socketService.createSocketConnection();
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          Function dispatch = store.dispatch;
          var user = state.user;
          if ((store.state.eventCategories ?? []).length == 0) {
            if (!isDone) start(store);
            isDone = true;
          }

          if (state.firstRun) {
            return WorkFlowScreen(onFinished: () {
              dispatch(DisableFirstRun());
            });
          }

          if (user == null || user.id == null) {
            return CreateAccountScreen();
          }

          if (user?.avatar == null || (user?.avatar ?? '').isEmpty || user?.gender == null || user?.birthday == null || user?.username == null) {
            if (_debug) print('user is incomplete, navigate to ProfilePreviewScreen $user');
            return ProfilePreviewScreen();
          } else {
            if (user != null) {
              apiToken = state.user.apiToken;
            }
            // ignore: null_aware_in_logical_operator
            if (isCreatAccount || user?.isAcceptPrivacyPolicy == null || user?.isAcceptTermsUse == null || !user?.isAcceptPrivacyPolicy || !user?.isAcceptTermsUse) {
              return AccountConfirmationScreen();
            } else {
              return DashboardScreen(user: user);
            }
          }
        });
  }
}
