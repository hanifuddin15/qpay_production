
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qpay/routers/account_router.dart';
import 'package:qpay/routers/dashboard_router.dart';
import 'package:qpay/views/home/home_page.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/router_init.dart';
import '404.dart';
import 'home_router.dart';

class Routes {

  static String home = '/home';
  static String webViewPage = '/webview';

  static final List<IRouterProvider> _listRouter = [];

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        debugPrint('Path not found!');
        return WidgetNotFound();
      });

    router.define(home, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) => Home()));

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first;
      final String url = params['url']?.first;
    }));
    
    _listRouter.clear();
    _listRouter.add(AuthRouter());
    _listRouter.add(DashboardRouter());
    _listRouter.add(HomeRouter());
    _listRouter.add(AccountRouters());
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
