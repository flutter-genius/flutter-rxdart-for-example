import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'config.dart';
import 'models/models.dart';

const _debug = false ?? debug;

AppState rootReducer(AppState state, action) {
  try {
    return action.reducer(state);
  } catch (e) {
    if (_debug) print('Error: $e');
    return state;
  }
}

Future<Store<AppState>> getStore() async {
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    throttleDuration: Duration(seconds: 1),
  );

  final initialState = await persistor.load();

  return Store<AppState>(
    rootReducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [thunkMiddleware, persistor.createMiddleware()],
  );
}
