import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';

import 'login_iview.dart';
import 'login_page_presenter.dart';

class ForgetPasswordConfirmPage extends StatefulWidget{
  @override
  _ForgetPasswordConfirmPageState createState() => _ForgetPasswordConfirmPageState();
}

class _ForgetPasswordConfirmPageState extends State<ForgetPasswordConfirmPage>
    with
        BasePageMixin<ForgetPasswordConfirmPage, LoginPagePresenter>,
        AutomaticKeepAliveClientMixin<ForgetPasswordConfirmPage>
    implements LoginIMvpView{
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  bool _clickable = false;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_verify);
    _tokenController.addListener(_verify);
    _confirmPasswordController.addListener(_verify);
    _passwordController.addListener(_verify);
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_verify);
    _phoneController.dispose();
    _tokenController.removeListener(_verify);
    _tokenController.dispose();
    _confirmPasswordController.removeListener(_verify);
    _confirmPasswordController.dispose();
    _passwordController.removeListener(_verify);
    _passwordController.dispose();
    _deviceInfoProvider.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    _nodeText4.dispose();
    super.dispose();
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String token = _tokenController.text;
    final String confirmPassword = _confirmPasswordController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (phone.isEmpty ||
        phone.length < 11 ||
        HelperUtils.isInvalidPhoneNumber(phone)) {
      clickable = false;
    }
    if (token.isEmpty || token.length < 6) {
      clickable = false;
    }
    if (confirmPassword.isEmpty || confirmPassword.length < 6) {
      clickable = false;
    }

    if (password.isEmpty || password.length < 6) {
       clickable = false;
    }

    if(password != confirmPassword){
      clickable = false;
    }
    if(!HelperUtils.isPasswordCompliant(password)){
      clickable = false;
    }

    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          centerTitle: AppLocalizations.of(context).resetPIN,
        ),
        body: MyScrollView(
          keyboardConfig:
          Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1,_nodeText2,_nodeText3,_nodeText4]),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  _callNumber() async{
    const number = '+8809666727279'; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Container(
        width: MediaQuery.of(context).size.width*.8,
        height: MediaQuery.of(context).size.height*.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context).pleaseContactWithCallCenter.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colours.app_main,),),
            Gaps.vGap32,
            InkWell(
              onTap: _callNumber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call,size: 80,color: Colours.app_main,),
                 /* Image(image:AssetImage("assets/images/calling.png"),height: 80,width: 80,),*/
                ],
              ),
            ),
          ],
        ),
      ),
      Gaps.vGap24,
      MyTextField(
        key: const Key('phone'),
        iconName: 'phone',
        focusNode: _nodeText4,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: AppLocalizations.of(context).inputPhoneHint,
        labelText: AppLocalizations.of(context).inputPhoneHint,

      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('vCode'),
        iconName: 'otp',
        focusNode: _nodeText1,
        controller: _tokenController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        hintText: AppLocalizations.of(context).inputOTP,
        labelText: AppLocalizations.of(context).inputOTP,
      ),
      Gaps.vGap8,
      InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                AppLocalizations.of(context).hint,
                style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.app_main,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        onTap: () =>_showHint(),
      ),
      Gaps.vGap4,
      MyTextField(
        key: const Key('password'),
        iconName: 'password',
        focusNode: _nodeText2,
        controller: _passwordController,
        isInputPwd: true,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).inputPINHint,
        labelText: AppLocalizations.of(context).inputPINHint,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('confirmPassword'),
        iconName: 'password',
        focusNode: _nodeText3,
        controller: _confirmPasswordController,
        isInputPwd: true,
        maxLength: 6,
        keyboardType: TextInputType.numberWithOptions(),
        hintText: AppLocalizations.of(context).confirmPINHint,
        labelText: AppLocalizations.of(context).confirmPINHint,
      ),
      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _changePassword : null,
        text: AppLocalizations.of(context).confirm,
      )
    ];
  }

   void _showHint(){
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: AppLocalizations.of(context).hint.toUpperCase(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).pinMustContain,
                  textAlign: TextAlign.justify),
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }


  void _changePassword() async{
    var deviceId = SpUtil.getString(Constant.fcmDeviceId)!=''?SpUtil.getString(Constant.fcmDeviceId):_deviceData[DeviceInfoProvider.deviceId];
    if(_confirmPasswordController.text == _passwordController.text) {
      var response = await presenter.forgetPasswordConfirm(_tokenController.text,_passwordController.text,
          _phoneController.text,deviceId);
      if (response != null) {
        _showSuccessDialog();
      }
    }else{
      Toast.show(AppLocalizations.of(context).pinDidNotMatch);
    }
  }

  @override
  bool get wantKeepAlive => false;

  @override
  LoginPagePresenter createPresenter() {
  return LoginPagePresenter();
  }

  void _showSuccessDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: "",
            title: AppLocalizations.of(context).pinReset,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).pinResetComplete,
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              NavigatorUtils.push(context, AuthRouter.loginPage,
                  replace: true, clearStack: true);
            },
          );
        });
  }
}