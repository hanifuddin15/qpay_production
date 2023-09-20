import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';

class LoginSignUpPopPage extends StatefulWidget{
  @override
  _LoginSignUpPopPageState createState() => _LoginSignUpPopPageState();

}

class _LoginSignUpPopPageState extends State<LoginSignUpPopPage>{
  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png",
                scale: 12.0,
              ),
              InkWell(
                onTap: ()=> NavigatorUtils.goBack(context),
                  child: Text('Cancel',style: TextStyle(color: Colours.app_main),)),
            ],
          ),
          elevation: 1,
        ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildBottomNavigationBar(),
            ),
          ),
        body: MyScrollView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Sign Up Prerequisites',
                            textScaleFactor: 1.8,
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/smartphone.png",
                          scale: 12.0,
                        ),
                        Gaps.hGap15,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Mobile Number',
                                textScaleFactor: 1.35,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text('Your valid mobile number.',
                                textScaleFactor: .9,
                                maxLines: 2,
                                textAlign: TextAlign.justify,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/email.png",
                          scale: 12.0,
                        ),
                        Gaps.hGap15,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email Address',
                                textScaleFactor: 1.35,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text('Your valid email address.',
                                textScaleFactor: .9,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/id-card.png",
                          scale: 12.0,
                        ),
                        Gaps.hGap15,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('National ID (NID) Card',
                                    textScaleFactor: 1.35,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('Your valid Bangladeshi \nold/smart NID card.',
                                textScaleFactor: .9,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Gaps.vGap16,
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0,left: 24.0,right: 24.0),
                    child: MyButton(
                      key: const Key('register'),
                      onPressed: _pushToSignUp ,
                      text: 'Continue',
                    ),
                  )*/
                ],
              ),
            ),
          ],
        )
      ));

  Widget _buildBottomNavigationBar() {
    return MyButton(
      key: const Key('register'),
      onPressed: _pushToSignUp ,
      text: 'Continue',
    );
  }

  void _pushToSignUp(){
    NavigatorUtils.push(context, AuthRouter.registerPage);

  }
}
