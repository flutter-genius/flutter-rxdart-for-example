import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/services/node_auth_service.dart';
import 'package:redux/redux.dart';

import '../config.dart';

const _debug = true;

class UpdateUser {
  final UserModel user;

  UpdateUser(this.user);

  reducer(AppState appState) {
    if (_debug) print("UpdateUser.reducer ${user.apiToken}  **** ${user.uid}");
    return appState.copyWith(
      user: user,
    );
  }
}

class UpdateUserToken {
  final String token;

  UpdateUserToken(this.token);

  reducer(AppState appState) {
    return appState.copyWith(
      userToken: token.toString(),
    );
  }
}

Function updateUser(UserModel user) {
  return (Store<AppState> store) async {
    store.dispatch(UpdateUser(user));
    try {
      NodeAuthService().updateUser(store.state.user.toFB(), store.state.user.uid);
    } catch (error) {
      if (debug) print(error);
    }
  };
}

createUserAccount(UserModel user) {
  return (Store<AppState> store) async {
    store.dispatch(UpdateUserToken("Firebase uid"));
      var apiResult = await NodeAuthService().createUser(user.toFB());
      store.dispatch(UpdateUser(user.copyWith(id: "firebase uid", uid: apiResult['_id'])));
  };
}

logIn() {
  return (Store<AppState> store) async {};
}

class LogoutUser {
  reducer(AppState appState) {
    return appState.copyWith(
      user: UserModel(),
      userToken: "",
      loggedIn: false,
    );
  }
}

Future<void> logOut(Store<AppState> store) async {
  store.dispatch(LogoutUser());
}
