import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/verification_vm.dart';
import 'package:qpay/providers/theme_provider.dart';
import 'package:qpay/res/colors.dart';
import 'package:qpay/res/dimens.dart';
import 'package:qpay/res/gaps.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/routers/routers.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_dialog.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/my_step_indicator.dart';
import 'package:qpay/widgets/text_field.dart';
import 'package:qpay/views/registration/register_iview.dart';
import 'package:qpay/views/registration/register_page_presenter.dart';
import '../../providers/user_registration_state_provider.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';



class RegistrationEmailAddressPage extends StatefulWidget{
  @override
  _RegistrationEmailAddressPageState createState() => _RegistrationEmailAddressPageState();
}
class _RegistrationEmailAddressPageState extends State<RegistrationEmailAddressPage>
    with
        BasePageMixin<RegistrationEmailAddressPage, RegisterPagePresenter>,
        AutomaticKeepAliveClientMixin<RegistrationEmailAddressPage>
    implements RegisterIMvpView{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vCodeEmailController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  var registrationDataHolder = UserRegistrationStateProvider();
  bool _clickable = false;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;
  ProofViewModel _verificationViewModel;
  bool _getCodeButtonShow = true;
  bool _getSubmitButtonShow = false;
  bool _resendButtonEnable = false;
  String _countDown;
  OTPCountDown _otpCountDown;
  int _otpTimeInMS;
  String _deviceId;

  @override
  void initState() {
    super.initState();
    _deviceId  = SpUtil.getString(Constant.fcmDeviceId);
    _emailController.addListener(_verify);
    _vCodeEmailController.addListener(_verify);
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
      registrationDataHolder.setDeviceData(_deviceData);
    });
  }

  @override
  void dispose() {
    if(_otpCountDown != null )_otpCountDown.cancelTimer();
    _emailController.removeListener(_verify);
    _emailController.dispose();
    _vCodeEmailController.removeListener(_verify);
    _vCodeEmailController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    registrationDataHolder.clear();
    super.dispose();
  }

  void _verify() {
    final String email = _emailController.text;
    final String vCodeEmail = _vCodeEmailController.text;
    bool clickable = true;
    if (email.isEmpty || HelperUtils.isInvalidEmailAddress(email)) {
      clickable = false;
      _getSubmitButtonShow = false;
      _getCodeButtonShow = true;
    }
    if(_getSubmitButtonShow) {
      if (vCodeEmail.isEmpty || vCodeEmail.length < 6) {
        clickable = false;
      }
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
          centerTitle: AppLocalizations.of(context).provideYourEmail,

        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1, _nodeText2]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      MyTextField(
        key: const Key('email'),
        iconName: 'email',
        focusNode: _nodeText1,
        controller: _emailController,
        maxLength: 50,
        keyboardType: TextInputType.emailAddress,
        hintText: AppLocalizations.of(context).inputEmailHint,
        labelText: AppLocalizations.of(context).inputEmailHint,
        enabled: !_getSubmitButtonShow,
      ),
      Gaps.vGap8,
      Visibility(
        visible: _getCodeButtonShow,
        child: Column(
          children: [
            Gaps.vGap50,
            MyButton(
              key: const Key('register'),
              onPressed: _clickable ? _requestCode : null,
              text: AppLocalizations.of(context).getVCode,
            ),
            Gaps.vGap16,
          ],
        ),
      ),
      Visibility(
        visible: _getSubmitButtonShow ,
        child: Container(
          child: Column(
            children: [
              MyTextField(
                key: const Key('vcode'),
                focusNode: _nodeText2,
                controller: _vCodeEmailController,
                keyboardType: TextInputType.number,
                hintText: AppLocalizations.of(context).inputOTP,
                labelText: AppLocalizations.of(context).inputOTP,
                maxLength: 6,
              ),
              Gaps.vGap50,
              MyButton(
                key: const Key('register'),
                onPressed: _clickable ? _next : null,
                text: AppLocalizations.of(context).submit,
              ),
              Gaps.vGap16,
              Column(
                children: [
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:'Your OTP validation will end in ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:15,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: _countDown??'',
                              style: TextStyle(
                                color: Colours.app_main,
                                fontSize:15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:' minutes',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                  Gaps.vGap50,
                  InkWell(
                    child: Text(
                      AppLocalizations.of(context).resendOTP,
                      style: TextStyle(
                        color: _resendButtonEnable?Colours.app_main:Colors.grey,
                        fontSize:Dimens.font_sp22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap:_resendButtonEnable? (){
                      _resendButtonEnable = false;
                      _vCodeEmailController.text = '';
                      _activeResendButton();
                    }:null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void _requestCode() async {
    _requestEmailVerificationCode(_emailController.text);
  }
  void _activeResendButton() async{
    _requestEmailVerificationCode(_emailController.text);
  }
  void _next() async{
    var deviceId = _deviceId.isNotEmpty?_deviceId:_deviceData[DeviceInfoProvider.deviceId];
    registrationDataHolder.setEmailAddress(_emailController.text, _vCodeEmailController.text);
    var response =
        await presenter.submitEmailVerification(
            _emailController.text,deviceId,_vCodeEmailController.text);

    if (response != null) {
      _verificationViewModel = response;
      if(_verificationViewModel.isVerified()) {
        NavigatorUtils.push(context, Routes.home);      }
    }
  }

  void _requestEmailVerificationCode(String emailAddress) async {
    var deviceId = _deviceId.isNotEmpty?_deviceId:_deviceData[DeviceInfoProvider.deviceId];
    var response = await presenter.requestEmailVerificationCode(
        emailAddress,deviceId);
    if (response != null) {
      _otpTimeInMS = response.expiresAt;
      _startCountDown();
      if(response.isVerified()){
        registrationDataHolder.setEmailAddress(_emailController.text, _vCodeEmailController.text);
        StaticKeyValueStore().set(Constant.emailVerificationToken, response.token);
        NavigatorUtils.push(context, Routes.home);
      }else{
        _getCodeButtonShow = false;
        _getSubmitButtonShow = true;
      }
    }
  }

  void _startCountDown() {
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: _otpTimeInMS,
      currentCountDown: (String countDown) {
        setState(() {
          _countDown = countDown;
        });
      },
      onFinish: () {
        setState(() {
          _resendButtonEnable = true;
        });

      },
    );
  }

  /*Future<bool> _showPinDialog(ApiBasicViewModel verificationViewModel) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegistrationEmailAddressOTPPage(_emailController.text,_deviceData[DeviceInfoProvider.deviceId],verificationViewModel);}));
    _verificationViewModel = result!=null? result : null;
    if(_verificationViewModel != null){
      if(_verificationViewModel.isSuccess){
        _showSuccessDialog();
        NavigatorUtils.push(context, Routes.home);
      } else{
        _showErrorDialog(_verificationViewModel.errorMessage);
      }
    }
  }*/

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;
  void _showSuccessDialog() {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: AppLocalizations.of(context).okay,
            cancelText: '',
            title:AppLocalizations.of(context).emailVerifyTitle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppLocalizations.of(context).emailVerifySuccess, textAlign: TextAlign.center,),
            ),
            onPressed:() {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }

  void _showErrorDialog(String message) {
    showElasticDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyDialog(
            actionText: "",
            cancelText: AppLocalizations.of(context).okay,
            title: AppLocalizations.of(context).cashOutTokenTimeExtend,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(message, textAlign: TextAlign.center,),
            ),
            onBackPressed:() {
              NavigatorUtils.goBack(context);
            },
          );
        });
  }
}