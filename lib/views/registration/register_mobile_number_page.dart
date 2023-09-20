import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:provider/provider.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/localization/app_localizations.dart';
import 'package:qpay/net/contract/api_basic_vm.dart';
import 'package:qpay/net/contract/mobile_operator.dart';
import 'package:qpay/net/contract/verification_vm.dart';
import 'package:qpay/static_data/cached_data_holder.dart';
import 'package:qpay/utils/device_utils.dart';
import 'package:qpay/mvp/base_page.dart';
import 'package:qpay/providers/theme_provider.dart';
import 'package:qpay/routers/auth_router.dart';
import 'package:qpay/res/resources.dart';
import 'package:qpay/routers/fluro_navigator.dart';
import 'package:qpay/utils/helper_utils.dart';
import 'package:qpay/utils/utils.dart';
import 'package:qpay/widgets/app_bar.dart';
import 'package:qpay/widgets/my_button.dart';
import 'package:qpay/widgets/my_scroll_view.dart';
import 'package:qpay/widgets/my_step_indicator.dart';
import 'package:qpay/widgets/text_field.dart';
import 'register_iview.dart';
import 'register_page_presenter.dart';
import 'package:qpay/widgets/pin_input_dialog.dart';
import '../../providers/user_registration_state_provider.dart';

class RegisterMobileNumberPage extends StatefulWidget {
  @override
  _RegisterMobileNumberPageState createState() => _RegisterMobileNumberPageState();
}

class _RegisterMobileNumberPageState extends State<RegisterMobileNumberPage>
    with
        BasePageMixin<RegisterMobileNumberPage, RegisterPagePresenter>,
        AutomaticKeepAliveClientMixin<RegisterMobileNumberPage>
    implements RegisterIMvpView {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  var registrationDataHolder = UserRegistrationStateProvider();
  var _isOperatorChangedByUser = false;
  bool _clickable = false;
  bool isNumberChanged = false;
  String lastPhoneNumber = '';
  List<MobileOperator> _operators = MobileOperator.getMobileOperators();
  List<DropdownMenuItem<MobileOperator>> _dropdownMenuItems;
  MobileOperator _selectedOperator;
  final _deviceInfoProvider = DeviceInfoProvider();
  Map<String, dynamic> _deviceData;
  ProofViewModel _verificationViewModel;
  int _expireTime = 180;
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
    _deviceId = SpUtil.getString(Constant.fcmDeviceId);
    _dropdownMenuItems = buildDropdownMenuItems(_operators);
    _selectedOperator = _dropdownMenuItems[0].value;
    _phoneController.addListener(_verify);
    _vCodeController.addListener(_verify);
    _deviceInfoProvider.addListener(() {
      _deviceData = _deviceInfoProvider.deviceData;
      registrationDataHolder.setDeviceData(_deviceData);
    });
  }

  List<DropdownMenuItem<MobileOperator>> buildDropdownMenuItems(
      List operators) {
    List<DropdownMenuItem<MobileOperator>> items = List();
    for (MobileOperator operator in operators) {
      items.add(
        DropdownMenuItem(
          value: operator,
          child: Text(operator.name),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    if(_otpCountDown != null) _otpCountDown.cancelTimer();
    _phoneController.removeListener(_verify);
    _phoneController.dispose();
    _nodeText1.dispose();
    _vCodeController.removeListener(_verify);
    _vCodeController.dispose();
    _nodeText2.dispose();
    registrationDataHolder.clear();
    super.dispose();
  }

  onChangeDropdownItem(MobileOperator operator) {
    setState(() {
      _isOperatorChangedByUser = true;
      _selectedOperator = operator;
    });
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String vCode = _vCodeController.text;
    final String operator = _selectedOperator.codeName;
    bool clickable = true;
    if (phone.isEmpty || HelperUtils.isInvalidPhoneNumber(phone)) {
      clickable = false;
      _selectedOperator= _dropdownMenuItems[0].value;
      _isOperatorChangedByUser = false;
    }
    if(_getSubmitButtonShow) {
      if (vCode.isEmpty || vCode.length < 6) {
        clickable = false;
      }
    }

    if (phone.isNotEmpty &&
       /* !HelperUtils.isInvalidPhoneNumber(phone) &&*/
        !_isOperatorChangedByUser) {
      var _operator = _operators[HelperUtils.defineOperatorFrom(phone)];
      setState(() {
        if (_operator != _selectedOperator) _selectedOperator = _operator;
      });
      if (_operator.id == 0){
        clickable = false;
      }
    }
    if(phone.length == 11 && HelperUtils.isInvalidPhoneNumber(phone)){
      clickable = false;
      showSnackBar('Invalid Phone number!!!');
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
          centerTitle: AppLocalizations.of(context).openYourAccount,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(
              context, <FocusNode>[_nodeText1]),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Container(
        child: Column(
          children: [
            MyTextField(
              key: const Key('phone'),
              iconName: 'phone',
              focusNode: _nodeText1,
              controller: _phoneController,
              maxLength: 11,
              keyboardType: TextInputType.phone,
              hintText: AppLocalizations.of(context).inputPhoneHint,
              labelText: AppLocalizations.of(context).inputPhoneHint,
              enabled: !_getSubmitButtonShow,
            ),
            Gaps.vGap16,
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: Colours.text_gray,
                    width: 1,
                  ),
                  color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _selectedOperator,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
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
                controller: _vCodeController,
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
                      _vCodeController.text = '';
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

  void _activeResendButton() async{
    _requestVerificationCode(_phoneController.text,_selectedOperator.codeName);
  }

  void _next() async {
    var deviceId= _deviceId.isNotEmpty?_deviceId:_deviceData[DeviceInfoProvider.deviceId];
    registrationDataHolder.setPhoneData(_phoneController.text, _selectedOperator.codeName,_vCodeController.text);
    var response =
        await presenter.submitPhoneVerification(
        _phoneController.text,deviceId ,_vCodeController.text);
    if (response != null) {
      _verificationViewModel = response;
      if(_verificationViewModel !=null && _verificationViewModel.token !=null) {
        setState(() {
          _otpTimeInMS = 1;
          _getSubmitButtonShow = false;
          _getCodeButtonShow = true;
        });
        StaticKeyValueStore().set(Constant.phoneVerificationToken, _verificationViewModel.token);
        NavigatorUtils.push(context, AuthRouter.registerComplete);
      }
    }else{
      _resendButtonEnable = false;
    }
  }

  void _requestCode() async {
    _requestVerificationCode(_phoneController.text,_selectedOperator.codeName);
  }

  void _requestVerificationCode(String phoneNumber, String operator) async {
    var deviceId = _deviceId.isNotEmpty?_deviceId:_deviceData[DeviceInfoProvider.deviceId];
    var response = await presenter.requestPhoneVerificationCode(
        phoneNumber,deviceId);
    if (response != null) {
      _otpTimeInMS = response.expiresAt;
      _startCountDown();
      if(response.isVerified()){
        registrationDataHolder.setPhoneData(_phoneController.text, _selectedOperator.codeName,_vCodeController.text);
        StaticKeyValueStore().set(Constant.phoneVerificationToken, response.token);
        NavigatorUtils.push(context, AuthRouter.registerComplete);
      }else{
        _getCodeButtonShow = false;
        _getSubmitButtonShow = true;
      }
    }
  }

  @override
  RegisterPagePresenter createPresenter() {
    return RegisterPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
