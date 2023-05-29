import 'package:hittapa/screens/auth/account_confirm_screen.dart';
import 'package:hittapa/screens/screens.dart';

class Routes {
  static const DEFAULT = '';
  static const MAIN = 'MainScreen';
  static const NEW_EVENT = 'NewEventScreen';
  static const EVENT_DETAIL = 'EventDetailScreen';
  static const LOGIN = 'LoginScreen';
  static const CREATE_ACCOUNT = 'CreateAccountScreen';
  static const SPLASH = 'SplashScreen';
  static const CONFORM_SCREEN = 'ConfirmScreen';
}

routes(context) => {
  Routes.DEFAULT: (context) => MainScreen(),
  Routes.MAIN: (context) => MainScreen(),
  Routes.NEW_EVENT: (context) => NewEventScreen(),
  Routes.EVENT_DETAIL: (context) => EventDetailScreen(),
  Routes.LOGIN: (context) => LoginScreen(email: '',),
  Routes.CREATE_ACCOUNT: (context) => CreateAccountScreen(),
  Routes.SPLASH: (context) => SplashScreen(),
  Routes.CONFORM_SCREEN: (context) => AccountConfirmationScreen(),
};
