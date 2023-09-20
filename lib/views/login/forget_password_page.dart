import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/forget_password_vm.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/toast.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/text_field.dart';

import 'login_iview.dart';
import 'login_page_presenter.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with
        BasePageMixin<ForgetPasswordPage, LoginPagePresenter>,
        AutomaticKeepAliveClientMixin<ForgetPasswordPage>
    implements LoginIMvpView{
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  bool _clickable = false;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;
  ForgetPasswordViewModel forgetPasswordViewModel;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_verify);
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_verify);
    _emailController.dispose();
    _deviceInfoProvider.dispose();
    _nodeText1.dispose();
    super.dispose();
  }

  void _verify() {
    final String email = _emailController.text;
    bool clickable = true;
    if (email.isEmpty|| HelperUtils.isInvalidEmailAddress(email)) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _reset() async {
    var deviceId = SpUtil.getString(Constant.fcmDeviceId)!=''?SpUtil.getString(Constant.fcmDeviceId):_deviceData[DeviceInfoProvider.deviceId];
    var response = await presenter.forgetPassword(_emailController.text, deviceId);
    if(response != null){
      forgetPasswordViewModel = response;
      if(forgetPasswordViewModel.token != null) {
        StaticKeyValueStore().set(Constant.forgetPasswordToken, forgetPasswordViewModel.token);
        StaticKeyValueStore().set(Constant.forgetPasswordEmail, _emailController.text);
        NavigatorUtils.push(context, AuthRouter.forgetPasswordConfirmPage);
      }
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
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1]),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Gaps.vGap16,
      MyTextField(
        iconName: 'email',
        focusNode: _nodeText1,
        controller: _emailController,
        maxLength: 50,
        keyboardType: TextInputType.emailAddress,
        hintText: AppLocalizations.of(context).inputEmailHint,
        labelText: AppLocalizations.of(context).inputEmailHint,

      ),

      Gaps.vGap24,
      MyButton(
        onPressed: _clickable ? _reset : null,
        text: AppLocalizations.of(context).nextStep,
      )
    ];
  }

  @override
  bool get wantKeepAlive => false;

  @override
  LoginPagePresenter createPresenter() {
    return LoginPagePresenter();
  }
}
