import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/load_image.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import '../../routers/auth_router.dart';
import 'register_iview.dart';
import 'register_page_presenter.dart';

class RegisterImageVerificationPage extends StatefulWidget {
  @override
  _RegisterImageVerificationPageState createState() =>
      _RegisterImageVerificationPageState();
}

class _RegisterImageVerificationPageState
    extends State<RegisterImageVerificationPage>
    with
        BasePageMixin<RegisterImageVerificationPage, RegisterPagePresenter>,
        AutomaticKeepAliveClientMixin<RegisterImageVerificationPage>
    implements RegisterIMvpView {
  bool _clickable = true;
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if(_timer!=null)_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).takeASelfie,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: MyButton(
              key: const Key('takeASelfie'),
              onPressed: _clickable ? _next : _enable,
              text: AppLocalizations.of(context).takeAPhoto,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }
  Widget _buildBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width * .05,
              left: MediaQuery.of(context).size.width * .05,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, right: 16.0, left: 16.0),
                child: Image.asset('assets/images/selfie_cartoor.png',scale: 2,),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .35,
              right: MediaQuery.of(context).size.width * .05,
              left: MediaQuery.of(context).size.width * .05,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                      Container(
                        width:MediaQuery.of(context).size.width*.8,
                        child: Card(
                          elevation: 5.0,
                          shadowColor: Colours.bg_gray,
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: LoadAssetImage('correct',width: 32,height: 32,),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context).tipsImageMessage1,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Dimens.font_sp14, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: LoadAssetImage('correct',width: 32,height: 32,),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context).tipsImageMessage2,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Dimens.font_sp14, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: LoadAssetImage('in_correct',width: 32,height: 32,),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context).tipsImageMessage3,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Dimens.font_sp14, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: LoadAssetImage('in_correct',width: 32,height: 32,),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context).tipsImageMessage4,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Dimens.font_sp14, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),

              ),
          ],
        ),
      );
  }
  void _enable(){
    if(!_clickable && mounted) {
      _timer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _clickable = true;
        });
      });
    }
  }
  void _next() {
    if(mounted) {
      setState(() {
        _clickable = false;
        NavigatorUtils.push(context, AuthRouter.faceVerification);
      });
    }
  }

  void _launchNIDFornt() {
    NavigatorUtils.push(context, AuthRouter.nidFrontUpdatePage);
  }

  //
  void _launchNIDBack() {
    NavigatorUtils.push(context, AuthRouter.nidBackUpdatePage);
  }

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
