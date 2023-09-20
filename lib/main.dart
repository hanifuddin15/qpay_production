import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:qpay/providers/theme_provider.dart';
import 'package:qpay/routers/application.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/utils/bad_certificate.dart';
import 'package:qpay/widgets/global_navigator.dart';
import 'locator.dart';
import 'net/push_notification_service.dart';
import 'views/home/splash_page.dart';
import 'localization/app_localizations.dart';
import 'net/dio_utils.dart';
import 'net/intercept.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  await runZonedGuarded(() async {
    HttpOverrides.global = new MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    setupLocator();
    runApp(MyApp());
  },(Object error, StackTrace stackTrace) async{
     await FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  final Widget home;
  final ThemeData theme;
  final PushNotificationService _pushNotificationService =
  locator<PushNotificationService>();
  MyApp({this.home, this.theme}) {
    _pushNotificationService.initialise();
    initDio();
    final FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  void initDio() {
    final List<Interceptor> interceptors = [];
    interceptors.add(TokenInterceptor());
    interceptors.add(LoggingInterceptor());
    interceptors.add(AuthInterceptor());
    interceptors.add(AdapterInterceptor());

    setInitDio(
      interceptors: interceptors,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (_, provider, __) {
              return OverlaySupport(
                child: MaterialApp(
                  navigatorKey: GlobalVariable.navState,
                  title: "",
                  debugShowCheckedModeBanner: false,
                  locale: provider.getLocale(),
                  theme: theme ?? provider.getTheme(),
                  darkTheme: provider.getTheme(isDarkMode: false),
                  themeMode: provider.getThemeMode(),
                  home: home ?? SplashPage(),
                  onGenerateRoute: Application.router.generator,
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const <Locale>[
                    Locale('bn', 'BD'),
                    Locale('en', 'US')
                  ],
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom);
  }
}
