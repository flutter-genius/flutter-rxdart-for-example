import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hittapa/actions/providerAction.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/screens/main/splash_screen.dart';
import 'package:hittapa/utils/routes.dart';
import 'package:redux/redux.dart';
import 'package:timezone/data/latest.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config.dart' as config;
import 'models/models.dart';
import 'screens/main/mainScreen.dart';
import 'store.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:hittapa/services/socket/dependecy_injection.dart';
import 'package:hittapa/services/socket/app_initializer.dart';
import 'package:hittapa/services/dynamic_link_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await setFirebaseNotification();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Store<AppState> store = await getStore();
  DependencyInjection().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector);
  await Permission.location.request();
  List languages = await Devicelocale.preferredLanguages;
  runApp(EasyLocalization(
    supportedLocales: getSupportedLanguages(),
    path: 'assets/langs',
    fallbackLocale: getdefaulLanguage(languages),
    assetLoader: CodegenLoader(),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider<IsScroller>(
          create: (context) => IsScroller(),
          lazy: false,
        ),
      ],
      child: MyApp(store: store),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    DynamicLinkService().handleDynamicLinks();
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: config.appTitle,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            fontFamily: config.appTheme.fontFamily2,
            primarySwatch: Colors.blue,
            canvasColor: Colors.transparent,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          home: store.state.user?.id == null ? MainScreen() : SplashScreen(),
          routes: routes(context),
        ));
  }
}
