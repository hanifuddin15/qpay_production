import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/my_step_indicator.dart';
import 'package:qpay/widgets/my_icon_button.dart';
import '../../routers/auth_router.dart';
import '../../widgets/load_image.dart';
import 'register_iview.dart';
import 'register_page_presenter.dart';
import '../../providers/user_registration_state_provider.dart';

class RegisterNIDVerificationPage extends StatefulWidget {
  @override
  _RegisterNIDVerificationPageState createState() =>
      _RegisterNIDVerificationPageState();
}

class _RegisterNIDVerificationPageState
    extends State<RegisterNIDVerificationPage>
    with
        BasePageMixin<RegisterNIDVerificationPage, RegisterPagePresenter>,
        AutomaticKeepAliveClientMixin<RegisterNIDVerificationPage>
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
          centerTitle: AppLocalizations.of(context).verifyNID,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: MyButton(
              key: const Key('verifyNID'),
              onPressed: _clickable ? _next : _enable,
              text: AppLocalizations.of(context).verifyNID,
            ),
          ),
        ),
        body: _buildBody()
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadAssetImage('nid_clear',height: 128,width: 164,),
                        Text("Good")
                      ],
                    ),
                  ],
                )
                ,Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadAssetImage('nid_cropped',height: 98,width: 106,),
                        Text("Not cropped")
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadAssetImage('nid_blur',height: 98,width: 106,),
                        Text("Not blur")
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadAssetImage('nid_reflect',height: 98,width: 106,),
                        Text("Not reflective")
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:16.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width*.8,
                    height: MediaQuery.of(context).size.height*.3,
                    child: Card(
                        elevation: 5.0,
                        shadowColor: Colours.bg_gray,
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage('correct',width: 32,height: 32,),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context).tipsNIDMessage1,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage('correct',width: 32,height: 32,),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context).tipsNIDMessage2,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage('correct',width: 32,height: 32,),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context).tipsNIDMessage3,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage('correct',width: 32,height: 32,),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context).tipsNIDMessage4,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadAssetImage('in_correct',width: 32,height: 32,),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context).tipsNIDMessage6,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ],
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
        NavigatorUtils.push(context, AuthRouter.nidFrontUpdatePage);
      });
    }
  }

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
