import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/theme_utils.dart';
import 'package:qpay/views/login/login_page.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:page_transition/page_transition.dart';



class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // StreamSubscription _subscription;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await SpUtil.getInstance();
  //     _initSplash();
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }
  //
  // void _initSplash() {
  //   _subscription =
  //       Stream.value(1).delay(Duration(milliseconds: 3000)).listen((_) {
  //         _goLogin();
  //       });
  // }

  void _goLogin() {
    NavigatorUtils.push(context, AuthRouter.loginPage, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return
      Material(
        color: ThemeUtils.getBackgroundColor(context),
        child: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/background.png"), fit: BoxFit.cover,),
              ),
            ),
            Positioned.fill(
              child:  Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                      heightFactor: 0.55,
                      widthFactor: 0.55,
                      alignment: Alignment.center,
                      child: AnimatedSplashScreen(
                        backgroundColor: Colors.transparent,
                        duration: 1000,
                        splashTransition: SplashTransition.sizeTransition,
                        pageTransitionType: PageTransitionType.rightToLeft,
                        splash: LoadAssetImage(ThemeUtils.getLogo(context)),
                        nextScreen: LoginPage(),
                      ),
                  ),
                ),
            ),
          ],
        ),
      );
  }
}
